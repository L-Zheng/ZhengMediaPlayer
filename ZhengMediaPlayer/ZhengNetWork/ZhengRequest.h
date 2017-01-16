//
//  ZhengRequest.h
//  ZhengNetWork
//
//  Created by 李保征 on 2016/11/25.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengBaseRequest.h"
#import "AFNetworking.h"

typedef NS_ENUM(NSInteger, RequestStatus) {
    RequestStatus_Unused      = 0, //空闲状态
    RequestStatus_Running     = 1, //
    RequestStatus_Success     = 2, //
    RequestStatus_Cache       = 3, //
    RequestStatus_Fail        = 4, //
    RequestStatus_Stopped     = 5, //
} NS_ENUM_AVAILABLE_IOS(6_0);

typedef NS_ENUM(NSInteger, RequestType) {
    RequestType_Get      = 0,
    RequestType_Post     = 1,
} NS_ENUM_AVAILABLE_IOS(6_0);

typedef NS_ENUM(NSInteger, CacheMethod) {
    CacheMethod_NoCache     = 0,
    CacheMethod_Coding      = 1,
    CacheMethod_SQLite      = 2,
} NS_ENUM_AVAILABLE_IOS(6_0);

@interface ZhengRequest : ZhengBaseRequest

#pragma mark - 请求参数

//必传
@property (nonatomic,strong) NSDictionary *parameters;

//可传
@property (nonatomic,strong) Class className;//需要转模型的类

@property (nonatomic,strong) NSDictionary *header; //默认nil

@property (nonatomic,strong) NSNumber *timeOut; //默认10s

@property (nonatomic,assign) RequestType requestType;//默认get

@property (nonatomic,assign) NSTimeInterval expiredTime;//缓存过期时间 默认30天

/** 普通请求只支持Coding存储 */
@property (nonatomic,assign) CacheMethod cacheMethod;//默认NoCache

/** 分页请求并且要求缓存时  必传 */
@property (nonatomic,copy) NSString *needJsonField;//需要的字段

#pragma mark - 请求管理者

@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;

#pragma mark - public

@property (nonatomic,assign) RequestStatus requestStatus;

- (void)stopRequest;

@end
