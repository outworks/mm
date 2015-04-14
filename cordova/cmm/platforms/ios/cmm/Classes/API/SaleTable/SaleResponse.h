//
//  SaleResponse.h
//  cmm
//
//  Created by Hcat on 15/3/29.
//
//

#import "LK_HttpResponse.h"

@interface SaleResponse : NSObject

@property(nonatomic,strong) NSNumber *regionId;	//区域
@property(nonatomic,strong) NSNumber *unitid;	//渠道ID
@property(nonatomic,strong) NSNumber *saleType;	//	销售类型
@property(nonatomic,strong) NSNumber *curMonthTargetCount;	//	本月目标值
@property(nonatomic,strong) NSNumber *totalCount;	//	累计完成量
@property(nonatomic,strong) NSNumber *curDayCount	;	//当日完成量
@property(nonatomic,strong) NSNumber *lastMonthCount;	//	上月同期入网量
@property(nonatomic,strong) NSNumber *lastMonthRitio;	//	上月环比
@property(nonatomic,strong) NSNumber *saleCount;	//	有销量
@property(nonatomic,strong) NSNumber *unitCount;	//	有销量
@property(nonatomic,strong) NSNumber *avgSaleCount;	//	平均销量
@property(nonatomic,strong) NSNumber *highestSaleCount;	//	最高销量
@property(nonatomic,strong) NSString * busiType;	//	业务类型
@property(nonatomic,strong) NSString *busiTypeLabel;	//	业务类型名称
@property(nonatomic,strong) NSNumber *curMonthFinishRitio;	//	本月完成率

@property(nonatomic,strong) NSString *regionRank; //区域排名


@end
