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


/*
 检查错误,如果需要回调业务层,则返回YES(例如网络错误,需要业务层弹框)
 检查错误后,不要走fail路径报到业务层,return NO.
*/
- (BOOL)handleCommonErrorWithResponse:(ADURLResponse *)response
                              manager:(ADAPIBaseManager *)manager
                            errorType:(ADAPIManagerErrorType)errorType;

@end


#endif /* ADServiceProtocol_h */
