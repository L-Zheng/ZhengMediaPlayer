//
//  ZhengMultiUploadRequest.h
//  ZhengNetWork
//
//  Created by 李保征 on 2016/12/8.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengUploadRequest.h"

@interface ZhengMultiUploadRequest : ZhengUploadRequest

@property (nonatomic ,nonnull, strong) NSDictionary *parameters;

@property (nonatomic, nullable, copy) NSString *fileName;

@end
