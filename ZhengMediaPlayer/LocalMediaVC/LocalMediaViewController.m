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
        
//        _zhengPlayView.backgroundColor = [UIColor orangeColor];
//        _zhengPlayView.url = self.filePathUrl;
    }
    return _zhengPlayView;
}

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.zhengPlayView];
    
    __weak __typeof__(self) weakSelf = self;

    self.zhengPlayView.fullBtnBlock = ^{
        //调整坐标
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            weakSelf.zhengPlayView.frame = CGRectMake(0, 0, weakSelf.view.bounds.size.height, weakSelf.view.bounds.size.width);
            weakSelf.zhengPlayView.center = weakSelf.view.center;
            weakSelf.zhengPlayView.transform = CGAffineTransformMakeRotation(M_PI_2);
            
        } completion:^(BOOL finished) {
            
        }];
    };

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

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
//    return YES;
//    //    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
//}


@end
