//
//  ZhengPlayView.h
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2016/12/23.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhengPlayerProtocol.h"

typedef NS_ENUM(NSInteger, PlayViewType) {
    PlayViewType_Local      = 0,
    PlayViewType_Live       = 1,
    PlayViewType_M3U8       = 2,
    PlayViewType_NetWork       = 3,
} NS_ENUM_AVAILABLE_IOS(6_0);

typedef NS_ENUM(NSInteger, PlayViewStatus) {
    PlayViewStatus_Portrait      = 0,
    PlayViewStatus_Animating       = 1,
    PlayViewStatus_FullScreen       = 2,
} NS_ENUM_AVAILABLE_IOS(6_0);

@interface ZhengPlayView : UIView<ZhengPlayerProtocol>

#pragma mark - func
/** 外界调用必须传入位置 */
- (instancetype)initWithFrame:(CGRect)frame url:(NSURL *)url playViewType:(PlayViewType)playViewType scale:(CGFloat)scale;

- (void)handleSubViewFrame;

#pragma mark - 传递属性

/** 全屏旋转回调 */
@property (nonatomic,copy) void (^rotationBlock) (ZhengPlayView *zhengPlayView, BOOL isEnterFullScreen);

#pragma mark - 获取属性

/** 全屏状态 */
@property (nonatomic,assign) PlayViewStatus playViewStatus;

#pragma mark - ZhengPlayerProtocol

//- (void)prepareToPlay;
//
//- (void)play;
//
//- (void)pause;
//
//- (void)stop;
//
//- (BOOL)isPlaying;
//
//- (void)shutdown;

@end
