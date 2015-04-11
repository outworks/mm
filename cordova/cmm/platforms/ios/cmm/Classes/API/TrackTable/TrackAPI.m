//
//  TrackAPI.m
//  cmm
//
//  Created by Hcat on 15/4/11.
//
//

#import "TrackAPI.h"
#import "LK_API.h"
#import "Track.h"

@implementation TrackAPI


+(void) visitTrackHttpAPIWithRequest:(TrackHttpRequest *)request Success:(void (^)(NSInteger result,NSString *msg))sucess fail:(void (^)(NSString *description))fail{
    
    [LK_APIUtil postHttpRequest:request apiPath:URLPATH_VISITTRACK Success:^(NSObject *response,NSInteger result,NSString *msg){
        sucess(result,msg);
    } fail:^(NSString * descript){
        fail(descript);
    }class:nil];
    
}


+(void)  trackQueryHttpAPIWithRequest:(TrackQueryHttpRequest *)request Success:(void (^)(NSArray *result,BOOL isLastPage))sucess fail:(void (^)(NSString *description))fail{

    [LK_APIUtil postHttpPageRequest:request apiPath:URLPATH_TRACKQUERY Success:^(LK_HttpBasePageResponse *response, NSInteger result, NSString *msg) {
        sucess(response.data.result,response.data.lastPage);
    } fail:^(NSString *description) {
        fail(description);
    } class:([Track class])];

}




@end
