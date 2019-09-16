//
//  AbstractRoom+MediaPlugin.m
//  MomoChat
//
//  Created by David on 2019/8/17.
//  Copyright © 2019年 wemomo.com. All rights reserved.
//

#import "AbstractRoom+MediaPlugin.h"
#import <objc/runtime.h>

static void *mediaDelegateKey = &mediaDelegateKey;

@implementation AbstractRoom (MediaPlugin)

- (void)setMediaDelegate:(id)mediaDelegate
{
    id objc = objc_getAssociatedObject(self, mediaDelegateKey);
    if (objc != mediaDelegate) {
        objc_setAssociatedObject(self, mediaDelegateKey, mediaDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (self.mediaPlugin != nil) {
        self.mediaPlugin.mediaDelegate = mediaDelegate;
    }
}

- (id)mediaDelegate
{
    return objc_getAssociatedObject(self, mediaDelegateKey);
}

#pragma mark - Media Api

- (void)enterSeat
{
    if ([self.mediaPlugin respondsToSelector:@selector(setClientRole:)]) {
        [self.mediaPlugin setClientRole:1];
    }
}

- (void)leaveSeat
{
    if ([self.mediaPlugin respondsToSelector:@selector(setClientRole:)]) {
        [self.mediaPlugin setClientRole:2];
    }
}

- (void)setMicOn:(BOOL)on
{
    if ([self.mediaPlugin respondsToSelector:@selector(setMicOn:)]) {
         [self.mediaPlugin setMicOn:on];
    }
}

- (void)setVideoOn:(BOOL)on
{
    if ([self.mediaPlugin respondsToSelector:@selector(setVideoOn:)]) {
        [self.mediaPlugin setVideoOn:on];
    }
}

//播放音效
- (void)playEffect:(int)soundId filePath:(NSString *)filePath loop:(BOOL)loop publish:(BOOL)publish
{
    if ([self.mediaPlugin respondsToSelector:@selector(playEffect:filePath:loop:publish:)]) {
        [self.mediaPlugin playEffect:soundId filePath:filePath loop:loop publish:publish];
    }
}
//停止音效
- (void)stopEffect:(int)soundId
{
    if ([self.mediaPlugin respondsToSelector:@selector(stopEffect:)]) {
        [self.mediaPlugin stopEffect:soundId];
    }
}

//停止所有音效
- (void)stopAllEffect
{
    if ([self.mediaPlugin respondsToSelector:@selector(stopAllEffect)]) {
        [self.mediaPlugin stopAllEffect];
    }
}

/**
 播放背景音乐
 
 @param urlString url
 @param flag 是否推流到远端
 @param cycle 重复次数  -1 为无限循环
 */
- (void)playMusicWithURLString:(NSString *)urlString loopback:(BOOL)flag repeat:(int)cycle
{
    if ([self.mediaPlugin respondsToSelector:@selector(playMusicWithURLString:loopback:repeat:)]) {
        [self.mediaPlugin playMusicWithURLString:urlString loopback:flag repeat:cycle];
    }
}

//播放背景音乐
- (void)playMusicWithURLString:(NSString *)urlString loopback:(BOOL)flag
{
    if ([self.mediaPlugin respondsToSelector:@selector(playMusicWithURLString:loopback:)]) {
        [self.mediaPlugin playMusicWithURLString:urlString loopback:flag];
    }
}

//停止音乐播放
- (void)stopPlayingMusic
{
    if ([self.mediaPlugin respondsToSelector:@selector(stopPlayingMusic)]) {
        [self.mediaPlugin stopPlayingMusic];
    }
}

//暂停音乐播放
- (void)pausePlayingMusic
{
    if ([self.mediaPlugin respondsToSelector:@selector(pausePlayingMusic)]) {
        [self.mediaPlugin pausePlayingMusic];
    }
}

//恢复音乐播放
- (void)resumePlayingMusic
{
    if ([self.mediaPlugin respondsToSelector:@selector(resumePlayingMusic)]) {
        [self.mediaPlugin resumePlayingMusic];
    }
}

// 设置音量大小
- (void)setPlayingMusicVolume:(CGFloat)volume
{
    if ([self.mediaPlugin respondsToSelector:@selector(setPlayingMusicVolume:)]) {
        [self.mediaPlugin setPlayingMusicVolume:volume];
    }
}
- (CGFloat)getMusicVolume
{
    if ([self.mediaPlugin respondsToSelector:@selector(getMusicVolume)]) {
        [self.mediaPlugin getMusicVolume];
    }
    return 0;
}

- (void)pushVideoBuffer:(CVPixelBufferRef)renderTarget atTime:(CMTime)frameTime
{
    if ([self.mediaPlugin respondsToSelector:@selector(pushVideoBuffer:atTime:)]) {
        [self.mediaPlugin pushVideoBuffer:renderTarget atTime:frameTime];
    }
}

@end
