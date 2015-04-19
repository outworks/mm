//
//  UnitCell.h
//  cmm
//
//  Created by ilikeido on 15/4/19.
//
//

#import <UIKit/UIKit.h>
#import "Unit.h"

@interface UnitCell : UITableViewCell

@property(nonatomic,strong) Unit *unit;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_contact;
@property (weak, nonatomic) IBOutlet UILabel *lb_telecom;


@end
