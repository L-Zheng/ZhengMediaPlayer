//
//  ZhengFullPlayVC.m
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2016/12/27.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengFullPlayVC.h"

@interface ZhengFullPlayVC ()

@end

@implementation ZhengFullPlayVC

- (void)loadView{
    [super loadView];
    
    self.view.autoresizesSubviews = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [btn addTarget:self action:@selector(exitFullAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)exitFullAction{
    if (self.exitFullBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.exitFullBlock();
        });
    }
}

#pragma mark - UIInterface

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
//    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end
