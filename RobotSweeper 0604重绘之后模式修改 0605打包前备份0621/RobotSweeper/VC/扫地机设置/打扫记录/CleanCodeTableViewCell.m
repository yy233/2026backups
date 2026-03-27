//
//  CleanCodeTableViewCell.m
//  RobotSweeper
//
//  Created by Joey on 2018/12/17.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "CleanCodeTableViewCell.h"

@implementation CleanCodeTableViewCell

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
        [self.contentView addSubview:self.oneTextLabel];
        [self.contentView addSubview:self.twoTextLabel];
//        [self.contentView addSubview:self.thrTextLabel];
        [self yuesu];
        
    }
    return self;
}
#pragma mark -- ys
- (void)yuesu{
    [_oneTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-80);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    [_twoTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(20);
        make.left.equalTo(_oneTextLabel.mas_right).offset(2);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        
    }];
    
    
    
//    [_thrTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.right.equalTo(self.contentView.mas_right).offset(-20);
//        make.height.offset(20);
//        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.4);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
//    }];
}
#pragma mark -- getter
- (UILabel *)oneTextLabel{
    if (!_oneTextLabel) {
        _oneTextLabel = [[UILabel alloc]init];
        _oneTextLabel.font = [UIFont systemFontOfSize:16];
        _oneTextLabel.textColor = [UIColor blackColor];
        _oneTextLabel.numberOfLines = 0;
        _oneTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _oneTextLabel;
}
- (UILabel *)twoTextLabel{
    if (!_twoTextLabel) {
        _twoTextLabel = [[UILabel alloc]init];
        _twoTextLabel.font = [UIFont systemFontOfSize:14];
        _twoTextLabel.textColor = [UIColor grayColor];
        _twoTextLabel.numberOfLines = 0;
        _twoTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _twoTextLabel;
}
//- (UILabel *)thrTextLabel{
//    if (!_thrTextLabel) {
//        _thrTextLabel = [[UILabel alloc]init];
//        _thrTextLabel.font = [UIFont systemFontOfSize:13];
//        _thrTextLabel.textColor = [UIColor lightGrayColor];
//        _thrTextLabel.numberOfLines = 0;
//        _thrTextLabel.textAlignment = NSTextAlignmentRight;
//    }
//    return _thrTextLabel;
//}
@end
