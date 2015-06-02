//
//  HudFactory.h
//  FreeLiving
//
//  Created by 洋景-Yue on 15/6/2.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface HudFactory : NSObject

+ (void)addTextHudToView:(UIView *)view withMessage:(NSString *)message afterDelay:(NSTimeInterval)delay;
@end
