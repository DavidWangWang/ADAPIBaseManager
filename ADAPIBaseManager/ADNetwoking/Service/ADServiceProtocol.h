//
//  ADServiceProtocol.h
//  ADAPIBaseManager
//
//  Created by David on 2019/9/16.
//  Copyright © 2019年 ADIOS. All rights reserved.
//

#ifndef ADServiceProtocol_h
#define ADServiceProtocol_h

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "ADNetworkingDefines.h"

@protocol ADServiceProtocol <NSObject>

@property (nonatomic, assign) ADServiceAPIEnvironment apiEnvironment;

// get request with params/identify/
- (NSURLRequest *)requestWithParams:(NSDictionary *)params
                         methodName:(NSString *)methodName
                        requestType:(ADAPIManagerRequestType)requestType;




@end


#endif /* ADServiceProtocol_h */
