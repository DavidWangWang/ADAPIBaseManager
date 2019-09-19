//
//  ADCacheCenter.m
//  ADAPIBaseManager
//
//  Created by David on 2019/9/16.
//  Copyright © 2019年 ADIOS. All rights reserved.
//

#import "ADCacheCenter.h"
#import "NSDictionary+AXNetworkingMethods.h"
#import "ADMemoryCache.h"
#import "ADDiskCache.h"

@interface ADCacheCenter ()

@property (nonatomic, strong) ADMemoryCache *memoryCache; ///< <#a#>
@property (nonatomic, strong) ADDiskCache *diskCache; ///< <#a#>

@end

@implementation ADCacheCenter

#pragma mark - public

+ (instancetype)sharedInstance
{
    static ADCacheCenter *cacheCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheCenter = [[ADCacheCenter alloc] init];
    });
    return cacheCenter;
}

- (ADURLResponse *)fetchMemoryCacheWithServiceIdentifier:(NSString *)serviceIdentifier
                                              methodName:(NSString *)methodName
                                                  params:(NSDictionary *)params
{
    return [self.memoryCache fetchCacheWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParmas:params]];
}

- (ADURLResponse *)fetchDiskCacheWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName params:(NSDictionary *)params
{
    return [self. diskCache fetchCacheWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParmas:params]];
}

- (void)saveMemoryCacheWithResponse:(ADURLResponse *)response
                  serviceIdentifier:(NSString *)serviceIdentifier
                         methodName:(NSString *)methodName
                          cacheTime:(NSTimeInterval)time
{
    if (response.originRequestParams && response.content && serviceIdentifier && methodName) {
        [self.memoryCache saveCacheWithResponse:response key:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParmas:response.originRequestParams] cacheTime:time];
    }
}

- (void)saveDiskCacheWithResponse:(ADURLResponse *)response
                serviceIdentifier:(NSString *)serviceIdentifier
                       methodName:(NSString *)methodName
                        cacheTime:(NSTimeInterval)time
{
    if (response.originRequestParams && response.content && serviceIdentifier && methodName) {
        [self.diskCache saveCacheWithResponse:response key:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParmas:response.originRequestParams] cacheTime:time];
    }
}

- (void)cleanCache
{
    [self cleanAllDiskCache];
    [self cleanAllMemoryCache];
}

- (void)cleanAllMemoryCache
{
    [self.memoryCache cleanAll];
}

- (void)cleanAllDiskCache
{
    [self.diskCache cleanAll];
}

- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier
                            methodName:(NSString *)methodName
                         requestParmas:(NSDictionary *)requestParams
{
    NSString *key = [NSString stringWithFormat:@"%@%@%@", serviceIdentifier, methodName, [requestParams CT_transformToUrlParamString]];
    return key;
}

#pragma mark - getter && setter

- (ADDiskCache *)diskCache
{
    if (_diskCache == nil) {
        _diskCache = [[ADDiskCache alloc] init];
    }
    return _diskCache;
}

- (ADMemoryCache *)memoryCache
{
    if (_memoryCache == nil) {
        _memoryCache = [[ADMemoryCache alloc] init];
    }
    return _memoryCache;
}

@end
