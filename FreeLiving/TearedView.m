//
//  TearedView.m
//  FreeLiving
//
//  Created by 岳宗申 on 15/5/30.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import "TearedView.h"
#import "UIImage+SplitImageIntoTwoParts.h"
#import "Masonry.h"
#import "AuthenticateObjec.h"

@implementation TearedView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.top.bottom.equalTo(self);
        }];
    }
    return self;
}
#pragma mark - UIAlertViewDelegate-
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if ([alertView textFieldAtIndex:0].text.length==0) {
        return NO;
    }
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex]) {
        [self showAuthenticateAlert];
        return;
    }
    if (buttonIndex == [alertView firstOtherButtonIndex]) {
        if ([[alertView textFieldAtIndex:0].text isEqualToString:@"xiangyecunfu"]) {
            [self removeTearImageV];
        }
        else
        {
            [self showPasswordAlert];
        }
    }
}
#pragma mark -private methods-
- (void)showAuthenticateAlert
{
    [AuthenticateObjec showAuthenticateUserAlertViewSuccess:^{
        [self removeTearImageV];
        
    } Failure:^(NSError *error) {
        if (error == nil) {
            [self showPasswordAlert];
        }
        else
        {
            //TODO:提示框
            //            NSString *str = [NSString stringWithFormat:@"%@",error.localizedDescription];
        }
    }];
}
- (void)showPasswordAlert
{
    UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:@"YPassword" message:@"Please input your password" delegate:self cancelButtonTitle:@"返回Touch ID" otherButtonTitles:@"Okay", nil];
    passwordAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [passwordAlert show];
}
- (void)removeTearImageV
{
    NSArray *imageArr = [UIImage splitImageIntoTwoParts:self.imageView.image];
    UIImageView *leftImageV = [[UIImageView alloc] initWithImage:[imageArr objectAtIndex:0]];
    [self addSubview:leftImageV];
    UIImageView *rightImageV = [[UIImageView alloc] initWithImage:[imageArr objectAtIndex:1]];
    [self addSubview:rightImageV];
    [self.imageView setHidden:YES];
    [leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.bottom.equalTo(self);
        make.height.equalTo(self);
        make.right.equalTo(rightImageV).offset(-30);
    }];
    
    [rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.top.bottom.equalTo(self);
        make.height.equalTo(self);
        make.left.equalTo(leftImageV).offset(30);
    }];
    
    [UIView animateWithDuration:1.0 animations:^{
        leftImageV.alpha = 0;
        rightImageV.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.showPopItem) {
            self.showPopItem();
        }
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.imageView removeFromSuperview];
        self.imageView = nil;
        [self removeFromSuperview];
    }];

}

#pragma mark -getters and setters
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = UIImageView.new;
    }
    return _imageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
