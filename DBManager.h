//
//  DBManager.h
//  FreeLiving
//
//  Created by 岳宗申 on 15/6/1.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "AccountModel.h"
#import "ConsumeModel.h"

#define dataBasePath [[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject]stringByAppendingPathComponent:dataBaseName]
#define dataBaseName @"dataBase.sqlite"

@interface DBManager : NSObject

/****/
/**
 *	@brief	数据库对象单例方法
 *
 *	@return	返回FMDateBase数据库操作对象
 */
+ (FMDatabase *)createDataBase;


/**
 *	@brief	关闭数据库
 */
+ (void)closeDataBase;

/**
 *	@brief	清空数据库内容
 */
+ (void)deleteDataBase;

/**
 *	@brief	判断表是否存在
 *
 *	@param 	tableName 	表明
 *
 *	@return	创建是否成功
 */
+ (BOOL)isTableExist:(NSString *)tableName;


/**
 *	@brief	创建账号密码表
 *
 *	@return
 */
+ (BOOL)createAccount_Table;

+ (BOOL)saveAccountModel:(AccountModel*)aModel;
+ (NSMutableArray *)getAllAccountModel;
// 删除某一条数据
+ (BOOL)deleteAccountModel:(NSString *)createTime;
//更新一条数据
+ (BOOL)updateAccountModel:(AccountModel*)aModel;

+ (BOOL)createConsume_Table;

+ (BOOL)saveConsumeModel:(ConsumeModel*)aModel;
+ (NSMutableArray *)getAllConsumeModel;
// 删除某一条数据
+ (BOOL)deleteConsumeModel:(NSString *)createTime;
//更新一条数据
+ (BOOL)updateConsumeModel:(ConsumeModel*)aModel;
@end
