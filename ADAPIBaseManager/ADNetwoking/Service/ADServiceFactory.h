//
//  ADServiceFactory.h
//  ADAPIBaseManager
//
//  Created by David on 2019/9/16.
//  Copyright © 2019年 ADIOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADServiceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADServiceFactory : NSObject

+ (instancetype)sharedInstance;

- (id<ADServiceProtocol>)serviceWithIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
