//
//  CTMediator+ADAppContext.m
//  ADAPIBaseManager
//
//  Created by David on 2019/9/16.
//  Copyright © 2019年 ADIOS. All rights reserved.
//

#import "CTMediator+ADAppContext.h"

@implementation CTMediator (ADAppContext)

- (BOOL)ct_shouldPrintNetworkingLog
{
    return YES;
}

- (BOOL)ct_networkingIsReachable
{
    return YES;
}

- (NSInteger)ct_cacheResponseCountLimit
{
    return 2;
}

@end
