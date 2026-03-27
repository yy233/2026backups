//
//  RobotSetTableViewCell.m
//  RobotSweeper
//
//  Created by Joey on 2018/5/8.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import "RobotSetTableViewCell.h"

@implementation RobotSetTableViewCell

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
        [self.contentView addSubview:self.backView];
        [self getNewYueSu];
        
    }
    return self;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor whiteColor];
        
         [_backView addSubview:self.textL];
         [_backView addSubview:self.upImgV];
         [_backView addSubview:self.pushImgv];
        
    }
    return _backView;
}

-(UILabel *)textL{
    if (!_textL) {
        _textL = [[UILabel alloc]init];
        _textL.backgroundColor = [UIColor whiteColor];
    }
    return _textL;
}

- (UIImageView *)upImgV{
    if (!_upImgV) {
        _upImgV = [[UIImageView alloc]init];
        _upImgV.backgroundColor = [UIColor redColor];
        _upImgV.layer.cornerRadius = 8;//16
    }
    return _upImgV;
}
- (UIImageView *)pushImgv{
    if (!_pushImgv) {
        _pushImgv = [[UIImageView alloc]init];
//        _pushImgv.image = [UIImage imageNamed:@"跳转"];
    }
    return _pushImgv;
}

- (void)getNewYueSu{
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.equalTo(self.contentView.mas_height);
        
    }];
    [_textL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_backView);
        make.left.equalTo(_backView.mas_left).offset(10);
        make.width.offset(160);
 
    }];
    [_pushImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_backView);
        make.width.offset(20);
        make.height.offset(20);
        make.right.equalTo(_backView.mas_right).offset(-10);
    }];
    [_upImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_backView);
        make.width.offset(16);
        make.height.offset(16);
        make.right.equalTo(_pushImgv.mas_left).offset(-10);
    }];

}
@end
