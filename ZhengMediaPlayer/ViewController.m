//
//  ViewController.m
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2016/12/9.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ViewController.h"
#import "LiveListViewController.h"
#import "LocalMediaViewController.h"
#import "M3U8TableViewController.h"
#import "NetWorkPlayViewController.h"
#import "CaptureLiveVC.h"
#import "Model.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *myTableView;

@property (nonatomic,retain) NSMutableArray *dataArray;

@end

@implementation ViewController

#pragma mark - getter

- (UITableView *)myTableView{
    if (_myTableView == nil) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
    }
    return _myTableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        Model *model1 = [[Model alloc] init];
        model1.title = @"直播";
        model1.modelType = ModelType_Live;
        
        Model *model2 = [[Model alloc] init];
        model2.title = @"本地播放";
        model2.modelType = ModelType_Local;
        
        Model *model3 = [[Model alloc] init];
        model3.title = @"M3U8 视频 simple";
        model3.modelType = ModelType_M3U8;
        
        Model *model4 = [[Model alloc] init];
        model4.title = @"网络视频播放";
        model4.modelType = ModelType_NetWork;
        
        Model *model5 = [[Model alloc] init];
        model5.title = @"视频采集";
        model5.modelType = ModelType_CaptureLive;
        
        _dataArray = [NSMutableArray arrayWithArray:@[model1,model2,model3,model4,model5]];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.myTableView];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    Model *model = self.dataArray[indexPath.row];
    
    cell.textLabel.text = model.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Model *model = self.dataArray[indexPath.row];
    ModelType modelType = model.modelType;
    
    switch (modelType) {
        case ModelType_Live:{
            LiveListViewController *liveVC = [[LiveListViewController alloc] init];
            [self.navigationController pushViewController:liveVC animated:YES];
        }
            break;
            
        case ModelType_Local:{
            LocalMediaViewController *localVC = [[LocalMediaViewController alloc] init];
            localVC.filePathUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"WeChatSight455" ofType:@"mp4"]];
            [self.navigationController pushViewController:localVC animated:YES];
        }
            break;
            
        case ModelType_M3U8:{
            M3U8TableViewController *vc = [[M3U8TableViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case ModelType_NetWork:{
            NetWorkPlayViewController *vc = [[NetWorkPlayViewController alloc] init];
//          @"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
            vc.url = [NSURL URLWithString:@"http://flv2.bn.netease.com/videolib3/1602/24/AnIoH5484/SD/AnIoH5484-mobile.mp4"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case ModelType_CaptureLive:{
            CaptureLiveVC *vc = [[CaptureLiveVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

@end
