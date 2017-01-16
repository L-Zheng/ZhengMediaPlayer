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
        
        _dataArray = [NSMutableArray arrayWithArray:@[model1,model2]];
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
            
        default:
            break;
    }
    
}

@end
