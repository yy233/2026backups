//
//  HealthBaseTotalDataContTouchTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/11/19.
//

#import "HealthBaseTotalDataContTouchTableViewCell.h"

@implementation HealthBaseTotalDataContTouchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
 
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
@end
