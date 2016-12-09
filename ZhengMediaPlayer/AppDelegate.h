//
//  AppDelegate.h
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2016/12/9.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

