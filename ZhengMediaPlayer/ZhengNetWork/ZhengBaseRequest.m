//
//  ZhengBaseRequest.m
//  ZhengNetWork
//
//  Created by 李保征 on 2016/12/8.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengBaseRequest.h"
#import "NSString+ZhengExtension.h"

@implementation ZhengBaseRequest

//- (NSString *)baseUrlStr{
//    return @"";
//}

- (void)setBaseUrlStr:(NSString *)baseUrlStr{
    _baseUrlStr = baseUrlStr;
    
    [self handleUrl];
}

- (void)setUrlStr:(NSString *)urlStr{
    if ([urlStr isValue]) {
        _urlStr = urlStr;
    } else {
        _urlStr = nil;
    }
    
    [self handleUrl];
}

#pragma mark - Private func

- (void)handleUrl{
    if (self.baseUrlStr == nil || self.urlStr == nil) {
        return;
    }
    _urlStr = [self.baseUrlStr stringByAppendingString:self.urlStr];
}

@end
