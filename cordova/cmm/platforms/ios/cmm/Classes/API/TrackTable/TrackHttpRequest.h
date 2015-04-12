//
//  TrackHttpRequest.h
//  cmm
//
//  Created by Hcat on 15/4/11.
//
//

#import "LK_HttpRequest.h"

@interface TrackHttpRequest : LK_HttpBaseRequest


@property(nonatomic,strong) NSString * userId;	//用户名	String	非空	50
@property(nonatomic,strong) NSString * lon;	//经度	String	非空	50
@property(nonatomic,strong) NSString * lat;	//玮度	String	非空	50
@property(nonatomic,strong) NSString * type;	//类型	String	非空	50	1：正常、2：离线上传、3：手动停止、4：掉线
@property(nonatomic,strong) NSString * postionWay;	//定位方式	String	非空	50	1:GPS 2:WIFI
@property(nonatomic,strong) NSString * gatherTime;	//采集时间	String	非空	50	yyyy-MM-dd HH:mm:ss
@property(nonatomic,strong) NSString * uploadTime;	//上传时间	String	非空	50	yyyy-MM-dd HH:mm:ss
@property(nonatomic,strong) NSString * kilometersNum;	//公里数	String	非空	50


@end


//.	获取轨迹

@interface TrackQueryHttpRequest : LK_HttpBasePageRequest

@property(nonatomic,strong) NSString * userId;	//	用户名	String	非空	50
@property(nonatomic,strong) NSString * startTime;	//	开始时间	String			yyyy-MM-dd HH:mm:ss
@property(nonatomic,strong) NSString * endTime;	//	结束时间	String			yyyy-MM-dd HH:mm:ss
@property(nonatomic,strong) NSString * orderDirection;	//	排序（时间正反序）	String	可空		默认ASC:升序 DESC 降序

@end

// 走访地图

@interface VisitMapHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString * userId; //	用户名	String	非空
@property(nonatomic,strong) NSString * lon; //	经度	String
@property(nonatomic,strong) NSString * lat; //	纬度	String

@end

// 走访地图

@interface TrackListHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString * userId; //	用户名	String	非空
@property(nonatomic,strong) NSString * correctDate; //	经度	String

@end




