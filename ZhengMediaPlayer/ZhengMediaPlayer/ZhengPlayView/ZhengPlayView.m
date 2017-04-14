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
#import "ZhengM3U8Player.h"
#import "ZhengNetWorkPlayer.h"

#import "ZhengProgressView.h"
#import "ZhengTimeLabel.h"
#import "ZhengVolumeView.h"
#import "ZhengBrightView.h"

typedef NS_ENUM(NSInteger, AdjustType) {
    AdjustType_GoForwardBack      = 0,
    AdjustType_Volume             = 1,
    AdjustType_Bright             = 2,
} NS_ENUM_AVAILABLE_IOS(6_0);

#define ProgressViewH 20
#define VolumeViewH 20
#define BrightViewH 20
#define TimeLabelH 20

@interface ZhengPlayView ()<ProgressViewDelgate>

#pragma mark - 传递属性

@property (nonatomic,strong) NSURL *url;

@property (nonatomic,assign) PlayViewType playViewType;

#pragma mark - 自身属性
//控件
@property (nonatomic, strong) UIView *playBgView;

@property (nonatomic, strong) ZhengTimeLabel *timeLabel;

@property (nonatomic, strong) ZhengProgressView *progressView;

@property (nonatomic, strong) ZhengVolumeView *volumeView;

@property (nonatomic, strong) ZhengBrightView *brightView;

@property (nonatomic, strong) UIButton *fullScreenBtn;

@property (nonatomic, strong) UIButton *playOrPauseBtn;

@property (nonatomic, strong) UIButton *modeInfoBtn;

//
@property (nonatomic,assign) AdjustType adjustType;

@property (nonatomic,strong) ZhengBasePlayer *zhengPlayer;

@property (nonatomic, strong) NSTimer *myTimer;

//记录进入后台前的播放状态
@property (nonatomic, assign) BOOL isPlayingWhenResignActive;

@end

@implementation ZhengPlayView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame url:(NSURL *)url playViewType:(PlayViewType)playViewType scale:(CGFloat)scale{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        
        self.url = url;
        self.playViewType = playViewType;
        self.playViewStatus = PlayViewStatus_Portrait;
        
        [ZhengNotificationTool removeNotification:self];
        [self addPlayerNotification];
        [self addApplicationNotification];
        
        self.zhengPlayer.url = self.url;
        
        //防止self.zhengPlayer.playerView上面有手势操作  会拦截掉gesture  禁止掉
        self.zhengPlayer.playerView.userInteractionEnabled = NO;
        
        self.zhengPlayer.player.scalingMode = IJKMPMovieScalingModeAspectFit;
        
        [self addSubview:self.playBgView];
        [self.playBgView addSubview:self.zhengPlayer.playerView];
        [self addSubview:self.progressView];
        [self addSubview:self.timeLabel];
        [self addSubview:self.volumeView];
        [self addSubview:self.brightView];
        [self addSubview:self.fullScreenBtn];
        [self addSubview:self.playOrPauseBtn];
        [self addSubview:self.modeInfoBtn];
        
        [self handleSubViewFrame];
    }
    return self;
}

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
                
            case PlayViewType_M3U8:
                _zhengPlayer = [[ZhengM3U8Player alloc] init];
                break;
                
            case PlayViewType_NetWork:
                _zhengPlayer = [[ZhengNetWorkPlayer alloc] init];
                break;
                
            default:
                break;
        }
    }
    return _zhengPlayer;
}

//控件
- (UIView *)playBgView{
    if (!_playBgView) {
        _playBgView = [[UIView alloc] init];
        _playBgView.backgroundColor = [UIColor yellowColor];
        _playBgView.clipsToBounds = YES;
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(playViewPanGesture:)];
        [_playBgView addGestureRecognizer:panGesture];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playViewTapGesture:)];
        [_playBgView addGestureRecognizer:tapGesture];
        
    }
    return _playBgView;
}

- (ZhengTimeLabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[ZhengTimeLabel alloc] init];
        _timeLabel.isShowHour = NO;
    }
    return _timeLabel;
}

- (ZhengProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[ZhengProgressView alloc] init];
        _progressView.delegate = self;
    }
    return _progressView;
}

- (ZhengVolumeView *)volumeView{
    if (!_volumeView) {
        _volumeView = [[ZhengVolumeView alloc] init];
        _volumeView.delegate = self;
    }
    return _volumeView;
}

- (ZhengBrightView *)brightView{
    if (!_brightView) {
        _brightView = [[ZhengBrightView alloc] init];
        _brightView.delegate = self;
        
    }
    return _brightView;
}

- (UIButton *)fullScreenBtn{
    if (!_fullScreenBtn) {
        _fullScreenBtn = [[UIButton alloc] init];
        _fullScreenBtn.backgroundColor = [UIColor orangeColor];
        
        [_fullScreenBtn setImage:[UIImage imageNamed:@"mini_launchFullScreen_btn"] forState:UIControlStateNormal];
        
        _fullScreenBtn.adjustsImageWhenHighlighted = YES;
        
        [_fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}

- (UIButton *)playOrPauseBtn{
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [[UIButton alloc] init];
        _playOrPauseBtn.backgroundColor = [UIColor cyanColor];
        
        _playOrPauseBtn.adjustsImageWhenHighlighted = NO;
        
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"full_pause_btn"] forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"full_play_btn"] forState:UIControlStateSelected];
        
        [_playOrPauseBtn addTarget:self action:@selector(playOrPauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playOrPauseBtn;
}

- (UIButton *)modeInfoBtn{
    if (!_modeInfoBtn) {
        _modeInfoBtn = [[UIButton alloc] init];
        _modeInfoBtn.backgroundColor = [UIColor orangeColor];
        
        [_modeInfoBtn setTitle:@"等比例缩放适应" forState:UIControlStateNormal];
        [_modeInfoBtn setTitle:@"等比例缩放铺满裁剪" forState:UIControlStateSelected];
        _modeInfoBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_modeInfoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_modeInfoBtn addTarget:self action:@selector(modeInfoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modeInfoBtn;
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

- (void)handleSubViewFrame{
    //这里面不设置center  只设置frame  否则会影响全屏旋转动画不连贯
    /*  self.bounds.size.height  这里的bounds不能换成frame
     外部设置了bounds并没有设置frame   bounds.size不等于frame.size
     */
    CGFloat viewY = 0;
    CGFloat viewH = self.bounds.size.height - ProgressViewH - TimeLabelH;
    CGFloat viewX = BrightViewH;
    CGFloat viewW = self.bounds.size.width - VolumeViewH - BrightViewH;
    self.playBgView.frame = CGRectMake(viewX, viewY, viewW, viewH);
    
    CGFloat playerViewW = self.playBgView.width - 20;
    CGFloat playerViewH = self.playBgView.height - 20;
    CGFloat playerViewX = self.playBgView.width * 0.5 - playerViewW * 0.5;
    CGFloat playerViewY = self.playBgView.height * 0.5 - playerViewH * 0.5;
    self.zhengPlayer.playerView.frame = CGRectMake(playerViewX, playerViewY, playerViewW, playerViewH);
    
    CGFloat progressViewX = self.playBgView.frame.origin.x;
    CGFloat progressViewY = CGRectGetMaxY(self.playBgView.frame);
    CGFloat progressViewW = self.playBgView.frame.size.width;
    self.progressView.frame = CGRectMake(progressViewX, progressViewY, progressViewW, ProgressViewH);
    
    CGFloat timeLabelX = self.playBgView.frame.origin.x;
    self.timeLabel.frame = CGRectMake(timeLabelX, CGRectGetMaxY(self.progressView.frame), 200, TimeLabelH);
    
    CGFloat volumeViewW = 130;
    CGFloat volumeViewX = self.bounds.size.width - ((self.bounds.size.width - CGRectGetMaxX(self.playBgView.frame)) * 0.5) - volumeViewW * 0.5;
    CGFloat volumeViewY = CGRectGetMaxY(self.playBgView.frame) - volumeViewW * 0.5 - VolumeViewH * 0.5;
    self.volumeView.transform = CGAffineTransformIdentity;
    self.volumeView.frame = CGRectMake(volumeViewX, volumeViewY, volumeViewW, VolumeViewH);
    self.volumeView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    CGFloat brightViewW = 130;
    CGFloat brightViewX = BrightViewH * 0.5 - brightViewW * 0.5;
    CGFloat brightViewY = CGRectGetMaxY(self.playBgView.frame) - brightViewW * 0.5 - BrightViewH * 0.5;
    self.brightView.transform = CGAffineTransformIdentity;
    self.brightView.frame = CGRectMake(brightViewX, brightViewY, brightViewW, BrightViewH);
    self.brightView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    CGFloat fullScreenBtnX = CGRectGetMaxX(self.timeLabel.frame) + 5;
    CGFloat fullScreenBtnY = self.timeLabel.frame.origin.y;
    CGFloat fullScreenBtnW = 20;
    CGFloat fullScreenBtnH = 20;
    self.fullScreenBtn.frame = CGRectMake(fullScreenBtnX, fullScreenBtnY, fullScreenBtnW, fullScreenBtnH);
    
    CGFloat playOrPauseBtnX = CGRectGetMaxX(self.fullScreenBtn.frame) + 5;
    CGFloat playOrPauseBtnY = self.timeLabel.frame.origin.y;
    CGFloat playOrPauseBtnW = 20;
    CGFloat playOrPauseBtnH = playOrPauseBtnW;
    self.playOrPauseBtn.frame = CGRectMake(playOrPauseBtnX, playOrPauseBtnY, playOrPauseBtnW, playOrPauseBtnH);
    
    CGFloat btnX = CGRectGetMaxX(self.playOrPauseBtn.frame) + 5;
    CGFloat btnY = self.timeLabel.frame.origin.y;
    CGFloat btnW = self.bounds.size.width - btnX;
    CGFloat btnH = 20;
    self.modeInfoBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
}

#pragma mark - Action

- (void)fullScreenBtnClick:(UIButton *)btn{
    if (!btn.selected) { //进入全屏
        [self enterFullScreen];
    }else{ //退出全屏
        [self exitFullScreen];
    }
    btn.selected = !btn.selected;
}

- (void)enterFullScreen{
    if (self.playViewStatus == PlayViewStatus_Portrait) {
        if (self.rotationBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.rotationBlock(self,YES);
            });
        }
    }
}

- (void)exitFullScreen{
    if (self.playViewStatus == PlayViewStatus_FullScreen) {
        if (self.rotationBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.rotationBlock(self,NO);
            });
        }
    }
}

- (void)playOrPauseBtnClick:(UIButton *)btn{
    if (btn.selected) { //点击播放
        [self play];
    }else{ //点击暂停
        [self pause];
    }
}

- (void)modeInfoBtnClick:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    
    if (self.zhengPlayer.player.scalingMode == IJKMPMovieScalingModeAspectFit) {
        self.zhengPlayer.player.scalingMode = IJKMPMovieScalingModeAspectFill;
    }else if (self.zhengPlayer.player.scalingMode == IJKMPMovieScalingModeAspectFill){
        self.zhengPlayer.player.scalingMode = IJKMPMovieScalingModeAspectFit;
    }else{
        
    }
}

- (void)playViewTapGesture:(UIPanGestureRecognizer *)panGesture{
    [self isPlaying] ? [self pause] : [self play];
}

- (void)playViewPanGesture:(UIPanGestureRecognizer *)panGesture{
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            [self handlePanGestureBegan:panGesture];
            break;
            
        case UIGestureRecognizerStateChanged:
            [self handlePanGestureChanged:panGesture];
            break;
            
        case UIGestureRecognizerStateEnded:
            [self handlePanGestureEnded:panGesture];
            break;
            
        case UIGestureRecognizerStateCancelled:
            [self handlePanGestureEnded:panGesture];
            break;
            
        case UIGestureRecognizerStateFailed:
            [self handlePanGestureEnded:panGesture];
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

- (void)handlePanGestureBegan:(UIPanGestureRecognizer *)panGesture{
    
    gestureDistanceHorizontal = 0;
    gestureDistanceVertical = 0;
    isSureAdjustType = NO;
    originVolume = self.zhengPlayer.playbackVolume;
    originBright = self.zhengPlayer.playbackBright;
    
    CGFloat playViewWidth = self.playBgView.frame.size.width;
    CGPoint touchPoint = [panGesture locationInView:panGesture.view];
    
    if (touchPoint.x > playViewWidth * 0.5) {
        self.adjustType = AdjustType_Volume;
    } else if (touchPoint.x < playViewWidth * 0.5){
        self.adjustType = AdjustType_Bright;
    } else {
        self.adjustType = AdjustType_GoForwardBack;
    }
}

- (void)handlePanGestureChanged:(UIPanGestureRecognizer *)panGesture{
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
                
            case AdjustType_GoForwardBack:{
                [self removeTimer];
                [self setUpPlayerGoForwardBack];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)handlePanGestureEnded:(UIPanGestureRecognizer *)panGesture{
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

#pragma mark - ProgressViewDelgate

- (void)progressView:(ProgressView *)progressView bgViewTapGesture:(UITapGestureRecognizer *)tapGesture progressValue:(CGFloat)progressValue{
    if ([progressView isKindOfClass:[ZhengProgressView class]]) {
        [self handleTapProgressView:tapGesture progressValue:progressValue];
    }else if ([progressView isKindOfClass:[ZhengVolumeView class]]){
        [self handleTapVolumeView:tapGesture progressValue:progressValue];
        
    }else if ([progressView isKindOfClass:[ZhengBrightView class]]){
        [self handleTapBrightView:tapGesture progressValue:progressValue];
    }else{
        
    }
}

- (void)progressView:(ProgressView *)progressView indicatorButtonPanGesture:(UIPanGestureRecognizer *)panGesture progressValue:(CGFloat)progressValue{
    if ([progressView isKindOfClass:[ZhengProgressView class]]) {
        [self handlePanProgressView:panGesture progressValue:progressValue];
    }else if ([progressView isKindOfClass:[ZhengVolumeView class]]){
        [self handlePanVolumeView:panGesture progressValue:progressValue];
        
    }else if ([progressView isKindOfClass:[ZhengBrightView class]]){
        [self handlePanBrightView:panGesture progressValue:progressValue];
    }else{
        
    }
}

//ProgressView
- (void)handleTapProgressView:(UITapGestureRecognizer *)tapGesture progressValue:(CGFloat)progressValue{

    [self removeTimer];
    
    [self refreshTimeLabel];
    
    self.zhengPlayer.currentPlaybackTime = progressValue * self.zhengPlayer.duration;
    
    [self addTimer];
}
- (void)handlePanProgressView:(UIPanGestureRecognizer *)panGesture progressValue:(CGFloat)progressValue{
    
    [self refreshTimeLabel];
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        
        [self removeTimer];
        
    } else if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled) {
        
        // 设置播放器的时间
        self.zhengPlayer.currentPlaybackTime = progressValue * self.zhengPlayer.duration;
        
        [self addTimer];
    }
}

//VolumeView
- (void)handleTapVolumeView:(UITapGestureRecognizer *)tapGesture progressValue:(CGFloat)progressValue{
    self.zhengPlayer.playbackVolume = progressValue;
}
- (void)handlePanVolumeView:(UIPanGestureRecognizer *)panGesture progressValue:(CGFloat)progressValue{
    self.zhengPlayer.playbackVolume = progressValue;
}

//BrightView
- (void)handleTapBrightView:(UITapGestureRecognizer *)tapGesture progressValue:(CGFloat)progressValue{
    self.zhengPlayer.playbackBright = progressValue;
}
- (void)handlePanBrightView:(UIPanGestureRecognizer *)panGesture progressValue:(CGFloat)progressValue{
    self.zhengPlayer.playbackBright = progressValue;
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
    //取消激活
    
    //保留状态
    self.isPlayingWhenResignActive = [self isPlaying];
    if ([self isPlaying]) {
        [self pause];
    }
}

- (void)applicationDidBecomeActive{
    //进入激活
    
    if (self.isPlayingWhenResignActive) {
        //进入后台前正在播放
        [self play];
    }else{
        //进入后台前已经暂停
    }
}

#pragma mark - dealloc

- (void)dealloc{
    [ZhengNotificationTool removeNotification:self];
}

@end
