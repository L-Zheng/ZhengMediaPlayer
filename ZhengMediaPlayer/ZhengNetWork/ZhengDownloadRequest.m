//
//  ZhengDownloadRequest.m
//  ZhengNetWork
//
//  Created by 李保征 on 2016/12/7.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengDownloadRequest.h"

@implementation ZhengDownloadRequest

- (void)resume{
    if (self.downloadTask) {
        if (self.downloadTask.state == NSURLSessionTaskStateRunning) {
            return;
        } else{
            [self.downloadTask resume];
        }
    }
}

- (void)suspend{
    if (self.downloadTask) {
        if (self.downloadTask.state == NSURLSessionTaskStateSuspended) {
            return;
        } else{
            [self.downloadTask suspend];
        }
    }
}

- (void)cancel{
    if (self.downloadTask) {
        if (self.downloadTask.state == NSURLSessionTaskStateCanceling) {
            return;
        } else{
            [self.downloadTask cancel];
        }
    }
}

@end
