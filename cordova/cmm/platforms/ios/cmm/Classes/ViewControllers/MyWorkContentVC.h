//
//  MyWorkContentVC.h
//  cmm
//
//  Created by Hcat on 15/4/15.
//
//

#import <UIKit/UIKit.h>
#import "Menu.h"

@interface MyWorkContentVC : UIViewController


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *lb_info;


@property (strong,nonatomic) NSMutableArray *arr_item;
@property (strong,nonatomic) Menu *menu_p;

@end
