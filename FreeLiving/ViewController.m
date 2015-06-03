//
//  ViewController.m
//  FreeLiving
//
//  Created by 岳宗申 on 15/5/29.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import "ViewController.h"
#import "AccountViewController.h"
#import "PasswordViewController.h"
#import "ConsumeViewController.h"

#define DELAYEXECUTE(delayTime,func) (dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{func;}))

@interface ViewController ()

@property (nonatomic, strong) NSArray *viewControllerS;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllerS = @[@"AccountViewController",@"PasswordViewController",@"ConsumeViewController",@"UIViewController"];
}

#pragma mark - LIVBubbleButtonDelegate -

-(void)livBubbleMenu:(LIVBubbleMenu *)bubbleMenu tappedBubbleWithIndex:(NSUInteger)index {

    UIViewController *viewController = [[NSClassFromString(self.viewControllerS[index]) alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)livBubbleMenuDidHide:(LIVBubbleMenu *)bubbleMenu {

    NSLog(@"LIVBubbleMenu has been hidden");
}
#pragma mark -viewDidAppear-

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IsLogin"]) {
        [self removeBubbleMenuView];
        [self.bubbleMenu show];
    }
}
#pragma mark -open methods-

- (void)removeBubbleMenuView
{
    if (_bubbleMenu) {
        [self.bubbleMenu removeFromSuperview];
        _bubbleMenu = nil;
    }
}
#pragma mark -private methods-

- (IBAction)popBtnAction:(id)sender {
    [self removeBubbleMenuView];
    [self.bubbleMenu show];
}

#pragma mark -getters and setters-
- (LIVBubbleMenu *)bubbleMenu
{
    if (_bubbleMenu == nil) {
        NSRange range;
        range.location = 0;
        range.length = 4;
        _bubbleMenu = [[LIVBubbleMenu alloc] initWithPoint:self.view.center radius:150 menuItems:[self.images subarrayWithRange:range] inView:self.view];
        _bubbleMenu.delegate = self;
        _bubbleMenu.easyButtons = NO;
        _bubbleMenu.bubbleStartAngle = 0.0f;
        _bubbleMenu.bubbleTotalAngle = 180.0f;
        _bubbleMenu.bubblePopInDuration = .35;
    }
    return _bubbleMenu;
}

- (NSArray *)images
{
    if (_images == nil) {
        _images = [NSArray arrayWithObjects:
                   [UIImage imageNamed:@"angry"],
                   [UIImage imageNamed:@"confused"],
                   [UIImage imageNamed:@"cool"],
                   [UIImage imageNamed:@"grin"],
                   [UIImage imageNamed:@"happy"],
                   [UIImage imageNamed:@"neutral"],
                   [UIImage imageNamed:@"sad"],
                   [UIImage imageNamed:@"shocked"],
                   [UIImage imageNamed:@"smile"],
                   [UIImage imageNamed:@"tongue"],
                   [UIImage imageNamed:@"wink"],
                   [UIImage imageNamed:@"wondering"],
                   nil];
    }
    return _images;
}
#pragma mark -no user method-

//- (void)moodButtonTapped {
//    _bubbleMenu = [[LIVBubbleMenu alloc] initWithPoint:self.view.center radius:150 menuItems:self.images inView:self.view];
//    _bubbleMenu.delegate = self;
//    _bubbleMenu.easyButtons = NO;
//    [_bubbleMenu show];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
