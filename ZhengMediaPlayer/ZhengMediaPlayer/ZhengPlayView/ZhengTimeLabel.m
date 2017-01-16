//
//  ZhengTimeLabel.m
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2016/12/20.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengTimeLabel.h"

@implementation ZhengTimeLabel

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        self.textColor = [UIColor cyanColor];
//        self.text = @"00:00:00/00:00:00";
    }
    return self;
}

- (void)setTimeWithCurrentTime:(NSTimeInterval)currentTime durationTime:(NSTimeInterval)durationTime{
    
    currentTime = currentTime + 0.5;
    durationTime = durationTime + 0.5;
    
    NSInteger durationHour = ((NSInteger)durationTime/ 60 / 60);
    NSInteger durationMinute = ((NSInteger)durationTime / 60);
    NSInteger durationSecond = ((NSInteger)durationTime % 60);
    NSString *durationTimeStr = self.isShowHour ? [NSString stringWithFormat:@"%02ld:%02ld:%02ld",durationHour,durationMinute,durationSecond] : [NSString stringWithFormat:@"%02ld:%02ld",durationMinute,durationSecond];
    
    NSInteger currentHour = ((NSInteger)currentTime / 60 / 60);
    NSInteger currentMinute = ((NSInteger)currentTime / 60);
    NSInteger currentSecond = ((NSInteger)currentTime % 60);
    NSString *currentTimeStr = self.isShowHour ? [NSString stringWithFormat:@"%02ld:%02ld:%02ld",currentHour,currentMinute,currentSecond] : [NSString stringWithFormat:@"%02ld:%02ld",currentMinute,currentSecond];
    
    NSString *timeLabelStr = [NSString stringWithFormat:@"%@/%@",currentTimeStr,durationTimeStr];
    
    self.text = timeLabelStr;
}

@end
