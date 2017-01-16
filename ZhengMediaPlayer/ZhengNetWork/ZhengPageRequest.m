//
//  ZhengPageRequest.m
//  ZhengNetWork
//
//  Created by 李保征 on 2016/12/2.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengPageRequest.h"
#import "ZhengParameterFieldConst.h"

@implementation ZhengPageRequest

- (NSDictionary *)parameters{
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionaryWithDictionary:[super parameters]];
    
    [parametersDic setValue:[NSString stringWithFormat:@"%ld",self.page] forKey:ParameterPageFiled];
    [parametersDic setValue:self.limit forKey:ParameterLimitFiled];
    
    return parametersDic;
}

- (NSInteger)page{
    if (_page <= 0) {
        _page = DefaultRequestPage;
    }
    return _page;
}

- (NSNumber *)limit{
    if (!_limit) {
        _limit = @(DefaultRequestLimit);
    }
    return _limit;
}

@end
