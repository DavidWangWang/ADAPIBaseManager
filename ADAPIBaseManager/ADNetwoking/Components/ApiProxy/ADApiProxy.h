//
//  ADApiProxy.h
//  ADAPIBaseManager
//
//  Created by David on 2019/9/16.
//  Copyright © 2019年 ADIOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADURLResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADApiProxy : NSObject

+ (instancetype)sharedInstance;

- (NSNumber *)callApiWithRequest:(NSURLRequest *)request
                         success:(void (^_Nullable)(ADURLResponse *_Nonnull response))successCallback
                            fail:(void (^_Nullable)(ADURLResponse *_Nonnull response))failCallback;
- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;

@end

NS_ASSUME_NONNULL_END
