//
//  ZhengCacheTool.m
//  ZhengNetWork
//
//  Created by 李保征 on 2016/12/7.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengCacheTool.h"
#import "ZhengCacheCoding.h"
#import "ZhengCacheSQLite.h"

@implementation ZhengCacheTool

+ (BOOL)cacheData:(id)cacheData zhengRequest:(ZhengRequest *)zhengRequest{
    CacheMethod cacheMethod = zhengRequest.cacheMethod;
    if (cacheMethod == CacheMethod_NoCache) { //没有缓存
        return NO;
    }
    
    if ([zhengRequest isMemberOfClass:[ZhengRequest class]]) {
        //普通请求
        return [ZhengCacheTool cacheJson:cacheData zhengRequest:zhengRequest];
        
    } else if ([zhengRequest isMemberOfClass:[ZhengPageRequest class]]){
        //分页请求
        if ([cacheData isKindOfClass:[NSArray class]]) {
            return [ZhengCacheTool cachePageJson:(NSArray *)cacheData zhengPageRequest:(ZhengPageRequest *)zhengRequest];
        } else {
            return NO;
        }
        
    } else {
        return NO;
        
    }
}

+ (id)readData:(ZhengRequest *)zhengRequest{
    if ([zhengRequest isMemberOfClass:[ZhengRequest class]]) {
        //普通请求
        return [ZhengCacheTool readJson:zhengRequest];
        
    } else if ([zhengRequest isMemberOfClass:[ZhengPageRequest class]]){
        //分页请求
        return [ZhengCacheTool readPageJson:(ZhengPageRequest *)zhengRequest];
        
    } else {
        return nil;
        
    }
}

#pragma mark - Private func

//分页数据
+ (BOOL)cachePageJson:(NSArray *)cacheArray zhengPageRequest:(ZhengPageRequest *)zhengPageRequest{
    
    //请求数据 数组 若为空
    if (cacheArray == nil || cacheArray.count == 0) {
        return NO;
    }
    CacheMethod cacheMethod = zhengPageRequest.cacheMethod;
    
    switch (cacheMethod) {
        case CacheMethod_Coding:{      //缓存Coding
            return [ZhengCacheCoding cachePageJson:cacheArray zhengPageRequest:zhengPageRequest];
        }
            break;
            
        case CacheMethod_SQLite:{      //缓存数据库
            return [[ZhengCacheSQLite shareCacheSQLite] cachePageJson:cacheArray zhengPageRequest:zhengPageRequest];
        }
            break;
            
        default:{
            return NO;
        }
            break;
    }
}

+ (NSArray *)readPageJson:(ZhengPageRequest *)zhengPageRequest{
    
    NSArray *readArray;
    CacheMethod cacheMethod = zhengPageRequest.cacheMethod;
    
    //从缓存加载数据
    switch (cacheMethod) {
        case CacheMethod_Coding:{  //Coding
            readArray = [ZhengCacheCoding readPageJson:zhengPageRequest];
        }
            break;
            
        case CacheMethod_SQLite:{  //数据库
            readArray = [[ZhengCacheSQLite shareCacheSQLite] readPageJson:zhengPageRequest];
        }
            break;
            
        default:{
            readArray = nil;
        }
            break;
    }
    //读取数据若为空
    return readArray;
}

//单纯json数据
+ (BOOL)cacheJson:(id)cacheJson zhengRequest:(ZhengRequest *)zhengRequest{
    
    if (cacheJson == nil || cacheJson == (id)[NSNull null]) return NO;
    
    CacheMethod cacheMethod = zhengRequest.cacheMethod;
    switch (cacheMethod) {
        case CacheMethod_Coding:{
            return [ZhengCacheCoding cacheJson:cacheJson zhengRequest:zhengRequest];
        }
            break;
            
        case CacheMethod_SQLite:{
            return NO;
        }
            break;
            
        default:{
            return NO;
        }
            break;
    }
}

+ (id)readJson:(ZhengRequest *)zhengRequest{
    
    id readJson;
    
    CacheMethod cacheMethod = zhengRequest.cacheMethod;
    
    switch (cacheMethod) {
        case CacheMethod_Coding:{
            readJson = [ZhengCacheCoding readJson:zhengRequest];
        }
            break;
            
        case CacheMethod_SQLite:{
            readJson = nil;
        }
            break;
            
        default:{
            readJson = nil;
        }
            break;
    }
    
    return readJson;
}

@end
