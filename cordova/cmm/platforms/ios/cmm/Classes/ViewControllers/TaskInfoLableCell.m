//
//  TaskInfoLableCell.m
//  cmm
//
//  Created by ilikeido on 15-3-31.
//
//

#import "TaskInfoLableCell.h"

@interface TaskInfoLableCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_state;

@property (weak, nonatomic) IBOutlet UILabel *lb_name;

@end

@implementation TaskInfoLableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
