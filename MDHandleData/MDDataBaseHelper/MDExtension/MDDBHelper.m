//
//  MDDBHelper.m
//  MDHandleData
//
//  Created by 没懂 on 2017/4/18.
//  Copyright © 2017年 com.infomacro. All rights reserved.
//

#import "MDDBHelper.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
@implementation MDDBHelper
+(MDDBHelper *)instance{
    static MDDBHelper *db ;
    @synchronized(self) {
        if(!db) {
            db = [[MDDBHelper alloc] init];
        }
    }
    return db;
}

-(id)init{
    self = [super init];
    if(self){
        // 数据库的地址，默认沙盒
        NSString *dbpath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"db.database"];
        NSLog(@"db path:%@",dbpath);
        _db = [FMDatabase databaseWithPath:dbpath];
        [_db setLogsErrors:YES];
        [_db open];
        _dbQueue =  [FMDatabaseQueue databaseQueueWithPath:dbpath];
    }
    return self;
}
-(FMDatabaseQueue *)queue{
    return _dbQueue;
}
-(FMDatabase *)db{
    return _db;
}
@end
