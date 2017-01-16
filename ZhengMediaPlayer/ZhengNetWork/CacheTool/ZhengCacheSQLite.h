//
//  ZhengCacheSQLite.h
//  ZhengNetWork
//
//  Created by 李保征 on 2016/12/7.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZhengPageRequest.h"

@interface ZhengCacheSQLite : NSObject

+ (instancetype)shareCacheSQLite;

- (BOOL)cachePageJson:(NSArray *)cacheArray zhengPageRequest:(ZhengPageRequest *)zhengPageRequest;

- (NSArray *)readPageJson:(ZhengPageRequest *)zhengPageRequest;

@end
