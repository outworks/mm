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

+(void)getTasksByHttpRequest:(TaskRequest *)request Success:(void (^)(NSArray *tasks,BOOL isLastPage))sucess fail:(void (^)(NSString *description))fail;

+(void)getDetailByHttpRequest:(TaskDetailRequest *)request Success:(void (^)(Task *task))sucess fail:(void (^)(NSString *description))fail;


// 现场确认接口

+(void)updataSiteConfirmHttpAPI:(SiteConfirmRequest *)request Success:(void (^)(NSInteger result,NSString *msg))sucess fail:(void (^)(NSString *description))fail;

// 现场拍照接口
+(void)updataSitePhotoHttpAPI:(SitePhotoRequest *)request Success:(void (^)(NSInteger result,NSString *msg))sucess fail:(void (^)(NSString *description))fail;

//短信确认接口

+(void)updataBusiNotifyHttpAPI:(BusiNotifyRequest *)request Success:(void (^)(NSInteger result,NSString *msg))sucess fail:(void (^)(NSString *description))fail;


//短信验证码接口
+(void)updataBusiNotifyCheckHttpAPI:(BusiNotifyCheckRequest *)request Success:(void (^)(NSInteger result,NSString *msg))sucess fail:(void (^)(NSString *description))fail;

@end
