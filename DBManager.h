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
 *	@brief	创建所有表
 *
 *	@return
 */
+ (BOOL)createTable;

+ (BOOL)saveOrUpdataAccountModel:(AccountModel*)aModel;

@end
