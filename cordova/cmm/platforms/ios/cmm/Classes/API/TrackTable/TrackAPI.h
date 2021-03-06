//
//  TrackAPI.h
//  cmm
//
//  Created by Hcat on 15/4/11.
//
//

#import <Foundation/Foundation.h>
#import "TrackHttpRequest.h"
#import "TrackHttpResponse.h"

@interface TrackAPI : NSObject


//营销经理位置(轨迹上传)

+(void) visitTrackHttpAPIWithRequest:(TrackHttpRequest *)request Success:(void (^)(NSInteger result,NSString *msg))sucess fail:(void (^)(NSString *description))fail;




//获取轨迹（每天轨迹查询统计）
+(void)  trackQueryHttpAPIWithRequest:(TrackQueryHttpRequest *)request Success:(void (^)(NSArray *result,BOOL isLastPage))sucess fail:(void (^)(NSString *description))fail;

//走访地图接口

+(void) visitMapHttpAPIWithRequest:(VisitMapHttpRequest *)request Success:(void (^)(NSArray *result))sucess fail:(void (^)(NSString *description))fail;

//14.	轨迹导航查询

+(void) trackListHttpAPIWithRequest:(TrackListHttpRequest *)request Success:(void (^)(TrackListHttpResponse *response,NSInteger result,NSString *msg))sucess fail:(void (^)(NSString *description))fail;

@end
