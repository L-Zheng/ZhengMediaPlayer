//
//  ZhengNetWork+Error.h
//  ZhengNetWork
//
//  Created by 李保征 on 2016/11/25.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengNetWork.h"
#import "ZhengBaseRequest.h"

@interface ZhengNetWork (Error)

+ (NSError *)checkRequest:(ZhengBaseRequest *)zhengBaseRequest;

@end
