//
//  PointPaopaoView.h
//  cmm
//
//  Created by Hcat on 15/4/6.
//
//

#import "Unit.h"

@protocol UnitTaskPaopaoViewDelegate;


@interface UnitTaskPaopaoView : UIView


@property (weak, nonatomic) IBOutlet UILabel *lb_wangdian;
@property (weak, nonatomic) IBOutlet UILabel *lb_contact;
@property (weak, nonatomic) IBOutlet UILabel *lb_task;


@property(nonatomic,strong)Unit *unit;

@property(nonatomic,weak)id<UnitTaskPaopaoViewDelegate> delegate;

+ (UnitTaskPaopaoView *)initCustomPaopaoView;


@end

@protocol UnitTaskPaopaoViewDelegate <NSObject>

-(void)beginTask:(UnitTaskPaopaoView *)unitTaskPaopaoView;

@end


