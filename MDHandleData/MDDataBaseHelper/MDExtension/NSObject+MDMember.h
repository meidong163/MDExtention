//
//  NSObject+MDMember.h
//  MDHandleData
//
//  Created by 没懂 on 2017/4/17.
//  Copyright © 2017年 com.infomacro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDIvar.h"

// 遍历所有类的block父类
typedef void(^MDClassesBlock)(Class c,BOOL *stop);

@interface NSObject (MDMember)


/**
 遍历所有的成员变量

 @param block block
 */
- (void)enmuerateIvarsWithBlock:(MDIvarsBlock)block;

// 遍历所有的方法 暂时不写
//- (void)enumerateMethodsWithBlock:(MJMethodsBlock)block;

/**
 遍历所有的类

 @param block 遍历类的block
 */
- (void)enmuerateClassesWithBlock:(MDClassesBlock)block;
@end
