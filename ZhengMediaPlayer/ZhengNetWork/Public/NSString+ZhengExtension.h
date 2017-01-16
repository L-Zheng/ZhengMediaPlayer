//
//  NSString+ZhengExtension.h
//  ZhengNetWork
//
//  Created by 李保征 on 2016/12/9.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZhengExtension)

@end

@interface NSString (ZhengIsValue)

- (BOOL)isValue;

@end

@interface NSString (ZhengHash)

@property (nonatomic,copy,readonly) NSString *md5String;
@property (nonatomic,copy,readonly) NSString *sha1String;
@property (nonatomic,copy,readonly) NSString *sha256String;
@property (nonatomic,copy,readonly) NSString *sha512String;

- (NSString *)hmacSHA1StringWithKey:(NSString *)key;
- (NSString *)hmacSHA256StringWithKey:(NSString *)key;
- (NSString *)hmacSHA512StringWithKey:(NSString *)key;

@end
