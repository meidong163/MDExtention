//
//  MDArgument.h
//  MDHandleData
//
//  Created by 没懂 on 2017/4/1.
//  Copyright © 2017年 com.infomacro. All rights reserved.
//  包装一个方法参数

#import <Foundation/Foundation.h>

@interface MDArgument : NSObject
// 参数的索引
@property (nonatomic, assign)int index;
// 参数的类型
@property (nonatomic, assign)NSString* type;

@end
