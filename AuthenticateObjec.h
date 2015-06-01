//
//  AuthenticateObjec.h
//  FreeLiving
//
//  Created by 岳宗申 on 15/5/31.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(void);
typedef void (^FailureBlock)(NSError *error);

@interface AuthenticateObjec : NSObject

+ (void)showAuthenticateUserAlertViewSuccess:(SuccessBlock)aSuccess Failure:(FailureBlock)fail;
@end
