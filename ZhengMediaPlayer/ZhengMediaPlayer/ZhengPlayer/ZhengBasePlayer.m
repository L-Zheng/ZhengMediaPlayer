//
//  ZhengBasePlayer.m
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2016/12/19.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengBasePlayer.h"

@implementation ZhengBasePlayer

#pragma mark - init

- (instancetype)init{
    self = [super init];
    if (self) {
        
#ifdef DEBUG
        [IJKFFMoviePlayerController setLogReport:YES];
        [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#else
        [IJKFFMoviePlayerController setLogReport:NO];
        [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
        
        //检查版本  调试时打开下句代码
//        [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
        
        //     [IJKFFMoviePlayerController checkIfPlayerVersionMatch:YES major:1 minor:0 micro:0];
    }
    return self;
}

#pragma mark - getter

- (id <IJKMediaPlayback> )player{
    if (!_player) {
        _player = [self creatPlayer];
//        [_player setPauseInBackground:YES];
    }
    return _player;
}

- (UIView *)playerView{
    if (!_playerView) {
        _playerView = self.player.view;
        _playerView.backgroundColor = [UIColor redColor];
    }
    return _playerView;
}

- (IJKMPMoviePlaybackState)playbackState{
    return self.player.playbackState;
}

- (IJKMPMovieLoadState)loadState{
    return self.player.loadState;
}

- (NSTimeInterval)duration{
    return self.player.duration;
}

- (NSTimeInterval)currentPlaybackTime{
    return self.player.currentPlaybackTime;
}

- (float)playbackVolume{
    return self.player.playbackVolume;
}

- (CGFloat)playbackBright{
    return [UIScreen mainScreen].brightness;
}

#pragma mark - creatPlayer

- (id <IJKMediaPlayback> )creatPlayer{
    return nil;
}

#pragma mark - setter

- (void)setCurrentPlaybackTime:(NSTimeInterval)currentPlaybackTime{
    self.player.currentPlaybackTime = currentPlaybackTime;
}

- (void)setPlaybackVolume:(float)playbackVolume{
    self.player.playbackVolume = playbackVolume;
}

- (void)setPlaybackBright:(CGFloat)playbackBright{
    [UIScreen mainScreen].brightness = playbackBright;
}

#pragma mark - public func

- (void)prepareToPlay{
    self.zhengPlayState = ZhengPlayState_Playing;
    [self.player prepareToPlay];
}

- (void)play{
    self.zhengPlayState = ZhengPlayState_Playing;
    if (!self.isPlaying) {
        [self.player play];
    }
}

- (void)pause{
    self.zhengPlayState = ZhengPlayState_Pause;
    [self.player pause];
}

- (void)stop{
    self.zhengPlayState = ZhengPlayState_Stop;
    [self.player stop];
}

- (BOOL)isPlaying{
    return self.player.isPlaying;
}

//停播
- (void)shutdown{
    [self.player shutdown];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
