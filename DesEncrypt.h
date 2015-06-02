//
//  DesEncrypt.h
//  YPassword
//
//  Created by 洋景-Yue on 15/1/5.
//  Copyright (c) 2015年 洋景-Yue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesEncrypt : NSObject

+ (NSString *)base64StringFromText:(NSString *)text;
+ (NSString *)textFromBase64String:(NSString *)base64;
@end
