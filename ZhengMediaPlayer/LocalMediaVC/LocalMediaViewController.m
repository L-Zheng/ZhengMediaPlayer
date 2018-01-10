//
//  LocalMediaViewController.m
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2016/12/16.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "LocalMediaViewController.h"

@interface LocalMediaViewController ()

@property (nonatomic, strong) ZhengPlayView *zhengPlayView;

//全屏旋转
@property (nonatomic,strong) UIView *originPlayViewSuperView;

@property (nonatomic,assign) CGRect originPlayViewFrame;

@end

@implementation LocalMediaViewController

#pragma mark - getter

- (ZhengPlayView *)zhengPlayView{
    if (!_zhengPlayView) {
        //宽高比 32：17
        CGFloat scale = (32.0 / 17.0);
        CGFloat zhengPlayViewX = 0;
        CGFloat zhengPlayViewY = 128;
        CGFloat zhengPlayViewW = self.view.bounds.size.width;
        CGFloat zhengPlayViewH = (zhengPlayViewW - 40) / scale + 40;
        _zhengPlayView = [[ZhengPlayView alloc] initWithFrame:CGRectMake(zhengPlayViewX, zhengPlayViewY, self.view.bounds.size.width, zhengPlayViewH) url:self.filePathUrl playViewType:PlayViewType_Local scale:scale];
    
        __weak __typeof__(self) weakSelf = self;
        _zhengPlayView.rotationBlock = ^(ZhengPlayView *zhengPlayView, BOOL isEnterFullScreen) {
            if (isEnterFullScreen) {
                [weakSelf enterFullScreen];
            }else{
                [weakSelf exitFullScreen];
            }
        };
    }
    return _zhengPlayView;
}

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.filePathUrl = [NSURL fileURLWithPath:@"/Users/zheng/Desktop/[乡村爱Q进行Q]第60集_bd.mp4"];
    
    [self.view addSubview:self.zhengPlayView];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.zhengPlayView prepareToPlay];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.zhengPlayView shutdown];
}

#pragma mark - dealloc

- (void)dealloc{
    [ZhengNotificationTool removeNotification:self];
}

#pragma mark - UIInterface

- (void)enterFullScreen{
    
    ZhengPlayView *zhengPlayView = self.zhengPlayView;
    
    zhengPlayView.playViewStatus = PlayViewStatus_Animating;
    
    //保存原来的父视图和位置
    self.originPlayViewSuperView = zhengPlayView.superview;
    self.originPlayViewFrame = zhengPlayView.frame;
    
    /*
     例把UITableViewCell中的subview(btn)的frame转换到 controllerA中
     [objc] view plain copy
     // controllerA 中有一个UITableView, UITableView里有多行UITableVieCell，cell上放有一个button
     // 在controllerA中实现:
     CGRect rc = [cell convertRect:cell.btn.frame toView:self.view];
     或
     CGRect rc = [self.view convertRect:cell.btn.frame fromView:cell];
     // 此rc为btn在controllerA中的rect
     
     或当已知btn时：
     CGRect rc = [btn.superview convertRect:btn.frame toView:self.view];
     或
     CGRect rc = [self.view convertRect:btn.frame fromView:btn.superview]; 
     */
    //移动到window上
    CGRect rectInWindow = [zhengPlayView convertRect:zhengPlayView.bounds toView:[UIApplication sharedApplication].keyWindow];
    [zhengPlayView removeFromSuperview];
    zhengPlayView.frame = rectInWindow;
    [[UIApplication sharedApplication].keyWindow addSubview:zhengPlayView];
    
    //旋转动画
    [UIView animateWithDuration:0.3 animations:^{
        
        zhengPlayView.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        zhengPlayView.bounds = CGRectMake(0, 0, CGRectGetHeight(zhengPlayView.superview.bounds), CGRectGetWidth(zhengPlayView.superview.bounds));
        zhengPlayView.center = CGPointMake(CGRectGetMidX(zhengPlayView.superview.bounds), CGRectGetMidY(zhengPlayView.superview.bounds));
        
        [zhengPlayView handleSubViewFrame];
        
    } completion:^(BOOL finished) {
        zhengPlayView.playViewStatus = PlayViewStatus_FullScreen;
        
        [UIApplication sharedApplication].statusBarHidden = YES;
    }];
    [self setScreenOrientation:UIInterfaceOrientationLandscapeRight];
}

- (void)exitFullScreen{
    ZhengPlayView *zhengPlayView = self.zhengPlayView;
    
    zhengPlayView.playViewStatus = PlayViewStatus_Animating;
    
    //移动到原来视图上
    CGRect frame = [self.originPlayViewSuperView convertRect:self.originPlayViewFrame toView:[UIApplication sharedApplication].keyWindow];
    
    [UIView animateWithDuration:0.3 animations:^{
        zhengPlayView.transform = CGAffineTransformIdentity;
        zhengPlayView.frame = frame;
        [zhengPlayView handleSubViewFrame];
    } completion:^(BOOL finished) {
        
        [zhengPlayView removeFromSuperview];
        zhengPlayView.frame = self.originPlayViewFrame;
        [self.originPlayViewSuperView addSubview:zhengPlayView];
        
        zhengPlayView.playViewStatus = PlayViewStatus_Portrait;
        
        [UIApplication sharedApplication].statusBarHidden = NO;
        
        [self setScreenOrientation:UIInterfaceOrientationPortrait];
    }];
}


- (void)setScreenOrientation:(UIInterfaceOrientation)interfaceOrientation{
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
}

//屏幕旋转调用
//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
//    NSLog(@"屏幕旋转完毕");
//}

- (BOOL)shouldAutorotate {
    return NO;
}


@end
