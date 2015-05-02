//
//  Unit.h
//  cmm
//
//  Created by ilikeido on 15-4-4.
//
//

#import <Foundation/Foundation.h>

@interface Unit : NSObject

@property(nonatomic,strong) NSString *addr;
@property(nonatomic,strong) NSString * addtime;
@property(nonatomic,strong) NSString * addtimeString;
@property(nonatomic,strong) NSString * adduserid;
@property(nonatomic,strong) NSString * areaid;

@property(nonatomic,strong) NSString *bossname;
@property(nonatomic,strong) NSString *bossphonenum;
@property(nonatomic,strong) NSString *boutiquetype;
@property(nonatomic,strong) NSString *certifyornot;

@property(nonatomic,strong) NSString * cooperationmode;
@property(nonatomic,strong) NSString * countyid;
@property(nonatomic,strong) NSString * districtid;
@property(nonatomic,strong) NSString * districtname;

@property(nonatomic,strong) NSString *gpslat;
@property(nonatomic,strong) NSString *gpslon;
@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString * imageflag;
@property(nonatomic,strong) NSString * isTask;
@property(nonatomic,strong) NSString * isexclusive;
@property(nonatomic,strong) NSString *lat;
@property(nonatomic,strong) NSString *lon;
@property(nonatomic,strong) NSString *marketingmanagerid;

@property(nonatomic,strong) NSString * modtime;
@property(nonatomic,strong) NSString * modtimeString;
@property(nonatomic,strong) NSString * moduserid;
@property(nonatomic,strong) NSString * monavgsale;
@property(nonatomic,strong) NSString * monterminalsale;
@property(nonatomic,strong) NSString * monthlyrent;
@property(nonatomic,strong) NSString * note;
@property(nonatomic,strong) NSString * obtainway;
@property(nonatomic,strong) NSString * status;
@property(nonatomic,strong) NSString * storecount;
@property(nonatomic,strong) NSArray * task;
@property(nonatomic,strong) NSString * telecomsOperator;

@property(nonatomic,strong) NSString *unitgradeid;
@property(nonatomic,strong) NSString *unitname;
@property(nonatomic,strong) NSString *unitnum;
@property(nonatomic,strong) NSString *unittypeid;
@property(nonatomic,strong) NSString *isFinish;
@property(nonatomic,strong) NSString *takeapicturetime;//现场拍照时间
@property(nonatomic,strong) NSString *affirmtime;//现场确认时间
@property(nonatomic,strong) NSString *affirmLon;//现场确认经度
@property(nonatomic,strong) NSString *affirmLat;//现场确认维度
@property(nonatomic,strong) NSString *busiinformsmscode;//业务通知-短信验证码
@property(nonatomic,strong) NSString *busiinformtime;//业务通知-完成时间
@property(nonatomic,strong) NSString *busiinformsmsPhone;//业务通知电话

@property(nonatomic,strong) NSString *sitePhoto;

-(void)addPhotoImage:(NSString *)imageurl;

@end
