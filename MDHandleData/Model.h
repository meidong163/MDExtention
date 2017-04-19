//
//  Model.h
//  MDHandleData
//
//  Created by 没懂 on 17/3/30.
//  Copyright © 2017年 com.infomacro. All rights reserved.
//  具体的格式，不太好处理，存储成blob合适，取出来后在解码。

#import <Foundation/Foundation.h>

@interface Model : NSObject
// 图片 只能存文本，图片也只能存URL
@property (nonatomic, copy)NSString *imageUrl;
//name
@property (nonatomic, copy)NSString *name;
// 序号
@property (nonatomic, copy)NSString *inde;
@end
