//
//  TaskRequest.h
//  cmm
//
//  Created by ilikeido on 15-3-29.
//
//

#import <UIKit/UIKit.h>
#import "LK_HttpRequest.h"

@interface TaskRequest : LK_HttpBasePageRequest

@property(nonatomic,strong) NSString *requestType;//类型

@property(nonatomic,strong) NSString *userId;//用户id

@property(nonatomic,strong) NSString *name;//名称

@property(nonatomic,strong) NSString *state;//状态

@property(nonatomic,strong) NSString *typeId;//任务类型ID

@property(nonatomic,strong) NSString *startTime;//开始时间

@property(nonatomic,strong) NSString *endTime;//结束时间

@property(nonatomic,assign) int curPageNum;//当前页

@property(nonatomic,assign) int pageSize;//每页多少条

@end
