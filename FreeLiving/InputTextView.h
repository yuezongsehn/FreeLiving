//
//  InputTextView.h
//  FreeLiving
//
//  Created by 洋景-Yue on 15/6/2.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountModel.h"

@interface InputTextView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UIView *inputBgView;
@property (nonatomic, strong) UITextField *nameText;
@property (nonatomic, strong) UILabel *nameTextName;
@property (nonatomic, strong) UITextField *accountText;
@property (nonatomic, strong) UILabel *accountTextName;
@property (nonatomic, strong) UITextField *passwordText;
@property (nonatomic, strong) UILabel *passwordTextName;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIButton *starBtn;
@property (nonatomic, assign) BOOL chang;
@property (nonatomic, copy) void(^removeInputViewAcion)(void);
@property (nonatomic, copy) void(^addAccountModelAction)(AccountModel *);

- (void)createInputView;
@end
