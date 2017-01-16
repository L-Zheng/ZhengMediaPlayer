//
//  ZhengCacheSQLite.m
//  ZhengNetWork
//
//  Created by 李保征 on 2016/12/7.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengCacheSQLite.h"
#import "ZhengParameterFieldConst.h"
#import "ZhengCacheDirectory.h"
#import "FMDB.h"

//数据库字段（不要改）
#define SQTableName @"t_myTable"
#define SQDicID @"dict_ID"
#define SQDicFiledName @"my_respose_dict"

@interface ZhengCacheSQLite ()

@property (nonatomic, strong) FMDatabase *myDataBase;

@end

@implementation ZhengCacheSQLite

- (BOOL)cachePageJson:(NSArray *)cacheArray zhengPageRequest:(ZhengPageRequest *)zhengPageRequest{
    
    NSString *urlStr = zhengPageRequest.urlStr;
    CacheMethod cacheMethod = zhengPageRequest.cacheMethod;
    
    //缓存完整路径
    NSString *cachefullPath = [ZhengCacheDirectory cacheFullPathWithDirectory:urlStr cacheMethod:cacheMethod];
    
    //检查文件是否超出限制大小
    if ([ZhengCacheDirectory fileIsExistsAtPath:cachefullPath]) {
        long long fileSize = [ZhengCacheDirectory readFileSize:cachefullPath];
        if (fileSize > SqliteFileLimtSize) {
            [ZhengCacheDirectory deleteFileAtPath:cachefullPath];
        }
    }
    
    self.myDataBase = [FMDatabase databaseWithPath:cachefullPath];
    
    if ([self.myDataBase open]) {   //数据库打开成功
        
        // 创表  字段   id  dict_ID  my_respose_dict
        NSString *creatTableStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT,%@ text NOT NULL,%@ blob NOT NULL);",SQTableName,SQDicID,SQDicFiledName];
        BOOL result = [self.myDataBase executeUpdate:creatTableStr];
        
        if (result) {      //创表成功
            for (NSDictionary *dic in cacheArray) {
                //取出字典唯一ID
                NSString *dicID = [NSString stringWithFormat:@"%@",dic[EachInfoID]];
                // 把cacheDic字典对象序列化成NSData二进制数据  存储数据库
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
                
                //插入数据之前先查询数据库有没有该条信息
                FMResultSet *resultSet = nil;
                NSString *selectStr = [NSString stringWithFormat:@"SELECT * FROM %@ where %@ = %@;",SQTableName,SQDicID,dicID];
                resultSet = [self.myDataBase executeQuery:selectStr];
                
                if (resultSet.next == NO) {  //插入数据
                    
                    [self.myDataBase executeUpdate:@"INSERT INTO t_myTable (my_respose_dict,dict_ID) VALUES (?, ?);", data,dicID];
                    
                }else{  //更新数据
                    [self.myDataBase executeUpdate:@"UPDATE t_myTable set my_respose_dict = ? where dict_ID = ?;", data,dicID];
                }
            }
            return [self.myDataBase close];
        } else {  //创表失败
            return NO;
        }
    }else{   //数据库打开失败
        return NO;
    }
}

- (NSArray *)readPageJson:(ZhengPageRequest *)zhengPageRequest{
    
    NSString *urlStr = zhengPageRequest.urlStr;
    CacheMethod cacheMethod = zhengPageRequest.cacheMethod;
    
    //缓存完整路径
    NSString *cachefullPath = [ZhengCacheDirectory cacheFullPathWithDirectory:urlStr cacheMethod:cacheMethod];
    
    //不存在文件直接返回空
    if (![ZhengCacheDirectory fileIsExistsAtPath:cachefullPath]){
        return nil;
    }
    //缓存过期
    if ([ZhengCacheDirectory fileIsExpiredAtPath:cachefullPath expiredTime:zhengPageRequest.expiredTime]) {
        return nil;
    }
    
    //设置页码 限制条数
    NSInteger page = zhengPageRequest.page;
    NSInteger limit = zhengPageRequest.limit.integerValue;
    
    self.myDataBase = [FMDatabase databaseWithPath:cachefullPath];
    
    if ([self.myDataBase open]) {
        //查询数据
        NSMutableArray *statuses = [NSMutableArray array];
        // 根据请求参数查询数据
        FMResultSet *resultSet = nil;
        NSString *selectStr = [NSString stringWithFormat:@"SELECT * FROM %@ order by %@ desc limit %ld, %ld;",SQTableName,SQDicID,limit * (page - 1),limit];
        resultSet = [self.myDataBase executeQuery:selectStr];
        
        // 遍历查询结果
        while (resultSet.next) {
            NSData *dictData = [resultSet objectForColumnName:SQDicFiledName];
            NSDictionary *getDict = [NSKeyedUnarchiver unarchiveObjectWithData:dictData];
            [statuses addObject:getDict];
        }
        if (statuses == nil || statuses.count == 0) {
            return nil;
        }else{
            return statuses;
        }
    }
    return nil;
}

// 单例
static id _instance;
+ (instancetype)shareCacheSQLite{
    if (_instance == nil) {
        _instance = [[self alloc] init];
    }
    return _instance;
}

- (void)dealloc{
    
}

@end
