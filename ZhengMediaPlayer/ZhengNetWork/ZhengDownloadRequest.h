//
//  ZhengDownloadRequest.h
//  ZhengNetWork
//
//  Created by 李保征 on 2016/12/7.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengBaseRequest.h"
#import "AFNetworking.h"

@interface ZhengDownloadRequest : ZhengBaseRequest

@property (nonatomic, nonnull, strong) NSURL *targetDirectoryURL;

#pragma mark - 请求管理者

@property (nullable, strong) AFURLSessionManager *sessionManager;

@property (nullable, strong) NSURLSessionDownloadTask *downloadTask;

- (void)resume;

- (void)suspend;

- (void)cancel;

@end
