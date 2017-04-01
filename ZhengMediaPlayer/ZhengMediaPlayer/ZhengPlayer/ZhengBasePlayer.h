//
//  ZhengBasePlayer.h
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2016/12/19.
//  Copyright © 2016年 李保征. All rights reserved.
//

//IJKFFMoviePlayerController  可播放 直播 网络视频 本地视频

#import <Foundation/Foundation.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "ZhengPlayerProtocol.h"

typedef NS_ENUM(NSInteger, ZhengPlayState) {
    ZhengPlayState_Unknown           = 0,
    ZhengPlayState_Playing           = 1,
    ZhengPlayState_Pause             = 2,
    ZhengPlayState_Stop              = 3,
} NS_ENUM_AVAILABLE_IOS(6_0);

@interface ZhengBasePlayer : NSObject<ZhengPlayerProtocol>

//播放地址
@property (nonatomic,strong) NSURL *url;

#pragma mark - Play State

//IJKFFMoviePlayerController  IJKAVMoviePlayerController IJKMPMoviePlayerController
@property (nonatomic,strong) id <IJKMediaPlayback> player;

@property (nonatomic,weak) UIView *playerView;

@property(nonatomic,assign,readonly)  IJKMPMovieLoadState loadState;

@property(nonatomic,assign,readonly)  IJKMPMoviePlaybackState playbackState;

@property (nonatomic,assign) ZhengPlayState zhengPlayState;

#pragma mark - Timer

@property(nonatomic, readonly)  NSTimeInterval duration;

@property(nonatomic)            NSTimeInterval currentPlaybackTime;

@property (nonatomic) float playbackVolume;

@property (nonatomic,assign) CGFloat playbackBright;

@end
