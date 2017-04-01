//
//  M3U8PlayViewController.m
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2017/4/1.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "M3U8PlayViewController.h"

@interface M3U8PlayViewController ()

@property (nonatomic, strong) ZhengPlayView *zhengPlayView;

@end

@implementation M3U8PlayViewController

#pragma mark - getter

- (ZhengPlayView *)zhengPlayView{
    if (!_zhengPlayView) {
        //宽高比 32：17
        CGFloat scale = (32.0 / 17.0);
        CGFloat zhengPlayViewX = 0;
        CGFloat zhengPlayViewY = 128;
        CGFloat zhengPlayViewW = self.view.bounds.size.width;
        CGFloat zhengPlayViewH = (zhengPlayViewW - 40) / scale + 40;
        _zhengPlayView = [[ZhengPlayView alloc] initWithFrame:CGRectMake(zhengPlayViewX, zhengPlayViewY, self.view.bounds.size.width, zhengPlayViewH) url:self.url playViewType:PlayViewType_M3U8 scale:scale];
    }
    return _zhengPlayView;
}

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
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

@end
