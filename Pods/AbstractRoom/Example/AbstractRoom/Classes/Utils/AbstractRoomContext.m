//
//  AbstractRoomContext.m
//  AbstractRoom_Example
//
//  Created by David on 2019/9/11.
//  Copyright © 2019年 351723770@qq.com. All rights reserved.
//

#import "AbstractRoomContext.h"

@implementation AbstractRoomContext

static AbstractRoomContext *instanceConetxt = nil;
+ (AbstractRoomContext *)sharedContext
{
    if (!instanceConetxt) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instanceConetxt = [[AbstractRoomContext alloc] init];
        });
    }
    return instanceConetxt;
}

@end
