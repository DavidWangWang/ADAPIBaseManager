//
//  ADAPIBaseManager.m
//  ADAPIBaseManager
//
//  Created by David on 2019/9/16.
//  Copyright © 2019年 ADIOS. All rights reserved.
//

#import "ADAPIBaseManager.h"
#import "ADURLResponse.h"
#import "ADCacheCenter.h"
#import "CTMediator+ADAppContext.h"
#import "ADServiceProtocol.h"
#import "ADServiceFactory.h"
#import "NSURLRequest+ADNetworkingMethods.h"
#import "ADApiProxy.h"
#import "ADCacheCenter.h"

NSString * const kCTUserTokenIllegalNotification = @"kCTUserTokenIllegalNotification";
NSString * const kCTUserTokenInvalidNotification = @"kCTUserTokenInvalidNotification";

NSString * const kCTUserTokenNotificationUserInfoKeyManagerToContinue = @"kCTUserTokenNotificationUserInfoKeyManagerToContinue";
NSString * const kCTAPIBaseManagerRequestID = @"kCTAPIBaseManagerRequestID";

@interface ADAPIBaseManager()

@property (nonatomic, strong, nullable) void (^successBlock)(ADAPIBaseManager *manager);
@property (nonatomic, strong, nullable) void (^failBlock)(ADAPIBaseManager *manager);

@property (nonatomic, readwrite) ADAPIManagerErrorType errorType;
@property (nonatomic, strong) NSMutableArray *requestIdList;

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong, readwrite) id fetchedRawData;
@property (nonatomic, copy, readwrite) NSString *errorMessage;

@end

@implementation ADAPIBaseManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _interceptor = nil;
        _validator = nil;
        _delegate = nil;
        _paramSource = nil;
        _fetchedRawData = nil;
        _errorType = ADAPIManagerErrorTypeDefault;
        _errorMessage = nil;
        
        _memoryCacheSecond = 3 * 60;
        _diskCacheSecond = 3 * 60;
        
        if ([self conformsToProtocol:@protocol(ADAPIManager)]) {
            self.child = (id<ADAPIManager>)self;
        } else {
            NSException *exception = [[NSException alloc] init];
            @throw exception;
        }
    }
    return self;
}

#pragma mark - public

+ (NSInteger)loadDataWithParams:(NSDictionary *)params
                        success:(void (^)(ADAPIBaseManager * _Nonnull))successCallback
                           fail:(void (^)(ADAPIBaseManager * _Nonnull))failCallback
{
    return [[[self alloc] init] loadDataWithParams:params success:successCallback fail:failCallback];
}

- (NSInteger)loadData
{
    NSDictionary *params = [self.paramSource paramsForApi:self];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
}

- (NSUInteger)loadDataWithParams:(NSDictionary *)params
                         success:(void (^)(ADAPIBaseManager * _Nonnull))successCallback
                            fail:(void (^)(ADAPIBaseManager * _Nonnull))failCallback
{
    self.successBlock = successCallback;
    self.failBlock = failCallback;
    
    return [self loadDataWithParams:params];
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params
{
    NSInteger requestId = 0;
    // request params
    NSDictionary *reformedParams = [self reformParams:params];
    if (reformedParams == nil) {
        reformedParams = @{};
    }
    if ([self shouldCallAPIWithParams:reformedParams]) {
        ADAPIManagerErrorType errorType = [self.validator maneger:self isCorrectWithParamsData:reformedParams];
        if (errorType == ADAPIManagerErrorTypeNoError) {
            ADURLResponse *response = nil;
            // 检查一下是否有内存缓存
            if ((self.cachePolicy & ADAPIManagerCachePolicyMemory) && self.shouldIgnoreCache == NO ) {
                response = [[ADCacheCenter sharedInstance] fetchMemoryCacheWithServiceIdentifier:self.child.serviceIdentifier methodName:self.child.methodName params:reformedParams];
            }
            // 检查是否有硬盘缓存
            if ((self.cachePolicy & ADAPIManagerCachePolicyDisk) && self.shouldIgnoreCache == NO) {
                response = [[ADCacheCenter sharedInstance] fetchDiskCacheWithServiceIdentifier:self.child.serviceIdentifier methodName:self.child.methodName params:reformedParams];
            }
            // get Cache data
            if (response != nil) {
                [self successedOnCallingAPI:response];
                return 0;
            }
            
            if ([self isReachable]) {
                self.isLoading = YES;
                id <ADServiceProtocol> service = [[ADServiceFactory sharedInstance] serviceWithIdentifier:self.child.serviceIdentifier];
                NSURLRequest *request = [service requestWithParams:reformedParams methodName:self.child.methodName requestType:self.child.requestType];
                request.service = service;
                
                NSNumber *requestNum = [[ADApiProxy sharedInstance] callApiWithRequest:request success:^(ADURLResponse * _Nonnull response) {
                    [self successedOnCallingAPI:response];
                } fail:^(ADURLResponse * _Nonnull response) {
                    ADAPIManagerErrorType errorType = ADAPIManagerErrorTypeDefault;
                    if (response.status == ADURLResponseStatusErrorCancel) {
                        errorType = ADAPIManagerErrorTypeCanceled;
                    } else if (response.status == ADURLResponseStatusErrorTimeout) {
                        errorType = ADAPIManagerErrorTypeTimeout;
                    } else if (response.status == ADURLResponseStatusErrorNoNetwork) {
                        errorType = ADAPIManagerErrorTypeNoNetWork;
                    }
                    [self failedOnCallingAPI:response errorType:errorType];
                }];
                [self.requestIdList addObject:requestNum];
                
                NSMutableDictionary *params = [reformedParams mutableCopy];
                params[kCTAPIBaseManagerRequestID] = requestNum;
                [self afterCallingAPIWithParams:params];
                return [requestNum integerValue];
            } else {
                [self failedOnCallingAPI:nil errorType:ADAPIManagerErrorTypeNoNetWork];
                return requestId;
            }
        } else {
            [self failedOnCallingAPI:nil errorType:errorType];
            return requestId;
        }
    }
    
    return requestId;
}

- (void)cancelAllRequest
{
    [[ADApiProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSUInteger)requestId
{
    [[ADApiProxy sharedInstance] cancelRequestWithRequestID:@(requestId)];
    [self removeRequestIdWithRequestID:requestId];
}

- (id)reformDataWithReformer:(id<ADAPIManagerDataReformer>)reformer
{
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(manager:reformData:)]) {
        resultData = [reformer manager:self reformData:self.fetchedRawData];
    } else {
        resultData = [self.fetchedRawData mutableCopy];
    }
    return resultData;
}

- (void)cleanData
{
    self.fetchedRawData = nil;
    self.errorType = ADAPIManagerErrorTypeDefault;
}

- (NSDictionary *)reformParams:(NSDictionary *)params
{
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP) {
        return params;
    } else {
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
    }
}

#pragma mark - private

- (void)successedOnCallingAPI:(ADURLResponse *)response
{
    self.isLoading = NO;
    self.response = response;
    
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    } else {
        self.fetchedRawData =  [response.responseData copy];
    }
    
    [self removeRequestIdWithRequestID:response.requestId];
    
    ADAPIManagerErrorType errorType = [self.validator manager:self isCorrectWithCallbackData:response.content];
    if (errorType == ADAPIManagerErrorTypeNoError) {
        if (self.cachePolicy != ADAPIManagerCachePolicyNoCache && response.isCache == NO) {
            if (self.cachePolicy & ADAPIManagerCachePolicyMemory) {
                [[ADCacheCenter sharedInstance] saveMemoryCacheWithResponse:response serviceIdentifier:self.child.serviceIdentifier methodName:self.child.methodName cacheTime:self.memoryCacheSecond];
            }
            if (self.cachePolicy & ADAPIManagerCachePolicyDisk) {
                [[ADCacheCenter sharedInstance] saveDiskCacheWithResponse:response serviceIdentifier:self.child.serviceIdentifier methodName:self.child.methodName cacheTime:self.diskCacheSecond];
            }
        }
        // 拦截器到了
        if ([self.interceptor respondsToSelector:@selector(manager:didReceiveResponse:)]) {
            [self.interceptor manager:self didReceiveResponse:response];
        }
        if ([self beforePerformSuccessWithResponse:response]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(managerCallAPIDidSuccess:)]) {
                    [self.delegate managerCallAPIDidSuccess:self];
                }
                if (self.successBlock) {
                    self.successBlock(self);
                }
            });
        }
        [self afterPerformSuccessWithResponse:response];
        
    } else {
        [self failedOnCallingAPI:response errorType:errorType];
    }
}

- (void)failedOnCallingAPI:(ADURLResponse *)response errorType:(ADAPIManagerErrorType)errorType
{
    self.isLoading = NO;
    if (response) {
        self.response = response;
    }
    
    self.errorType = errorType;
    [self removeRequestIdWithRequestID:response.requestId];
    
    // user token 无效,重新登录
    if (errorType == ADAPIManagerErrorTypeNeedLogin) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCTUserTokenIllegalNotification object:nil userInfo:@{kCTUserTokenNotificationUserInfoKeyManagerToContinue:self}];
        return;
    }
    // 可以自动处理的错误
    // user token 过期, 重新刷新
    if (errorType == ADAPIManagerErrorTypeNeedAccessToken) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCTUserTokenInvalidNotification object:nil userInfo:@{kCTUserTokenNotificationUserInfoKeyManagerToContinue:self}];
        return;
    }
    id<ADServiceProtocol> service = [[ADServiceFactory sharedInstance] serviceWithIdentifier:self.child.serviceIdentifier];
    BOOL shouldContinue = [service handleCommonErrorWithResponse:response manager:self errorType:errorType];
    // 不需要回调到业务层
    if (shouldContinue == NO) {
        return;
    }
    
    // 常规错误
    if (errorType == ADAPIManagerErrorTypeNoNetWork) {
        self.errorMessage = @"无网络连接,请检查错误";
    }
    if (errorType == ADAPIManagerErrorTypeTimeout) {
        self.errorMessage = @"请求超时";
    }
    if (errorType == ADAPIManagerErrorTypeCanceled) {
        self.errorMessage = @"您已取消";
    }
    if (errorType == ADAPIManagerErrorTypeDownGrade) {
        self.errorMessage = @"网络阻塞";
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.interceptor respondsToSelector:@selector(manager:didReceiveResponse:)]) {
            [self.interceptor manager:self didReceiveResponse:response];
        }
        if ([self beforePerformFailWithResponse:response]) {
            [self.delegate managerCallAPIDidFailed:self];
        }
        if (self.failBlock) {
            self.failBlock(self);
        }
        [self afterPerformFailWithResponse:response];
    });
}

- (BOOL)isReachable
{
    BOOL isReachability = [[CTMediator sharedInstance] ct_networkingIsReachable];
    if (!isReachability) {
        self.errorType = ADAPIManagerErrorTypeNoNetWork;
    }
    return isReachability;
}

- (void)removeRequestIdWithRequestID:(NSInteger)requestId
{
    NSNumber *requestIdToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIdToRemove = storedRequestId;
        }
    }
    if (requestIdToRemove) {
        [self.requestIdList removeObject:requestIdToRemove];
    }
}

#pragma mark - getter and setter

- (NSMutableArray *)requestIdList
{
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

- (BOOL)isLoading
{
    if (self.requestIdList.count == 0) {
        return NO;
    }
    return _isLoading;
}

@end

@implementation ADAPIBaseManager (InnerInterceptor)

// 内部持有拦截器,自身也可以成为拦截器. 装饰者模式
- (BOOL)beforePerformSuccessWithResponse:(ADURLResponse *)response
{
    BOOL result = YES;
    
    self.errorType = ADAPIManagerErrorTypeNoError;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformSuccessWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    }
    return result;
}

- (void)afterPerformSuccessWithResponse:(ADURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}

- (BOOL)beforePerformFailWithResponse:(ADURLResponse *)response
{
    BOOL result = YES;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformFailWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformFailWithResponse:response];
    }
    return result;
}

- (void)afterPerformFailWithResponse:(ADURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformFailWithResponse:)]) {
        [self.interceptor manager:self afterPerformFailWithResponse:response];
    }
}

- (BOOL)shouldCallAPIWithParams:(NSDictionary *)param
{
    BOOL result = YES;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldCallAPIWithParams:)]) {
        result = [self.interceptor manager:self shouldCallAPIWithParams:param];
    }
    return result;
}

- (void)afterCallingAPIWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterCallingAPIWithParams:)]) {
        [self.interceptor manager:self afterCallingAPIWithParams:params];
    }
}

@end
