//
//  VisitLocusCell.h
//  cmm
//
//  Created by Hcat on 15/4/13.
//
//

#import <UIKit/UIKit.h>
#import "VisitTrack.h"

@interface VisitLocusCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_date;
@property (weak, nonatomic) IBOutlet UILabel *lb_startTime;
@property (weak, nonatomic) IBOutlet UILabel *lb_endTime;

@property (weak, nonatomic) IBOutlet UILabel *lb_goTime;

@property (weak, nonatomic) IBOutlet UILabel *lb_kilo;

@property(nonatomic,strong) VisitTrack *track;

@end
