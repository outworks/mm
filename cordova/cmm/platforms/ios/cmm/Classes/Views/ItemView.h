//
//  ItemView.h
//  cmm
//
//  Created by Hcat on 15/3/30.
//
//

#import <UIKit/UIKit.h>

@protocol ItemDelegate;

@interface ItemView : UIView

@property(nonatomic,weak)id<ItemDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_item;
@property (weak, nonatomic) IBOutlet UILabel *lb_itmeName;
@property (weak, nonatomic) IBOutlet UIButton *btn_item;


+ (ItemView *)initCustomView;

@end

@protocol ItemDelegate <NSObject>

-(void)ItemButtonAction:(ItemView *)itemView;

@end