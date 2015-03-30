//
//  BasicVC.h
//  cmm
//
//  Created by Hcat on 15/3/19.
//
//

#import <UIKit/UIKit.h>
#import "UtilsMacro.h"
#import "NoticeMacro.h"


@interface BasicVC : UIViewController

@property (nonatomic, strong) UIView *v_nav;
@property (nonatomic, strong) UIView *v_leftItem;
@property (nonatomic, strong) UIView *v_rightItem;
@property (nonatomic, strong) NSString *navTitle;

- (void)createNavWithTitle:(NSString *)t_title withbgImage:(UIImage *)bgImage createMenuItem:(UIView *(^)(int index))menuItem;


@end
