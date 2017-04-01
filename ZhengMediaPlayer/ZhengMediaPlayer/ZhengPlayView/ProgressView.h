//
//  ProgressView.h
//  ZhengSlider
//
//  Created by 李保征 on 2017/4/1.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProgressView;
@protocol ProgressViewDelgate <NSObject>

- (void)progressView:(ProgressView *)progressView bgViewTapGesture:(UITapGestureRecognizer *)tapGesture progressValue:(CGFloat)progressValue;

- (void)progressView:(ProgressView *)progressView indicatorButtonPanGesture:(UIPanGestureRecognizer *)panGesture progressValue:(CGFloat)progressValue;

@end

@interface ProgressView : UIView

@property (nonatomic,weak) id <ProgressViewDelgate> delegate;

@property(nonatomic) float value;

@end
