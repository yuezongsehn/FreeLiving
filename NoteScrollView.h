//
//  NoteScrollView.h
//  FreeLiving
//
//  Created by 洋景-Yue on 15/6/4.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NoteScrollView;

@protocol NoteScrollViewDelegate <NSObject>

-(void)noteScrollView:(NoteScrollView *)noteScroll didSelectAtIndex:(NSInteger)index withLayer:(CALayer *)layer;

@end

@interface NoteScrollView : UIScrollView
{

    NSInteger selectIndex;
    //确定所选定的layer是第几号，然后在关闭动画中确定动画layer的最终位置
}
//layer的数组，用来存放在scrollview中的layer，这里layer是自定义的
@property (nonatomic, strong) NSMutableArray *layersArray;
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, assign) id<NoteScrollViewDelegate>delegateForNote;
-(void)loadDataForView;
-(void)resetSelection;
-(void)loadViewData;

@end
