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

+(void)getTasksByHttpRequest:(TaskRequest *)request Success:(void (^)(NSArray *tasks,BOOL isLastPage))sucess fail:(void (^)(NSString *description))fail{
    [LK_APIUtil postHttpPageRequest:request apiPath:URLPATH_TASKS Success:^(LK_HttpBasePageResponse *response, NSInteger result, NSString *msg) {
        sucess(response.data.result,response.data.lastPage);
    } fail:^(NSString *description) {
        fail(description);
    } class:([Task class])];
}

+(void)getDetailByHttpRequest:(TaskDetailRequest *)request Success:(void (^)(Task *task))sucess fail:(void (^)(NSString *description))fail{
    [LK_APIUtil postHttpRequest:request apiPath:URLPATH_TASKDETAIL Success:^(NSObject *response, NSInteger result, NSString *msg) {
        sucess((Task *)response);
    } fail:^(NSString *description) {
        
    } class:[Task class]];
}

@end
