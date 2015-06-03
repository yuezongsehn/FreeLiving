//
//  ViewController.h
//  FreeLiving
//
//  Created by 岳宗申 on 15/5/29.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIVBubbleMenu.h"

@interface ViewController : UIViewController<LIVBubbleButtonDelegate>

@property (nonatomic, strong) LIVBubbleMenu *bubbleMenu;
@property (nonatomic, strong) NSArray* images;

- (void)removeBubbleMenuView;
- (void)showBubbleMenuView;
@end

