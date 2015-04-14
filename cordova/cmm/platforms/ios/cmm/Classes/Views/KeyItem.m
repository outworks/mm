//
//  KeyItem.m
//  cmm
//
//  Created by Hcat on 15/4/1.
//
//

#import "KeyItem.h"
#import "UtilsMacro.h"

@implementation KeyItem

+ (KeyItem *)initCustomView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"KeyItem" owner:self options:nil];
    
    return [nibView objectAtIndex:0];
    
}


- (void)setNeedsDisplay{
    if (_v_progress == nil) {
        _v_progress = [[KACircleProgressView alloc] initWithSize:110 withType:KACircleProgressViewTypeCircleBacked andProgressBarLineWidth:6 andCircleBackLineWidth:6];
        [_v_progress setProgress:0.000001];
        [_v_progress setColorOfBackCircle:UIColorFromRGB(0xf2f2f2)];
        [_v_progress setColorOfProgressBar:UIColorFromRGB(0x1fbbff)];
        [self addSubview:_v_progress];
        [_v_progress setCenter:CGPointMake(ScreenWidth/2,90)];
    }
}



-(void)setData_sale:(SaleResponse *)data_sale{

    if (data_sale != nil) {
        
        _data_sale = data_sale;
        
        _lb_curMonthCount.text =  [data_sale.curMonthTargetCount stringValue];
        _lb_doneCount.text = [data_sale.totalCount stringValue];
//        _lb_wancheng.text = [NSString stringWithFormat:@"%ld%%",[data_sale.totalCount integerValue]/[data_sale.curMonthTargetCount integerValue]*100];
//        [_v_progress setProgress:[data_sale.totalCount integerValue]/[data_sale.curMonthTargetCount integerValue]*100]; // set progress to 0.3 out of 1.0
        _lb_wancheng.text = [NSString stringWithFormat:@"%ld",[data_sale.curMonthFinishRitio integerValue]];
        [_v_progress setProgress:[data_sale.curMonthFinishRitio integerValue]]; // set progress to 0.3 out of 1.0
        _lb_quyu.text = data_sale.regionRank;
        _lb_todayCount.text = [data_sale.curDayCount stringValue];
        
        _lb_wangdianCount.text = [NSString stringWithFormat:@"%ld/%ld",[data_sale.saleCount integerValue],[data_sale.unitCount integerValue]];;
        _lb_pingjunCount.text = [data_sale.avgSaleCount stringValue];[data_sale.highestSaleCount integerValue];
        _lb_zuigaoCount.text = [data_sale.highestSaleCount stringValue];
        
    }

}

@end
