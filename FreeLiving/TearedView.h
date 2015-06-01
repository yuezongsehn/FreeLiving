//
//  TearedView.h
//  FreeLiving
//
//  Created by 岳宗申 on 15/5/30.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TearedView : UIView<UIAlertViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) void (^showPopItem)(void);

- (void)showAuthenticateAlert;
@end
