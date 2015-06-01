//
//  DBManager.m
//  FreeLiving
//
//  Created by 岳宗申 on 15/6/1.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import "DBManager.h"

static FMDatabase *shareDataBase = nil;

@implementation DBManager

+ (FMDatabase *)createDataBase {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareDataBase = [FMDatabase databaseWithPath:dataBasePath];
    });
    return shareDataBase;
}

/**
 判断数据库中表是否存在
 **/
+ (BOOL)isTableExist:(NSString *)tableName
{
    FMResultSet *rs = [shareDataBase executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        NSLog(@"%@ isOK %ld", tableName,(long)count);
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}

/**
 创建表
 **/
+ (BOOL)createAccount_Table {
    //    debugMethod();
    NSLog(@"%@",dataBasePath);
    if (1){
        {
            shareDataBase = [DBManager createDataBase];
            if ([shareDataBase open]) {
                if (![DBManager isTableExist:@"account_table"]) {
                    NSString *sql = @"CREATE TABLE account_table (id integer primary key autoincrement,accountstring varchar(64),accountname varchar(128),accountpassword varchar(64),creattime varchar(64),isimportant varchar(2),accounttype varchar(64))";
                    [shareDataBase executeUpdate:sql];
                }
                [shareDataBase close];
            }
        }
    }
    return YES;
}
+ (BOOL)saveOrUpdataAccountModel:(AccountModel*)aModel
{
    BOOL isOk = NO;
    shareDataBase = [DBManager createDataBase];
    if ([shareDataBase open]) {
        isOk = [shareDataBase executeUpdate:
                @"INSERT INTO account_table(accountstring,accountname,accountpassword,creatTime,isimportant,accounttype)VALUES(?,?,?,?,?,?)",aModel.accountString,aModel.accountName,aModel.accountPassword,aModel.creatTime,aModel.isImportant,aModel.accountType];
        [shareDataBase close];
    }
    return isOk;

}
/**
 关闭数据库
 **/
+ (void)closeDataBase {
    if(![shareDataBase close]) {
        NSLog(@"数据库关闭异常，请检查");
        return;
    }
}

/**
 删除数据库
 **/
+ (void)deleteDataBase {
    if (shareDataBase != nil) {
        //这里进行数据库表的删除工作
    }
}

@end
