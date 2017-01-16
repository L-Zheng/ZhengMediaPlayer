//
//  ZhengCacheDirectory.m
//  ZhengNetWork
//
//  Created by 李保征 on 2016/12/7.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengCacheDirectory.h"
#import "NSString+ZhengExtension.h"

@implementation ZhengCacheDirectory

+ (NSString *)cacheFullPathWithDirectory:(NSString *)urlStr cacheMethod:(CacheMethod)cacheMethod{
    
    if (![urlStr isValue]) {
        return @"";
    }
    
    NSString *fileName = nil;
    //设定总体 数据缓存目录
    NSString *directoryStr;
    
    if (cacheMethod == CacheMethod_Coding) {
        fileName = [NSString stringWithFormat:@"%@.%@",[urlStr md5String],CodingCacheFileSuffixName];
        //(Library/Caches/ZhengRequestCache/CodingCache)
        directoryStr = [ZhengCacheDirectory CodingCacheDirectory];
        
    }else if (cacheMethod == CacheMethod_SQLite){
        fileName = [NSString stringWithFormat:@"%@.%@",[urlStr md5String],SQLiteCacheFileSuffixName];
        //(Library/Caches/ZhengRequestCache/SQLiteCache)
        directoryStr = [ZhengCacheDirectory SQLiteCacheDirectory];
    }
    else{
        
    }
    //返回全路径
    //  (Library/Caches/ZhengRequestCache/CodingCache/fileName.data)
    return [directoryStr stringByAppendingPathComponent:fileName];
}

+ (BOOL)deleteAllCache{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:[ZhengCacheDirectory allCacheDirectory] error:nil];
}

+ (long long)readCacheDirectorySize{
    return [self readFileSize:[ZhengCacheDirectory allCacheDirectory]];
}

+ (long long)readFileSize:(NSString *)filePath{
    // 1.文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 2.判断file是否存在
    BOOL isDirectory = NO;
    BOOL fileExists = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
    // 文件\文件夹不存在
    if (fileExists == NO) return 0;
    
    // 3.判断file是否为文件夹
    if (isDirectory) { // 是文件夹
        NSArray *subpaths = [mgr contentsOfDirectoryAtPath:filePath error:nil];
        long long totalSize = 0;
        for (NSString *subpath in subpaths) {
            NSString *fullSubpath = [filePath stringByAppendingPathComponent:subpath];
            totalSize += [self readFileSize:fullSubpath];
        }
        return totalSize;
    } else { // 不是文件夹, 文件
        // 直接计算当前文件的尺寸
        NSDictionary *attr = [mgr attributesOfItemAtPath:filePath error:nil];
        return [attr[NSFileSize] longLongValue];
    }
}

+ (BOOL)fileIsExistsAtPath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    BOOL fileExists = [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
    return fileExists;
}

+ (BOOL)fileIsExpiredAtPath:(NSString *)filePath expiredTime:(NSTimeInterval)expiredTime{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDirectory = NO;
    BOOL fileExists = [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
    
    if (fileExists) {
        NSDictionary *attr = [fileManager attributesOfItemAtPath:filePath error:nil];
        NSDate *modifyDate = attr[NSFileModificationDate];
        
        NSTimeInterval existTime = [[NSDate date] timeIntervalSinceDate:modifyDate];
        
        if (existTime < expiredTime) {
            return NO;
            
        } else {
            [fileManager removeItemAtPath:filePath error:nil];
            return YES;
        }
        
    } else {
        return YES;
    }
}

+ (BOOL)deleteFileAtPath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:filePath error:nil];
}

#pragma mark - Private func

+ (NSString *)allCacheDirectory{
    NSString *allCachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ZhengRequestCache"];
    BOOL isSuccess = [ZhengCacheDirectory creatFileFolder:allCachePath];
    if (isSuccess) {
        return allCachePath;
    }else{
        return nil;
    }
}

+ (NSString *)SQLiteCacheDirectory{
    
    NSString *sqLiteCachePath = [[self allCacheDirectory] stringByAppendingPathComponent:@"SQLiteCache"];
    
    BOOL isSuccess = [ZhengCacheDirectory creatFileFolder:sqLiteCachePath];
    if (isSuccess) {
        return sqLiteCachePath;
    }else{
        return nil;
    }
}

+ (NSString *)CodingCacheDirectory{
    
    NSString *codingCachePath = [[self allCacheDirectory] stringByAppendingPathComponent:@"CodingCache"];
    
    BOOL isSuccess = [ZhengCacheDirectory creatFileFolder:codingCachePath];
    if (isSuccess) {
        return codingCachePath;
    }else{
        return nil;
    }
}

+ (BOOL)creatFileFolder:(NSString *)fileFolderPath{
    BOOL isDir = NO;
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:fileFolderPath isDirectory:&isDir];
    if (!existed){
        BOOL isCreatSuccess = [fileManager createDirectoryAtPath:fileFolderPath withIntermediateDirectories:YES attributes:nil error:&error];
        return isCreatSuccess;
    }else{
        return YES;
    }
}

@end
