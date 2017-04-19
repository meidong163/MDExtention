//
//  NSObject+MDKeyValue.h
//  MDHandleData
//
//  Created by 没懂 on 2017/4/17.
//  Copyright © 2017年 com.infomacro. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  KeyValue协议
 */
@protocol MDKeyValue <NSObject>
@optional
/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
- (NSDictionary *)replacedKeyFromPropertyName;

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class
 */
- (NSDictionary *)objectClassInArray;
@end
@interface NSObject (MDKeyValue)<MDKeyValue>
// 将model转成sql语句

// 获取建标语句
+ (NSString *)getCreateTableSqlUseClassName;
+ (NSString *)getCreateTableSqlWithTablename:(NSString *)tablename;
- (NSString *)getCreateTableSqlWithTablename:(NSString *)tablename;
+ (void)dbExcuteCreateTablesql;
+ (void)insertDataIntoDatabase;
- (void)insertDataIntoDatabase;

// 直接把model扔进数据库
- (void)modelEnterDatabase;
+(NSArray *)queryDbToObjectArray;
/**
 模型转字典

 @param keyValues 字典
 @return 模型
 */
+ (instancetype)objectWithKeyValues:(NSDictionary *)keyValues;
@end
