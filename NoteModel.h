//
//  NoteModel.h
//  FreeLiving
//
//  Created by 洋景-Yue on 15/6/4.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteModel : NSObject

@property (nonatomic, assign) NSInteger noteId;
@property (nonatomic, strong) NSString *noteText;
@property (nonatomic, strong) NSString *noteTime;
@property (nonatomic, strong) NSString *isImportant;
@property (nonatomic, strong) NSString *noteType;

@end
