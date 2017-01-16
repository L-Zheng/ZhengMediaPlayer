//
//  ZhengCacheTool.h
//  ZhengNetWork
//
//  Created by 李保征 on 2016/12/7.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZhengCacheDirectory.h"
#import "ZhengRequest.h"
#import "ZhengPageRequest.h"

@interface ZhengCacheTool : NSObject

+ (BOOL)cacheData:(id)cacheData zhengRequest:(ZhengRequest *)zhengRequest;

+ (id)readData:(ZhengRequest *)zhengRequest;

@end
