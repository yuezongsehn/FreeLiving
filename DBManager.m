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
#pragma mark - Account_Table -
/**
 创建表
 **/
+ (BOOL)createAccount_Table {
    
    BOOL result = NO;
    shareDataBase = [DBManager createDataBase];
    if ([shareDataBase open]) {
        if ([DBManager isTableExist:@"account_table"]) {
            result = YES;
        }
        else
        {
            NSString *sql = @"CREATE TABLE account_table (id integer primary key autoincrement,accountstring varchar(64),accountname varchar(128),accountpassword varchar(64),createtime varchar(64),isimportant varchar(2),accounttype varchar(64))";
            result = [shareDataBase executeUpdate:sql];
        }
        [shareDataBase close];
    }
    return result;
}
+ (BOOL)saveAccountModel:(AccountModel*)aModel
{
    BOOL isOk = NO;
    shareDataBase = [DBManager createDataBase];
    if ([shareDataBase open]) {
        isOk = [shareDataBase executeUpdate:
                @"INSERT INTO account_table(accountstring,accountname,accountpassword,createtime,isimportant,accounttype)VALUES(?,?,?,?,?,?)",aModel.accountString,aModel.accountName,aModel.accountPassword,aModel.createTime,aModel.isImportant,aModel.accountType];
        aModel.accountId = [shareDataBase lastInsertRowId];
        [shareDataBase close];
    }
    return isOk;
    
}
+ (NSMutableArray *)getAllAccountModel
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    shareDataBase = [DBManager createDataBase];
    if ([shareDataBase open]) {
        FMResultSet *s = [shareDataBase executeQuery:@"SELECT * FROM account_table order by id desc"];
        while ([s next]) {
            AccountModel *aModel = [[AccountModel alloc] init];
            aModel.accountId = [s intForColumn:@"id"];
            aModel.accountString = [s stringForColumn:@"accountstring"];
            aModel.accountName = [s stringForColumn:@"accountname"];
            aModel.accountPassword = [s stringForColumn:@"accountpassword"];
            aModel.isImportant = [s stringForColumn:@"isimportant"];
            aModel.createTime = [s stringForColumn:@"createtime"];
            aModel.accountType = [s stringForColumn:@"accounttype"];
            [array addObject:aModel];
        }
        [shareDataBase close];
    }
    return array;
}
// 删除某一条数据
+ (BOOL)deleteAccountModel:(NSString *)createTime
{
    BOOL isOk = NO;
    shareDataBase = [DBManager createDataBase];
    if ([shareDataBase open]) {
        isOk = [shareDataBase executeUpdate:
                @"delete from account_table where createtime = ?",createTime];
        [shareDataBase close];
    }
    return isOk;
}
//更新一条数据
+ (BOOL)updateAccountModel:(AccountModel*)aModel
{
    BOOL isOk = NO;
    shareDataBase = [DBManager createDataBase];
    if ([shareDataBase open]) {
        isOk = [shareDataBase executeUpdate:
                @"update account_table set accountpassword = ? where id = ?",aModel.accountPassword,[NSString stringWithFormat:@"%ld",(long)aModel.accountId]];
        [shareDataBase close];
    }
    return isOk;
}
#pragma mark -----
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
