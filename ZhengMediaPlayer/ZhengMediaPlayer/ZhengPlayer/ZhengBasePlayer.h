//
//  ZhengBasePlayer.h
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2016/12/19.
//  Copyright © 2016年 李保征. All rights reserved.
//

//IJKFFMoviePlayerController  可播放 直播 本地视频 网络视频

//([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"] || [scheme isEqualToString:@"rtmp"])

//用于直播的类  IJKFFMoviePlayerController RTMP协议的视频
//用于本地播放的类  IJKFFMoviePlayerController RTMP协议的视频
//用于M3U8播放的类  IJKFFMoviePlayerController RTMP协议的视频
//用于网络视频播放的类  IJKAVMoviePlayerController IJKFFMoviePlayerController

//ijk暂时不支持边下边播功能 http://blog.csdn.net/codingfire/article/details/53839513

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
