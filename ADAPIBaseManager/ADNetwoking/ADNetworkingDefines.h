//
//  ADNetworkingDefines.h
//  ADAPIBaseManager
//
//  Created by David on 2019/9/16.
//  Copyright © 2019年 ADIOS. All rights reserved.
//

#ifndef ADNetworkingDefines_h
#define ADNetworkingDefines_h

#import <Foundation/Foundation.h>

@class ADAPIBaseManager;
@class ADURLResponse;

typedef NS_ENUM (NSUInteger, ADAPIManagerRequestType){
    ADAPIManagerRequestTypePost,
    ADAPIManagerRequestTypeGet,
    ADAPIManagerRequestTypePut,
    ADAPIManagerRequestTypeDelete,
};

typedef NS_ENUM (NSUInteger, ADAPIManagerErrorType){
    ADAPIManagerErrorTypeNeedAccessToken, // 需要重新刷新accessToken
    ADAPIManagerErrorTypeNeedLogin,       // 需要登陆
    ADAPIManagerErrorTypeDefault,         // 没有产生过API请求，这个是manager的默认状态。
    ADAPIManagerErrorTypeLoginCanceled,   // 调用API需要登陆态，弹出登陆页面之后用户取消登陆了
    ADAPIManagerErrorTypeSuccess,         // API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    ADAPIManagerErrorTypeNoContent,       // API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    ADAPIManagerErrorTypeParamsError,     // 参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    ADAPIManagerErrorTypeTimeout,         // 请求超时。CTAPIProxy设置的是20秒超时，具体超时时间的设置请自己去看CTAPIProxy的相关代码。
    ADAPIManagerErrorTypeNoNetWork,       // 网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
    ADAPIManagerErrorTypeCanceled,        // 取消请求
    ADAPIManagerErrorTypeNoError,         // 无错误
    ADAPIManagerErrorTypeDownGrade,       // APIManager被降级了
};

typedef NS_OPTIONS(NSUInteger, ADAPIManagerCachePolicy) {
    ADAPIManagerCachePolicyNoCache = 0,
    ADAPIManagerCachePolicyMemory = 1 << 0,
    ADAPIManagerCachePolicyDisk = 1 << 1,
};

typedef NS_ENUM (NSUInteger, ADServiceAPIEnvironment){
    ADServiceAPIEnvironmentDevelop,
    ADServiceAPIEnvironmentReleaseCandidate,
    ADServiceAPIEnvironmentRelease
};

/*
 Interceptor
**/
@protocol ADAPIManagerInterceptor <NSObject>

@optional
- (BOOL)manager:(ADAPIBaseManager *_Nonnull)manager shouldCallAPIWithParams:(NSDictionary *_Nullable)params;
- (void)manager:(ADAPIBaseManager *_Nonnull)manager didReceiveResponse:(ADURLResponse *_Nullable)response;

@end

@protocol ADAPIManagerValidator <NSObject>

@required
- (ADAPIManagerErrorType)maneger:(ADAPIBaseManager *_Nonnull)manager isCorrectWithParamsData:(NSDictionary *_Nullable)data;
- (ADAPIManagerErrorType)manager:(ADAPIBaseManager *_Nonnull)manager isCorrectWithCallbackData:(NSDictionary *_Nullable)data;

@end

@protocol ADAPIManagerParam <NSObject>

@required
- (NSDictionary *_Nullable)paramsForApi:(ADAPIBaseManager *_Nonnull)manager;

@end

#endif /* ADNetworkingDefines_h */
