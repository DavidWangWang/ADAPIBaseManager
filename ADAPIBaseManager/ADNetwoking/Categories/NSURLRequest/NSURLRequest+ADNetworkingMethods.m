//
//  NSURLRequest+ADNetworkingMethods.m
//  ADAPIBaseManager
//
//  Created by David on 2019/9/16.
//  Copyright © 2019年 ADIOS. All rights reserved.
//

#import "NSURLRequest+ADNetworkingMethods.h"
#import <objc/runtime.h>

static void *CTNetworkingActualRequestParams = &CTNetworkingActualRequestParams;
static void *CTNetworkingOriginRequestParams = &CTNetworkingOriginRequestParams;
static void *CTNetworkingRequestService = &CTNetworkingRequestService;

@implementation NSURLRequest (ADNetworkingMethods)

- (void)setActualRequestParams:(NSDictionary *)actualRequestParams
{
    objc_setAssociatedObject(self, CTNetworkingActualRequestParams, actualRequestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)actualRequestParams
{
    return objc_getAssociatedObject(self, CTNetworkingActualRequestParams);
}

- (void)setOriginRequestParams:(NSDictionary *)originRequestParams
{
    objc_setAssociatedObject(self, CTNetworkingOriginRequestParams, originRequestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)originRequestParams
{
    return objc_getAssociatedObject(self, CTNetworkingOriginRequestParams);
}

- (void)setService:(id<ADServiceProtocol>)service
{
    objc_setAssociatedObject(self, CTNetworkingRequestService, service, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<ADServiceProtocol>)service
{
    return objc_getAssociatedObject(self, CTNetworkingRequestService);
}

@end
