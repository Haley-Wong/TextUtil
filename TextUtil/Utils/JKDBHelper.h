//
//  JKDataBase.h
//  JKBaseModel
//
//  github:https://github.com/Joker-King/JKDBModel
//  Created by zx_04 on 15/6/24.
//
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface JKDBHelper : NSObject

@property (nonatomic, retain, readonly) FMDatabaseQueue *dbQueue;

+ (JKDBHelper *)shareInstance;

+ (NSString *)dbPath;

@end
