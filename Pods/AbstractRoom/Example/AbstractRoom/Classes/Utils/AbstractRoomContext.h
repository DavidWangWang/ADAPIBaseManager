//
//  AbstractRoomContext.h
//  AbstractRoom_Example
//
//  Created by David on 2019/9/11.
//  Copyright © 2019年 351723770@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbsHttpDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AbstractRoomContext : NSObject

+ (AbstractRoomContext *)sharedContext;

@property (nonatomic, strong) NSObject<AbsHttpDelegate> *httpDelegate;

@end

NS_ASSUME_NONNULL_END
