//
//  MainVC.h
//  cmm
//
//  Created by Hcat on 15/3/20.
//
//

#import "BasicVC.h"
#import "SliderVC.h"

@interface MainVC : BasicVC

@property(strong,nonatomic)UITabBarController *vc_tab;
@property(weak,nonatomic)SliderVC *sliderVC;

@end
