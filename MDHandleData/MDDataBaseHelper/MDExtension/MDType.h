//
//  MDType.h
//  MDHandleData
//
//  Created by 没懂 on 2017/4/1.
//  Copyright © 2017年 com.infomacro. All rights reserved.
//  包装一个类型

#import <Foundation/Foundation.h>

@interface MDType : NSObject
// 类型标识符
@property (nonatomic, copy)NSString *code;
// 对象类型，（如果是基本类型，此值为nil）model的类型，sql语句到时候用这个处理就好
@property (nonatomic, assign,readonly)Class typeClass;
/** 类型是否来自于Foundation框架，比如NSString、NSArray */
@property (nonatomic, readonly,getter=isFromFoundation)BOOL fromFoundation;
/** 类型是否不支持KVC */
@property (nonatomic, readonly, getter = isKVCDisabled) BOOL KVCDisabled;
/**
 *  初始化一个类型对象
 *
 *  @param code 类型标识符
 */
- (instancetype)initWithCode:(NSString *)code;
@end
