//
//  InScrollViewLayer.m
//  FreeLiving
//
//  Created by 洋景-Yue on 15/6/4.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import "InScrollViewLayer.h"

@implementation InScrollViewLayer

- (void)drawInContext:(CGContextRef)ctx
{
    [super drawInContext:ctx];
    UIGraphicsPushContext(ctx);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10.0];
    CGContextSaveGState(ctx);
    CGContextAddPath(ctx, path.CGPath);
    CGContextClip(ctx);
    [_image drawInRect:self.bounds];
    CGContextRestoreGState(ctx);
    UIGraphicsPopContext();
}
- (void)setImage:(UIImage *)inImage
{
     _image = inImage;
    [self setNeedsDisplay];
}
@end
