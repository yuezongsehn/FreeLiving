//
//  AccountModel.h
//  FreeLiving
//
//  Created by 岳宗申 on 15/6/1.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountModel : NSObject

@property (nonatomic, assign) NSInteger accountId;
@property (nonatomic, strong) NSString *accountString;
@property (nonatomic, strong) NSString *accountName;
@property (nonatomic, strong) NSString *accountPassword;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *isImportant;
@property (nonatomic, strong) NSString *accountType;

@end
