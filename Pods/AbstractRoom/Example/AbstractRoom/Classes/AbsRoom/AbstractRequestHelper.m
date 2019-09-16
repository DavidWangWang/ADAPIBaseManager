//
//  AbstractRequestHelper.m
//  MomoChat
//
//  Created by David on 2019/8/7.
//  Copyright © 2019年 wemomo.com. All rights reserved.
//

#import "AbstractRequestHelper.h"
#import "AbstractRoomContext.h"

@interface AbstractRequestHelper()

@property (nonatomic, weak) id<AbsHttpDelegate> httpDelegate;
@property (nonatomic, copy) NSString *baseURL;
@property (nonatomic, strong) NSDictionary *roomInfo; ///< <#a#>

@end

@implementation AbstractRequestHelper

- (instancetype)initWithBaseURL:(NSString *)baseURL
{
    if (self = [super init]) {
        self.baseURL = baseURL;
    }
    return self;
}

- (void)createRoom:(NSDictionary *)roomInfo callback:(RoomRequestCallback)handler
{
    NSMutableDictionary *params = roomInfo.mutableCopy;
    [params addEntriesFromDictionary:[self baseParamsWithAction:@"createRoom"]];
    [self.httpDelegate httpPost:self.baseURL params:params completionHandler:handler];
}

#pragma mark - base API

- (void)extracted:(RoomRequestCallback _Nonnull)handler params:(NSMutableDictionary *)params
{
    __weak typeof(self) weakSelf = self;
    [self.httpDelegate httpPost:self.baseURL params:params completionHandler:^(BOOL success, NSDictionary *respInfo, NSDictionary *errorInfo) {
         __strong typeof(self) strongSelf = weakSelf;
        if (!strongSelf) return ;
        NSDictionary *data = respInfo[@"data"] ?: @{};
        strongSelf.roomInfo = data;
        if (handler) {
            handler(success, respInfo, errorInfo);
        }
    }];
}

- (void)enterRoom:(nullable NSDictionary *)roomInfo callback:(RoomRequestCallback)handler
{
    NSMutableDictionary *params = roomInfo.mutableCopy;
    [params addEntriesFromDictionary:[self baseParamsWithAction:@"enterRoom"]];
    [self extracted:handler params:params];
}

-(void)refreshRoom:(NSDictionary *)roomInfo callback:(RoomRequestCallback)handler {
    
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:roomInfo];
    params[@"action"] = @"queryRoomDetail";
    __weak typeof(self) weakSelf = self;
    [self.httpDelegate httpPost:self.baseURL params:params completionHandler:^(BOOL success, NSDictionary *respInfo, NSDictionary *errorInfo) {
         __strong typeof(self) strongSelf = weakSelf;
        if (!strongSelf) return ;
        NSDictionary *data = respInfo[@"data"] ?: @{};
        strongSelf.roomInfo = data;
        if (handler) {
            handler(success, respInfo, errorInfo);
        }
    }];
}

// 离开房间
- (void)leaveRoom:(nullable NSDictionary *)roomInfo
{
    NSMutableDictionary *params = self.roomInfo.mutableCopy;
    [params addEntriesFromDictionary:roomInfo];
    [params addEntriesFromDictionary:[self baseParamsWithAction:@"exitRoom"]];
    params[@"reason"] = @"1";
    [self.httpDelegate httpPost:self.baseURL params:params completionHandler:nil];
}

// 申请上麦
- (void)applyMediaConnection:(nonnull NSDictionary *)others callback:(RoomRequestCallback)handler
{
    NSMutableDictionary *params = self.roomInfo.mutableCopy;
    [params addEntriesFromDictionary:others];
    [params addEntriesFromDictionary:[self baseParamsWithAction:@"applyUpSeat"]];
    [self.httpDelegate httpPost:self.baseURL params:params completionHandler:handler];
}

// 取消申请上麦
- (void)cancelApplyMediaConnection:(nonnull NSDictionary *)others callback:(RoomRequestCallback)handler
{
    NSMutableDictionary *params = self.roomInfo.mutableCopy;
    [params addEntriesFromDictionary:others];
    [params addEntriesFromDictionary:[self baseParamsWithAction:@"cancelApplyUpSeat"]];
    [self.httpDelegate httpPost:self.baseURL params:params completionHandler:handler];
}

// 主持人同意上麦
- (void)confirmApplyMediaConnection:(nonnull NSDictionary *)others callback:(RoomRequestCallback)handler
{
    NSMutableDictionary *params = self.roomInfo.mutableCopy;
    [params addEntriesFromDictionary:others];
    [params addEntriesFromDictionary:[self baseParamsWithAction:@"confirmApplyUpSeat"]];
    [self.httpDelegate httpPost:self.baseURL params:params completionHandler:handler];
}

// 成为主持人
- (void)confirmApplyMediaConnection1:(nonnull NSDictionary *)others callback:(RoomRequestCallback)handler
{
    NSMutableDictionary *params = self.roomInfo.mutableCopy;
    [params addEntriesFromDictionary:others];
    [params addEntriesFromDictionary:[self baseParamsWithAction:@"confirmApplyUpSeat"]];
   
    [self.httpDelegate httpPost:self.baseURL params:params completionHandler:handler];
}


// 主持人拒绝申请上麦
- (void)rejectApplyMediaConnection:(nonnull NSDictionary *)others callback:(RoomRequestCallback)handler
{
    NSMutableDictionary *params = self.roomInfo.mutableCopy;
    [params addEntriesFromDictionary:others];
    [params addEntriesFromDictionary:[self baseParamsWithAction:@"rejectApplyUpSeat"]];
    [self.httpDelegate httpPost:self.baseURL params:params completionHandler:handler];
}

// 主持人邀请用户上麦
- (void)inviteMediaConnection:(nonnull NSDictionary *)others callback:(RoomRequestCallback)handler
{
    NSMutableDictionary *params = self.roomInfo.mutableCopy;
    [params addEntriesFromDictionary:others];
    [params addEntriesFromDictionary:[self baseParamsWithAction:@"inviteUpSeat"]];
    [self.httpDelegate httpPost:self.baseURL params:params completionHandler:handler];
}

// 用户同意邀请上麦
- (void)confirmInviteMediaConnection:(nonnull NSDictionary *)others callback:(RoomRequestCallback)handler
{
    NSMutableDictionary *params = self.roomInfo.mutableCopy;
    [params addEntriesFromDictionary:others];
    [params addEntriesFromDictionary:[self baseParamsWithAction:@"confirmInviteUpSeat"]];
    
    [self.httpDelegate httpPost:self.baseURL params:params completionHandler:handler];
}

// 用户拒绝邀请上麦
- (void)rejectInviteMediaConnection:(nonnull NSDictionary *)others callback:(RoomRequestCallback)handler
{
    NSMutableDictionary *params = self.roomInfo.mutableCopy;
    [params addEntriesFromDictionary:others];
    [params addEntriesFromDictionary:[self baseParamsWithAction:@"rejectInviteUpSeat"]];
    
    [self.httpDelegate httpPost:self.baseURL params:params completionHandler:handler];
}

// 主持人清空申请队列
- (void)clearMediaConnection:(nonnull NSDictionary *)others callback:(RoomRequestCallback)handler
{
    NSMutableDictionary *params = self.roomInfo.mutableCopy;
    [params addEntriesFromDictionary:others];
    [params addEntriesFromDictionary:[self baseParamsWithAction:@"clearCandidateQueue"]];
    
    [self.httpDelegate httpPost:self.baseURL params:params completionHandler:handler];
}

- (void)forbidSpeak:(NSDictionary *)others callback:(RoomRequestCallback)handler
{
    NSMutableDictionary *params = self.roomInfo.mutableCopy;
    [params addEntriesFromDictionary:others];
    [params addEntriesFromDictionary:[self baseParamsWithAction:@"forbidSpeak"]];
    [self.httpDelegate httpPost:self.baseURL params:params completionHandler:handler];
}

// 主持人禁止麦克风
- (void)muteMircophone:(nonnull NSDictionary *)others callback:(RoomRequestCallback)handler
{
    NSMutableDictionary *params = self.roomInfo.mutableCopy;
    [params addEntriesFromDictionary:others];
    [params addEntriesFromDictionary:[self baseParamsWithAction:@"muteMicrophone"]];

    [self.httpDelegate httpPost:self.baseURL params:params completionHandler:handler];
    
}

// 离座
- (void)disconnectMediaConnection:(nonnull NSDictionary *)others callback:(RoomRequestCallback)handler
{
    NSMutableDictionary *params = self.roomInfo.mutableCopy;
    [params addEntriesFromDictionary:others];
    [params addEntriesFromDictionary:[self baseParamsWithAction:@"leaveSeat"]];
    params[@"reason"] = @"1";
    [self.httpDelegate httpPost:self.baseURL params:params completionHandler:handler];
}

// 踢麦
- (void)stopMediaConnection:(nonnull NSDictionary *)params callback:(RoomRequestCallback)handler
{
    
}

- (NSDictionary *)baseParamsWithAction:(NSString *)action
{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"innerVersion"] = [NSString stringWithFormat:@"%d",(int)self.innverVersion];
    params[@"osType"] = @"ios";
    params[@"action"] = action;
    return params.copy;
}

#pragma mark - --
- (id<AbsHttpDelegate>)httpDelegate
{
    if (!_httpDelegate) {
        _httpDelegate = [AbstractRoomContext sharedContext].httpDelegate;
    }
    return _httpDelegate;
}

@end
