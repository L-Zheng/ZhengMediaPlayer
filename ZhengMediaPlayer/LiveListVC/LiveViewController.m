//
//  LiveViewController.m
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2016/12/13.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "LiveViewController.h"
#import "ZhengLivePlayer.h"

@interface LiveViewController ()

@property (nonatomic,strong) ZhengLivePlayer *zhengLivePlayer;

@end

@implementation LiveViewController

#pragma mark - getter

- (ZhengLivePlayer *)zhengLivePlayer{
    if (!_zhengLivePlayer) {
        _zhengLivePlayer = [[ZhengLivePlayer alloc] init];
    }
    return _zhengLivePlayer;
}

#pragma mark - ViewLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    @"http://pull99.a8.com/live/1481795474480687.flv"
    self.zhengLivePlayer.url = [NSURL URLWithString:self.live.stream_addr];
    
    //按屏幕比例
    CGFloat scale = self.view.bounds.size.width / self.view.bounds.size.height;
    CGFloat playViewH = 500;
    self.zhengLivePlayer.playerView.frame = CGRectMake(0, 64, scale * playViewH, playViewH);
    
    [self.view insertSubview:self.zhengLivePlayer.playerView atIndex:1];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.zhengLivePlayer prepareToPlay];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    // 界面消失，一定要记得停止播放
    //    [self.zhengLivePlayer pause];
    //    [self.zhengLivePlayer stop];
    [self.zhengLivePlayer shutdown];
    
    [ZhengNotificationTool removeNotification:self];
}

#pragma mark - Notification

- (void)addNotification{
    [ZhengNotificationTool registerMPMoviePlayerLoadStateDidChangeNotification:self selector:@selector(loadStateDidChange:)];
    
    [ZhengNotificationTool registerMPMoviePlayerPlaybackDidFinishNotification:self selector:@selector(moviePlayBackFinish:)];
    
    [ZhengNotificationTool registerMPMediaPlaybackIsPreparedToPlayDidChangeNotification:self selector:@selector(mediaIsPreparedToPlayDidChange:)];
    
    [ZhengNotificationTool registerMPMoviePlayerPlaybackStateDidChangeNotification:self selector:@selector(moviePlayBackStateDidChange:)];
    
}

/** 准备播放通知 */
- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification{
    NSLog(@"mediaIsPrepareToPlayDidChange\n");
}

/** 加载状态通知 */
- (void)loadStateDidChange:(NSNotification*)notification{
    IJKMPMovieLoadState loadState = self.zhengLivePlayer.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlayable) != 0) {
        NSLog(@"LoadStateDidChange: IJKMPMovieLoadStatePlayable: %d\n",(int)loadState);
    }else if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

/** 播放状态通知 */
- (void)moviePlayBackStateDidChange:(NSNotification*)notification{
    IJKMPMoviePlaybackState playbackState = self.zhengLivePlayer.playbackState;
    switch (playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)playbackState);
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)playbackState);
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)playbackState);
            break;
        }
            
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)playbackState);
            break;
        }
    }
}

/** 播放完成通知 */
- (void)moviePlayBackFinish:(NSNotification*)notification{
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

#pragma mark - Action

- (IBAction)playBtn:(id)sender {
    [self.zhengLivePlayer play];
}

- (IBAction)pauseBtn:(id)sender {
    [self.zhengLivePlayer pause];
}

- (IBAction)stopBtn:(id)sender {
    [self.zhengLivePlayer stop];
}

- (void)dealloc{
    [ZhengNotificationTool removeNotification:self];
}


@end
