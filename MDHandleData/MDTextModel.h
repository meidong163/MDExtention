//
//  MDTextModel.h
//  MDHandleData
//
//  Created by 没懂 on 2017/4/1.
//  Copyright © 2017年 com.infomacro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJKeyValue.h"
@interface MDTextModel : NSObject<MJKeyValue>

@property (nonatomic, copy)NSString *name;
//@property (nonatomic, assign)NSInteger num;
//@property (nonatomic, assign)double doubleNum;
//@property (nonatomic, assign)long long longNum;
@property (nonatomic, strong)NSData *data;

@end
