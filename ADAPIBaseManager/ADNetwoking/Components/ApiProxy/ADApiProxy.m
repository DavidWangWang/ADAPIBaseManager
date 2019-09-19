//
//  ADApiProxy.m
//  ADAPIBaseManager
//
//  Created by David on 2019/9/16.
//  Copyright © 2019年 ADIOS. All rights reserved.
//

#import "ADApiProxy.h"
#import <AFNetworking/AFNetworking.h>
#import "ADServiceProtocol.h"
#import "NSURLRequest+ADNetworkingMethods.h"

NSString * const kCTApiProxyValidateResultKeyResponseObject = @"kCTApiProxyValidateResultKeyResponseObject";
NSString * const kCTApiProxyValidateResultKeyResponseString = @"kCTApiProxyValidateResultKeyResponseString";

@interface ADApiProxy()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;

@end

@implementation ADApiProxy

#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static ADApiProxy *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ADApiProxy alloc] init];
    });
    return sharedInstance;
}

- (NSNumber *)callApiWithRequest:(NSURLRequest *)request
                         success:(void (^)(ADURLResponse * _Nonnull))successCallback
                            fail:(void (^)(ADURLResponse * _Nonnull))failCallback
{
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [[self sessionManagerWithService:request.service] dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.dispatchTable removeObjectForKey:requestID];
        
        NSDictionary *result = [request.service resultWithResponseObject:responseObject response:response request:request error:&error];
        ADURLResponse *urlResponse = [[ADURLResponse alloc] initWithResponseString:result[kCTApiProxyValidateResultKeyResponseString] requestID:requestID request:request responseObject:result[kCTApiProxyValidateResultKeyResponseObject] error:error];
        if (error) {
            !failCallback ?:failCallback(urlResponse);
        } else {
            !successCallback ?: successCallback(urlResponse);
        }
    }];
    NSNumber *requestID = @([dataTask taskIdentifier]);
    self.dispatchTable[requestID] = dataTask;
    [dataTask resume];
    
    return requestID;
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID
{
    NSURLSessionDataTask *task = self.dispatchTable[requestID];
    [task cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList
{
    for (NSNumber *requestID in requestIDList) {
        [self cancelRequestWithRequestID:requestID];
    }
}

- (AFHTTPSessionManager *)sessionManagerWithService:(id<ADServiceProtocol>)service
{
    AFHTTPSessionManager *sessionManager = nil;
    if ([service respondsToSelector:@selector(sessionManager)]) {
        sessionManager = service.sessionManager;
    }
    if (sessionManager == nil) {
        sessionManager = [AFHTTPSessionManager manager];
    }
    return sessionManager;
}

- (NSMutableDictionary *)dispatchTable
{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

@end
