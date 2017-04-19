//
//  NSObject+MDMember.m
//  MDHandleData
//
//  Created by 没懂 on 2017/4/17.
//  Copyright © 2017年 com.infomacro. All rights reserved.
//

#import "NSObject+MDMember.h"

@implementation NSObject (MDMember)

- (void)enmuerateClassesWithBlock:(MDClassesBlock)block
{
    if (block == nil) {
        return;
    }
    BOOL stop = NO;
    Class c = [self class];
    while (c && !stop) {
        // 执行操作
        block(c,&stop);
        // 类向上递归，遍历父类
        c = class_getSuperclass(c);
    }
}

- (void)enmuerateIvarsWithBlock:(MDIvarsBlock)block
{
    [self enmuerateClassesWithBlock:^(__unsafe_unretained Class c, BOOL *stop) {
        // 1. 获得所有的成员变量
        unsigned int outCount = 0;
        // 用runtime把类处理下，重新包装
        Ivar *ivars = class_copyIvarList(c,&outCount);
        // 2. 遍历每一个成员变量
        for (int i = 0; i < outCount; i++) {
            MDIvar *ivar = [[MDIvar alloc]initWithIvar:ivars[i] srcObject:self];// 调用这个方法者，self。
            ivar.srcClass = c;
            block(ivar,stop);
        }

        free(ivars);
    }];

}

@end
