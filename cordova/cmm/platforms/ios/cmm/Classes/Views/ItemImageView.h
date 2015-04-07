//
//  ItemImageView.h
//  cmm
//
//  Created by Hcat on 15/4/7.
//
//

#import <UIKit/UIKit.h>

@protocol ItemImageViewDelegate;
@interface ItemImageView : UIView

@property(weak,nonatomic) id<ItemImageViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *btn_close;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (assign,nonatomic) BOOL isAdd;

+ (ItemImageView *)initCustomView;

@end


@protocol ItemImageViewDelegate <NSObject>

-(void)imageViewAction:(ItemImageView *)view;
-(void)imageViewDelAction:(ItemImageView *)view;

@end