//
//  ZhengBaseRequest.h
//  ZhengNetWork
//
//  Created by 李保征 on 2016/12/8.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhengBaseRequest : NSObject
//必传
@property (nonatomic, nonnull, copy) NSString *urlStr;

//可传
@property (nonatomic, assign, getter=isEnableHTTPS) BOOL enableHTTPS;

@property (nonatomic, nonnull, copy) NSString *baseUrlStr;

@end
