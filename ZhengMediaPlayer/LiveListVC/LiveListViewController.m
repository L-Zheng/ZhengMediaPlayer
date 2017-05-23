//
//  LiveListViewController.m
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2016/12/16.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "LiveListViewController.h"
#import "YZLiveItem.h"
#import "YZLiveCell.h"
#import "LiveViewController.h"

static NSString * const ID = @"cell";

@interface LiveListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *myTableView;
@property(nonatomic, strong) NSMutableArray *lives;

@end

@implementation LiveListViewController

-(UITableView *)myTableView{
    if (_myTableView == nil) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myTableView;
}

- (NSMutableArray *)lives{
    if (!_lives) {
        _lives = [NSMutableArray array];
    }
    return _lives;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"直播列表";
    
    [self loadData];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"YZLiveCell" bundle:nil] forCellReuseIdentifier:ID];
    
    [self.view addSubview:self.myTableView];
}

- (void)loadData{
//    http://service.ingkee.com/api/live/gettop?imsi=&uid=17800399&proto=5&idfa=A1205EB8-0C9A-4131-A2A2-27B9A1E06622&lc=0000000000000026&cc=TG0001&imei=&sid=20i0a3GAvc8ykfClKMAen8WNeIBKrUwgdG9whVJ0ljXi1Af8hQci3&cv=IK3.1.00_Iphone&devi=bcb94097c7a3f3314be284c8a5be2aaeae66d6ab&conn=Wifi&ua=iPhone&idfv=DEBAD23B-7C6A-4251-B8AF-A95910B778B7&osversion=ios_9.300000&count=5&multiaddr=1
    
//    http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1
    ZhengRequest *request = [[ZhengRequest alloc] init];
    request.urlStr = @"http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1";
    request.className = [YZLiveItem class];
    request.needJsonField = @"lives";
    
    
    __weak typeof(self) weakSelf = self;
    [ZhengNetWork sendRequest:request success:^(id responseObject, id modelObject) {
        [weakSelf.lives removeAllObjects];
        [weakSelf.lives addObjectsFromArray:(NSArray *)modelObject];
        [weakSelf.myTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 430;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _lives.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.live = _lives[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveViewController *liveVc = [[LiveViewController alloc] init];
    liveVc.live = _lives[indexPath.row];
    
    [self.navigationController pushViewController:liveVc animated:YES];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
//    [UIView animateWithDuration:1 animations:^{
//        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
//    }];
    
    
    //动画效果
    //    CATransition *animation = [CATransition animation];
    //    animation.duration = 0.75f;
    //    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //    animation.fillMode = kCAFillModeForwards;
    //    animation.type = kCATransitionPush;
    //    animation.subtype = kCATransitionFromRight;
    //
    //    [cell.layer addAnimation:animation forKey:@"animation"];
}


@end
