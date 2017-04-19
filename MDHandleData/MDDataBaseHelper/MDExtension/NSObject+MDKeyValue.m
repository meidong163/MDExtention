//
//  NSObject+MDKeyValue.m
//  MDHandleData
//
//  Created by 没懂 on 2017/4/17.
//  Copyright © 2017年 com.infomacro. All rights reserved.
//

#import "NSObject+MDKeyValue.h"
#import "NSObject+MDMember.h"
#import "MDDBHelper.h"
#import <FMDB/FMDB.h>
@implementation NSObject (MDKeyValue)

#pragma --mark 创建数据库表
- (NSString *)getCreateTableSqlWithTablename:(NSString *)tablename
{
    return [self jointSqlWithTablename:tablename operation:@"create table" isInsert:NO];
}

+ (NSString *)getCreateTableSqlUseClassName
{
    return [[self new] getCreateTableSqlWithTablename:[NSString stringWithUTF8String:object_getClassName(self)]];
}

+ (NSString *)getCreateTableSqlWithTablename:(NSString *)tablename
{
    return [[self new] getCreateTableSqlWithTablename:tablename];
}

+ (void)dbExcuteCreateTablesql
{
    [[[MDDBHelper instance]db] executeUpdate:[self getCreateTableSqlUseClassName]];
}

#pragma --mark 插入数据

- (void)insertDataIntoDatabase
{
    return [self insertDataIntoDatabase:[NSString stringWithUTF8String:object_getClassName(self)]];
}

+ (void)insertDataIntoDatabase
{
    return [[self new] insertDataIntoDatabase:[NSString stringWithUTF8String:object_getClassName(self)]];
}

- (void)insertDataIntoDatabase:(NSString *)tablename;
{
    NSMutableString *sql = [self jointSqlWithTablename:tablename operation:@"insert into" isInsert:YES];
    [sql appendString:@"values ("];
    NSMutableArray *arrayValue = [NSMutableArray array];
    [self enmuerateIvarsWithBlock:^(MDIvar *ivar, BOOL *stop) {
        if (ivar.isSrcClassFromFoundation) return;
        // 1.取出属性值
        id value = ivar.value;
        if (!value) return;
        // 2.如果是模型属性
        if (ivar.type.typeClass && !ivar.type.fromFoundation) {
            value = [value keyValues];
        } else if ([self respondsToSelector:@selector(objectClassInArray)]) {
            // 3.处理数组里面有模型的情况 // 这中情况还要不要放在表里边。
            Class objectClass = self.objectClassInArray[ivar.propertyName];
            if (objectClass) {
                value = [objectClass keyValuesArrayWithObjectArray:value];
            }
        }
        [arrayValue addObject:value];
        [sql appendString:@"?, "];
    }];
    [sql replaceCharactersInRange:NSMakeRange(sql.length-2, 2) withString:@""];
    [sql appendFormat:@")"];
    NSLog(@"插入表的sql = %@ /n data= %@",sql,arrayValue);

    [[[MDDBHelper instance]db]executeUpdate:sql withArgumentsInArray:arrayValue];
}

#pragma --mark model 扔到数据库
- (void)modelEnterDatabase
{
    [[self class] dbExcuteCreateTablesql];
    [self insertDataIntoDatabase];
}

#pragma --mark model 从数据库中拿出来
+ (NSArray *)queryDbToObjectArray
{
    NSString *classname = [NSString  stringWithUTF8String:class_getName(self)];
    NSString *sql = [NSString stringWithFormat:@"select * from %@",classname];
    return [self queryDbToObjectArray:self sql:sql];
}

-(NSArray *)queryDbToObjectArray:(Class )clazz sql:(NSString *)sql{
    FMResultSet *resultSet=[[[MDDBHelper instance]db] executeQuery:sql];
    NSArray *columnArray = [self fMSetColumnArray:resultSet];
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
            // FMDB 这个方法无法拿出来NSData 所以不得在下面再次获取一次
            id columnValue = [resultSet objectForColumnName:columnName];
            if (columnValue == nil) {
                columnValue = [resultSet dataForColumn:columnName];
            }
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
// private 返回某一列的数据
-(NSArray *)fMSetColumnArray:(FMResultSet *)fmset{
    NSInteger columnCount = fmset.columnCount;
    NSMutableArray *columnArray = [NSMutableArray array];
    for (int columnIdx = 0; columnIdx < columnCount; columnIdx++) {
        NSString *columnName = [fmset columnNameForIndex:columnIdx];
        [columnArray addObject:columnName];
    }
    return columnArray;
}
#pragma --mark MJ辅助方法
/**
 *  将模型转成字典
 *  @return 字典
 */
- (NSDictionary *)keyValues
{
    NSMutableDictionary *keyValues = [NSMutableDictionary dictionary];

    [self enmuerateIvarsWithBlock:^(MDIvar *ivar, BOOL *stop) {
        if (ivar.isSrcClassFromFoundation) return;

        // 1.取出属性值
        id value = ivar.value;
        if (!value) return;

        // 2.如果是模型属性
        if (ivar.type.typeClass && !ivar.type.fromFoundation) {
            value = [value keyValues];
        } else if ([self respondsToSelector:@selector(objectClassInArray)]) {
            // 3.处理数组里面有模型的情况
            Class objectClass = self.objectClassInArray[ivar.propertyName];
            if (objectClass) {
                value = [objectClass keyValuesArrayWithObjectArray:value];
            }
        }

        // 4.赋值
        NSString *key = [self keyWithPropertyName:ivar.propertyName];
        keyValues[key] = value;
    }];

    return keyValues;
}

/**
 *  通过模型数组来创建一个字典数组
 *  @param objectArray 模型数组
 *  @return 字典数组
 */
+ (NSArray *)keyValuesArrayWithObjectArray:(NSArray *)objectArray
{
    // 0.判断真实性
    if (![objectArray isKindOfClass:[NSArray class]]) {
        [NSException raise:@"objectArray is not a NSArray" format:nil];
    }
    // 1.过滤
    if (![objectArray isKindOfClass:[NSArray class]]) return objectArray;
    if (![[objectArray lastObject] isKindOfClass:self]) return objectArray;

    // 2.创建数组
    NSMutableArray *keyValuesArray = [NSMutableArray array];
    for (id object in objectArray) {
        [keyValuesArray addObject:[object keyValues]];
    }
    return keyValuesArray;
}

/**
 *  根据属性名获得对应的key
 *
 *  @param propertyName 属性名
 *
 *  @return 字典的key
 */
- (NSString *)keyWithPropertyName:(NSString *)propertyName
{
    NSString *key = nil;
    // 1.查看有没有需要替换的key
    if ([self respondsToSelector:@selector(replacedKeyFromPropertyName)]) {
        key = self.replacedKeyFromPropertyName[propertyName];
    }
    // 2.用属性名作为key
    if (!key) key = propertyName;

    return key;
}

#pragma mark - 字典转模型
/**
 *  通过字典来创建一个模型
 *  @param keyValues 字典
 *  @return 新建的对象
 */
+ (instancetype)objectWithKeyValues:(NSDictionary *)keyValues
{
    // 判断参数是否是字典 否则直接抛异常
    if (![keyValues isKindOfClass:[NSDictionary class]]) {
        [NSException raise:@"keyValues is not a NSDictionary" format:nil];
    }
    // 创建一个model，由于是类方法，Self也就是调用这个方法的对象，即需要初始化的model
    id model = [[self alloc] init];
    // 将字典的值初始化给model 并返回model
    [model setKeyValues:keyValues];
    return model;
}

/**
 *  将字典的键值对转成模型属性
 *  @param keyValues 字典
 */
- (void)setKeyValues:(NSDictionary *)keyValues
{
    if (![keyValues isKindOfClass:[NSDictionary class]]) {
        [NSException raise:@"keyValues is not a NSDictionary" format:nil];
    }
    [self enmuerateIvarsWithBlock:^(MDIvar *ivar, BOOL *stop) {
        // 来自Foundation框架的成员变量，直接返回
        if (ivar.isSrcClassFromFoundation) return;

        // 1.取出属性值 属性名作为key
        NSString *key = [self keyWithPropertyName:ivar.propertyName];
        id value = keyValues[key];
        if (!value) return;

        // 2.如果是模型属性
        if (ivar.type.typeClass && !ivar.type.fromFoundation) {
            value = [ivar.type.typeClass objectWithKeyValues:value];
        } else if ([self respondsToSelector:@selector(objectClassInArray)]) {
            // 3.字典数组-->模型数组
            Class objectClass = self.objectClassInArray[ivar.propertyName];
            if (objectClass) {
                value = [objectClass objectArrayWithKeyValuesArray:value];
            }
        }
        // 4.赋值
        ivar.value = value;
    }];
}

/**
 *  通过字典数组来创建一个模型数组
 *  @param keyValuesArray 字典数组
 *  @return 模型数组
 */
+ (NSArray *)objectArrayWithKeyValuesArray:(NSArray *)keyValuesArray
{
    // 1.判断真实性
    if (![keyValuesArray isKindOfClass:[NSArray class]]) {
        [NSException raise:@"keyValuesArray is not a NSArray" format:nil];
    }

    // 2.创建数组
    NSMutableArray *modelArray = [NSMutableArray array];

    // 3.遍历
    for (NSDictionary *keyValues in keyValuesArray) {
        if (![keyValues isKindOfClass:[NSDictionary class]]) continue;

        id model = [self objectWithKeyValues:keyValues];
        [modelArray addObject:model];
    }

    return modelArray;
}

#pragma -mark 私有方法拼接sql 创建表或插入数据。

- (NSMutableString *)jointSqlWithTablename:(NSString *)tablename operation:(NSString*)operation isInsert:(BOOL)flag
{
    NSMutableString *sql = [[NSMutableString alloc]init];
    [sql appendFormat:@"%@ %@ (",operation,tablename];
    [self enmuerateIvarsWithBlock:^(MDIvar *ivar, BOOL *stop) {
        if (ivar.isSrcClassFromFoundation) {
            return ;// 类迭代结束条件。
        }
        if (flag) {
            // insert
            if ([ivar.type.code isEqualToString:@"NSString"]) {
                [sql appendFormat:@"%@, ",ivar.propertyName];
            }else if ([ivar.type.code isEqualToString:@"NSData"])
            {
                [sql appendFormat:@"%@, ",ivar.propertyName];
            }
        }else
        {   // create
            if ([ivar.type.code isEqualToString:@"NSString"]) {
                [sql appendFormat:@"%@ text, ",ivar.propertyName];
            }else if ([ivar.type.code isEqualToString:@"NSData"])
            {
                [sql appendFormat:@"%@ blob, ",ivar.propertyName];
            }
        }

    }];
    // 去掉末尾的 逗号和空格。
    [sql replaceCharactersInRange:NSMakeRange(sql.length-2, 2) withString:@""];
    [sql appendFormat:@")"];
    return sql;
}

@end
