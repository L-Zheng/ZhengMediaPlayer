//
//  ZhengPageRequest.h
//  ZhengNetWork
//
//  Created by 李保征 on 2016/12/2.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengRequest.h"

@interface ZhengPageRequest : ZhengRequest

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) NSNumber *limit;

@end
