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
        _zhengPlayView = [[ZhengPlayView alloc] initWithFrame:CGRectMake(0, 128, self.view.bounds.size.width, 300) url:self.filePathUrl playViewType:PlayViewType_Local];
        
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
    
    __weak typeof(self) weakSelf = self;
    
    self.zhengPlayView.fullBtnBlock = ^{
        
        ZhengFullPlayVC *fullVC = [[ZhengFullPlayVC alloc] init];
        
        __weak typeof(fullVC) weakFullVC = fullVC;
        
//        fullVC.exitFullBlock = ^{
//            [weakSelf.view addSubview:weakSelf.zhengPlayView];
//            
//            [weakFullVC dismissViewControllerAnimated:YES completion:^{
//                //调整坐标
//                [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
//                    weakSelf.zhengPlayView.frame = CGRectMake(0, 128, weakSelf.view.bounds.size.width, 300);
//                    
//                } completion:nil];
//            }];
//        };
        
        [weakSelf.zhengPlayView removeFromSuperview];
        
        [weakSelf presentViewController:fullVC animated:YES completion:^{
            [fullVC.view addSubview:weakSelf.zhengPlayView];
            //调整坐标
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                weakSelf.zhengPlayView.frame = CGRectMake(0, 128, weakSelf.view.bounds.size.width, 300);
                
            } completion:nil];
        }];
    };

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.zhengPlayView prepareToPlay];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.zhengPlayView shutdown];
}

#pragma mark - dealloc

- (void)dealloc{
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
