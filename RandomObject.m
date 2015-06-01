//
//  RandomObject.m
//  FreeLiving
//
//  Created by 岳宗申 on 15/5/31.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import "RandomObject.h"

@implementation RandomObject

//获取从fromNum（包括fromNum）到 toNum 的随机数
+ (int)getRandomNumber:(int)fromNum to:(int)toNum
{
    
    return (int)(fromNum + (arc4random() % ((toNum-fromNum) + 1)));
    
}

@end
