//
//  PointPaopaoView.h
//  cmm
//
//  Created by Hcat on 15/4/6.
//
//

#import "Unit.h"

@protocol PointPaopaoViewDelegate;

@interface PointPaopaoView : UIView

@property(weak,nonatomic)id<PointPaopaoViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *lb_wangdian;
@property (weak, nonatomic) IBOutlet UILabel *lb_contact;
@property (weak, nonatomic) IBOutlet UILabel *lb_task;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_phone;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_SMS;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_scene;


@property (weak, nonatomic) IBOutlet UIImageView *imageV_bg;

@property(nonatomic,assign)BOOL isTakePicture; // 是否照片确认
@property(nonatomic,assign)BOOL isSMSConfirmation; // 是否短信确认
@property(nonatomic,assign)BOOL issceneConfirmation; // 是否现场确认

@property(nonatomic,strong)Unit *unit;
@property(nonatomic,strong)NSString *taskName;
@property(nonatomic,strong)NSString *taskId;


+ (PointPaopaoView *)initCustomPaopaoView;


@end


@protocol PointPaopaoViewDelegate <NSObject>

-(void)takePictureAction:(PointPaopaoView *)view;
-(void)SMSConfirmationAction:(PointPaopaoView *)view;
-(void)sceneConfirmationAction:(PointPaopaoView *)view;

@end

