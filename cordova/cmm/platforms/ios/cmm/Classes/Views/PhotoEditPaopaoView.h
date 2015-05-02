//
//  PhotoEditPaopaoView.h
//  cmm
//
//  Created by Hcat on 15/4/7.
//
//

#import <UIKit/UIKit.h>
#import "Unit.h"

@protocol PhotoEditPaopaoViewDelegate;

@interface PhotoEditPaopaoView : UIView

@property (weak,nonatomic) id<PhotoEditPaopaoViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *lb_wangdian;
@property (weak, nonatomic) IBOutlet UILabel * tx_lbname;
@property (weak, nonatomic) IBOutlet UILabel *lb_task;
@property (weak, nonatomic) IBOutlet UILabel *lb_state;

@property (weak, nonatomic) IBOutlet UIButton *btn_send;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_bg;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong)Unit *unit;
@property(nonatomic,strong)NSString *taskName;
@property(nonatomic,strong)NSString *taskId;

+ (PhotoEditPaopaoView *)initCustomPaopaoView;

+ (PhotoEditPaopaoView *)initFinishPaopaoView;

-(void)addPhotoImage:(NSString *)imageurl;

-(NSString *)photoParams;

@end


@protocol PhotoEditPaopaoViewDelegate <NSObject>

@required

-(void)addPhoneAction:(PhotoEditPaopaoView *)view;

-(void)photoSendAction:(PhotoEditPaopaoView *)view;

@end

