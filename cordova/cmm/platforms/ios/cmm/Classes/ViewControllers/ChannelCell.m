//
//  ChannelCell.m
//  cmm
//
//  Created by ilikeido on 15-3-31.
//
//

#import "ChannelCell.h"

@interface ChannelCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_state;

@property (weak, nonatomic) IBOutlet UILabel *lb_name;

@end

@implementation ChannelCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUnit:(Unit *)unit{
    _unit = unit;
    _lb_state.text = @"正在进行";
    _lb_name.text = unit.unitname;
}


@end
