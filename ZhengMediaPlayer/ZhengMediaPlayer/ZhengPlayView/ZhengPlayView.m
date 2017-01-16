//
//  ZhengPlayView.m
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2016/12/23.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengPlayView.h"

#import "ZhengBasePlayer.h"
#import "ZhengLivePlayer.h"
#import "ZhengLocalPlayer.h"

#import "ZhengProgressView.h"
#import "ZhengTimeLabel.h"
#import "ZhengVolumeView.h"
#import "ZhengBrightView.h"

#import "ZhengFullPlayVC.h"

typedef NS_ENUM(NSInteger, AdjustType) {
    AdjustType_GoForwardBack      = 0,
    AdjustType_Volume             = 1,
    AdjustType_Bright             = 2,
} NS_ENUM_AVAILABLE_IOS(6_0);

@interface ZhengPlayView ()<ZhengProgressViewDelgate,ZhengVolumeViewDelgate,ZhengBrightViewDelgate>

#pragma mark - 传递属性

@property (nonatomic,strong) NSURL *url;

@property (nonatomic,assign) PlayViewType playViewType;

#pragma mark - 自身属性

@property (nonatomic,assign) AdjustType adjustType;

@property (nonatomic,strong) ZhengBasePlayer *zhengPlayer;

@property (nonatomic, strong) NSTimer *myTimer;

@property (nonatomic, strong) ZhengTimeLabel *timeLabel;

@property (nonatomic, strong) ZhengProgressView *progressView;

@property (nonatomic, strong) ZhengVolumeView *volumeView;

@property (nonatomic, strong) ZhengBrightView *brightView;

@property (nonatomic, strong) UIButton *fullScreenBtn;

@property (nonatomic, strong) UIButton *playOrPauseBtn;
@end

@implementation ZhengPlayView

#pragma mark - getter

- (ZhengBasePlayer *)zhengPlayer{
    if (!_zhengPlayer) {
        
        switch (self.playViewType) {
            case PlayViewType_Local:
                _zhengPlayer = [[ZhengLocalPlayer alloc] init];
                break;
                
            case PlayViewType_Live:
                _zhengPlayer = [[ZhengLivePlayer alloc] init];
                break;
                
            default:
                break;
        }
    }
    return _zhengPlayer;
}

- (ZhengTimeLabel *)timeLabel{
    if (!_timeLabel) {
        CGFloat timeLabelX = self.zhengPlayer.playerView.frame.origin.x;
        
        _timeLabel = [[ZhengTimeLabel alloc] initWithFrame:CGRectMake(timeLabelX, CGRectGetMaxY(self.progressView.frame) + 10, 200, 30)];
        _timeLabel.isShowHour = NO;
    }
    return _timeLabel;
}

- (ZhengProgressView *)progressView{
    if (!_progressView) {
        CGFloat progressViewX = self.zhengPlayer.playerView.frame.origin.x;
        CGFloat progressViewY = CGRectGetMaxY(self.zhengPlayer.playerView.frame);
        CGFloat progressViewW = self.zhengPlayer.playerView.frame.size.width;
        
        _progressView = [[ZhengProgressView alloc] initWithFrame:CGRectMake(progressViewX, progressViewY, progressViewW, 0)];
        
        _progressView.delegate = self;
        
    }
    return _progressView;
}

- (ZhengVolumeView *)volumeView{
    if (!_volumeView) {
        CGFloat volumeViewX = CGRectGetMaxX(self.zhengPlayer.playerView.frame) + 10;
        CGFloat volumeViewY = CGRectGetMaxY(self.zhengPlayer.playerView.frame) - 10;
        
        _volumeView = [[ZhengVolumeView alloc] initWithFrame:CGRectMake(volumeViewX, volumeViewY, 0, 0)];
        
        _volumeView.delegate = self;
        
        _volumeView.layer.anchorPoint = CGPointMake(0, 0.5);
        _volumeView.layer.position = CGPointMake(volumeViewX, volumeViewY);
        _volumeView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        
    }
    return _volumeView;
}

- (ZhengBrightView *)brightView{
    if (!_brightView) {
        CGFloat brightViewX = 10;
        CGFloat brightViewY = CGRectGetMaxY(self.zhengPlayer.playerView.frame) - 10;
        
        _brightView = [[ZhengBrightView alloc] initWithFrame:CGRectMake(brightViewX, brightViewY, 0, 0)];
        
        _brightView.delegate = self;
        
        _brightView.layer.anchorPoint = CGPointMake(0, 0.5);
        _brightView.layer.position = CGPointMake(brightViewX, brightViewY);
        _brightView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        
    }
    return _brightView;
}

- (UIButton *)fullScreenBtn{
    if (!_fullScreenBtn) {
        
        CGFloat fullScreenBtnX = CGRectGetMaxX(self.timeLabel.frame) + 20;
        CGFloat fullScreenBtnY = self.timeLabel.frame.origin.y;
        CGFloat fullScreenBtnW = 50;
        CGFloat fullScreenBtnH = 40;
        
        _fullScreenBtn = [[UIButton alloc] initWithFrame:CGRectMake(fullScreenBtnX, fullScreenBtnY, fullScreenBtnW, fullScreenBtnH)];
        _fullScreenBtn.backgroundColor = [UIColor orangeColor];
        
        [_fullScreenBtn setImage:[UIImage imageNamed:@"mini_launchFullScreen_btn"] forState:UIControlStateNormal];
        
        _fullScreenBtn.adjustsImageWhenHighlighted = YES;
        
        [_fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _fullScreenBtn;
}

- (UIButton *)playOrPauseBtn{
    if (!_playOrPauseBtn) {
        CGFloat playOrPauseBtnX = CGRectGetMaxX(self.fullScreenBtn.frame) + 20;
        CGFloat playOrPauseBtnY = self.timeLabel.frame.origin.y;
        CGFloat playOrPauseBtnW = 50;
        CGFloat playOrPauseBtnH = playOrPauseBtnW;
        
        _playOrPauseBtn = [[UIButton alloc] initWithFrame:CGRectMake(playOrPauseBtnX, playOrPauseBtnY, playOrPauseBtnW, playOrPauseBtnH)];
        _playOrPauseBtn.backgroundColor = [UIColor cyanColor];
        
        _playOrPauseBtn.adjustsImageWhenHighlighted = NO;
        
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"full_pause_btn"] forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"full_play_btn"] forState:UIControlStateSelected];
        
        [_playOrPauseBtn addTarget:self action:@selector(playOrPauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playOrPauseBtn;
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame url:(NSURL *)url playViewType:(PlayViewType)playViewType{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        
        self.url = url;
        self.playViewType = playViewType;
        
        [ZhengNotificationTool removeNotification:self];
        [self addPlayerNotification];
        [self addApplicationNotification];
        
        self.zhengPlayer.url = self.url;
        
        //比例32：17
        CGFloat playerViewW = self.bounds.size.width - 2 * 20;
        CGFloat playerViewH = playerViewW * 17 / 32;
        self.zhengPlayer.playerView.frame = CGRectMake(20, 0, playerViewW, playerViewH);
        
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(playViewGesture:)];
        [self.zhengPlayer.playerView addGestureRecognizer:gesture];
        
        [self addSubview:self.zhengPlayer.playerView];
        [self addSubview:self.progressView];
        [self addSubview:self.timeLabel];
        [self addSubview:self.volumeView];
        [self addSubview:self.brightView];
        [self addSubview:self.fullScreenBtn];
        [self addSubview:self.playOrPauseBtn];
    }
    return self;
}

#pragma mark - setter

- (void)setUrl:(NSURL *)url{
    _url = url;
}

#pragma mark - Public Func

- (void)prepareToPlay{
    
    [self.zhengPlayer prepareToPlay];
    
    [self refreshPlayOrPauseBtn:YES];
    
    self.volumeView.value = self.zhengPlayer.playbackVolume;
    self.brightView.value = self.zhengPlayer.playbackBright;
    
    [self addTimer];
}

- (void)play{
    if (!self.isPlaying) {
        [self.zhengPlayer play];
        [self refreshPlayOrPauseBtn:YES];
        [self addTimer];
    }
}

- (void)pause{
    [self.zhengPlayer pause];
    [self refreshPlayOrPauseBtn:NO];
    [self removeTimer];
}

- (void)stop{
    [self.zhengPlayer stop];
    [self refreshPlayOrPauseBtn:NO];
    [self removeTimer];
}

- (BOOL)isPlaying{
    return self.zhengPlayer.isPlaying;
}

- (void)shutdown{
    
    // 界面消失，一定要记得停止播放
    //    [self.zhengPlayer pause];
    //    [self.zhengPlayer stop];
    [self.zhengPlayer shutdown];
    
    [self removeTimer];
}

#pragma mark - Timer

- (void)addTimer{
    if (!self.myTimer) {
        ZhengPlayState playState = self.zhengPlayer.zhengPlayState;
        if (playState == ZhengPlayState_Playing) {
            self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        }
    }
}

- (void)removeTimer{
    if (self.myTimer) {
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
}

- (void)timerAction{
    [self refreshProgressView];
    [self refreshTimeLabel];
}

#pragma mark - UI

- (void)refreshProgressView{
    self.progressView.value = self.zhengPlayer.currentPlaybackTime / self.zhengPlayer.duration;
}

- (void)refreshTimeLabel{
    
    NSTimeInterval currentTime = self.progressView.value * self.zhengPlayer.duration;
    
    [self.timeLabel setTimeWithCurrentTime:currentTime durationTime:self.zhengPlayer.duration];
}

- (void)refreshPlayOrPauseBtn:(BOOL)isPlaying{
    self.playOrPauseBtn.selected = !isPlaying;
}

#pragma mark - Action

- (void)fullScreenBtnClick:(UIButton *)btn{
    if (self.fullBtnBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.fullBtnBlock();
        });
    }
}

- (void)playOrPauseBtnClick:(UIButton *)btn{
    if (btn.selected) { //点击播放
        [self play];
    }else{ //点击暂停
        [self pause];
    }
}

- (void)playViewGesture:(UIPanGestureRecognizer *)panGesture{
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            [self handleGestureBegan:panGesture];
            break;
            
        case UIGestureRecognizerStateChanged:
            [self handleGestureChanged:panGesture];
            break;
            
        case UIGestureRecognizerStateEnded:
            [self handleGestureEnded:panGesture];
            break;
            
        case UIGestureRecognizerStateCancelled:
            [self handleGestureEnded:panGesture];
            break;
            
        case UIGestureRecognizerStateFailed:
            [self handleGestureEnded:panGesture];
            break;
            
        default:
            break;
    }
}

static CGFloat gestureDistanceHorizontal = 0;
static CGFloat gestureDistanceVertical = 0;
static BOOL isSureAdjustType;
static float originVolume = 0;
static CGFloat originBright = 0;

- (void)handleGestureBegan:(UIPanGestureRecognizer *)panGesture{
    
    gestureDistanceHorizontal = 0;
    gestureDistanceVertical = 0;
    isSureAdjustType = NO;
    originVolume = self.zhengPlayer.playbackVolume;
    originBright = self.zhengPlayer.playbackBright;
    
    CGFloat playViewWidth = self.zhengPlayer.playerView.bounds.size.width;
    CGPoint touchPoint = [panGesture locationInView:panGesture.view];
    
    if (touchPoint.x > playViewWidth * 0.5) {
        self.adjustType = AdjustType_Volume;
    } else if (touchPoint.x < playViewWidth * 0.5){
        self.adjustType = AdjustType_Bright;
    } else {
        self.adjustType = AdjustType_GoForwardBack;
    }
}

- (void)handleGestureChanged:(UIPanGestureRecognizer *)panGesture{
    // 获得挪动的距离
    CGPoint movePoint = [panGesture translationInView:panGesture.view];
    [panGesture setTranslation:CGPointZero inView:panGesture.view];
    
    gestureDistanceHorizontal += movePoint.x;//向右为正
    gestureDistanceVertical += movePoint.y;  //向下为正
    
    CGFloat moveDistanceHorizontal = (gestureDistanceHorizontal > 0) ? gestureDistanceHorizontal : -gestureDistanceHorizontal;
    
    CGFloat moveDistanceVertical = (gestureDistanceVertical > 0) ? gestureDistanceVertical : -gestureDistanceVertical;
    
    //确定设置类型
    if (!isSureAdjustType) {
        if (moveDistanceHorizontal > moveDistanceVertical) {
            self.adjustType = AdjustType_GoForwardBack;
            
        } else if (moveDistanceHorizontal < moveDistanceVertical){
            
            
        } else {
            self.adjustType = AdjustType_GoForwardBack;
        }
        isSureAdjustType = YES;
        
        [self removeTimer];
    }
    
    if (isSureAdjustType) {
        //即时设置音量 亮度 快进快退
        switch (self.adjustType) {
            case AdjustType_Volume:
                [self setUpPlayerVolume];
                break;
                
            case AdjustType_Bright:
                [self setUpPlayerBright];
                break;
                
            case AdjustType_GoForwardBack:
                [self setUpPlayerGoForwardBack];
                break;
                
            default:
                break;
        }
    }
}

- (void)handleGestureEnded:(UIPanGestureRecognizer *)panGesture{
    //设置快进快退
    switch (self.adjustType) {
        case AdjustType_GoForwardBack:
            self.zhengPlayer.currentPlaybackTime = (self.progressView.value * self.zhengPlayer.duration + 0.5);
            
            [self addTimer];
            break;
            
        case AdjustType_Bright:
            
            break;
            
        case AdjustType_Volume:
            
            break;
            
        default:
            break;
    }
}

- (void)setUpPlayerVolume{
    //滑动距离10为音量加0.1
    float targetVolume = originVolume + ((int)(-gestureDistanceVertical / 10)) * 0.1;
    
    if (targetVolume >= 1) {
        targetVolume = 1;
    } else if (targetVolume <= 0){
        targetVolume = 0;
    }
    
    self.zhengPlayer.playbackVolume = targetVolume;
    
    self.volumeView.value = self.zhengPlayer.playbackVolume;
}

- (void)setUpPlayerBright{
    
    float targetBright = originBright + ((int)(-gestureDistanceVertical / 10)) * 0.1;
    
    if (targetBright >= 1) {
        targetBright = 1;
    } else if (targetBright <= 0){
        targetBright = 0;
    }
    
    self.zhengPlayer.playbackBright = targetBright;
    
    self.brightView.value = self.zhengPlayer.playbackBright;
}

- (void)setUpPlayerGoForwardBack{
    //滑动距离10为快进一秒
    NSTimeInterval targetTime = self.zhengPlayer.currentPlaybackTime + (int)(gestureDistanceHorizontal / 10);
    
    if (targetTime >= self.zhengPlayer.duration) {
        targetTime = self.zhengPlayer.duration;
        
    } else if (targetTime <= 0){
        targetTime = 0;
        
    }
    
    //设置进度条
    self.progressView.value = targetTime / self.zhengPlayer.duration;
    
    //设置时间显示
    NSTimeInterval currentTime = self.progressView.value * self.zhengPlayer.duration;
    [self.timeLabel setTimeWithCurrentTime:currentTime durationTime:self.zhengPlayer.duration];
}

#pragma mark - ZhengProgressViewDelgate

- (void)zhengProgressView:(ZhengProgressView *)zhengProgressView bgViewTapGesture:(UITapGestureRecognizer *)tapGesture progressValue:(CGFloat)progressValue{
    
    [self removeTimer];
    
    [self refreshTimeLabel];
    
    self.zhengPlayer.currentPlaybackTime = progressValue * self.zhengPlayer.duration;
    
    [self addTimer];
}

- (void)zhengProgressView:(ZhengProgressView *)zhengProgressView indicatorButtonPanGesture:(UIPanGestureRecognizer *)panGesture progressValue:(CGFloat)progressValue{
    
    [self refreshTimeLabel];
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        
        [self removeTimer];
        
    } else if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled) {
        
        // 设置播放器的时间
        self.zhengPlayer.currentPlaybackTime = progressValue * self.zhengPlayer.duration;
        
        [self addTimer];
    }
}

#pragma mark - ZhengVolumeViewDelgate

- (void)zhengVolumeView:(ZhengVolumeView *)zhengVolumeView bgViewTapGesture:(UITapGestureRecognizer *)tapGesture volumeValue:(CGFloat)volumeValue{
    self.zhengPlayer.playbackVolume = volumeValue;
}

- (void)zhengVolumeView:(ZhengVolumeView *)zhengVolumeView indicatorButtonPanGesture:(UIPanGestureRecognizer *)panGesture volumeValue:(CGFloat)volumeValue{
    self.zhengPlayer.playbackVolume = volumeValue;
}

#pragma mark - ZhengBrightViewDelgate

- (void)zhengBrightView:(ZhengBrightView *)zhengBrightView bgViewTapGesture:(UITapGestureRecognizer *)tapGesture brightValue:(CGFloat)brightValue{
    self.zhengPlayer.playbackBright = brightValue;
}

- (void)zhengBrightView:(ZhengBrightView *)zhengBrightView indicatorButtonPanGesture:(UIPanGestureRecognizer *)panGesture brightValue:(CGFloat)brightValue{
    self.zhengPlayer.playbackBright = brightValue;
}

#pragma mark - Notification

- (void)addPlayerNotification{
    [ZhengNotificationTool registerMPMoviePlayerLoadStateDidChangeNotification:self selector:@selector(loadStateDidChange:)];
    
    [ZhengNotificationTool registerMPMoviePlayerPlaybackDidFinishNotification:self selector:@selector(moviePlayBackFinish:)];
    
    [ZhengNotificationTool registerMPMediaPlaybackIsPreparedToPlayDidChangeNotification:self selector:@selector(mediaIsPreparedToPlayDidChange:)];
    
    [ZhengNotificationTool registerMPMoviePlayerPlaybackStateDidChangeNotification:self selector:@selector(moviePlayBackStateDidChange:)];
    
}

- (void)addApplicationNotification{
    
    //将要辞去激活
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    //重新激活
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

/** 准备播放通知 */
- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification{
    NSLog(@"mediaIsPrepareToPlayDidChange\n");
}

/** 加载状态通知 */
- (void)loadStateDidChange:(NSNotification*)notification{
    IJKMPMovieLoadState loadState = self.zhengPlayer.loadState;
    
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
    IJKMPMoviePlaybackState playbackState = self.zhengPlayer.playbackState;
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
    [self.zhengPlayer shutdown];
    [self removeTimer];
    [self refreshPlayOrPauseBtn:NO];
    
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


- (void)applicationWillResignActive{
    [self pause];
}

- (void)applicationDidBecomeActive{
    [self play];
}

#pragma mark - dealloc

- (void)dealloc{
    [ZhengNotificationTool removeNotification:self];
}

@end
