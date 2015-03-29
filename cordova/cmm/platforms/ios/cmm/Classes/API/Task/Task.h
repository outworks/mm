//
//  Task.h
//  cmm
//
//  Created by ilikeido on 15-3-29.
//
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property(nonatomic,strong) NSString *	id	;//任务ID
@property(nonatomic,strong) NSString *	regionId	;//所属区域
@property(nonatomic,strong) NSString *	userId	;//创建者村
@property(nonatomic,strong) NSString *	visitnum	;//任务编号
@property(nonatomic,strong) NSString *	name	;//任务名称
@property(nonatomic,strong) NSString *	starttime	;//任务开始时间
@property(nonatomic,strong) NSString *	endtime	;//任务结束时间
@property(nonatomic,strong) NSString *	typeid	;//任务类型
@property(nonatomic,strong) NSString *	typeidLabel	;//任务类型名称
@property(nonatomic,strong) NSString *	opetypeid	;//任务操作类型
@property(nonatomic,strong) NSString *	opetypeidLabel	;//任务操作类型名称
@property(nonatomic,strong) NSString *	smstemplate	;//短信模板
@property(nonatomic,strong) NSString *	describe	;//描述
@property(nonatomic,strong) NSString *	countyid	;//区县ID
@property(nonatomic,strong) NSString *	districtid	;//片区ID
@property(nonatomic,strong) NSString *	unittypeid	;//渠道类型
@property(nonatomic,strong) NSString *	boutiquetype	;//专营店类型
@property(nonatomic,strong) NSString *	unitgradeid	;//渠道星级
@property(nonatomic,strong) NSString *	isall	;//是否全部网点
@property(nonatomic,strong) NSString *	isinput	;//是否导入渠道
@property(nonatomic,strong) NSString *	isfinish	;//是否完成
@property(nonatomic,strong) NSString *	finishtime	;//任务完成时间
@property(nonatomic,strong) NSString *	smsDate	;//短信催办时间
@property(nonatomic,strong) NSString *	marketingmanagerid	;//营销经理ID
@property(nonatomic,strong) NSString *	marketingmanagername	;//营销经理名称


@end
