//
//  PluginInterface.h
//  Demo
//
//  Created by David on 2019/8/6.
//  Copyright © 2019年 Wicky. All rights reserved.
//

#ifndef PluginInterface_h
#define PluginInterface_h

#import <Foundation/Foundation.h>
#import <CoreMedia/CMTime.h>

@protocol AbsRoomBasePlugin <NSObject>

- (void)registPluginErrorTarget:(id)target handler:(SEL)handler;
- (void)registPluginWithParam:(id)param;

- (void)destory;

@end


@protocol AbsMediaPlugin <AbsRoomBasePlugin>

@property (nonatomic,weak) id mediaDelegate;
// 统筹为setUp.细节内部控制
- (void)setUpWithData:(NSDictionary *)data;

// 开启音量大小的回调
- (void)enableAgoraReportAudioVolume:(BOOL)bRet;
// 设置当前角色
- (void)setClientRole:(NSUInteger)clientRole;
// 开闭麦克风
- (void)setMicOn:(BOOL)on;
// 开闭视频
- (void)setVideoOn:(BOOL)on;

- (void)enterBackground;
- (void)enterForeground;

// 推流
- (void)pushVideoBuffer:(CVPixelBufferRef)renderTarget atTime:(CMTime)frameTime;

//播放音效
- (void)playEffect:(int)soundId filePath:(NSString *)filePath loop:(BOOL)loop publish:(BOOL)publish;
//停止音效
- (void)stopEffect:(int)soundId;
//停止所有音效
- (void)stopAllEffect;

/**
 播放背景音乐
 
 @param urlString url
 @param flag 是否推流到远端
 @param cycle 重复次数  -1 为无限循环
 */
- (void)playMusicWithURLString:(NSString *)urlString loopback:(BOOL)flag repeat:(int)cycle;

//播放背景音乐
- (void)playMusicWithURLString:(NSString *)urlString loopback:(BOOL)flag;

//停止音乐播放
- (void)stopPlayingMusic;

//暂停音乐播放
- (void)pausePlayingMusic;
//恢复音乐播放
- (void)resumePlayingMusic;
// 设置音量大小
- (void)setPlayingMusicVolume:(CGFloat)volume;
// 获取音量大小
- (CGFloat)getMusicVolume;

@end

@protocol AbsRoomGiftPlugin <AbsRoomBasePlugin>

@optional
-(void)showGiftPanel:(NSInteger)category
   withReceiveMomoId:(NSString *)momoID
              roomId:(NSString *)roomID
            animated:(BOOL)animated;
- (void)focusUpdate:(NSUInteger)categroy;
- (void)loadResources:(NSArray <NSString *>*)resources;

@required
- (void)show;
- (void)close;
- (void)sendGift:(NSDictionary *)param;

@end

@protocol AbsRoomIMPlugin <AbsRoomBasePlugin>

-(void)setupHost:(NSString *)host port:(NSString *)port;

-(void)setupChannel:(NSString *)channel;

-(void)registHandler:(id)target selector:(SEL)selector forEvent:(NSString *)event;

-(void)sendMsg:(NSString *)msg;

-(void)sendMsgWithParams:(NSDictionary *)params;

-(void)connect;

-(void)disconnect;

@end




#endif /* PluginInterface_h */
