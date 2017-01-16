//
//  ZhengBrightView.h
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2016/12/27.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZhengBrightView;
@protocol ZhengBrightViewDelgate <NSObject>

- (void)zhengBrightView:(ZhengBrightView *)zhengBrightView bgViewTapGesture:(UITapGestureRecognizer *)tapGesture brightValue:(CGFloat)brightValue;

- (void)zhengBrightView:(ZhengBrightView *)zhengBrightView indicatorButtonPanGesture:(UIPanGestureRecognizer *)panGesture brightValue:(CGFloat)brightValue;

@end

@interface ZhengBrightView : UIView

@property (nonatomic,weak) id <ZhengBrightViewDelgate> delegate;

@property(nonatomic) float value;

@end
