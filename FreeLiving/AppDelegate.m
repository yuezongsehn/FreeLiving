//
//  AppDelegate.m
//  FreeLiving
//
//  Created by 岳宗申 on 15/5/29.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import "AppDelegate.h"
#import "TearedView.h"
#import "RandomObject.h"
#import "Masonry.h"
#import "ViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) TearedView *maskView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [self showMaskView];
    [self.maskView showAuthenticateAlert];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
//    NSLog(@"%s",__func__);
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
        NSLog(@"%s",__func__);
    [self showMaskView];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
//        NSLog(@"%seeeee",__func__);
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IsLogin"]) {
        [self.maskView showAuthenticateAlert];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IsLogin"];
        UINavigationController *na = (UINavigationController *)self.window.rootViewController;
        ViewController *viewC = (ViewController *)na.viewControllers[0];
        [viewC removeBubbleMenuView];
        }
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
//        NSLog(@"%sddddd",__func__);
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
//        NSLog(@"%s",__func__);
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IsLogin"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IsLogin"];
        UINavigationController *na = (UINavigationController *)self.window.rootViewController;
        ViewController *viewC = (ViewController *)na.viewControllers[0];
        [viewC removeBubbleMenuView];
    }
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark -private methods-
- (void)showMaskView
{
    [self.window.rootViewController.view addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.bottom.equalTo(self.window.rootViewController.view);
    }];
}
#pragma mark -getters and setters-
- (TearedView *)maskView
{
    if (_maskView == nil) {
        _maskView = TearedView.new;
        _maskView.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"IMG_20%d.JPG",[RandomObject getRandomNumber:91 to:95]]];
        __weak AppDelegate *weakSelf = self;
        _maskView.showPopItem = ^(){
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"IsLogin"]) {
                UINavigationController *na = (UINavigationController *)weakSelf.window.rootViewController;
                if ([na.visibleViewController isKindOfClass:[ViewController class]]) {
                    ViewController *viewC = (ViewController *)na.visibleViewController;
                    [viewC.bubbleMenu show];
                }
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsLogin"];

            }
            weakSelf.maskView = nil;
        };
    }
    return _maskView;
}

@end
