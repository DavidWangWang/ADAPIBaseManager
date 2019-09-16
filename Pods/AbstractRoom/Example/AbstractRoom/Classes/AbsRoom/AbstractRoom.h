//
//  AbstractRoom.h
//  Demo
//
//  Created by David on 2019/8/6.
//  Copyright © 2019年 Wicky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PluginInterface.h"
#import "AbstractRequestHelper.h"

typedef NS_ENUM(NSUInteger, AbsRoomLeaveType) {
    
    AbsRoomLeaveTypeNone             = 0,
    AbsRoomLeaveTypeUser             = 1,    //用户主动挂断
    AbsRoomLeaveTypeMediaConflict    = 2,    //业务冲突
    AbsRoomLeaveTypeJoinInvalid      = 3,    //channel name,key,appid错误
    AbsRoomLeaveTypeRTCJoinReject    = 4,    //join reject
    AbsRoomLeaveTypeEngineStartErr   = 5,    //初始化rtcEngine 出错
    AbsRoomLeaveTypeForceEnd         = 6,    //被踢或房间解散
    AbsRoomLeaveTypePingPongTimeout  = 7,    //服务器pingpong超时
    AbsRoomLeaveTypeJoinError        = 8,    //服务器join接口err
    AbsRoomLeaveTypeJoinRTCTimeOut   = 9,    //加入rtc房间超时
    AbsRoomLeaveTypeWeilaError       = 10,   //微辣引擎error，媒体层已退出房间，业务层也要退出。
};


@class AbstractRoom;
@protocol AbstractRoomDelegate <NSObject>
@optional
- (id<AbsRoomIMPlugin>)abstractRoomOverrideIMPlugin:(AbstractRoom *)room response:(NSDictionary *)response;
- (id<AbsMediaPlugin>)abstractRoomOverrideMediaPlugin:(AbstractRoom *)room response:(NSDictionary *)response;
- (id<AbsRoomGiftPlugin>)abstractRoomOverrideGiftPlugin:(AbstractRoom *)room response:(NSDictionary *)response;
@end

@protocol AbstractRequestHelper <NSObject>
@optional
- (nonnull NSString *)convertDomainWithUrl:(nullable NSString *)url;  /// < transfrom

@property (nonatomic, copy) NSString *baseUrl;

@end

NS_ASSUME_NONNULL_BEGIN

@interface AbstractRoomConfiguration : NSObject

@property (nonatomic, copy) NSString *busiID;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic, assign) NSUInteger innerVersion;

@property (nonatomic ,assign) NSInteger giftCategory;

@property (nonatomic ,strong) UIView * giftPanelContainer;
@property (nonatomic ,strong) UIView * giftEffectContainer;

@end

@interface AbstractRoom : NSObject

@property (nonatomic, strong) void (^globalCallback)();
@property (nonatomic, strong, readonly) id<AbsRoomIMPlugin> imPlugin;
@property (nonatomic, strong, readonly) id<AbsMediaPlugin> mediaPlugin;
@property (nonatomic, strong, readonly) id<AbsRoomGiftPlugin> giftPlugin;
@property (nonatomic, copy, readonly) NSString * roomid;
@property (nonatomic, strong, readonly) AbstractRoomConfiguration * conf;
@property (nonatomic, weak) id<AbstractRoomDelegate> delegate;
@property (nonatomic, strong) NSObject<AbstractRequestHelper> *requestSupport; ///< 数据支持

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

-(instancetype)initWithConf:(__kindof AbstractRoomConfiguration *)conf NS_DESIGNATED_INITIALIZER;

// roombase API
- (void)createRoom:(RoomRequestCallback)callback;
- (void)enterRoom:(NSDictionary *)roomInfo callback:(RoomRequestCallback)handler;
-(void)refreshRoom:(RoomRequestCallback)callback;
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
// 主持人邀请用户上麦
- (void)inviteMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler;
// 用户同意邀请上麦
- (void)confirmInviteMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler;
// 用户拒绝邀请上麦
- (void)rejectInviteMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler;
// 主持人清空申请队列
- (void)clearMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler;
// 禁止说话
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
