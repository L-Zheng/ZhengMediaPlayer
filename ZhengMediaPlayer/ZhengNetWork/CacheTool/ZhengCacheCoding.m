//
//  ZhengCacheCoding.m
//  ZhengNetWork
//
//  Created by 李保征 on 2016/12/7.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengCacheCoding.h"
#import "ZhengParameterFieldConst.h"

@implementation ZhengCacheCoding

+ (BOOL)cachePageJson:(NSArray *)cacheArray zhengPageRequest:(ZhengPageRequest *)zhengPageRequest{
    
    NSString *urlStr = zhengPageRequest.urlStr;
    CacheMethod cacheMethod = zhengPageRequest.cacheMethod;
    
    //缓存完整路径
    NSString *cachefullPath = [ZhengCacheDirectory cacheFullPathWithDirectory:urlStr cacheMethod:cacheMethod];
    
    //1.读取全部缓存
    NSArray *readArray = [NSKeyedUnarchiver unarchiveObjectWithFile:cachefullPath];
    
    if (readArray == nil || readArray.count == 0) {  //1.1读取文件为空
        //缓存到本地 归档 (如果原来已经存在该文件 会覆盖数据)
        return [NSKeyedArchiver archiveRootObject:cacheArray toFile:cachefullPath];
        
    }else{
        //拿出旧数据
        NSMutableArray *oldCacheArray = [NSMutableArray arrayWithArray:readArray];
        //拿出新数据
        NSMutableArray *newCacheArray = [NSMutableArray arrayWithArray:cacheArray];
        
        //遍历旧数据  查找是否有相同的数据
        [readArray enumerateObjectsUsingBlock:^(id  _Nonnull objOld, NSUInteger idxOld, BOOL * _Nonnull stopOld) {
            
            NSDictionary *dicOld = (NSDictionary *)objOld;
            NSString *strIDOld = [NSString stringWithFormat:@"%@",dicOld[EachInfoID]];
            
            //遍历新数据
            [cacheArray enumerateObjectsUsingBlock:^(id  _Nonnull objNew, NSUInteger idxNew, BOOL * _Nonnull stopNew) {
                
                NSDictionary *dicNew = (NSDictionary *)objNew;
                NSString *strIDNew = [NSString stringWithFormat:@"%@",dicNew[EachInfoID]];
                
                if ([strIDNew isEqualToString:strIDOld]) { //如果有相同的
                    //直接删除老的该条数据
                    [oldCacheArray removeObjectAtIndex:idxOld];
                    //停止遍历新数据  进行下一个老数据
                    *stopNew = YES;
                }
            }];
        }];
        //新数据 + 经过删除后老数据
        [newCacheArray addObjectsFromArray:oldCacheArray];
        
        //3.缓存到本地 归档 (如果原来已经存在该文件 会覆盖数据)
        return [NSKeyedArchiver archiveRootObject:newCacheArray toFile:cachefullPath];
    }
}

+ (NSArray *)readPageJson:(ZhengPageRequest *)zhengPageRequest{
    
    NSString *urlStr = zhengPageRequest.urlStr;
    CacheMethod cacheMethod = zhengPageRequest.cacheMethod;
    
    //缓存完整路径  数据库文件用不到page字段
    NSString *cachefullPath = [ZhengCacheDirectory cacheFullPathWithDirectory:urlStr cacheMethod:cacheMethod];
    
    //不存在文件直接返回空
    if (![ZhengCacheDirectory fileIsExistsAtPath:cachefullPath]){
        return nil;
    }
    //缓存过期
    if ([ZhengCacheDirectory fileIsExpiredAtPath:cachefullPath expiredTime:zhengPageRequest.expiredTime]) {
        return nil;
    }
    //设置页码  限制条数
    NSInteger page = zhengPageRequest.page;
    NSInteger limit = zhengPageRequest.limit.integerValue;
    
    //读取数据
    NSArray *readArray = [NSKeyedUnarchiver unarchiveObjectWithFile:cachefullPath];
    if (readArray == nil || readArray.count == 0) {
        return nil;
    }
    
    NSMutableArray *readMutableArray = [NSMutableArray arrayWithArray:readArray];
    
    //排序处理  降序
    for (int j = 0; j < readMutableArray.count; j++) {
        for (int k = j+1; k < readMutableArray.count; k++) {
            NSDictionary *dicj = readMutableArray[j];
            NSDictionary *dick = readMutableArray[k];
            
            NSString *strj = [NSString stringWithFormat:@"%@",dicj[EachInfoID]];
            NSString *strk = [NSString stringWithFormat:@"%@",dick[EachInfoID]];
            
            if (strj.integerValue < strk.integerValue) {
                [readMutableArray replaceObjectAtIndex:k withObject:dicj];
                [readMutableArray replaceObjectAtIndex:j withObject:dick];
            }
        }
    }
    //选取范围
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(limit * (page - 1), limit)];
    //越界处理
    if (limit * page > readMutableArray.count) {
        return readMutableArray;
    }
    //查询返回
    return [readMutableArray objectsAtIndexes:indexSet];
}


+ (BOOL)cacheJson:(id)cacheJson zhengRequest:(ZhengRequest *)zhengRequest{
    
    if (cacheJson == nil) return NO;
    
    NSString *urlStr = zhengRequest.urlStr;
    CacheMethod cacheMethod = zhengRequest.cacheMethod;
    //缓存完整路径
    NSString *cachefullPath = [ZhengCacheDirectory cacheFullPathWithDirectory:urlStr cacheMethod:cacheMethod];
    
    return [NSKeyedArchiver archiveRootObject:cacheJson toFile:cachefullPath];
}

+ (id)readJson:(ZhengRequest *)zhengRequest{
    
    NSString *urlStr = zhengRequest.urlStr;
    CacheMethod cacheMethod = zhengRequest.cacheMethod;
    //缓存完整路径
    NSString *cachefullPath = [ZhengCacheDirectory cacheFullPathWithDirectory:urlStr cacheMethod:cacheMethod];
    
    //不存在文件直接返回空
    if (![ZhengCacheDirectory fileIsExistsAtPath:cachefullPath]){
        return nil;
    }
    //缓存过期
    if ([ZhengCacheDirectory fileIsExpiredAtPath:cachefullPath expiredTime:zhengRequest.expiredTime]) {
        return nil;
    }
    //读取数据
    id Json = [NSKeyedUnarchiver unarchiveObjectWithFile:cachefullPath];
    
    return Json;
    
}

@end
