//
//  ZhengParseTool.h
//  ZhengNetWork
//
//  Created by 李保征 on 2016/12/6.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhengParseTool : NSObject


/**   转换模型  返回数据模型
 如果是字典 返回单个模型   如果是数组 返回模型数组
 
 @param convertJsonData    转换的元数据  数组或者字典
 @param ClassName   获得Json转成的模型类
 */
+ (id)sourceData:(id)convertJsonData toModel:(Class)ClassName;

@end
