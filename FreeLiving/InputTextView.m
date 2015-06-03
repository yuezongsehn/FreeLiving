//
//  InputTextView.m
//  FreeLiving
//
//  Created by 洋景-Yue on 15/6/2.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import "InputTextView.h"
#import "InputText.h"
#import "DesEncrypt.h"
#import "AccountModel.h"
#import "ConsumeModel.h"

@implementation InputTextView

- (instancetype)initWithFrame:(CGRect)frame inputStyle:(NSInteger)style
{
    self = [super initWithFrame:frame];
    if (self) {
        self.inputStyle = style;
    }
    return self;
}

- (void)createInputView
{
    [self addSubview:self.inputBgView];
    [self inputBgViewAnimation];
}

- (void)inputBgViewAnimation
{
    CGRect rect = self.inputBgView.frame;
    if (CGRectGetMinY(rect)<0)
    {
        [self.nameText becomeFirstResponder];
        rect.origin.y += (CGRectGetHeight(rect)+74);
    }
    else
    {
        rect.origin.y = -CGRectGetHeight(rect);
        [self.inputBgView endEditing:YES];
        [self restoreTextName:self.nameTextName textField:self.nameText];
        [self restoreTextName:self.accountTextName textField:self.accountText];
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
    }
    [UIView animateWithDuration:.35 animations:^{
        self.inputBgView.frame = rect;
    } completion:^(BOOL finished) {
        if (CGRectGetMinY(rect)<0) {
            [self.inputBgView removeFromSuperview];
            self.inputBgView = nil;
            [UIView animateWithDuration:.35 animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                if (self.removeInputViewAcion) {
                    self.removeInputViewAcion();
                }
                [self removeFromSuperview];
            }];
        }
    }];
}
- (void)setupInputRectangle
{
    [self.inputBgView addSubview:self.nameText];
    [self.inputBgView addSubview:self.nameTextName];
    [self.inputBgView addSubview:self.accountText];
    [self.inputBgView addSubview:self.accountTextName];
    [self.inputBgView addSubview:self.passwordText];
    [self.inputBgView addSubview:self.passwordTextName];
    [self.inputBgView addSubview:self.saveBtn];
    [self.inputBgView addSubview:self.starBtn];
    
    if (self.inputStyle) {
        [self.passwordText removeFromSuperview];
        self.passwordText = nil;
        [self.passwordTextName removeFromSuperview];
        self.passwordTextName = nil;
        self.nameTextName.text = @"描述";
        self.accountTextName.text = @"金额";
        
        self.accountText.keyboardType = UIKeyboardTypeNumberPad;
    }
}

- (UILabel *)setupTextName:(NSString *)textName frame:(CGRect)frame
{
    UILabel *textNameLabel = [[UILabel alloc] init];
    textNameLabel.text = textName;
    textNameLabel.font = [UIFont systemFontOfSize:16];
    textNameLabel.textColor = [UIColor grayColor];
    textNameLabel.frame = frame;
    return textNameLabel;
}
#pragma mark -getter and setter -
- (UIView *)inputBgView
{
    if (_inputBgView == nil) {
        _inputBgView = [[UIView alloc] initWithFrame:CGRectMake(10, 100-CGRectGetWidth(self.frame), CGRectGetWidth(self.frame)-20, CGRectGetWidth(self.frame)-100)];
        _inputBgView.backgroundColor = [UIColor whiteColor];
        _inputBgView.layer.cornerRadius = 4;
        _inputBgView.layer.masksToBounds = YES;
        [self setupInputRectangle];
    }
    return _inputBgView;
}
- (UITextField *)nameText
{
    if (_nameText == nil) {
        CGFloat centerX = CGRectGetWidth(self.frame) * 0.5;
        CGFloat userY = 20;
        _nameText = [InputText setupWithIcon:nil textY:userY centerX:centerX point:nil];
        _nameText.delegate = self;
        [_nameText setReturnKeyType:UIReturnKeyNext];
        [_nameText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    }
    return _nameText;
}
- (UILabel *)nameTextName
{
    if (_nameTextName == nil) {
        _nameTextName = [self setupTextName:@"名称" frame:_nameText.frame];
    }
    return _nameTextName;
}
- (UITextField *)accountText
{
    if (_accountText == nil) {
        _accountText = [InputText setupWithIcon:nil textY:CGRectGetMaxY(_nameText.frame) + 30 centerX:CGRectGetWidth(self.frame) * 0.5 point:nil];
        _accountText.keyboardType = UIKeyboardTypeEmailAddress;
        [_accountText setReturnKeyType:UIReturnKeyNext];
        _accountText.delegate = self;
        [_accountText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    }
    return _accountText;
}
- (UILabel *)accountTextName
{
    if (_accountTextName == nil) {
     _accountTextName = [self setupTextName:@"账号" frame:_accountText.frame];
    }
    return _accountTextName;
}
- (UITextField *)passwordText
{
    if (_passwordText == nil) {
        _passwordText = [InputText setupWithIcon:nil textY:CGRectGetMaxY(_accountText.frame) + 30 centerX:CGRectGetWidth(self.frame) * 0.5 point:nil];
        [_passwordText setReturnKeyType:UIReturnKeyDone];
        [_passwordText setSecureTextEntry:YES];
        _passwordText.delegate = self;
        [_passwordText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordText;
}
- (UILabel *)passwordTextName
{
    if (_passwordTextName == nil) {
       _passwordTextName = [self setupTextName:@"密码" frame:_passwordText.frame];
    }
    return _passwordTextName;
}
- (UIButton *)saveBtn
{
    if (_saveBtn == nil) {
        _saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        [_saveBtn setCenter:CGPointMake(CGRectGetWidth(self.frame)/2,CGRectGetMaxY(_passwordText.frame) + 30)];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn setBackgroundColor:[UIColor lightGrayColor]];
        _saveBtn.enabled = NO;
        [_saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}
- (UIButton *)starBtn
{
    if (_starBtn == nil) {
        _starBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        _starBtn.center = CGPointMake(26, CGRectGetMidY(_saveBtn.frame));
        [_starBtn setImage:[UIImage imageNamed:@"star_gray"] forState:UIControlStateNormal];
        [_starBtn setImage:[UIImage imageNamed:@"star_orange"] forState:UIControlStateSelected];
        [_starBtn addTarget:self action:@selector(starBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _starBtn;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.nameText) {
        [self diminishTextName:self.nameTextName];
        [self restoreTextName:self.accountTextName textField:self.accountText];
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
    } else if (textField == self.accountText) {
        [self diminishTextName:self.accountTextName];
        [self restoreTextName:self.nameTextName textField:self.nameText];
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
    } else if (textField == self.passwordText) {
        [self diminishTextName:self.passwordTextName];
        [self restoreTextName:self.nameTextName textField:self.nameText];
        [self restoreTextName:self.accountTextName textField:self.accountText];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameText) {
        return [self.accountText becomeFirstResponder];
    } else if (textField == self.accountText){
        return [self.passwordText becomeFirstResponder];
    } else {
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
        return [self.passwordText resignFirstResponder];
    }
}
- (void)diminishTextName:(UILabel *)label
{
    [UIView animateWithDuration:0.5 animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, -16);
        label.font = [UIFont systemFontOfSize:9];
    }];
}
- (void)restoreTextName:(UILabel *)label textField:(UITextField *)textFieled
{
    [self textFieldTextChange:textFieled];
    if (self.chang) {
        [UIView animateWithDuration:0.5 animations:^{
            label.transform = CGAffineTransformIdentity;
            label.font = [UIFont systemFontOfSize:16];
        }];
    }
}
- (void)textFieldTextChange:(UITextField *)textField
{
    if (textField.text.length != 0) {
        self.chang = NO;
    } else {
        self.chang = YES;
    }
}
- (void)textFieldDidChange
{
    if (self.inputStyle) {
        if (self.nameText.text.length != 0 && self.accountText.text.length != 0) {
            [self.saveBtn setBackgroundColor:[UIColor orangeColor]];
            self.saveBtn.enabled = YES;
        } else {
            [self.saveBtn setBackgroundColor:[UIColor lightGrayColor]];
            self.saveBtn.enabled = NO;
        }
    }
    else
    {
        if (self.nameText.text.length != 0 && self.accountText.text.length != 0 && self.passwordText.text.length != 0) {
            [self.saveBtn setBackgroundColor:[UIColor orangeColor]];
            self.saveBtn.enabled = YES;
        } else {
            [self.saveBtn setBackgroundColor:[UIColor lightGrayColor]];
            self.saveBtn.enabled = NO;
        }
    }
}
#pragma mark - touchesBegan -
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(self.inputBgView.frame, point))
    {
        return;
    }
    [self inputBgViewAnimation];
}
#pragma mark -private methods-
- (void)starBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
}
- (void)saveBtnClick
{
    [self inputBgViewAnimation];
    if (self.inputStyle) {
        ConsumeModel *aModel = [[ConsumeModel alloc] init];
        aModel.consumeDes = self.nameText.text;
        if (self.inputStyle == 2) {
            aModel.consumeAmount = [NSString stringWithFormat:@"-%@",self.accountText.text];
        }
        else
        aModel.consumeAmount = self.accountText.text;
        aModel.consumeTime = [self getCurrentTime];
        if (_starBtn.selected) {
            aModel.isImportant = @"1";
        }
        else
            aModel.isImportant = @"0";
        if (self.addAccountModelAction) {
            self.addAccountModelAction(aModel);
        }
    }
    else
    {
        AccountModel *aModel = [[AccountModel alloc] init];
        aModel.accountString = self.nameText.text;
        aModel.accountName = self.accountText.text;
        aModel.accountPassword  = [DesEncrypt base64StringFromText:self.passwordText.text];
        aModel.createTime = [self getCurrentTime];
        if (_starBtn.selected) {
            aModel.isImportant = @"1";
        }
        else
            aModel.isImportant = @"0";
        if (self.addAccountModelAction) {
            self.addAccountModelAction(aModel);
        }
    }
}
- (NSString *)getCurrentTime
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:[NSDate date]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
