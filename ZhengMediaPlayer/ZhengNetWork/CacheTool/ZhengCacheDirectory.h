//
//  ZhengCacheDirectory.h
//  ZhengNetWork
//
//  Created by 李保征 on 2016/12/7.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZhengRequest.h"

#define CodingCacheFileSuffixName @"data"
#define SQLiteCacheFileSuffixName @"sqlite"

@interface ZhengCacheDirectory : NSObject

/** 返回缓存的全路径 */
+ (NSString *)cacheFullPathWithDirectory:(NSString *)urlStr cacheMethod:(CacheMethod)cacheMethod;

+ (BOOL)deleteAllCache;

+ (long long)readCacheDirectorySize;

+ (long long)readFileSize:(NSString *)filePath;

+ (BOOL)fileIsExistsAtPath:(NSString *)filePath;

+ (BOOL)fileIsExpiredAtPath:(NSString *)filePath expiredTime:(NSTimeInterval)expiredTime;

+ (BOOL)deleteFileAtPath:(NSString *)filePath;

@end
