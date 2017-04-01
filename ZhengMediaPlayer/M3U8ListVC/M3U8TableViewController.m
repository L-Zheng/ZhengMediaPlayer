//
//  M3U8ViewController.m
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2017/4/1.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "M3U8TableViewController.h"
#import "M3U8PlayViewController.h"

@interface M3U8TableViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *myTableView;

@property (nonatomic,retain) NSMutableArray *dataArray;

@end

@implementation M3U8TableViewController

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
        
        NSMutableArray *sampleList = [[NSMutableArray alloc] init];
        
        [sampleList addObject:@[@"bipbop basic master playlist",
                                @"http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8"]];
        [sampleList addObject:@[@"bipbop basic 400x300 @ 232 kbps",
                                @"http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/gear1/prog_index.m3u8"]];
        [sampleList addObject:@[@"bipbop basic 640x480 @ 650 kbps",
                                @"http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/gear2/prog_index.m3u8"]];
        [sampleList addObject:@[@"bipbop basic 640x480 @ 1 Mbps",
                                @"http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/gear3/prog_index.m3u8"]];
        [sampleList addObject:@[@"bipbop basic 960x720 @ 2 Mbps",
                                @"http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/gear4/prog_index.m3u8"]];
        [sampleList addObject:@[@"bipbop basic 22.050Hz stereo @ 40 kbps",
                                @"http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/gear0/prog_index.m3u8"]];
        
        [sampleList addObject:@[@"bipbop advanced master playlist",
                                @"http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8"]];
        [sampleList addObject:@[@"bipbop advanced 416x234 @ 265 kbps",
                                @"http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/gear1/prog_index.m3u8"]];
        [sampleList addObject:@[@"bipbop advanced 640x360 @ 580 kbps",
                                @"http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/gear2/prog_index.m3u8"]];
        [sampleList addObject:@[@"bipbop advanced 960x540 @ 910 kbps",
                                @"http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/gear3/prog_index.m3u8"]];
        [sampleList addObject:@[@"bipbop advanced 1280x720 @ 1 Mbps",
                                @"http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/gear4/prog_index.m3u8"]];
        [sampleList addObject:@[@"bipbop advanced 1920x1080 @ 2 Mbps",
                                @"http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/gear5/prog_index.m3u8"]];
        [sampleList addObject:@[@"bipbop advanced 22.050Hz stereo @ 40 kbps",
                                @"http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/gear0/prog_index.m3u8"]];
        [sampleList addObject:@[@"其他测试 此视频类似于直播 没有播放时长",
                                @"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8"]];
        
        _dataArray = sampleList;
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
    cell.textLabel.text = self.dataArray[indexPath.row][0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    M3U8PlayViewController *vc = [[M3U8PlayViewController alloc] init];
    vc.url = [NSURL URLWithString:self.dataArray[indexPath.row][1]];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
