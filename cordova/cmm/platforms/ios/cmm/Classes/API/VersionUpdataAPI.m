//
//  VersionUpdataAPI.m
//  cmm
//
//  Created by Hcat on 15/5/11.
//
//

#import "VersionUpdataAPI.h"
#import "LK_API.h"

@implementation VersionUpdataRequest

@end

@implementation VersionUpdataResponse

@end


@implementation VersionUpdataAPI

+(void)versionUpdataHttpAPI:(VersionUpdataRequest *)request Success:(void (^)(VersionUpdataResponse *response,NSInteger result,NSString *msg))sucess fail:(void (^)(NSString *description))fail{

    [LK_APIUtil postHttpRequest:request apiPath:URLPATH_CLIENTVERSION Success:^(NSObject *response,NSInteger result,NSString *msg){
    
        sucess((VersionUpdataResponse *)response,result,msg);
    } fail:^(NSString * descript){
        fail(descript);
    }class:[VersionUpdataResponse class]];

}

@end
