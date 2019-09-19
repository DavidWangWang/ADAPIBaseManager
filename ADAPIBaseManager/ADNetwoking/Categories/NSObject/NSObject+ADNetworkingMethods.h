//
//  NSObject+ADNetworkingMethods.h
//  ADAPIBaseManager
//
//  Created by David on 2019/9/19.
//  Copyright © 2019年 ADIOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ADNetworkingMethods)

- (id)ad_defaultValue:(id)defaultValue;
- (BOOL)ad_isEmptyObject;

@end

NS_ASSUME_NONNULL_END
