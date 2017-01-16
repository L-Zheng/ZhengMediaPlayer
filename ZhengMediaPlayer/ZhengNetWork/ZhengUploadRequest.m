//
//  ZhengUploadRequest.m
//  ZhengNetWork
//
//  Created by 李保征 on 2016/12/8.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengUploadRequest.h"

@implementation ZhengUploadRequest

- (void)resume{
    if (self.uploadTask) {
        if (self.uploadTask.state == NSURLSessionTaskStateRunning) {
            return;
        } else{
            [self.uploadTask resume];
        }
    }
}

- (void)suspend{
    if (self.uploadTask) {
        if (self.uploadTask.state == NSURLSessionTaskStateSuspended) {
            return;
        } else{
            [self.uploadTask suspend];
        }
    }
}

- (void)cancel{
    if (self.uploadTask) {
        if (self.uploadTask.state == NSURLSessionTaskStateCanceling) {
            return;
        } else{
            [self.uploadTask cancel];
        }
    }
}
@end
