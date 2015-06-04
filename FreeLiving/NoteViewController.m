//
//  NoteViewController.m
//  FreeLiving
//
//  Created by 洋景-Yue on 15/6/4.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import "NoteViewController.h"
#import "NoteScrollView.h"
#import "InScrollViewLayer.h"
#import "AddNewNoteViewController.h"
#import "NoteDetailViewController.h"
#import "UIView+Screenshot.h"

@interface NoteViewController ()<addDelegate,NoteScrollViewDelegate,NoteDetailViewControllerDelegate>

@property (nonatomic, strong) NoteScrollView *backScrollView;
@property (nonatomic, strong) InScrollViewLayer *inScrollViewLayer;
@property (nonatomic,strong) NoteDetailViewController *noteDetailViewController;
@property (nonatomic,strong) UINavigationController *subNav;
@end

@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addANote:)];
    self.navigationItem.rightBarButtonItem = addButton;
    [self.view addSubview:self.backScrollView];
}
#pragma mark -private method-
-(void)addANote:(id)sender{
    AddNewNoteViewController *addDetail = [[AddNewNoteViewController alloc] init];
    addDetail.delegateForAdd = self;
    [self.navigationController pushViewController:addDetail animated:YES];
}
#pragma mark -addDelegate-
-(void)refreshFlipView
{
    [self.backScrollView loadViewData];
}
#pragma mark -NoteScrollViewDelegate-
-(void)noteScrollView:(NoteScrollView *)noteScroll didSelectAtIndex:(NSInteger)index withLayer:(CALayer *)layer
{
    self.inScrollViewLayer = (InScrollViewLayer *)layer;
    self.noteDetailViewController.detailNoteModel = noteScroll.contentArray[index];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    //由于在scrollview中添加layer的时候我先后顺序，所以需要把所选中的layer放到最上面，否则在动画的时候，其他的layer在选中layer之上
    [self.navigationController.view.layer addSublayer:self.inScrollViewLayer];
    [CATransaction commit];
    
    //变化layer的大小，从小到大
    CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    boundsAnimation.fromValue = [NSValue valueWithCGRect:self.inScrollViewLayer.frame];
    boundsAnimation.toValue = [NSValue valueWithCGRect:self.navigationController.view.bounds];
    //变化layer的位置
    CABasicAnimation *positonAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positonAnimation.fromValue = [NSValue valueWithCGPoint:self.inScrollViewLayer.position];
    positonAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(self.navigationController.view.bounds), CGRectGetMidY(self.navigationController.view.bounds))];
    
    //组合动画
    CAAnimationGroup *group =[CAAnimationGroup animation];
    group.duration = 0.5;
    group.animations = [NSArray arrayWithObjects:boundsAnimation,positonAnimation, nil];
    group.delegate = self;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    
    [self.inScrollViewLayer addAnimation:group forKey:@"zoomIn"];
    
    //页面翻转
    CATransition *transition = [CATransition animation];
    transition.type =@"flip";// kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    transition.duration = 0.25;
    self.inScrollViewLayer.contents = (id)[self.subNav.view screenshot].CGImage;
    [self.inScrollViewLayer addAnimation:transition forKey:@"push"];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [self.inScrollViewLayer animationForKey:@"zoomIn"]) {
        //self.transitionLayer.hidden = YES;
      [self.navigationController presentViewController:self.subNav animated:NO completion:^{}];
    }
}
#pragma mark -NoteDetailViewControllerDelegate-

-(void)NoteDetailViewControllerClose:(NoteDetailViewController *)noteViewController
{
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    [self.inScrollViewLayer removeAllAnimations];
    self.inScrollViewLayer.frame = self.navigationController.view.bounds;
    [CATransaction commit];
    [self.backScrollView performSelector:@selector(resetSelection) withObject:nil afterDelay:0.0];
    self.inScrollViewLayer = nil;
    [self dismissViewControllerAnimated:NO completion:^{
        if (noteViewController.isDelete) {
            [self.backScrollView performSelector:@selector(loadViewData) withObject:nil afterDelay:1.0];
        }
    }];
}

#pragma mark -setter and getter-
- (NoteDetailViewController *)noteDetailViewController
{
    if (_noteDetailViewController == nil) {
        _noteDetailViewController = [[NoteDetailViewController alloc] init];
        _noteDetailViewController.delegateForDetail = self;
    }
    return _noteDetailViewController;
}
- (UINavigationController *)subNav
{
    if (_subNav == nil) {
       _subNav = [[UINavigationController alloc]initWithRootViewController:self.noteDetailViewController];
    }
    return _subNav;
}
- (NoteScrollView *)backScrollView
{
    if (_backScrollView == nil) {
        _backScrollView = [[NoteScrollView alloc] initWithFrame:self.view.frame];
        _backScrollView.delegateForNote = self;
    }
    return _backScrollView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.backScrollView = nil;
//    self.flipDetailViewController = nil;
//    self.inScrollViewLayer = nil;
//    self.subNav = nil;
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
