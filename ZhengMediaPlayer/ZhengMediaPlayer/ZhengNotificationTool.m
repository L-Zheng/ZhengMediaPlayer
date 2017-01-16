//
//  ZhengNotificationTool.m
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2016/12/16.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengNotificationTool.h"

@implementation ZhengNotificationTool

+ (void)removeNotification:(nonnull id)observer{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

/** 准备播放通知 */
+ (void)registerMPMediaPlaybackIsPreparedToPlayDidChangeNotification:(nonnull id)observer selector:(nonnull SEL)aSelector{
    
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:nil];
}

/** 加载状态通知 */
+ (void)registerMPMoviePlayerLoadStateDidChangeNotification:(nonnull id)observer selector:(nonnull SEL)aSelector{
/*  未知  可播   加载完成即将播放   加载停止
    {
        IJKMPMovieLoadStateUnknown        = 0,
        IJKMPMovieLoadStatePlayable       = 1 << 0,
        IJKMPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
        IJKMPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
    }
*/
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:IJKMPMoviePlayerLoadStateDidChangeNotification object:nil];
}

/** 播放状态通知 */
+ (void)registerMPMoviePlayerPlaybackStateDidChangeNotification:(nonnull id)observer selector:(nonnull SEL)aSelector{
    /*
     {
     IJKMPMoviePlaybackStateStopped,
     IJKMPMoviePlaybackStatePlaying,
     IJKMPMoviePlaybackStatePaused,
     IJKMPMoviePlaybackStateInterrupted,
     IJKMPMoviePlaybackStateSeekingForward,
     IJKMPMoviePlaybackStateSeekingBackward
     }
     */
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:nil];
}

/** 播放完成通知 */
+ (void)registerMPMoviePlayerPlaybackDidFinishNotification:(nonnull id)observer selector:(nonnull SEL)aSelector{
/*
    {
        IJKMPMovieFinishReasonPlaybackEnded,
        IJKMPMovieFinishReasonPlaybackError,
        IJKMPMovieFinishReasonUserExited
    }
*/
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:IJKMPMoviePlayerPlaybackDidFinishNotification object:nil];
}

@end
