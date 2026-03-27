//
//  MessageCenterTableViewCell.m
//  RobotSweeper
//
//  Created by Joey on 2018/11/2.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "MessageCenterTableViewCell.h"

@implementation MessageCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.mainLabel];
        [self.contentView addSubview:self.subLabel];
        [self.contentView addSubview:self.timeLabel];
        [self yuesu];
        
    }
    return self;
}
#pragma mark -- ys
- (void)yuesu{
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.height.offset(20);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.height.offset(20);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.4);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    
    [_mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.bottom.equalTo(_subLabel.mas_top).offset(-10);

        
    }];
}
#pragma mark -- getter
- (UILabel *)mainLabel{
    if (!_mainLabel) {
        _mainLabel = [[UILabel alloc]init];
        _mainLabel.font = [UIFont systemFontOfSize:16];
        _mainLabel.textColor = [UIColor blackColor];
        _mainLabel.numberOfLines = 0;
        _mainLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _mainLabel;
}
- (UILabel *)subLabel{
    if (!_subLabel) {
        _subLabel = [[UILabel alloc]init];
        _subLabel.font = [UIFont systemFontOfSize:14];
        _subLabel.textColor = [UIColor blackColor];
        _subLabel.numberOfLines = 1;
        _subLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _subLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.numberOfLines = 1;
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}
@end
