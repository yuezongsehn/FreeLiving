//
//  AddNewNoteViewController.m
//  FreeLiving
//
//  Created by 洋景-Yue on 15/6/4.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import "AddNewNoteViewController.h"
#import "DBManager.h"
#import "HudFactory.h"

#define TEXTPLACEHOLDER @"在这里输入记事本内容"

@interface AddNewNoteViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *dateLabel;
@end

@implementation AddNewNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增笔记";
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveNote)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"notepad.png"]];
    imageView.userInteractionEnabled = YES;
    imageView.frame =  CGRectMake(10, 70, 300, 350);
    imageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imageView];
    
    [imageView addSubview:self.textView];
    [imageView addSubview:self.dateLabel];
    
}
#pragma mark -private method-
-(void)saveNote{
    [self.textView resignFirstResponder];
    
    NoteModel *aModel = [[NoteModel alloc] init];
    aModel.noteText = self.textView.text;
    aModel.noteTime = self.dateLabel.text;
    if ([DBManager saveNoteModel:aModel]) {
     [HudFactory addTextHudToView:self.view withMessage:@"保存成功" afterDelay:1.5];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"保存失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}
#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)atextView
{
    if ([atextView.text isEqualToString:TEXTPLACEHOLDER]) {
        atextView.text = nil;
    }
}
#pragma mark -private method-
- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(35, 60, 200, 180)];
        _textView.delegate = self;
        _textView.font = [UIFont fontWithName:@"KaiTi_GB2312" size:21];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.layer.masksToBounds = YES;
        _textView.text = TEXTPLACEHOLDER;
    }
    return _textView;
}
- (UILabel *)dateLabel
{
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 285, 150, 30)];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.font = [UIFont fontWithName:@"AmericanTypewriter-CondensedLight" size:17];//MarkerFelt-Thin
        _dateLabel.transform = CGAffineTransformMakeRotation(M_PI_2/20);
        NSDate * newDate = [NSDate date];
        NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
        [dateformat setDateFormat:@"yyyy-MM-dd HH:mm"];

        NSString * newDateOne = [dateformat stringFromDate:newDate];
        [dateformat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        _dateLabel.text = newDateOne;
    }
    return _dateLabel;
}
#pragma mark -viewDidDisappear-
- (void)viewDidDisappear:(BOOL)animated
{
    if (self.delegateForAdd && [self.delegateForAdd respondsToSelector:@selector(refreshFlipView)]) {
        [self.delegateForAdd refreshFlipView];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textView resignFirstResponder];
    if (_textView.text.length <=0) {
        _textView.text = @"在这里输入记事本内容";
    }
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
