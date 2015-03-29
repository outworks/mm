//
//  TaskAPI.m
//  cmm
//
//  Created by ilikeido on 15-3-29.
//
//

#import "TaskAPI.h"
#import "LK_API.h"

@implementation TaskAPI

+(void)getTasksByHttpRequest:(TaskRequest *)request Success:(void (^)(NSArray *tasks))sucess fail:(void (^)(NSString *description))fail{
    [LK_APIUtil postHttpRequest:request apiPath:URLPATH_TASKS Success:^(NSObject *response, NSInteger result, NSString *msg) {
        sucess((NSArray *)response);
    } fail:^(NSString *description) {
        fail(description);
    } class:([Task  class])];
}

@end
