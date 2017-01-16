//
//  ZhengNotificationTool.h
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2016/12/16.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhengNotificationTool : NSObject

+ (void)removeNotification:(nonnull id)observer;

/** 准备播放通知 */
+ (void)registerMPMediaPlaybackIsPreparedToPlayDidChangeNotification:(nonnull id)observer selector:(nonnull SEL)aSelector;

/** 加载状态通知 */
+ (void)registerMPMoviePlayerLoadStateDidChangeNotification:(nonnull id)observer selector:(nonnull SEL)aSelector;

/** 播放状态通知 */
+ (void)registerMPMoviePlayerPlaybackStateDidChangeNotification:(nonnull id)observer selector:(nonnull SEL)aSelector;

/** 播放完成通知 */
+ (void)registerMPMoviePlayerPlaybackDidFinishNotification:(nonnull id)observer selector:(nonnull SEL)aSelector;

@end
