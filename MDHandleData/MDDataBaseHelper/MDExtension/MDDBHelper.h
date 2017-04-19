//
//  MDDBHelper.h
//  MDHandleData
//
//  Created by 没懂 on 2017/4/18.
//  Copyright © 2017年 com.infomacro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
@interface MDDBHelper : NSObject
{
    FMDatabase* _db;
    FMDatabaseQueue* _dbQueue;
}
/**
 *  获取数据库单例对象
 *
 *  @return 数据库对象。
 */
+(MDDBHelper *)instance;
/**
 *  数据库操作队列
 *
 *  @return 队列
 */
-(FMDatabaseQueue *)queue;
/**
 *  数据库
 *
 *  @return db
 */
-(FMDatabase *)db;
@end
