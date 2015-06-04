//
//  NoteDetailViewController.m
//  FreeLiving
//
//  Created by 洋景-Yue on 15/6/4.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import "NoteDetailViewController.h"
#import "DBManager.h"
#import "HudFactory.h"

@interface NoteDetailViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *dateLabel;
@end

@implementation NoteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item =
    [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
    self.navigationItem.leftBarButtonItem = item;

    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteItem:)];
    self.navigationItem.rightBarButtonItem = deleteButton;
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"notepad.png"]];
    imageView.userInteractionEnabled = YES;
    imageView.frame =  CGRectMake(10, 70, 300, 350);
    imageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imageView];
    
    [imageView addSubview:self.textView];
    [imageView addSubview:self.dateLabel];
}
#pragma mark -private method-
-(void)close:(id)sender{
    if ([self.delegateForDetail respondsToSelector:@selector(NoteDetailViewControllerClose:)]) {
        [self.delegateForDetail NoteDetailViewControllerClose:self];
    }
}
-(void)deleteItem:(id)sender{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定要删除么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    if (buttonIndex == [alertView firstOtherButtonIndex]) {
        if ([DBManager deleteNoteModel:self.detailNoteModel.noteId]) {
            self.isDelete = YES;
            [self performSelector:@selector(delegateDelayAction) withObject:nil afterDelay:1.0];
                   }
        else
        {
            [HudFactory addTextHudToView:self.view withMessage:@"删除失败" afterDelay:1.5];
        }
    }
}
- (void)delegateDelayAction
{
    if ([self.delegateForDetail respondsToSelector:@selector(NoteDetailViewControllerClose:)]) {
        [self.delegateForDetail NoteDetailViewControllerClose:self];
    }
}
#pragma mark -UITextViewDelegate-
- (void)textViewDidBeginEditing:(UITextView *)atextView
{
    if ([atextView.text isEqualToString:@"在这里输入记事本内容"]) {
        atextView.text = nil;
    }
}
- (void)textViewDidEndEditing:(UITextView *)atextView
{
    self.detailNoteModel.noteText = atextView.text;
    if (![DBManager updateNoteModel:self.detailNoteModel]) {
        [HudFactory addTextHudToView:self.view withMessage:@"内容保存失败" afterDelay:1.5];
    }
}
#pragma mark -setter and getter-
- (void)setDetailNoteModel:(NoteModel *)detailNoteModel
{
    self.isDelete = NO;
    if (_detailNoteModel == detailNoteModel) {
        return;
    }
    _detailNoteModel = detailNoteModel;
    [self.textView setText:_detailNoteModel.noteText];
    [self.dateLabel setText:_detailNoteModel.noteTime];
}
- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(35, 60, 200, 180)];
        _textView.delegate = self;
        _textView.tag = 500;
        _textView.font = [UIFont fontWithName:@"KaiTi_GB2312" size:21];
        _textView.backgroundColor = [UIColor clearColor];
        
    }
    return _textView;
}
- (UILabel *)dateLabel
{
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 285, 150, 30)];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.font = [UIFont fontWithName:@"AmericanTypewriter-CondensedLight" size:17];
        _dateLabel.transform = CGAffineTransformMakeRotation(M_PI_2/20);
    }
    return _dateLabel;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textView resignFirstResponder];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.delegateForDetail = nil;
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
