//
//  SliderVC.h
//  cmm
//
//  Created by Hcat on 15/3/19.
//
//

#import "BasicVC.h"


@interface SliderVC : BasicVC

@property(nonatomic,strong)UIViewController *leftVC;
@property(nonatomic,strong)UIViewController *rightVC;
@property(nonatomic,strong)UIViewController *mainVC;

@property(nonatomic,strong)UIImage *backgroundImage;


@property(nonatomic,strong)NSMutableDictionary *dic_controllers;

@property(nonatomic,assign)BOOL canShowLeft;
@property(nonatomic,assign)BOOL canShowRight;


@property(nonatomic,assign) float leftContentOffSet; //左侧内容偏移
@property(nonatomic,assign) float rightContentOffSet; //右侧内容偏移


@property(nonatomic,assign) float leftContentScale; //左侧缩放大小
@property(nonatomic,assign) float rightContenScale; //右侧缩放大小

@property(nonatomic,assign) float leftJudgeOffSet; // 左侧判断是否划开偏移
@property(nonatomic,assign) float rightJudgeOffSet; // 右侧判断是否划开偏移

@property(nonatomic,assign) float leftOpenDuration; //左侧打开时间
@property(nonatomic,assign) float rightOpenDuration; //右侧打开时间

@property(nonatomic,assign) float leftCloseDuration; //左侧关闭时间
@property(nonatomic,assign) float rightCloseDuration; //右侧关闭时间


@property(nonatomic,assign) float leftTrantY;//左侧位移y
@property(nonatomic,assign) float rightTrantY;//右侧位移y



+(SliderVC *)shareSliderVC;
-(void)resetShareSliderVC;

-(void)showContentControllerWithModel:(NSString *)className;
-(void)showLeftViewController;
-(void)showRightViewController;

-(void)closeSideBar;

-(void)closeSideBarWithAnimate:(BOOL)bAnimate complete:(void(^)(BOOL finished))complete;


@end
