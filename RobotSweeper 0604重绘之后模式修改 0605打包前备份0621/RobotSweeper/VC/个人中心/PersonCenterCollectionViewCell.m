//
//  PersonCenterCollectionViewCell.m
//  RobotSweeper
//
//  Created by Joey on 2018/6/13.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "PersonCenterCollectionViewCell.h"

@implementation PersonCenterCollectionViewCell

/*
 @property (nonatomic,strong) UIImageView *imgv;
 @property (nonatomic,strong) UILabel *titleL;
 @property (nonatomic,strong) UIButton *signal;*/
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imgv];
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.signal];
        [self getNewYs];
    }
    return self;
}
//-(instancetype)init{
//    self = [super init];
//    if (self) {
//        [self.contentView addSubview:self.imgv];
//        [self.contentView addSubview:self.titleL];
//        [self.contentView addSubview:self.signal];
//        [self getNewYs];
//    }
//    return self;
//}
-(void)awakeFromNib{
    [super awakeFromNib];
    
    
}

- (void)getNewYs{
    [_imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.width.equalTo(self.contentView.mas_width).offset(-60);
        make.height.equalTo(self.contentView.mas_height).offset(-60);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.imgv.mas_bottom);
        make.width.equalTo(self.contentView.mas_width);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    [_signal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.width.offset(20);
        make.height.offset(20);
    }];
}

- (UIImageView *)imgv{
    if (!_imgv) {
        _imgv = [[UIImageView alloc]init];
        _imgv.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgv;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textAlignment = NSTextAlignmentCenter;
    }
    return _titleL;
}
- (UIButton *)signal{
    if (!_signal) {
        _signal = [UIButton buttonWithType:UIButtonTypeCustom];
        _signal.layer.cornerRadius = 10;
    }
    return _signal;
}
@end
