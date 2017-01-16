//
//  ZhengPlayerProtocol.h
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2016/12/26.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZhengPlayerProtocol <NSObject>

@required

- (void)prepareToPlay;

- (void)play;

- (void)pause;

- (void)stop;

- (BOOL)isPlaying;

- (void)shutdown;

@end
