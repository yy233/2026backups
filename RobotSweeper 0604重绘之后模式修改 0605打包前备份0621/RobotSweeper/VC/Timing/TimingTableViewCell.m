//
//  TimingTableViewCell.m
//  RobotSweeper
//
//  Created by Joey on 2018/3/22.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import "TimingTableViewCell.h"

@implementation TimingTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //1.加入单元格内容视图中
        self.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.textL];
        [self.contentView addSubview:self.img];
        
        //2.加入约束
        [_textL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self).offset(30);
            make.width.offset(200.0);
        }];
        
        [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self).offset(-30);
        make.width.offset(40);
    }];
    
    }
    return self;
}
//view
- (UILabel *)textL {
    if (!_textL) {
        _textL = [[UILabel alloc]init];
        _textL.font = [UIFont systemFontOfSize:15];
        
    }
    return _textL;
}


- (UIImageView *)img {
    if (!_img) {
        _img = [[UIImageView alloc]init];
        _img.contentMode = UIViewContentModeScaleAspectFit;
       
    }
    return _img;
}

//data
-(void)setStrOfSelected:(NSString *)strOfSelected{
    if ([strOfSelected isEqualToString:@"0"]) {
        _img.image = [UIImage imageNamed:@"Oval_colour"];

    }else{
        _img.image = [UIImage imageNamed:@"xuanzhong_colour"];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
