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
@property(nonatomic,strong) NSString *bossname;
@property(nonatomic,strong) NSString *bossphonenum;
@property(nonatomic,strong) NSString *boutiquetype;
@property(nonatomic,strong) NSString *gpslat;
@property(nonatomic,strong) NSString *gpslon;
@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString *lat;
@property(nonatomic,strong) NSString *lon;
@property(nonatomic,strong) NSString *marketingmanagerid;
@property(nonatomic,strong) NSString *unitgradeid;
@property(nonatomic,strong) NSString *unitname;
@property(nonatomic,strong) NSString *unitnum;
@property(nonatomic,strong) NSString *unittypeid;
@property(nonatomic,strong) NSString *isFinish;

@property(nonatomic,strong) NSString *sitePhoto;

-(void)addPhotoImage:(NSString *)imageurl;
@end
