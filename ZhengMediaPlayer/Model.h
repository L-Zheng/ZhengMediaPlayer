//
//  Model.h
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2016/12/16.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ModelType) {
    ModelType_Live      = 0,
    ModelType_Local     = 1,
    ModelType_M3U8     = 2,
    ModelType_NetWork     = 3,
} NS_ENUM_AVAILABLE_IOS(6_0);

@interface Model : NSObject

@property (nonatomic,copy) NSString *title;

@property (nonatomic,assign) ModelType modelType;

@end
