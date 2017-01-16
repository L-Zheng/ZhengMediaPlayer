//
//  ZhengParameterFieldConst.h
//  AFN封装使用
//
//  Created by 李保征 on 16/8/12.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DefaultRequestPage 1
#define DefaultRequestLimit 30

//限制数据库文件大小 50M
#define SqliteFileLimtSize (50 * 1024 * 1024)

//请求参数中的page字段
extern NSString * const ParameterPageFiled;
//请求参数中的limit字段
extern NSString * const ParameterLimitFiled;

//请求获得列表数据中  每一条数据的id  key值
extern NSString * const EachInfoID;


