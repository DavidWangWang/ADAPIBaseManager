//
//  AbstractRoom+IMPlugin.m
//  MomoChat
//
//  Created by Wicky on 2019/8/17.
//  Copyright © 2019 wemomo.com. All rights reserved.
//

#import "AbstractRoom+IMPlugin.h"

@implementation AbstractRoom (IMPlugin)

- (void)sendMsg:(NSString *)msg
{
    [self.imPlugin sendMsg:msg];
}

- (void)sendMsgWithParams:(NSDictionary *)params
{
    [self.imPlugin sendMsgWithParams:params];
}

@end
