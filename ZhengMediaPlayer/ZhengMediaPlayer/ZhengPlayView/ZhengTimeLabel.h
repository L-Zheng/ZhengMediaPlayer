//
//  ZhengTimeLabel.h
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2016/12/20.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhengTimeLabel : UILabel

- (void)setTimeWithCurrentTime:(NSTimeInterval)currentTime durationTime:(NSTimeInterval)durationTime;

@property (nonatomic,assign) BOOL isShowHour;

@end
