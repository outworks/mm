//
//  TrackTable.h
//  cmm
//
//  Created by Hcat on 15/4/11.
//
//

#import <Foundation/Foundation.h>

@interface TrackTable : NSObject

@property(nonatomic,assign) double lon	; //经度	String	非空	50
@property(nonatomic,assign) double lat	; //玮度	String	非空	50
@property(nonatomic,strong) NSString * type	; //类型	String	非空	50	1：正常、2：离线上传、3：手动停止、4：掉线
@property(nonatomic,strong) NSString * postionWay	; //定位方式	String	非空	50	1:GPS 2:WIFI
@property(nonatomic,strong) NSString * gatherTime	; //采集时间	String	非空	50	yyyy-MM-dd HH:mm:ss
@property(nonatomic,strong) NSString * uploadTime	; //上传时间	String	非空	50	yyyy-MM-dd HH:mm:ss
@property(nonatomic,strong) NSString * kilometersNum	; //公里数	String	非空	50
@property(nonatomic,assign) NSInteger pointTag;  // 点的标志位


-(void)save;



@end
