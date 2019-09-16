//
//  ADApiProxy.m
//  ADAPIBaseManager
//
//  Created by David on 2019/9/16.
//  Copyright © 2019年 ADIOS. All rights reserved.
//

#import "ADApiProxy.h"

@implementation ADApiProxy

- (NSNumber *)callApiWithRequest:(NSURLRequest *)request
                         success:(void (^)(ADURLResponse * _Nonnull))successCallback
                            fail:(void (^)(ADURLResponse * _Nonnull))failCallback
{
    return @1;
}

@end
