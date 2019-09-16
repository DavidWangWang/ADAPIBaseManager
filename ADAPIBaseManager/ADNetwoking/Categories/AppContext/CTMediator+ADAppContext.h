//
//  CTMediator+ADAppContext.h
//  ADAPIBaseManager
//
//  Created by David on 2019/9/16.
//  Copyright © 2019年 ADIOS. All rights reserved.
//

#import "CTMediator.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTMediator (ADAppContext)

- (BOOL)ct_shouldPrintNetworkingLog;
- (BOOL)ct_networkingIsReachable;
- (NSInteger)ct_cacheResponseCountLimit;

@end

NS_ASSUME_NONNULL_END
