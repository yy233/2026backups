//
//  ChatMainSetRightSwichTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/5/18.
//

#import "ChatMainSetRightSwichTableViewCell.h"

@implementation ChatMainSetRightSwichTableViewCell

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
        self.titleL.font = [UIFont systemFontOfSize:16];    
    }
    return self;
}
@end
