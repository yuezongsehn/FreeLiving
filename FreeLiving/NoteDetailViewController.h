//
//  NoteDetailViewController.h
//  FreeLiving
//
//  Created by 洋景-Yue on 15/6/4.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"

@class NoteDetailViewController;

@protocol NoteDetailViewControllerDelegate <NSObject>

-(void)NoteDetailViewControllerClose:(NoteDetailViewController *)noteViewController;

@end

@interface NoteDetailViewController : UIViewController

@property (nonatomic, assign) id <NoteDetailViewControllerDelegate> delegateForDetail;
@property (nonatomic, strong) NoteModel *detailNoteModel;
@property (nonatomic, assign) BOOL isDelete;
@end
