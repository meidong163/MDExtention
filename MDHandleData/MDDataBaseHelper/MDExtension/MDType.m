//
//  MDType.m
//  MDHandleData
//
//  Created by 没懂 on 2017/4/1.
//  Copyright © 2017年 com.infomacro. All rights reserved.
//

#import "MDType.h"
#import "MDHead.h"
@implementation MDType

- (instancetype)initWithCode:(NSString *)code
{
    if (self = [super init]) {
        self.code = code;
    }
    return self;
}
/** 类型标识符*/
- (void)setCode:(NSString *)code
{
    _code = code;
    if (_code.length == 0 || [_code isEqualToString:MDTypeSEL] || [_code isEqualToString:MDTypeIvar] ||[_code isEqualToString:MDTypeMethod]) {
        _KVCDisabled = YES;
        }else if ([_code hasPrefix:@"@"] && _code.length > 3)
        {
            _code = [_code substringFromIndex:2];
            _code = [_code substringToIndex:_code.length - 1];
            _typeClass = NSClassFromString(_code);
            _fromFoundation = [_code hasPrefix:@"NS"];
        }
}
@end
