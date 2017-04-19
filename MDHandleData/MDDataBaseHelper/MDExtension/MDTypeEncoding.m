//
//  MDTypeEncoding.m
//  MDHandleData
//
//  Created by 没懂 on 2017/4/1.
//  Copyright © 2017年 com.infomacro. All rights reserved.
//

#import "MDTypeEncoding.h"

NSString *const MDTypeInt = @"i";
NSString *const MDTypeFloat = @"f";
NSString *const MDTypeDouble = @"d";
NSString *const MDTypeLong = @"q";
NSString *const MDTypeLongLong = @"q";
NSString *const MDTypeChar = @"c";
NSString *const MDTypeBool = @"c";
NSString *const MDTypePointer = @"*";

NSString *const MDTypeIvar = @"^{objc_ivar=}";
NSString *const MDTypeMethod = @"^{objc_method=}";
NSString *const MDTypeBlock = @"@?";
NSString *const MDTypeClass = @"#";
NSString *const MDTypeSEL = @":";
NSString *const MDTypeId = @"@";

/**
 *  返回值类型(如果是unsigned，就是大写)
 */
NSString *const MDReturnTypeVoid = @"v";
NSString *const MDReturnTypeObject = @"@";
