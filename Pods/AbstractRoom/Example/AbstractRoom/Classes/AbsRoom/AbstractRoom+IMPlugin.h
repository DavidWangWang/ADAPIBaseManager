//
//  AbstractRoom+IMPlugin.h
//  MomoChat
//
//  Created by Wicky on 2019/8/17.
//  Copyright © 2019 wemomo.com. All rights reserved.
//


#import "AbstractRoom.h"

NS_ASSUME_NONNULL_BEGIN

@interface AbstractRoom (IMPlugin)

- (void)sendMsg:(NSString *)msg;

- (void)sendMsgWithParams:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
