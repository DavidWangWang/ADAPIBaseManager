//
//  NSURLRequest+ADNetworkingMethods.h
//  ADAPIBaseManager
//
//  Created by David on 2019/9/16.
//  Copyright © 2019年 ADIOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADServiceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSURLRequest (ADNetworkingMethods)

@property (nonatomic, copy) NSDictionary *actualRequestParams;
@property (nonatomic, copy) NSDictionary *originRequestParams;
@property (nonatomic, strong) id<ADServiceProtocol> service;

@end

NS_ASSUME_NONNULL_END
