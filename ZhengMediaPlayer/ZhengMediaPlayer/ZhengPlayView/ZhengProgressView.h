//
//  ZhengProgressView.h
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2016/12/20.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZhengProgressView;
@protocol ZhengProgressViewDelgate <NSObject>

- (void)zhengProgressView:(ZhengProgressView *)zhengProgressView bgViewTapGesture:(UITapGestureRecognizer *)tapGesture progressValue:(CGFloat)progressValue;

- (void)zhengProgressView:(ZhengProgressView *)zhengProgressView indicatorButtonPanGesture:(UIPanGestureRecognizer *)panGesture progressValue:(CGFloat)progressValue;

@end

@interface ZhengProgressView : UIView

@property (nonatomic,weak) id <ZhengProgressViewDelgate> delegate;

@property(nonatomic) float value;

@end
