//
//  TaskAPI.h
//  cmm
//
//  Created by ilikeido on 15-3-29.
//
//

#import <Foundation/Foundation.h>
#import "Task.h"
#import "TaskRequest.h"

@interface TaskAPI : NSObject

+(void)getTasksByHttpRequest:(TaskRequest *)request Success:(void (^)(NSArray *tasks))sucess fail:(void (^)(NSString *description))fail;


@end
