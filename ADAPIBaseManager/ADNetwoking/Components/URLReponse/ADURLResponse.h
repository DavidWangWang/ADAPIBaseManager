//
//  ADURLResponse.h
//  ADAPIBaseManager
//
//  Created by David on 2019/9/16.
//  Copyright © 2019年 ADIOS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ADURLResponseStatus)
{
    ADURLResponseStatusSuccess, //作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的CTAPIBaseManager来决定。
    ADURLResponseStatusErrorTimeout,
    ADURLResponseStatusErrorCancel,
    ADURLResponseStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};

NS_ASSUME_NONNULL_BEGIN

@interface ADURLResponse : NSObject

@property (nonatomic, readonly,assign) ADURLResponseStatus status;
@property (nonatomic, copy, readonly) id content;
@property (nonatomic, copy, readonly) NSData *responseData;
@property (nonatomic, assign, readonly) NSInteger requestId;

@property (nonatomic, assign, readonly) BOOL isCache;

@end

NS_ASSUME_NONNULL_END
