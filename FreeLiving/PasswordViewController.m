//
//  PasswordViewController.m
//  FreeLiving
//
//  Created by 岳宗申 on 15/6/2.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import "PasswordViewController.h"
#import "APRoundedButton.h"

#define kRandomLength 10
static const NSString *kRandomAlphabet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@interface PasswordViewController ()

@property (nonatomic, strong) UITextField *passwordField;
@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    int padding = 10;
    
    [self.view addSubview:self.passwordField];
    
    APRoundedButton *leftBtn1 = APRoundedButton.new;
    leftBtn1.style = 2;
    [leftBtn1 setTitle:@"6位数字密码" forState:UIControlStateNormal];
    [leftBtn1 setBackgroundColor:[UIColor colorWithRed:0x0e/255.0 green:0x0e/255.0 blue:0xff/255.0 alpha:1.0]];

    [self.view addSubview:leftBtn1];
    
    APRoundedButton *leftBtn2 = APRoundedButton.new;
    leftBtn2.style = 0;
    [leftBtn2 setTitle:@"随机密码" forState:UIControlStateNormal];
    [leftBtn2 setBackgroundColor:[UIColor colorWithRed:0x0e/255.0 green:0x70/255.0 blue:0x01/255.0 alpha:1.0]];
    [self.view addSubview:leftBtn2];
    
    APRoundedButton *rightBtn1 = APRoundedButton.new;
    rightBtn1.style = 3;
    [rightBtn1 setBackgroundColor:[UIColor colorWithRed:0xfb/255.0 green:0x00/255.0 blue:0xff/255.0 alpha:1.0]];

    [self.view addSubview:rightBtn1];

    APRoundedButton *rightBtn2 = APRoundedButton.new;
    rightBtn2.style = 1;
    [rightBtn2 setBackgroundColor:[UIColor colorWithRed:0xfd/255.0 green:0x6b/255.0 blue:0x06/255.0 alpha:1.0]];

    [self.view addSubview:rightBtn2];
    
    
}
#pragma mark -private method-
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
    char data[10];
    
    for (int x=0;x<10;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:10 encoding:NSUTF8StringEncoding];
}

//生成一个既有数字又有字母的字符串

- (void)randomAllString
{
    NSMutableString *randomString = [NSMutableString stringWithCapacity:kRandomLength];
    for (int i = 0; i < kRandomLength; i++) {
        [randomString appendFormat: @"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform((u_int32_t)[kRandomAlphabet length])]];
    }
}
#pragma mark -getters and setters-

- (UITextField *)passwordField
{
    if (_passwordField == nil) {
        _passwordField = UITextField.new;
        _passwordField.textAlignment = NSTextAlignmentCenter;
        _passwordField.backgroundColor = [UIColor colorWithRed:0xb4/255.0 green:0xf1/255.0 blue:0x41/255.0 alpha:0.4];
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
