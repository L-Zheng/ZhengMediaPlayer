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

@interface ZhengPlayView : UIView<ZhengPlayerProtocol>

@property (nonatomic,copy) void(^fullBtnBlock)();

#pragma mark - func

- (instancetype)initWithFrame:(CGRect)frame url:(NSURL *)url playViewType:(PlayViewType)playViewType scale:(CGFloat)scale;

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
