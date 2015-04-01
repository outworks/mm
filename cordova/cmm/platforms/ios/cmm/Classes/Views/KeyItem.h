//
//  KeyItem.h
//  cmm
//
//  Created by Hcat on 15/4/1.
//
//

#import <UIKit/UIKit.h>
#import "KACircleProgressView.h"
#import "SaleResponse.h"

@interface KeyItem : UIView


@property(nonatomic,strong)SaleResponse *data_sale;

@property (nonatomic, strong)KACircleProgressView *v_progress;


@property (weak, nonatomic) IBOutlet UILabel *lb_curMonthCount;
@property (weak, nonatomic) IBOutlet UILabel *lb_wancheng;
@property (weak, nonatomic) IBOutlet UILabel *lb_doneCount;

@property (weak, nonatomic) IBOutlet UILabel *lb_todayCount;
@property (weak, nonatomic) IBOutlet UILabel *lb_quyu; // 区域排名
@property (weak, nonatomic) IBOutlet UILabel *lb_wangdianCount;
@property (weak, nonatomic) IBOutlet UILabel *lb_pingjunCount;
@property (weak, nonatomic) IBOutlet UILabel *lb_zuigaoCount;

+ (KeyItem *)initCustomView;
@end
