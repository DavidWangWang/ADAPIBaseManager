//
//  ADMemoryCachedRecord.h
//  ADAPIBaseManager
//
//  Created by David on 2019/9/19.
//  Copyright © 2019年 ADIOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADMemoryCachedRecord : NSObject

@property (nonatomic, copy, readonly) NSData *content;
@property (nonatomic, copy, readonly) NSDate *lastUpdateTime;
@property (nonatomic, assign) NSTimeInterval cacheTime;

- (instancetype)initWithData:(NSData *)data;
- (void)updateContent:(NSData *)data;

- (BOOL)isOutdated;
- (BOOL)isEmpty;

@end

NS_ASSUME_NONNULL_END
