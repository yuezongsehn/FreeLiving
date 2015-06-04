//
//  AddNewNoteViewController.h
//  FreeLiving
//
//  Created by 洋景-Yue on 15/6/4.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol addDelegate <NSObject>

-(void)refreshFlipView;

@end
@interface AddNewNoteViewController : UIViewController

@property (nonatomic,assign) id<addDelegate>delegateForAdd;

@end
