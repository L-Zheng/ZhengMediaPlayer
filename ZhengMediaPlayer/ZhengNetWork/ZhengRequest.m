//
//  ZhengRequest.m
//  ZhengNetWork
//
//  Created by 李保征 on 2016/11/25.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengRequest.h"

@implementation ZhengRequest

#pragma mark - getter

- (NSDictionary *)parameters{
    if (!_parameters) {
        _parameters = [NSDictionary dictionary];
    }
    return _parameters;
}

- (NSNumber *)timeOut{
    if (!_timeOut) {
        _timeOut = @(10);
    }
    return _timeOut;
}

- (NSTimeInterval)expiredTime{
    if (_expiredTime <= 0) {
        _expiredTime = 30 * 24 * 60 * 60;
    }
    return _expiredTime;
}

#pragma mark - public func

- (void)stopRequest{
    if (self.sessionManager) {
        [self.sessionManager.operationQueue cancelAllOperations];
    }
    self.requestStatus = RequestStatus_Stopped;
//    for (NSURLSessionTask *task in self.sessionManager.tasks) {
//        if (task.state == NSURLSessionTaskStateRunning) {
//            [task cancel];
//        }
//    }
}

- (void)dealloc{
    
}

@end
