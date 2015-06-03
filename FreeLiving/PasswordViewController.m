//
//  PasswordViewController.m
//  FreeLiving
//
//  Created by 岳宗申 on 15/6/2.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import "PasswordViewController.h"
#import "APRoundedButton.h"
#import "HudFactory.h"

static const NSString *kRandomAlphabet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@interface PasswordViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, assign) NSInteger digit;
@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.digit = 8;
    [self.view addSubview:self.passwordField];
    
    APRoundedButton *leftBtn1 = APRoundedButton.new;
    leftBtn1.style = 2;
    [leftBtn1 setTitle:@"6位数字密码" forState:UIControlStateNormal];
    [leftBtn1 setBackgroundColor:[UIColor colorWithRed:0x0e/255.0 green:0x0e/255.0 blue:0xff/255.0 alpha:1.0]];
    [leftBtn1 addTarget:self action:@selector(makePassworkString:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn1];
    leftBtn1.tag = 1;
    
    APRoundedButton *leftBtn2 = APRoundedButton.new;
    leftBtn2.style = 0;
    [leftBtn2 setTitle:@"密码6位" forState:UIControlStateNormal];
    [leftBtn2 setBackgroundColor:[UIColor colorWithRed:0x0e/255.0 green:0x70/255.0 blue:0x01/255.0 alpha:1.0]];
    [leftBtn2 addTarget:self action:@selector(makePassworkString:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn2];
    leftBtn2.tag = 2;
    
    APRoundedButton *rightBtn1 = APRoundedButton.new;
    rightBtn1.style = 3;
    [rightBtn1 setTitle:@"随机密码" forState:UIControlStateNormal];
    [rightBtn1 setBackgroundColor:[UIColor colorWithRed:0xfb/255.0 green:0x00/255.0 blue:0xff/255.0 alpha:1.0]];
    [rightBtn1 addTarget:self action:@selector(makePassworkString:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn1];
    rightBtn1.tag = 3;

    APRoundedButton *rightBtn2 = APRoundedButton.new;
    rightBtn2.style = 1;
    [rightBtn2 setTitle:@"copy" forState:UIControlStateNormal];
    [rightBtn2 setBackgroundColor:[UIColor colorWithRed:0xfd/255.0 green:0x6b/255.0 blue:0x06/255.0 alpha:1.0]];
    [rightBtn2 addTarget:self action:@selector(makePassworkString:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn2];
    rightBtn2.tag = 4;
    
    int padding = 2;
    int margin = 10;
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(80);
        make.bottom.equalTo(leftBtn1.mas_top).offset(-margin);
        make.left.equalTo(self.view).offset(margin);
        make.right.equalTo(self.view).offset(-margin);
        make.height.equalTo(@40);
    }];
    [leftBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordField.mas_bottom).offset(margin);
        make.left.equalTo(self.view.mas_left).offset(margin);
        make.bottom.equalTo(leftBtn2.mas_top).offset(-padding);
        make.right.equalTo(rightBtn1.mas_left).offset(-padding);
        make.width.equalTo(rightBtn1.mas_width);

        make.height.equalTo(@40);
    }];
    [rightBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordField.mas_bottom).with.offset(margin);
        make.left.equalTo(leftBtn1.mas_right).offset(padding);
        make.bottom.equalTo(rightBtn2.mas_top).offset(-padding);
        make.right.equalTo(self.view.mas_right).offset(-margin);
        make.width.equalTo(leftBtn1.mas_width);
        make.height.equalTo(@40);
    }];
    [leftBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftBtn1.mas_bottom).offset(padding);
        make.left.equalTo(self.view.mas_left).offset(margin);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-padding);
        make.right.equalTo(rightBtn2.mas_left).offset(-padding);
        make.width.equalTo(rightBtn2.mas_width);
        make.height.equalTo(@40);
    }];
    [rightBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightBtn1.mas_bottom).offset(padding);
        make.left.equalTo(leftBtn2.mas_right).offset(padding);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-padding);
        make.right.equalTo(self.view.mas_right).offset(-margin);
        make.width.equalTo(leftBtn2.mas_width);
        make.height.equalTo(@40);
    }];
}
#pragma mark -private method-
- (void)makePassworkString:(APRoundedButton *)sender
{
    switch (sender.tag) {
        case 1:
        {
            [self.passwordField setText:[self randomPassword]];
            break;
        }
        case 2:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入你想生成的密码位数" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertView show];
            break;
        }
        case 3:
        {
            [self.passwordField setText:[self randomAllString]];
            break;
        }
        case 4:
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.passwordField.text;
            [HudFactory addTextHudToView:self.view withMessage:@"已复制到粘贴板" afterDelay:1.0];
            break;
        }
        default:
            break;
    }
}
-(NSString *)randomPassword{
    //自动生成8位随机密码
    NSTimeInterval random=[NSDate timeIntervalSinceReferenceDate];
    NSString *randomString = [NSString stringWithFormat:@"%.6f",random];
    NSString *randompassword = [[randomString componentsSeparatedByString:@"."]objectAtIndex:1];
    return randompassword;
}
//随机生成一个字符串
- (NSString *)randomString
{
    char data[self.digit];
    
    for (int x=0;x<self.digit;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:self.digit encoding:NSUTF8StringEncoding];
}

//生成一个既有数字又有字母的字符串

- (NSString *)randomAllString
{
    NSMutableString *randomString = [NSMutableString stringWithCapacity:self.digit];
    for (int i = 0; i < self.digit; i++) {
        [randomString appendFormat: @"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform((u_int32_t)[kRandomAlphabet length])]];
    }
    return randomString;
}
#pragma mark -UIAlertViewDelegate-
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.digit = [[alertView textFieldAtIndex:0].text integerValue];
    }
}
#pragma mark -getters and setters-

- (UITextField *)passwordField
{
    if (_passwordField == nil) {
        _passwordField = UITextField.new;
        _passwordField.textAlignment = NSTextAlignmentCenter;
        _passwordField.backgroundColor = [UIColor colorWithRed:0xb4/255.0 green:0xf1/255.0 blue:0x41/255.0 alpha:0.4];
        _passwordField.placeholder = @"点击下面按钮生成密码";
    }
    return _passwordField;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
