//
//  ProgressView.m
//  ZhengSlider
//
//  Created by 李保征 on 2017/4/1.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "ProgressView.h"
#import "UIView+ZhengExtension.h"

#define ProgressViewH 3

#define IndicatorButtonW 20

#define IndicatorButtonH IndicatorButtonW

#define ProgressViewAllDistance (self.bounds.size.width)

@interface ProgressView ()

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UIButton *indicatorButton;

@property (nonatomic,strong) UIView *bgProgressView;

@property (nonatomic,strong) UIView *progressView;

@end

@implementation ProgressView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        //        self.clipsToBounds = YES;
        
        [self addSubview:self.bgView];//响应点击手势
        [self addSubview:self.bgProgressView];
        [self addSubview:self.progressView];
        [self addSubview:self.indicatorButton];//响应滑动手势
    }
    return self;
}

#pragma mark - getter

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTapGesture:)];
        [_bgView addGestureRecognizer:tapGesture];
    }
    return _bgView;
}

- (UIView *)bgProgressView{
    if (!_bgProgressView) {
        _bgProgressView = [[UIView alloc] init];
        _bgProgressView.backgroundColor = [UIColor orangeColor];
        _bgProgressView.userInteractionEnabled = NO;
    }
    return _bgProgressView;
}

- (UIView *)progressView{
    if (!_progressView) {
        _progressView = [[UIView alloc] init];
        _progressView.backgroundColor = [UIColor cyanColor];
        _progressView.userInteractionEnabled = NO;
    }
    return _progressView;
}

- (UIButton *)indicatorButton{
    if (!_indicatorButton) {
        _indicatorButton = [[UIButton alloc] init];
        _indicatorButton.backgroundColor = [UIColor whiteColor];
        _indicatorButton.clipsToBounds = YES;
        _indicatorButton.adjustsImageWhenHighlighted = NO;
        
        [_indicatorButton setImage:[UIImage imageNamed:@"indicator_btn1"] forState:UIControlStateNormal];
        
        [_indicatorButton addTarget:self action:@selector(indicatorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(indicatorButtonPanGesture:)];
        
        [_indicatorButton addGestureRecognizer:panGesture];
    }
    return _indicatorButton;
}

#pragma mark - setter

//布局子空间位置  不能放在layoutSubview中 因为改变进度条的宽度时会在此调用此方法
//              不能放在initWithFrame中 因为初始化的时候可能没有设置frame
// 此方法会在 self = [super initWithFrame:frame];  执行后立即执行  外界设置frame后执行
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    self.bgView.frame = self.bounds;
    
    CGFloat bgProgressViewH = ProgressViewH;
    CGFloat bgProgressViewW = self.bounds.size.width;
    CGFloat bgProgressViewY = (self.bounds.size.height -bgProgressViewH) * 0.5;
    self.bgProgressView.frame = CGRectMake(0, bgProgressViewY, bgProgressViewW, bgProgressViewH);
    
    CGFloat progressViewH = ProgressViewH;
    CGFloat progressViewY = (self.bounds.size.height - progressViewH) * 0.5;
    CGFloat progressViewW = self.progressView.width;
    self.progressView.frame = CGRectMake(0, progressViewY, progressViewW, progressViewH);
    
    self.indicatorButton.frame = CGRectMake(self.indicatorButton.centerX - IndicatorButtonW * 0.5, 0, IndicatorButtonW, IndicatorButtonH);
    self.indicatorButton.layer.cornerRadius = self.indicatorButton.bounds.size.height * 0.5;
    
    //设置进度条的位置
    self.value = self.value;
}

- (void)setValue:(float)value{
    _value = value;
    if (value >= 0 && value <= 1) {
        
        CGFloat currentWidth = value * ProgressViewAllDistance;
        
        self.indicatorButton.centerX = currentWidth;
        
        self.progressView.width = currentWidth;
    }
}

#pragma mark - Action

- (void)bgViewTapGesture:(UITapGestureRecognizer *)tapGesture{
    
    CGPoint point = [tapGesture locationInView:tapGesture.view];
    CGFloat progressValue = point.x / ProgressViewAllDistance;
    
    self.value = progressValue;
    
    if ([_delegate respondsToSelector:@selector(progressView:bgViewTapGesture:progressValue:)]) {
        [_delegate progressView:self bgViewTapGesture:tapGesture progressValue:progressValue];
    }
}

- (void)indicatorButtonPanGesture:(UIPanGestureRecognizer *)panGesture{
    
    // 获得挪动的距离
    CGPoint t = [panGesture translationInView:panGesture.view];
    [panGesture setTranslation:CGPointZero inView:panGesture.view];
    
    self.indicatorButton.centerX = self.indicatorButton.centerX + t.x;
    
    if (self.indicatorButton.centerX < 0) {
        self.indicatorButton.centerX = 0;
    }else if (self.indicatorButton.centerX > ProgressViewAllDistance) {
        self.indicatorButton.centerX = ProgressViewAllDistance;
    }
    
    CGFloat progressValue = self.indicatorButton.center.x / ProgressViewAllDistance;
    self.value = progressValue;
    
    if ([_delegate respondsToSelector:@selector(progressView:indicatorButtonPanGesture:progressValue:)]) {
        [_delegate progressView:self indicatorButtonPanGesture:panGesture progressValue:progressValue];
    }
}

- (void)indicatorButtonClick:(UIButton *)button{
    
}

@end
