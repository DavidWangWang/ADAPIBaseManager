//
//  ADCacheCenter.m
//  ADAPIBaseManager
//
//  Created by David on 2019/9/16.
//  Copyright © 2019年 ADIOS. All rights reserved.
//

#import "ADCacheCenter.h"

@implementation ADCacheCenter

+ (instancetype)sharedInstance
{
    static ADCacheCenter *cacheCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheCenter = [[ADCacheCenter alloc] init];
    });
    return cacheCenter;
}

- (ADURLResponse *)fetchMemoryCacheWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName params:(NSDictionary *)params
{
    return nil;
}

@end
