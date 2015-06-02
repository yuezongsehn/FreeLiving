//
//  FLViewControllerIntercepter.m
//  FreeLiving
//
//  Created by 岳宗申 on 15/5/30.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import "FLViewControllerIntercepter.h"
#import "Aspects.h"
#import <UIKit/UIKit.h>

@implementation FLViewControllerIntercepter
+ (void)load
{
    [super load];
    [FLViewControllerIntercepter sharedInstance];
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static FLViewControllerIntercepter *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FLViewControllerIntercepter alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        /* 在这里做好方法拦截 */
        [UIViewController aspect_hookSelector:@selector(loadView) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo){
            [self loadView:[aspectInfo instance]];
        } error:NULL];
        
//        [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated){
//            [self viewWillAppear:animated viewController:[aspectInfo instance]];
//        } error:NULL];
    }
    return self;
}
#pragma mark - fake methods
- (void)loadView:(UIViewController *)viewController
{
    viewController.view.backgroundColor = [UIColor whiteColor];

//    viewController.view.backgroundColor = [UIColor colorWithRed:0x4f/255.0 green:0xc5/255.0 blue:0x6e/255.0 alpha:1.0];
}

//- (void)viewWillAppear:(BOOL)animated viewController:(UIViewController *)viewController
//{
//    /* 你可以使用这个方法进行打日志，初始化基础业务相关的内容 */
//    NSLog(@"[%@ viewWillAppear:%@]", [viewController class], animated ? @"YES" : @"NO");
//}
@end
