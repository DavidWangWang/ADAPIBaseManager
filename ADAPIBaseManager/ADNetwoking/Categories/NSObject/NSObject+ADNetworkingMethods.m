//
//  NSObject+ADNetworkingMethods.m
//  ADAPIBaseManager
//
//  Created by David on 2019/9/19.
//  Copyright © 2019年 ADIOS. All rights reserved.
//

#import "NSObject+ADNetworkingMethods.h"

@implementation NSObject (ADNetworkingMethods)

- (id)ad_defaultValue:(id)defaultValue
{
    if (![defaultValue isKindOfClass:[self class]]) {
        return defaultValue;
    }
    if ([self ad_isEmptyObject]) {
        return defaultValue;
    }
    return self;
}

- (BOOL)ad_isEmptyObject
{
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([self isKindOfClass:[NSString class]]) {
        if (((NSString *)self).length == 0 ) {
            return YES;
        }
    }
    if ([self isKindOfClass:[NSArray class]]) {
        if (((NSArray *)self).count == 0) {
            return YES;
        }
    }
    if ([self isKindOfClass:[NSDictionary class]]) {
        if (((NSDictionary *)self).count == 0) {
            return YES;
        }
    }
    
    return NO;
}

@end
