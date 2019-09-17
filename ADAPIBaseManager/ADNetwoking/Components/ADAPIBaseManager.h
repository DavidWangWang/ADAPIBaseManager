//
//  ADAPIBaseManager.h
//  ADAPIBaseManager
//
//  Created by David on 2019/9/16.
//  Copyright © 2019年 ADIOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADNetworkingDefines.h"
#import "ADURLResponse.h"

@protocol ADAPIManager <NSObject>

@required
- (nonnull NSString *)methodName;
- (nonnull NSString *)serviceIdentifier;
- (ADAPIManagerRequestType)requestType;

@optional
- (void)cleanData;
- (nullable NSDictionary *)reformParams:(nullable NSDictionary *)params;
- (NSUInteger)loadDataWithParams:(nullable NSDictionary *)params;
@end


NS_ASSUME_NONNULL_BEGIN

@interface ADAPIBaseManager : NSObject

@property (nonatomic, weak) id <ADAPIManagerParam> _Nullable paramSource;  /// < 参数获取器
@property (nonatomic, weak) NSObject<ADAPIManager> *child;
@property (nonatomic, weak) id<ADAPIManagerInterceptor> interceptor; /// < 拦截器
@property (nonatomic, weak) id<ADAPIManagerValidator> validator;     /// < 验证器

// cache
@property (nonatomic, assign) ADAPIManagerCachePolicy cachePolicy;
@property (nonatomic, assign) BOOL shouldIgnoreCache;  //默认NO
@property (nonatomic, assign) NSTimeInterval memoryCacheSecond; // 默认 3 * 60
@property (nonatomic, assign) NSTimeInterval diskCacheSecond; // 默认 3 * 60
// response
@property (nonatomic, strong) ADURLResponse *response;

// start
- (NSInteger)loadData;
+ (NSInteger)loadDataWithParams:(NSDictionary * _Nullable)params
                        success:(void (^ _Nullable)(ADAPIBaseManager * _Nonnull apiManager))successCallback
                           fail:(void (^ _Nullable)(ADAPIBaseManager * _Nonnull apiManager))failCallback;


- (BOOL)shouldCallAPIWithParams:(nullable NSDictionary *)param;
- (void)afterCallingAPIWithParams:(NSDictionary *)params;

@end

@interface ADAPIBaseManager(InnerInterceptor)

- (BOOL)beforePerformSuccessWithResponse:(ADURLResponse *_Nullable)response;

@end


NS_ASSUME_NONNULL_END
