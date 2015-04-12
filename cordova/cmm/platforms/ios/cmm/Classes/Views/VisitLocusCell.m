//
//  VisitLocusCell.m
//  cmm
//
//  Created by Hcat on 15/4/13.
//
//

#import "VisitLocusCell.h"
#import "NSDate+Helper.h"

@implementation VisitLocusCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setTrack:(VisitTrack *)track{

    if (track != nil) {
        _track = track;
        
        NSDate *starTime = [NSDate dateFromString:track.startTime];
        NSDate *endTime = [NSDate dateFromString:track.endTime];
        
        NSTimeInterval  timeInterval = [endTime timeIntervalSinceDate:starTime];
        
        _lb_date.text = _track.correctDate;
//        _lb_endTime.text = _track.endTime;
//        _lb_startTime.text = _track.startTime;
        _lb_goTime.text = [NSString stringWithFormat:@"%.2f",timeInterval = timeInterval/3600];
        _lb_kilo.text = [NSString stringWithFormat:@"%.1f",[_track.kilometersNum doubleValue]/1000];
    
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
