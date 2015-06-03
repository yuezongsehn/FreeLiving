//
//  ConsumeModel.h
//  FreeLiving
//
//  Created by 洋景-Yue on 15/6/3.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConsumeModel : NSObject

@property (nonatomic, assign) NSInteger consumeId;
@property (nonatomic, strong) NSString *consumeDes;
@property (nonatomic, strong) NSString *consumeAmount;
@property (nonatomic, strong) NSString *consumeTime;
@property (nonatomic, strong) NSString *isImportant;
@property (nonatomic, strong) NSString *consumeType;

@end
