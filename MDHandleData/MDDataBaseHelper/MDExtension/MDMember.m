//
//  MDMember.m
//  MDHandleData
//
//  Created by 没懂 on 2017/4/1.
//  Copyright © 2017年 com.infomacro. All rights reserved.
//

#import "MDMember.h"
// 用来处理model中的继承的情况。处理类的递归。
@implementation MDMember
/**
 *  初始化
 *
 *  @param srcObject 来源于哪个对象
 *
 *  @return 初始化好的对象
 */
- (instancetype)initWithSrcObject:(id)srcObject
{
    if (self = [super init]) {
        _srcObject = srcObject;
    }
    return self;
}

- (void)setSrcClass:(Class)srcClass
{
    _srcClass = srcClass;
    _srcClassFromFoundation = [NSStringFromClass(srcClass) hasPrefix:@"NS"];
}
@end
