//
//  ZhengLocalPlayer.m
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2016/12/19.
//  Copyright © 2016年 李保征. All rights reserved.
//

//用于本地播放的类  IJKFFMoviePlayerController RTMP协议的视频

#import "ZhengLocalPlayer.h"

@implementation ZhengLocalPlayer

#pragma mark - Player

- (id <IJKMediaPlayback> )creatPlayer{
    // 设置解码    使用默认配置
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
    id <IJKMediaPlayback> player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:options];
    
    player.scalingMode = IJKMPMovieScalingModeAspectFit;
    player.shouldAutoplay = YES;
    
    return player;
}

@end
