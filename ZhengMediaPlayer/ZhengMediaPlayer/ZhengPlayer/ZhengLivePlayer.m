//
//  ZhengLivePlayer.m
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2016/12/19.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengLivePlayer.h"

@implementation ZhengLivePlayer

#pragma mark - Player

- (id <IJKMediaPlayback> )creatPlayer{
    // 设置解码    使用默认配置
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    //改进
    //[options setPlayerOptionIntValue:0 forKey:@"no-time-adjust"];
    //[options setPlayerOptionIntValue:1 forKey:@"audio_disable"];
    //[options setPlayerOptionIntValue:1 forKey:@"infbuf"];
    //[options setPlayerOptionIntValue:0 forKey:@"framedrop"];
    
    //videotoolbox 配置（硬件解码）
    [options setPlayerOptionIntValue:1  forKey:@"videotoolbox"];
    
    //    [player setOptionValue:nil forKey:nil ofCategory:kIJKFFOptionCategoryCodec];
    
    
    // 创建IJKFFMoviePlayerController：专门用来直播，传入拉流地址就好了
    //    player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:nil];
    
    id <IJKMediaPlayback> player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:options];
    
    player.scalingMode = IJKMPMovieScalingModeAspectFit;
    
    player.shouldAutoplay = YES;
    
    //显示编码及来源信息
    //        player.shouldShowHudView = YES;
    return player;
}

@end
