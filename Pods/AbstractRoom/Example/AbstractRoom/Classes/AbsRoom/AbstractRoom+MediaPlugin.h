//
//  AbstractRoom+MediaPlugin.h
//  MomoChat
//
//  Created by David on 2019/8/17.
//  Copyright © 2019年 wemomo.com. All rights reserved.
//
#import "AbstractRoom.h"

NS_ASSUME_NONNULL_BEGIN

@interface AbstractRoom (MediaPlugin)

@property (nonatomic,strong) id mediaDelegate; ///< save

// Media API
- (void)enterSeat;
- (void)leaveSeat;
- (void)setMicOn:(BOOL)on;
- (void)setVideoOn:(BOOL)on;

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

// 推流
- (void)pushVideoBuffer:(CVPixelBufferRef)renderTarget atTime:(CMTime)frameTime;

@end

NS_ASSUME_NONNULL_END
