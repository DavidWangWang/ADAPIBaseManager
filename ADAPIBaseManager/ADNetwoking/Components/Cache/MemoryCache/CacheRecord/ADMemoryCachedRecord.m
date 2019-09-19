//
//  ADMemoryCachedRecord.m
//  ADAPIBaseManager
//
//  Created by David on 2019/9/19.
//  Copyright © 2019年 ADIOS. All rights reserved.
//

#import "ADMemoryCachedRecord.h"

@interface ADMemoryCachedRecord ()

@property (nonatomic, copy) NSData *content;
@property (nonatomic, copy) NSDate *lastUpdateTime;

@end

@implementation ADMemoryCachedRecord

- (BOOL)isOutdated
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
    return timeInterval > self.cacheTime;
}

- (BOOL)isEmpty
{
    return _content == nil;
}

- (instancetype)initWithData:(NSData *)data
{
    if (self = [super init]) {
        _content = data;
        _lastUpdateTime = NSDate.date;
    }
    return self;
}

- (void)updateContent:(NSData *)data
{
    _lastUpdateTime = NSDate.date;
    _content = data;
}

@end
