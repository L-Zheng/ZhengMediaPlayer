//
//  ZhengM3U8Player.m
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2017/4/1.
//  Copyright © 2017年 李保征. All rights reserved.
//

//用于M3U8播放的类  IJKFFMoviePlayerController RTMP协议的视频

#import "ZhengM3U8Player.h"

@implementation ZhengM3U8Player

- (id <IJKMediaPlayback> )creatPlayer{
    // 设置解码    使用默认配置
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
    id <IJKMediaPlayback> player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:options];
    
    player.scalingMode = IJKMPMovieScalingModeAspectFill;
    player.shouldAutoplay = YES;
    
    return player;
}

@end
