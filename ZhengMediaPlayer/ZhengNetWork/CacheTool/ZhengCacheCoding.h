//
//  ZhengCacheCoding.h
//  ZhengNetWork
//
//  Created by 李保征 on 2016/12/7.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZhengCacheDirectory.h"
#import "ZhengRequest.h"
#import "ZhengPageRequest.h"

@interface ZhengCacheCoding : NSObject

+ (BOOL)cachePageJson:(NSArray *)cacheArray zhengPageRequest:(ZhengPageRequest *)zhengPageRequest;

+ (NSArray *)readPageJson:(ZhengPageRequest *)zhengPageRequest;

+ (BOOL)cacheJson:(id)cacheJson zhengRequest:(ZhengRequest *)zhengRequest;

+ (id)readJson:(ZhengRequest *)zhengRequest;

@end
