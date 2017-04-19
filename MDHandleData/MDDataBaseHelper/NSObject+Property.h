//
//  NSObject+Property.h
//   
//
//  Created on 12-12-15.
//
//
#import <objc/runtime.h>
#import <Foundation/Foundation.h>

@interface NSObject (Property)
/**
 *  获取属性列表 类
 *
 *  @return 调用的类的所有属性
 */
- (NSArray *)getPropertyList;
/**
 *  获取类的属性列表
 *
 *  @param clazz 要获取类的属性列表
 *
 *  @return 类属性列表
 */
- (NSArray *)getPropertyList: (Class)clazz;
/**
 *  创建数据表
 *
 *  @param tablename 表名
 *
 *  @return sql语句
 */
- (NSString *)tableSql:(NSString *)tablename;
/**
 *  创建数据库表 表名默认为类名
 *  创建表，类型都是text型的，其它的类型都需要测试下。
 *  @return 建表 sql语句
 */
- (NSString *)tableSql;
/**
 *  对象转字典
 *
 *  @return 对象数据存到字典中 无法处理NSArray 试一下
 */
- (NSDictionary *)convertDictionary;
/**
 *  初始化对象
 *
 *  @param dict 对象数据
 *
 *  @return 对象
 */
- (id)initWithDictionary:(NSDictionary *)dict;
/**
 *  获取类名
 *
 *  @return 类名
 */
- (NSString *)className;

@end
