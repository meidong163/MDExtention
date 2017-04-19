//
//  MDIvar.m
//  MDHandleData
//
//  Created by 没懂 on 2017/4/17.
//  Copyright © 2017年 com.infomacro. All rights reserved.
//

#import "MDIvar.h"
#import "MDTypeEncoding.h"
@implementation MDIvar
/**
 *  初始化
 *
 *  @param ivar      成员变量
 *  @param srcObject 哪个对象的成员变量
 *
 *  @return 初始化好的对象
 */
- (instancetype)initWithIvar:(Ivar)ivar srcObject:(id)srcObject
{
    if (self = [super initWithSrcObject:srcObject]) {
        self.ivar = ivar;
    }
    return self;
}

- (void)setIvar:(Ivar)ivar
{
    _ivar = ivar;
    // 1. 成员变量名。
    _name = [NSString stringWithUTF8String:ivar_getName(ivar)];
    // 2. 属性名
    if ([_name hasPrefix:@"_"]) {
        // 去掉属性下划线
        _propertyName = [_name stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }else
    {
        _propertyName = _name;
    }
    // 3. 成员变量的类型符
    NSString *code = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
    // 成员的类型。
    _type = [[MDType alloc]initWithCode:code];
}

// 获得成员变量的值
- (id)value
{
    if (_type.KVCDisabled) return [NSNull null];
    // _srcObject 为要设置值的模型对象
    return [_srcObject valueForKey:_propertyName];
}

// 设置成员变量的值
- (void)setValue:(id)value
{
    if(_type.KVCDisabled) return;
    [_srcObject setValue:value forKey:_propertyName];
}
@end
