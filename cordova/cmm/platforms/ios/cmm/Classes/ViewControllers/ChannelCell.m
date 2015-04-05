//
//  ChannelCell.m
//  cmm
//
//  Created by ilikeido on 15-3-31.
//
//

#import "ChannelCell.h"
#import "UIColor+External.h"

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
    if (![unit.isFinish isEqual:@"1"]) {
        _lb_state.text = @"正在进行";
        _lb_state.textColor = HEX_RGB(0xfc0000);
    }else{
        _lb_state.text = @"已完成";
        _lb_state.textColor = HEX_RGB(0x55c55a);
    }
    _lb_name.text = unit.unitname;
}


@end
