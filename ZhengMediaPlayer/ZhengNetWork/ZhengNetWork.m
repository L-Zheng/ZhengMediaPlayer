//
//  ZhengNetWork.m
//  ZhengNetWork
//
//  Created by 李保征 on 2016/11/25.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengNetWork.h"
#import "ZhengNetWork+Error.h"
#import "ZhengCacheTool.h"
#import "ZhengParseTool.h"

@implementation ZhengNetWork

#pragma mark - Public func

+ (void)sendRequest:(ZhengRequest *)zhengRequest success:(void (^)(id responseObject ,id modelObject))success failure:(void (^)(NSError *error))failure{
    
    //检查Request
    NSError *myError = [ZhengNetWork checkRequest:zhengRequest];
    if (myError) {
        if (failure) {
            failure(myError);
        }
        return;
    }
    
    //创建管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.securityPolicy.allowInvalidCertificates = YES;
    zhengRequest.sessionManager = manager;
    
    //设置请求头
    NSDictionary *header = zhengRequest.header;
    if (header) {
        NSArray *keysArray = header.allKeys;
        for (NSString *key in keysArray) {
            [manager.requestSerializer setValue:header[key] forHTTPHeaderField:key];
        }
    }
    
    //设置请求超时时间
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = zhengRequest.timeOut.doubleValue;
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //设置ContentType
//    self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
    manager.responseSerializer.acceptableContentTypes = [[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"] setByAddingObject:@"text/plain"];
    
    //发送请求
    switch (zhengRequest.requestType) {
        case RequestType_Get:
            [ZhengNetWork getRequest:zhengRequest success:success failure:failure];
            break;
            
        case RequestType_Post:
            [ZhengNetWork postRequest:zhengRequest success:success failure:failure];
            break;
            
        default:
            return;
            break;
    }
}

+ (void)readCacheRequest:(ZhengRequest *)zhengRequest cache:(void (^)(id responseObject ,id modelObject))cache failure:(void (^)(NSError *error))failure{
    
    //检查Request
    NSError *myError = [ZhengNetWork checkRequest:zhengRequest];
    if (myError) {
        if (failure) {
            failure(myError);
        }
        return;
    }
    
    id cacheData = [ZhengCacheTool readData:zhengRequest];
    
    [ZhengNetWork callBackCache:zhengRequest cacheData:cacheData cache:cache];
}

+ (void)downLoadFileRequst:(ZhengDownloadRequest *)zhengDownloadRequest
              progress:(void (^)(NSProgress *downloadProgress))downloadProgress
           destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
     completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler{
    
    //检查Request
    NSError *myError = [ZhengNetWork checkRequest:zhengDownloadRequest];
    if (myError) {
        if (completionHandler) {
            completionHandler(nil,nil,myError);
        }
        return;
    }
    
    NSString *urlStr = zhengDownloadRequest.urlStr;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    manager.securityPolicy.allowInvalidCertificates = YES;
    
    zhengDownloadRequest.sessionManager = manager;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:downloadProgress destination:destination completionHandler:completionHandler];
    
    zhengDownloadRequest.downloadTask = downloadTask;
    
    [downloadTask resume];
}

+ (void)upLoadFileRequst:(ZhengUploadRequest *)zhengUploadRequest
            progress:(void (^)(NSProgress *uploadProgress))uploadProgress
   completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler{
    
    //检查Request
    NSError *myError = [ZhengNetWork checkRequest:zhengUploadRequest];
    if (myError) {
        if (completionHandler) {
            completionHandler(nil,nil,myError);
        }
        return;
    }
    
    NSString *urlStr = zhengUploadRequest.urlStr;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //    manager.securityPolicy.allowInvalidCertificates = YES;
    
    zhengUploadRequest.sessionManager = manager;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    NSURL *filePath = [NSURL fileURLWithPath:zhengUploadRequest.upLoadFilePath];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:uploadProgress completionHandler:completionHandler];
    
    zhengUploadRequest.uploadTask = uploadTask;
    
    [uploadTask resume];
}

+ (void)upLoadMultiRequst:(ZhengMultiUploadRequest *)zhengMultiUploadRequest
           multiprogress:(void (^)(NSProgress *uploadProgress))uploadMultiProgress
       completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler{
    
    //检查Request
    NSError *myError = [ZhengNetWork checkRequest:zhengMultiUploadRequest];
    if (myError) {
        if (completionHandler) {
            completionHandler(nil,nil,myError);
        }
        return;
    }
    
    NSString *urlStr = zhengMultiUploadRequest.urlStr;
    
    NSString *upLoadFilePath = zhengMultiUploadRequest.upLoadFilePath;
    NSString *fileName = zhengMultiUploadRequest.fileName;
    NSDictionary *parameters = zhengMultiUploadRequest.parameters;
    
    __weak typeof(zhengMultiUploadRequest.mimeType) weakMimeType = zhengMultiUploadRequest.mimeType;
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:upLoadFilePath] name:@"file" fileName:fileName mimeType:weakMimeType error:nil];
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    zhengMultiUploadRequest.sessionManager = manager;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:uploadMultiProgress completionHandler:completionHandler];
    
    zhengMultiUploadRequest.uploadTask = uploadTask;
    
    [uploadTask resume];
}

#pragma mark - Private func

#pragma mark - Request func

+ (void)getRequest:(ZhengRequest *)zhengRequest success:(void (^)(id responseObject ,id modelObject))success failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parameters = zhengRequest.parameters;
    NSString *urlStr = zhengRequest.urlStr;
    
    zhengRequest.requestStatus = RequestStatus_Running;
    
    [zhengRequest.sessionManager GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ZhengNetWork callBackSuccess:zhengRequest responseObject:responseObject success:success];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ZhengNetWork callBackFailure:zhengRequest error:error failure:failure];
        
    }];
}

+ (void)postRequest:(ZhengRequest *)zhengRequest success:(void (^)(id responseObject ,id modelObject))success failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parameters = zhengRequest.parameters;
    NSString *urlStr = zhengRequest.urlStr;
    
    zhengRequest.requestStatus = RequestStatus_Running;
    
    [zhengRequest.sessionManager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ZhengNetWork callBackSuccess:zhengRequest responseObject:responseObject success:success];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ZhengNetWork callBackFailure:zhengRequest error:error failure:failure];
        
    }];
}

#pragma mark - CallBack func

+ (void)callBackSuccess:(ZhengRequest *)zhengRequest responseObject:(id _Nullable)responseObject success:(void (^)(id responseObject ,id modelObject))success{
    
    if (zhengRequest.requestStatus == RequestStatus_Running) {
        zhengRequest.requestStatus = RequestStatus_Success;
        if (success) {
            //分页数据处理
            id cacheData = nil;
            if (zhengRequest.needJsonField) {
                NSDictionary *jsonDic = (NSDictionary *)responseObject;
                cacheData = [jsonDic valueForKey:zhengRequest.needJsonField];
            } else {
                cacheData = responseObject;
            }
            //转模型
            id modelObject = nil;
            if (zhengRequest.className) {
                modelObject = [ZhengParseTool sourceData:cacheData toModel:zhengRequest.className];
            }
            //回调
            success(responseObject,modelObject);
            //缓存
            [ZhengCacheTool cacheData:cacheData zhengRequest:zhengRequest];
        }
    }
}

+ (void)callBackCache:(ZhengRequest *)zhengRequest cacheData:(id _Nullable)cacheData cache:(void (^)(id responseObject ,id modelObject))cache{
    if (cache) {
        zhengRequest.requestStatus = RequestStatus_Cache;
        //转模型
        id modelObject = nil;
        if (zhengRequest.className) {
            modelObject = [ZhengParseTool sourceData:cacheData toModel:zhengRequest.className];
        }
        //回调
        cache(cacheData,modelObject);
    }
}

+ (void)callBackFailure:(ZhengRequest *)zhengRequest error:(NSError * _Nonnull)error failure:(void (^)(NSError *error))failure{
    
    if (zhengRequest.requestStatus == RequestStatus_Running) {
        zhengRequest.requestStatus = RequestStatus_Fail;
        if (failure) {
            failure(error);
        }
    }
}

@end
