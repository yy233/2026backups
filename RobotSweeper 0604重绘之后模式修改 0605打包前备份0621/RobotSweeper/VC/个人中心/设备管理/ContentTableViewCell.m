//
//  ContentTableViewCell.m
//  RobotSweeper
//
//  Created by Joey on 2018/6/15.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import "ContentTableViewCell.h"

@implementation ContentTableViewCell

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
        _backView.backgroundColor = Y_RGB(240, 240, 240);
        
        [_backView addSubview:self.textL];
        [_backView addSubview:self.pushImgv];
        
    }
    return _backView;
}

-(UILabel *)textL{
    if (!_textL) {
        _textL = [[UILabel alloc]init];
//        _textL.backgroundColor = [UIColor whiteColor];
        _textL.numberOfLines = 3;
    }
    return _textL;
}


- (UIImageView *)pushImgv{
    if (!_pushImgv) {
        _pushImgv = [[UIImageView alloc]init];
        _pushImgv.image = Y_IMAGE(@"跳转");
        
    }
    return _pushImgv;
}

- (void)getNewYueSu{
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView);
         make.centerX.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.height.equalTo(self.contentView.mas_height).offset(-10);
        
    }];
    [_textL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_backView);
//        make.centerX.equalTo(_backView);
        make.left.equalTo(_backView.mas_left).offset(10);
        make.width.equalTo(_backView.mas_width).offset(-50);
        
    }];
    [_pushImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_backView);
        make.width.offset(20);
        make.height.offset(20);
        make.right.equalTo(_backView.mas_right).offset(-10);
    }];
    
}

@end
