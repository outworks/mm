//
//  Track.h
//  cmm
//
//  Created by Hcat on 15/4/11.
//
//

#import <Foundation/Foundation.h>

@interface VisitTrack : NSObject

@property(nonatomic,strong) NSString * correctDate; //	走访时间	String			yyyy-mm-dd
@property(nonatomic,strong) NSString * startTime; //	开始时间	String			yyyy-MM-dd HH:mm:ss
@property(nonatomic,strong) NSString * endTime; //	结束时间	String			yyyy-MM-dd HH:mm:ss
@property(nonatomic,strong) NSString * kilometersNum; //	公里数	String
@end
