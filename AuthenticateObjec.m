//
//  AuthenticateObjec.m
//  FreeLiving
//
//  Created by 岳宗申 on 15/5/31.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import "AuthenticateObjec.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <Security/Security.h>

@implementation AuthenticateObjec

+ (void)showAuthenticateUserAlertViewSuccess:(SuccessBlock)aSuccess Failure:(FailureBlock)fail
{
    LAContext *lacontext = [[LAContext alloc] init];
    NSError *error = nil;
    NSString *notesStr = @"Authentication is needed to access your notes.";
    if ([lacontext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
       
        [lacontext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:notesStr reply:^(BOOL success, NSError *error) {
            if (success) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    //用户选择其他验证方式，切换主线程处理
                    if (aSuccess) {
                        aSuccess();
                    }
                }];
            }
            else
            {
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"Authentication was cancelled by the system");
                        //切换到其他APP，系统取消验证Touch ID
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"Authentication was cancelled by the user");
                        //用户取消验证Touch ID
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            if (fail) {
                                fail(nil);
                            }
                        }];
                        
                        return;
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        NSLog(@"User selected to enter custom password");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            if (fail) {
                                fail(nil);
                            }
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }
            }
        }];
    }
    else
    {
        if (fail) {
            fail(nil);
        }
    }
}

@end
