//
//  ADDiskCache.h
//  ADAPIBaseManager
//
//  Created by David on 2019/9/19.
//  Copyright © 2019年 ADIOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADURLResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADDiskCache : NSObject

- (ADURLResponse *)fetchCacheWithKey:(NSString *)key;
- (void)saveCacheWithResponse:(ADURLResponse *)response
                          key:(NSString *)key
                    cacheTime:(NSTimeInterval)cacheTime;

- (void)cleanAll;

@end

NS_ASSUME_NONNULL_END
