//
//  ZhengVolumeView.h
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2016/12/21.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZhengVolumeView;
@protocol ZhengVolumeViewDelgate <NSObject>

- (void)zhengVolumeView:(ZhengVolumeView *)zhengVolumeView bgViewTapGesture:(UITapGestureRecognizer *)tapGesture volumeValue:(CGFloat)volumeValue;

- (void)zhengVolumeView:(ZhengVolumeView *)zhengVolumeView indicatorButtonPanGesture:(UIPanGestureRecognizer *)panGesture volumeValue:(CGFloat)volumeValue;

@end

@interface ZhengVolumeView : UIView

@property (nonatomic,weak) id <ZhengVolumeViewDelgate> delegate;

@property(nonatomic) float value;

@end
