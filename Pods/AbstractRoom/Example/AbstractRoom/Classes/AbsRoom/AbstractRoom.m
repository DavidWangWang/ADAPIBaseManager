//
//  AbstractRoom.m
//  Demo
//
//  Created by David on 2019/8/6.
//  Copyright © 2019年 Wicky. All rights reserved.
//

#import "AbstractRoom.h"

@interface AbstractRoom()

@property (nonatomic ,strong) NSDictionary * enterInfo;
@property (nonatomic, strong) id<AbsRoomIMPlugin> imPlugin;
@property (nonatomic, strong) id<AbsMediaPlugin> mediaPlugin;
@property (nonatomic, strong) id<AbsRoomGiftPlugin> giftPlugin;

@property (nonatomic, assign) AbsRoomLeaveType leaveReason;
@property (nonatomic, strong) AbstractRequestHelper *requestHelper; ///< <#a#>

@end

@implementation AbstractRoom

- (instancetype)initWithConf:(__kindof AbstractRoomConfiguration *)conf {
    if (self = [super init]) {
        _leaveReason = AbsRoomLeaveTypeNone;
        _conf = conf;
        
        [self addNotifaction];
    }
    return self;
}

- (void)dealloc
{
    
}

#pragma mark - public

- (void)setupRoomInfoWithResponse:(NSDictionary *)response
{
    _roomid = response[@"roomId"];
}

- (void)loadPluginIfNeedWithResponse:(NSDictionary *)response
{
    if (!self.imPlugin) {
        if ([self.delegate respondsToSelector:@selector(abstractRoomOverrideIMPlugin:response:)]) {
            self.imPlugin = [self.delegate abstractRoomOverrideIMPlugin:self response:response];
        }
    }
    
    if (!self.mediaPlugin) {
        if ([self.delegate respondsToSelector:@selector(abstractRoomOverrideMediaPlugin:response:)]) {
            self.mediaPlugin = [self.delegate abstractRoomOverrideMediaPlugin:self response:response];
        }
    }
    
    if (!self.giftPlugin) {
        if ([self.delegate respondsToSelector:@selector(abstractRoomOverrideGiftPlugin:response:)]) {
            self.giftPlugin = [self.delegate abstractRoomOverrideGiftPlugin:self response:response];
        }
    }
}

- (void)bulidConnect:(NSDictionary *)response
{
    [self setUpMediaService:response];
    [self setUpIMService:response];
}

- (void)setUpMediaService:(NSDictionary *)response
{
    [self.mediaPlugin setUpWithData:response];
}

- (void)setUpIMService:(NSDictionary *)response {
    [self.imPlugin registPluginWithParam:response];
    [self.imPlugin connect];
}

#pragma mark - roombase Api

- (void)createRoom:(RoomRequestCallback)callback
{
   [self.requestHelper createRoom:nil callback:callback];
}

- (void)enterRoom:(NSDictionary *)roomInfo callback:(RoomRequestCallback)handler
{
    self.enterInfo = roomInfo;
    __weak typeof(self) weakSelf = self;
    [self.requestHelper enterRoom:roomInfo callback:^(BOOL success, NSDictionary *respInfo, NSDictionary *errorInfo) {
        __strong typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return ;
        }
        if (success) {
            [strongSelf setupRoomInfoWithResponse:respInfo];
            [strongSelf loadPluginIfNeedWithResponse:respInfo];
            [strongSelf bulidConnect:respInfo];
        } else {
            !strongSelf.globalCallback ? : strongSelf.globalCallback();
        }
        if (handler) {
            handler(success, respInfo, errorInfo);
        }
    }];
}

- (void)refreshRoom:(RoomRequestCallback)callback {
    __weak typeof(self) weakSelf = self;
   
    [self.requestHelper refreshRoom:self.enterInfo callback:^(BOOL success, NSDictionary *respInfo, NSDictionary *errorInfo) {
        __strong typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return ;
        }
        if (success) {
            [strongSelf bulidConnect:respInfo];
        } else {
            !strongSelf.globalCallback ? : strongSelf.globalCallback();
        }
        if (callback) {
            callback(success, respInfo, errorInfo);
        }
    }];
}

- (void)leaveRoom:(NSDictionary *)roomInfo
{
    [self.imPlugin destory];
    [self.mediaPlugin destory];
    [self.requestHelper leaveRoom:roomInfo];
}

- (void)applyMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler
{
    [self.requestHelper applyMediaConnection:params callback:handler];
}

- (void)cancelApplyMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler
{
    [self.requestHelper cancelApplyMediaConnection:params callback:handler];
}

- (void)confirmApplyMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler
{
    [self.requestHelper confirmApplyMediaConnection:params callback:handler];
}

- (void)rejectApplyMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler
{
    [self.requestHelper rejectApplyMediaConnection:params callback:handler];
}

- (void)inviteMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler
{
    [self.requestHelper inviteMediaConnection:params callback:handler];
}

- (void)confirmInviteMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler
{
    [self.requestHelper confirmInviteMediaConnection:params callback:handler];
}

- (void)rejectInviteMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler
{
    [self.requestHelper rejectInviteMediaConnection:params callback:handler];
}

- (void)clearMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler
{
    [self.requestHelper clearMediaConnection:params callback:handler];
}

- (void)forbidSpeak:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler
{
    [self.requestHelper forbidSpeak:params callback:handler];
}

- (void)muteMircophone:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler
{
    [self.requestHelper muteMircophone:params callback:handler];
}

- (void)disconnectMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler
{
    [self.requestHelper disconnectMediaConnection:params callback:handler];
}

- (void)stopMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler
{
    [self.requestHelper stopMediaConnection:params callback:handler];
}

- (void)confirmApplyMediaConnection1:(nonnull NSDictionary *)others callback:(RoomRequestCallback)handler
{
    [self.requestHelper confirmApplyMediaConnection1:others callback:handler];
}


#pragma mark - private

#pragma mark - notification

- (void)addNotifaction
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)enterBackground
{
    [self.mediaPlugin enterBackground];
}

- (void)enterForeground
{
    [self.mediaPlugin enterForeground];
}

#pragma mark - setter && getter

- (AbstractRequestHelper *)requestHelper
{
    if (!_requestHelper) {
        NSString *url = self.conf.baseUrl;
        if ([self.requestSupport respondsToSelector:@selector(convertDomainWithUrl:)]) {
            url = [self.requestSupport convertDomainWithUrl:url];
        }
        _requestHelper = [[AbstractRequestHelper alloc]initWithBaseURL:url];
        _requestHelper.innverVersion = self.conf.innerVersion;
    }
    return _requestHelper;
}

@end

@implementation AbstractRoomConfiguration

@end
