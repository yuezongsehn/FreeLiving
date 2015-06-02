//
//  AccountDetailViewController.m
//  FreeLiving
//
//  Created by 洋景-Yue on 15/6/2.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import "AccountDetailViewController.h"
#import "DBManager.h"
#import "HudFactory.h"
#import "DesEncrypt.h"

@interface AccountDetailViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *passwordField;
@end

@implementation AccountDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveNewPassword)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}
#pragma mark -private methods-
- (void)saveNewPassword
{
//    if (self.saveAction) {
//        [self.passwordTextField resignFirstResponder];
//        self.saveAction(@{@"title":self.detailItem[@"title"],@"password":[DesEncrypt base64StringFromText:self.passwordTextField.text]});
//    }
    _detailModel.accountPassword = self.passwordField.text;
    if ([DBManager updateAccountModel:_detailModel]) {
        [HudFactory addTextHudToView:self.view withMessage:@"修改成功" afterDelay:1.0];
    }
}

#pragma mark -getters and setters-
- (void)setDetailModel:(AccountModel *)detailModel
{
    if (detailModel == _detailModel) {
        return;
    }
    _detailModel = detailModel;
    self.title = _detailModel.accountString;
    
    UILabel *accountLabel = UILabel.new;
    accountLabel.backgroundColor = [UIColor colorWithRed:0xb4/255.0 green:0xf1/255.0 blue:0x41/255.0 alpha:0.4];
    accountLabel.textAlignment = NSTextAlignmentCenter;
    accountLabel.layer.cornerRadius = 4;
    accountLabel.layer.masksToBounds = YES;
    accountLabel.text = _detailModel.accountName;
    [self.view addSubview:accountLabel];
    
    [self.passwordField setText: [DesEncrypt textFromBase64String:_detailModel.accountPassword]];
    [self.view addSubview:self.passwordField];
    int padding = 60;
    int leftPadding = 20;
    [accountLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view.mas_top).offset(100);
        make.left.equalTo(self.view.mas_left).offset(leftPadding);
        make.bottom.equalTo(self.passwordField.mas_top).offset(-padding);
        make.right.equalTo(self.view.mas_right).offset(-leftPadding);
        make.height.equalTo(@40);
    }];

    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountLabel.mas_bottom).offset(padding);
        make.left.equalTo(self.view.mas_left).offset(leftPadding);
        make.bottom.lessThanOrEqualTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right).offset(-leftPadding);
        make.height.equalTo(@40);
    }];
}
- (UITextField *)passwordField
{
    if (_passwordField == nil) {
        _passwordField = UITextField.new;
        _passwordField.delegate = self;
        _passwordField.textAlignment = NSTextAlignmentCenter;
        _passwordField.backgroundColor = [UIColor colorWithRed:0xb4/255.0 green:0xf1/255.0 blue:0x41/255.0 alpha:0.4];
    }
    return _passwordField;
}
#pragma mark -UITextFieldDelegate-

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!self.navigationItem.rightBarButtonItem.enabled) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }    return YES;
}

#pragma mark -UITextViewDelegate-
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (!self.navigationItem.rightBarButtonItem.enabled) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }    return YES;
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
