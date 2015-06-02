//
//  HudFactory.m
//  FreeLiving
//
//  Created by 洋景-Yue on 15/6/2.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import "HudFactory.h"

@implementation HudFactory

+ (void)addTextHudToView:(UIView *)view withMessage:(NSString *)message afterDelay:(NSTimeInterval)delay {
    
    [MBProgressHUD hideHUDForView:view animated:YES];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.labelFont = [UIFont systemFontOfSize:14];
    hud.labelText = message;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [hud hide:YES afterDelay:delay];
}
@end
