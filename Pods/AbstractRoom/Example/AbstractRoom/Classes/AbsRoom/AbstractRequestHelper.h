//
//  AbstractRequestHelper.h
//  MomoChat
//
//  Created by David on 2019/8/7.
//  Copyright © 2019年 wemomo.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbsHttpDelegate.h"

typedef void(^RoomRequestCallback)(BOOL success, NSDictionary *respInfo, NSDictionary *errorInfo);

NS_ASSUME_NONNULL_BEGIN

@interface AbstractRequestHelper : NSObject

- (instancetype)initWithBaseURL:(NSString *)baseURL NS_DESIGNATED_INITIALIZER;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, assign) NSUInteger innverVersion;

- (void)createRoom:(nullable NSDictionary *)roomInfo callback:(RoomRequestCallback)handler;

// 加入房间
- (void)enterRoom:(nullable NSDictionary *)roomInfo callback:(RoomRequestCallback)handler;
- (void)refreshRoom:(nullable NSDictionary *)roomInfo callback:(RoomRequestCallback)handler;
// 离开房间
- (void)leaveRoom:(nullable NSDictionary *)roomInfo;
// 申请上麦
- (void)applyMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler;
// 取消申请上麦
- (void)cancelApplyMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler;
// 主持人同意上麦
- (void)confirmApplyMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler;
// 主持人拒绝申请上麦
- (void)rejectApplyMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler;
// 支持人邀请用户上麦
- (void)inviteMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler;
// 用户同意邀请上麦
- (void)confirmInviteMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler;
// 用户拒绝邀请上麦
- (void)rejectInviteMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler;
// 主持人清空申请队列
- (void)clearMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler;

- (void)forbidSpeak:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler;

// 主持人禁止麦克风
- (void)muteMircophone:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler;

// 离座
- (void)disconnectMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler;
// 踢麦
- (void)stopMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler;
// 成为主持人
- (void)confirmApplyMediaConnection1:(nonnull NSDictionary *)others callback:(RoomRequestCallback)handler;

@end

NS_ASSUME_NONNULL_END
