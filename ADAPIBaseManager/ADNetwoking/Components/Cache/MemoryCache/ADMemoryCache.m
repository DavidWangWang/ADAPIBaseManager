//
//  ADMemoryCache.m
//  ADAPIBaseManager
//
//  Created by David on 2019/9/19.
//  Copyright © 2019年 ADIOS. All rights reserved.
//

#import "ADMemoryCache.h"
#import "ADMemoryCachedRecord.h"

@interface ADMemoryCache ()

@property (nonatomic, strong) NSCache *cache; ///< 缓存池

@end

@implementation ADMemoryCache

- (void)saveCacheWithResponse:(ADURLResponse *)response
                          key:(NSString *)key
                    cacheTime:(NSTimeInterval)cacheTime
{
    // 1. 从cache中去获取元素
    // 2. 元素存在 如果response 为nil 则清空. reponse不为空则更新数据
    // 3. 元素不存在, response为nil 直接return ; reponse不是空的话,则生成Record存储在Cache中
    ADMemoryCachedRecord *cachedRecord = [self.cache objectForKey:key];
    if (cachedRecord == nil) {
        cachedRecord = [[ADMemoryCachedRecord alloc] initWithData:response.content];
    }
    cachedRecord.cacheTime = cacheTime;
    [cachedRecord updateContent:[NSJSONSerialization dataWithJSONObject:response.content options:0 error:NULL]];
    [self.cache setObject:cachedRecord forKey:key];
}

- (ADURLResponse *)fetchCacheWithKey:(NSString *)key
{
    // 1.从cache中获取数据  2.如果数据为nil直接返回  3. record 找到的话超时的话.清空数据 返回nil/ .如果返回nil的话.直接返回nil.否则合成ADURLResponse
    ADURLResponse *response = nil;
    ADMemoryCachedRecord *cacheRecord = [self.cache objectForKey:key];
    if (cacheRecord != nil) {
        if (!cacheRecord.isOutdated && !cacheRecord.isEmpty) {
            response = [[ADURLResponse alloc] initWithData:cacheRecord.content];
        } else {
            [self.cache removeObjectForKey:key];
        }
    }
    
    return response;
}


- (void)cleanAll
{
    [self.cache removeAllObjects];
}

- (NSCache *)cache
{
    if (_cache == nil) {
        _cache = [[NSCache alloc] init];
    }
    return _cache;
}

@end
