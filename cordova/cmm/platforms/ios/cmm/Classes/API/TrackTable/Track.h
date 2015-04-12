//
//  Track.h
//  cmm
//
//  Created by Hcat on 15/4/13.
//
//

#import <Foundation/Foundation.h>

@interface Track : NSObject

@property(nonatomic,strong) NSString * id; //	ID	String
@property(nonatomic,strong) NSString * lon; //	经度	String
@property(nonatomic,strong) NSString * lat; //	纬度	String
@property(nonatomic,strong) NSString * interval; //	轨迹间隔	String
@property(nonatomic,strong) NSString * marketingmanagerid; //	营销经理ID	String
@property(nonatomic,strong) NSString * type; //	类型	String			1：正常、2：离线上传、3：手动停止、4：掉线
@property(nonatomic,strong) NSString * unitinfoid; //	机构ID	String
@property(nonatomic,strong) NSString * correctTime; //	校准时间	String


@end
