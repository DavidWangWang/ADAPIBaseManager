//
//  ADCacheCenter.h
//  ADAPIBaseManager
//
//  Created by David on 2019/9/16.
//  Copyright © 2019年 ADIOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADURLResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADCacheCenter : NSObject

+ (instancetype)sharedInstance;

- (nullable ADURLResponse *)fetchMemoryCacheWithServiceIdentifier:(NSString *)serviceIdentifier
                                            methodName:(NSString *)methodName
                                                params:(NSDictionary *)params;

- (nullable ADURLResponse *)fetchDiskCacheWithServiceIdentifier:(NSString *)serviceIdentifier
                                                     methodName:(NSString *)methodName
                                                         params:(NSDictionary *)params;

- (void)saveMemoryCacheWithResponse:(ADURLResponse *)response
                  serviceIdentifier:(NSString *)serviceIdentifier
                         methodName:(NSString *)methodName
                          cacheTime:(NSTimeInterval)time;
- (void)saveDiskCacheWithResponse:(ADURLResponse *)response
                serviceIdentifier:(NSString *)serviceIdentifier
                       methodName:(NSString *)methodName
                        cacheTime:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
