//
//  ZhengUploadRequest.h
//  ZhengNetWork
//
//  Created by 李保征 on 2016/12/8.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengBaseRequest.h"
#import "AFNetworking.h"

@interface ZhengUploadRequest : ZhengBaseRequest

@property (nonatomic, nonnull, copy) NSString *upLoadFilePath;

//可传(单纯文件上传暂时不需要) @"image/jpeg"
@property (nonatomic, nullable, copy) NSString *mimeType;

#pragma mark - 请求管理者

@property (nullable, strong) AFURLSessionManager *sessionManager;

@property (nullable, strong) NSURLSessionUploadTask *uploadTask;

- (void)resume;

- (void)suspend;

- (void)cancel;

@end
