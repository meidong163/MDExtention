//
//  DbHelper.h
//  
//
//  Created on 12-12-15.
//
//

#import <Foundation/Foundation.h>
#import "NSObject+Property.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface DbHelper : NSObject
{
    FMDatabase* _db;
    FMDatabaseQueue* _dbQueue;
}
/**
 *  获取数据库单例对象
 *
 *  @return 数据库对象。
 */
+(DbHelper *)instance;
/**
 *  数据库操作队列
 *
 *  @return 队列
 */
-(FMDatabaseQueue *)queue;
/**
 *  数据库
 *
 *  @return db
 */
-(FMDatabase *)db;
/**
 *  判断表是否在数据库中存在
 *
 *  @param tablename 表明
 *
 *  @return bool结果
 */
-(BOOL)isExistsTable:(NSString *)tablename;
/**
 *  判断数据库中表示是否被移除
 *
 *  @param tableName 表名
 *
 *  @return 判断结果
 */
-(BOOL)DropExistsTable:(NSString*)tableName;
/**
 *  通过类名创建表
 *
 *  @param classname 类名
 *
 *  @return 是否创建成功
 */
-(BOOL)createTableByClassName:(NSString *)classname;
/**
 *  通过类名创建表
 *
 *  @param clazz 类
 *
 *  @return 是否创建成功
 */
-(BOOL)createTableByClass:(Class)clazz;
/**
 *  类对应的表中插入数据
 *
 *  @param clazz 类
 *  @param dict  数据
 */
-(void)insert:(Class)clazz dict:(NSDictionary *)dict;
/**
 *  插入某个类对应的表中的sql
 *
 *  @param clazz 类
 *
 *  @return sql语句
 */
-(NSString *)createInsertSqlByClass:(Class)clazz;
/**
 *  插入dict到表中
 *
 *  @param dict  数据
 *  @param table 表名
 *
 *  @return sql语句
 */
-(NSString *)createInsertSqlByDictionary:(NSDictionary *)dict tablename:(NSString *)table;
/**
 *  插入数据 字典的值，sql语句
 *
 *  @param sql  sql
 *  @param dict (?) 需要填的值
 */
-(void)insertBySql:(NSString *)sql dict:(NSDictionary *)dict;
/**
 *  对象插入数据库
 *
 *  @param object 对象
 */
-(void)insertObject:(id)object;
/**
 *  查数据
 *
 *  @param sql
 */
-(void)executeByQueue:(NSString *)sql;

//查询数据到字典数组，字典的Key对应列名
-(NSArray *)queryDbToDictionaryArray:(NSString *)tablename;
-(NSArray *)queryDbToDictionaryArray:(NSString *)tablename sql:(NSString *)sql;

//查询数据到对象数组，数据多时考虑效率问题，另注意列名与对象属性之间的对应关系
-(NSArray *)queryDbToObjectArray:(Class )clazz sql:(NSString *)sql;
-(NSArray *)queryDbToObjectArray:(Class )clazz;
@end
