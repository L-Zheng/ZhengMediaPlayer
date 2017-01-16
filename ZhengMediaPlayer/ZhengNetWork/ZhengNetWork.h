//
//  ZhengNetWork.h
//  ZhengNetWork
//
//  Created by 李保征 on 2016/11/25.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZhengBaseRequest.h"
#import "ZhengRequest.h"
#import "ZhengDownloadRequest.h"
#import "ZhengUploadRequest.h"
#import "ZhengMultiUploadRequest.h"

@interface ZhengNetWork : NSObject

#pragma mark - Request

+ (void)sendRequest:(ZhengRequest *)zhengRequest success:(void (^)(id responseObject ,id modelObject))success failure:(void (^)(NSError *error))failure;

+ (void)readCacheRequest:(ZhengRequest *)zhengRequest cache:(void (^)(id responseObject ,id modelObject))cache failure:(void (^)(NSError *error))failure;

#pragma mark - download

+ (void)downLoadFileRequst:(ZhengDownloadRequest *)zhengDownloadRequest
              progress:(void (^)(NSProgress *downloadProgress))downloadProgress
           destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
     completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

#pragma mark - upload

+ (void)upLoadFileRequst:(ZhengUploadRequest *)zhengUploadRequest
            progress:(void (^)(NSProgress *uploadProgress))uploadProgress
   completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

+ (void)upLoadMultiRequst:(ZhengMultiUploadRequest *)zhengMultiUploadRequest
           multiprogress:(void (^)(NSProgress *uploadProgress))uploadMultiProgress
       completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

@end
