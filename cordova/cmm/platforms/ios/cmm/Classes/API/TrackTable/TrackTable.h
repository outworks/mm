//
//  TrackTable.h
//  cmm
//
//  Created by Hcat on 15/4/11.
//
//

#import <Foundation/Foundation.h>
#import "LKDBHelper.h"

@interface TrackTable : NSObject

@property(nonatomic,assign) double lon	; //经度	String	非空	50
@property(nonatomic,assign) double lat	; //玮度	String	非空	50
@property(nonatomic,assign) int type	; //类型	String	非空	50	1：正常、2：离线上传、3：手动停止、4：掉线
@property(nonatomic,assign) int postionWay	; //定位方式	String	非空	50	1:GPS 2:WIFI
@property(nonatomic,strong) NSString * gatherTime	; //采集时间	String	非空	50	yyyy-MM-dd HH:mm:ss
@property(nonatomic,strong) NSString * uploadTime	; //上传时间	String	非空	50	yyyy-MM-dd HH:mm:ss
@property(nonatomic,assign) double  distance; //与上次定位点的距离	String	非空	50
@property(nonatomic,assign) int isFinish; // 是否上传完成;

@property(nonatomic,strong) NSString *userid;


-(void)save;

+(TrackTable *)loadMemberByPointTag:( NSInteger )pointTag;

@end
