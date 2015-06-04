//
//  NoteScrollView.m
//  FreeLiving
//
//  Created by 洋景-Yue on 15/6/4.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import "NoteScrollView.h"
#import "InScrollViewLayer.h"
#import "DBManager.h"

@implementation NoteScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layersArray = [[NSMutableArray alloc] initWithCapacity:0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectALayerToShow:)];
        [self addGestureRecognizer:tap];
        if ([DBManager createNote_Table]) {
            [self loadDataForView];
        }
    }
    return self;
}
#pragma mark -UITapGes method-
-(void)selectALayerToShow:(UITapGestureRecognizer *)recognizer{
    //判断点击的点是否在某一个layer里面
    //    if (selectIndex != NSNotFound) {
    //		return;
    //	}
    CGPoint location = [recognizer locationInView:self];
    NSInteger index = 0;
    for (CALayer *layer in self.layersArray) {
        if (CGRectContainsPoint(layer.frame, location)) {
            //如果在，则执行动画效果显示FlipDetailViewController，由于FlipDetailViewController在FlipViewController中定义，则利用代理传递参数
            selectIndex = index;
            for (CATextLayer *textLayer in layer.sublayers) {
                if ([textLayer isKindOfClass:[CATextLayer class]]) {
                    textLayer.hidden = YES;
                }
            }
            [_delegateForNote noteScrollView:self didSelectAtIndex:index withLayer:layer];
            break;
        }
        index++;
    }
}
#pragma mark -private method-
-(void)loadDataForView{
    selectIndex = NSNotFound;
    [self loadViewData];
}
- (void)loadViewData
{
    for (CALayer *aLayer in self.layersArray) {
        if (aLayer.superlayer) {
            [aLayer removeFromSuperlayer];
        }
    }
    [self.layersArray removeAllObjects];
    self.contentArray = [DBManager getAllNoteModel];
    NSInteger numberOfItems = self.contentArray.count;//这里可以设置layer的数量，数量的大小可以通过代理从controller的layerarray里面获得
    for (int i = 0; i < numberOfItems; i++) {
        NoteModel *aModel = self.contentArray[i];
        InScrollViewLayer *layer = [InScrollViewLayer layer];
        layer.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"notepad" ofType:@"png"]];//这里设置layer的图片，可以用代理获取controller里面的截图
        layer.bounds = CGRectMake(0, 0, 80, 80);//80，80是layer可以设置layer的大小bound，大小最好设置成全局静态变量，方便修改和使用，修改时注意跟layer每行的数量相配合
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.string = aModel.noteTime;
        textLayer.fontSize = 15.f;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.frame = CGRectMake(3, 20, 65, 50);
        textLayer.foregroundColor = [[UIColor purpleColor] CGColor];
        textLayer.wrapped = YES;
        [layer addSublayer:textLayer];
        [self.layersArray addObject:layer];
    }
    [self setNeedsLayout];
}
//每次刷新页面的时候都将非选择layer加到scrollview中去
- (void)layoutSubviews
{
    NSInteger index = 0;
    float border = 60;
    NSUInteger rows = (NSUInteger)ceilf((float)[self.layersArray count] / (float)3);
    
    self.contentSize = CGSizeMake(self.bounds.size.width, rows * (80 + 20.0) + 80.0);
    [CATransaction begin];//显示事物
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    for (InScrollViewLayer *aLayer in self.layersArray) {
        if (index != selectIndex) {
            NSInteger indexInRow = index % 3;//layer在这一行中的列坐标
            NSInteger row = index / 3;//layer的行坐标
            //这里的3是每行layer的数量，可以设置成全局变量方便修改和使用
            aLayer.bounds = CGRectMake(0, 0, 80.0, 80.0);//
            aLayer.position = CGPointMake(border + (indexInRow) * ((self.bounds.size.width - border * 2) / (3 - 1)) , ((row + 0.5) * (80 + 20.0)) + 10.0);
            aLayer.backgroundColor = [UIColor clearColor].CGColor;
            if ([aLayer superlayer] != self.layer) {
                [self.layer addSublayer:aLayer];
            }
        }
        index++;
    }
    [CATransaction commit];
}

-(void)resetSelection{
    if (self.layersArray.count > selectIndex) {
        InScrollViewLayer *aLayer = [self.layersArray objectAtIndex:selectIndex];
        NSUInteger k = 3;
        for (CATextLayer *textLayer in aLayer.sublayers) {
            if ([textLayer isKindOfClass:[CATextLayer class]]) {
                textLayer.hidden = NO;
            }
        }
        
        NSUInteger indexInRow = selectIndex % k;//选中layer的纵坐标
        NSUInteger row = selectIndex / k;//选中layer的横坐标
        CGPoint position = CGPointMake(60 + (indexInRow) * ((self.bounds.size.width - 60 * 2) / (k - 1)) , ((row + 0.5) * (80 + 20.0)) + 10.0);
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:aLayer.position];
        positionAnimation.toValue = [NSValue valueWithCGPoint:[aLayer.superlayer convertPoint:position fromLayer:self.layer]];
        
        CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        boundsAnimation.fromValue = [NSValue valueWithCGRect:aLayer.bounds];
        boundsAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, 80, 80)];
        
        CATransition *t = [CATransition animation];
        t.type = @"flip";
        t.subtype = kCATransitionFromLeft;
        t.duration = 0.25;
        t.removedOnCompletion = YES;
        
        aLayer.contents = nil;
        //	aLayer.image = [dataSource imageForItemInGridControl:self atIndex:selectedIndex];
        aLayer.image = [UIImage imageNamed:@"notepad.png"];
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.duration = 0.5;
        group.animations = [NSArray arrayWithObjects:positionAnimation, boundsAnimation, nil];
        group.delegate = self;
        group.fillMode = kCAFillModeForwards;
        group.removedOnCompletion = NO;
        
        [aLayer addAnimation:group forKey:@"zoomOut"];
        [aLayer addAnimation:t forKey:@"flip"];
        
    }
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //关闭动画执行后
    if (self.layersArray.count > selectIndex) {
        InScrollViewLayer *aLayer = [self.layersArray objectAtIndex:selectIndex];
        [aLayer removeAllAnimations];
        [aLayer setNeedsDisplay];
        [self.layer addSublayer:aLayer];
        
        selectIndex = NSNotFound;
        [self setNeedsLayout];
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
