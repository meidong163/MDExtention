//
//  DbHelper.m
//  
//
//  Created on 12-12-15.
//
//

#import "DbHelper.h"
#include <sqlite3.h>
@implementation DbHelper
 
+(DbHelper *)instance{
    static DbHelper *db = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!db) {
            db = [[DbHelper alloc]init];
        }
    });
    return db;
}

-(id)init{
    self = [super init];
    if(self){
        // 数据库的地址，默认沙盒
        NSString *dbpath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"db.database"];
        NSLog(@"db path:%@",dbpath);
        _db = [FMDatabase databaseWithPath:dbpath];
        [_db setLogsErrors:YES];
        [_db open];
       _dbQueue =  [FMDatabaseQueue databaseQueueWithPath:dbpath];
    }
    return self;
}
-(FMDatabaseQueue *)queue{
    return _dbQueue;
}
-(FMDatabase *)db{
   return _db;
}
-(void)executeByQueue:(NSString *)sql{
    // 执行sql,在队列中
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql];
    }];
}

#pragma --mark 表操作
// 判断是存在某个数据库
-(BOOL)isExistsTable:(NSString *)tablename{
    FMResultSet *rs = [_db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tablename];
    BOOL ret = NO;
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        NSLog(@"isTableOK %ld", (long)count);

        if (0 == count)
        {
            ret = NO;
        }
        else
        {
            ret = YES;
        }
    }
    return ret;
}
//drop exists table 删除数据库中存在的表
-(BOOL)DropExistsTable:(NSString*)tableName{
    if ([self isExistsTable:tableName]) {
        NSString *sql = [NSString stringWithFormat:@"drop table %@",tableName];
        BOOL ret = [_db executeUpdate:sql];
        return ret;
    }
    return YES;
}
// 创建以类名为表明的数据库表
-(BOOL)createTableByClass:(Class)clazz{
   NSString *classname = [NSString  stringWithUTF8String:class_getName(clazz)];
    return [self createTableByClassName:classname];
}
-(BOOL)createTableByClassName:(NSString *)classname{
    if ([self isExistsTable:classname]) {
        return YES;
    }// mattt: 这个反射写的。
   id obj = [[NSClassFromString(classname) alloc] init];
    if (obj==nil) {
        return NO;
    }
    // 建表sql
    NSString *sql = [obj tableSql];
    NSLog(@"建表sql %@",sql);
    // 执行建表sql
    BOOL ret = [_db executeUpdate:sql];
    return ret;
}

 //创建表，类型都是text类型的。 mattt: 映射需要写的地方。
- (NSString *)tableSql:(NSString *)tablename{
    NSMutableString *sql = [[NSMutableString alloc] init];
    NSArray *array = [self getPropertyList];
    [sql appendFormat:@"create table %@ (",tablename] ;
    NSInteger i = 0;
    // key 就是属性的值。
    for (NSString *key in array) {
        if (i>0) {
            [sql appendString:@","];
        }
        [sql appendFormat:@"%@ text",key];
        i++;
    }
    [sql appendString:@")"];
    NSLog(@"sql = %@",sql);
    return sql;
}
#pragma --mark 插入数据
// 类<－>字典，形式的数据插入数据库 表名是类名
-(void)insert:(Class)clazz dict:(NSDictionary *)dict{
    // 创建插入某个对象的sql语句，clazz 对象的类名
    NSString *sql = [self createInsertSqlByClass:clazz ];
    //excute sql dict ?,? 占位符中的数据 key：属性名，value 对用的数据
    return [self insertBySql:sql dict:dict];
}
// 数据库中插对象，表名是对象名。
-(void)insertObject:(id)object{
    NSString *tablename = [object className];
    NSMutableString *sql = [[NSMutableString alloc] init];
    NSArray *array = [object getPropertyList];
    [sql appendFormat:@"insert into %@ (",tablename] ;
    NSInteger i = 0;
    for (NSString *key in array) {
        if (i>0) {
            [sql appendString:@","];
        }
        [sql appendFormat:@"%@",key];
        i++;
    }
    [sql appendString:@") values ("];
    NSMutableArray *arrayValue = [NSMutableArray array];
    i=0;
    for (NSString *key in array) {
        SEL selector = NSSelectorFromString(key);
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id value = [object performSelector:selector];
#pragma clang diagnostic pop
        
 
        if (value==nil) {
            value = @"";
        }
        [arrayValue addObject:value];
        if (i>0) {
            [sql appendString:@","];
        }
        [sql appendString:@"?"];
        i++;
    }
    [sql appendString:@")"];
    NSLog(@"拼接sql的值 = %@",sql);
    NSLog(@"arrayValues = %@",arrayValue);
    [_db executeUpdate:sql withArgumentsInArray:arrayValue];
}
// private method
-(void)insertBySql:(NSString *)sql dict:(NSDictionary *)dict{
    if (sql && sql.length>0) {
        [_dbQueue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:sql withParameterDictionary:dict];
        }];
    }
}

-(NSString *)createInsertSqlByDictionary:(NSDictionary *)dict tablename:(NSString *)table{
    
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"insert into %@ (",table] ;
    NSInteger i = 0;
    for (NSString *key in dict.allKeys) {
        if (i>0) {
            [sql appendString:@","];
        }
        [sql appendFormat:@"%@",key];
        i++;
    }
    [sql appendString:@") values ("];
    i = 0;
    for (NSString *key in dict.allKeys) {
        if (i>0) {
            [sql appendString:@","];
        }
        [sql appendFormat:@":%@",key];
        i++;
    }
    [sql appendString:@")"];
    return sql;
}
// 通过类名产生插入到表中的sql
-(NSString *)createInsertSqlByClass:(Class)clazz{
    id obj = [[clazz alloc] init];
    if (obj==nil) {
        return nil;
    }
    NSString *classname = [NSString  stringWithUTF8String:class_getName(clazz)];
    
    NSMutableString *sql = [[NSMutableString alloc] init];
    NSArray *array = [obj getPropertyList];
    [sql appendFormat:@"insert into %@ (",classname] ;
    NSInteger i = 0;
    for (NSString *key in array) {
        if (i>0) {
            [sql appendString:@","];
        }
        [sql appendFormat:@"%@",key];
        i++;
    }
    [sql appendString:@") values ("];
    i = 0;
    for (NSString *key in array) {
        if (i>0) {
            [sql appendString:@","];
        }
        [sql appendFormat:@":%@",key];
        i++;
    }
    [sql appendString:@")"];
    return sql;
}
#pragma --mark 从数据库中查询数据
// 查询表中所有的数据 返回字典数组。
-(NSArray *)queryDbToDictionaryArray:(NSString *)tablename{
    //TDB
    NSString *sql = [NSString stringWithFormat:@"select * from %@",tablename];
    return [self queryDbToDictionaryArray:tablename sql:sql];
}
// private 返回某一列的数据
-(NSArray *)fMSetColumnArray:(FMResultSet *)fmset{
    FMStatement *statement = fmset.statement;
    NSInteger columnCount = sqlite3_column_count(statement.statement);
    NSMutableArray *columnArray = [NSMutableArray array];
    
    for (NSInteger columnIdx = 0; columnIdx < columnCount; columnIdx++) {
        NSString *columnName = [NSString stringWithUTF8String:sqlite3_column_name(statement.statement, (int)columnIdx)];
        [columnArray addObject:columnName];
    }
    return columnArray;
}
// sql+表名,查询数据  字段数组
-(NSArray *)queryDbToDictionaryArray:(NSString *)tablename sql:(NSString *)sql{
    FMResultSet *resultSet=[_db executeQuery:sql];
    NSArray *columnArray = [self  fMSetColumnArray:resultSet];
    NSMutableArray *syncArray = [[NSMutableArray alloc] init];
    NSString *columnName = nil;
    while ([resultSet next])
    {
        NSMutableDictionary *syncData = [[NSMutableDictionary alloc] init];
        for(int i =0;i<columnArray.count;i++)
        {
            columnName = [columnArray objectAtIndex:i];
            NSString *columnValue = [resultSet stringForColumn: columnName];
            if (columnValue==nil) {
                columnValue=@"";
            }
            [syncData setObject:columnValue forKey:columnName];
        }
        [syncArray addObject:syncData];
    }
    if ([syncArray count]==0) {
        return nil;
    }
    return syncArray;
}
//sql+class 查询数据－> 对象数组
-(NSArray *)queryDbToObjectArray:(Class )clazz sql:(NSString *)sql{
    FMResultSet *resultSet=[_db executeQuery:sql];
    NSArray *columnArray = [self  fMSetColumnArray:resultSet];
    NSMutableArray *syncArray = [[NSMutableArray alloc] init];
    NSString *columnName = nil;
    while ([resultSet next])
    {
        NSObject *obj = [[clazz alloc] init];
        
        if (obj==nil) {
            continue;
        }
        
        for(int i =0;i<columnArray.count;i++)
        {
            columnName = [columnArray objectAtIndex:i];
            NSString *columnValue = [resultSet stringForColumn: columnName];
            SEL selector = NSSelectorFromString(columnName);
            
            if ([obj respondsToSelector:selector]) {
                [obj setValue:columnValue forKeyPath:columnName ];
            }
        }
        [syncArray addObject:obj];
    }
    if ([syncArray count]==0) {
        return nil;
    }
    return syncArray;
}
// class 返回对象数组。
-(NSArray *)queryDbToObjectArray:(Class )clazz{
    NSString *classname = [NSString  stringWithUTF8String:class_getName(clazz)];
    NSString *sql = [NSString stringWithFormat:@"select * from %@",classname];
    return [self queryDbToObjectArray:clazz sql:sql];
    
}
@end
