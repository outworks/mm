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
        fail(description);
    } class:[Task class]];
}

+(void)updataSiteConfirmHttpAPI:(SiteConfirmRequest *)request Success:(void (^)(NSInteger result,NSString *msg))sucess fail:(void (^)(NSString *description))fail{
    
    [LK_APIUtil postHttpRequest:request apiPath:URLPATH_SITTECONFIRM Success:^(NSObject *response,NSInteger result,NSString *msg){
        sucess(result,msg);
    } fail:^(NSString * descript){
        fail(descript);
    }class:nil];

}

+(void)updataSitePhotoHttpAPI:(SitePhotoRequest *)request Success:(void (^)(NSInteger result,NSString *msg))sucess fail:(void (^)(NSString *description))fail{

    [LK_APIUtil postHttpRequest:request apiPath:URLPATH_SITEPHOTO Success:^(NSObject *response,NSInteger result,NSString *msg){
        sucess(result,msg);
    } fail:^(NSString * descript){
        fail(descript);
    }class:nil];


}

+(void)updataBusiNotifyHttpAPI:(BusiNotifyRequest *)request Success:(void (^)(NSInteger result,NSString *msg))sucess fail:(void (^)(NSString *description))fail{
    [LK_APIUtil postHttpRequest:request apiPath:URLPATH_BUSINOTIFY Success:^(NSObject *response,NSInteger result,NSString *msg){
        sucess(result,msg);
    } fail:^(NSString * descript){
        fail(descript);
    }class:nil];


}


+(void)updataBusiNotifyCheckHttpAPI:(BusiNotifyCheckRequest *)request Success:(void (^)(NSInteger result,NSString *msg))sucess fail:(void (^)(NSString *description))fail{

    [LK_APIUtil postHttpRequest:request apiPath:URLPATH_BUSINOTIFYCHECK Success:^(NSObject *response,NSInteger result,NSString *msg){
        sucess(result,msg);
    } fail:^(NSString * descript){
        fail(descript);
    }class:nil];


}


@end
