//
//  TimmerListTableViewCell.m
//  RobotSweeper
//
//  Created by Joey on 2018/4/16.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import "TimmerListTableViewCell.h"

@implementation TimmerListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
    
        [self addview];
    }
    return self;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addview{
     [self.contentView addSubview:self.beginTimerTitleL];
     [self.contentView addSubview:self.beginTimerL];
     [self.contentView addSubview:self.modelTitleL];
     [self.contentView addSubview:self.modelL];
     [self.contentView addSubview:self.strengthTitleL];
     [self.contentView addSubview:self.strengthL];
     [self.contentView addSubview:self.repeatTitleL];
     [self.contentView addSubview:self.repeatL];
     [self.contentView addSubview:self.offAndOnSwitch];
     [self viewMask];

}
- (void)viewMask{
    [_beginTimerTitleL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.height.offset(20);
        make.left.equalTo(self.mas_left).offset(10);
        make.width.offset(70);
    }];
    [_beginTimerL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.height.offset(20);
        make.left.equalTo(self.beginTimerTitleL.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    [_modelTitleL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.beginTimerTitleL.mas_bottom).offset(5);
        make.height.offset(20);
        make.left.equalTo(self.mas_left).offset(10);
        make.width.offset(70);
    }];
    [_modelL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.beginTimerL.mas_bottom).offset(5);
        make.height.offset(20);
        make.left.equalTo(self.beginTimerTitleL.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    [_strengthTitleL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.modelTitleL.mas_bottom).offset(5);
        make.height.offset(20);
        make.left.equalTo(self.mas_left).offset(10);
        make.width.offset(70);

    }];
    [_strengthL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.modelL.mas_bottom).offset(5);
        make.height.offset(20);
        make.left.equalTo(self.beginTimerTitleL.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);

    }];
    [_repeatTitleL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.strengthTitleL.mas_bottom).offset(5);
        make.height.offset(20);
        make.left.equalTo(self.mas_left).offset(10);
        make.width.offset(70);

    }];
    [_repeatL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.strengthL.mas_bottom).offset(5);
        make.height.offset(20);
        make.left.equalTo(self.beginTimerTitleL.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    //switch
    [_offAndOnSwitch mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.modelL.mas_top).offset(5);
        make.height.offset(20);
        make.width.offset(70);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
}


- (void)dataSource{
    
}
#pragma mark -- getter

- (UILabel*)beginTimerTitleL{
    if (!_beginTimerTitleL) {
        _beginTimerTitleL = [[UILabel alloc]init];
        _beginTimerTitleL.text = @"开始时间";
        _beginTimerTitleL.textAlignment = NSTextAlignmentCenter;
    }
    
    return _beginTimerTitleL;
}

- (UILabel*)beginTimerL{
    if (!_beginTimerL) {
        _beginTimerL = [[UILabel alloc]init];
        _beginTimerL.text = @"12:30";
        _beginTimerL.textAlignment = NSTextAlignmentLeft;
    }
    
    return _beginTimerL;
}

- (UILabel*)modelTitleL{
    if (!_modelTitleL) {
        _modelTitleL = [[UILabel alloc]init];
        _modelTitleL.text = @"清扫模式";
        _modelTitleL.textAlignment = NSTextAlignmentCenter;
    }
    return _modelTitleL;
}

- (UILabel*)modelL{
    if (!_modelL) {
        _modelL = [[UILabel alloc]init];
        _modelL.text = @"区域清扫";
        _modelL.textAlignment = NSTextAlignmentLeft;
    }
    return _modelL;
}

- (UILabel*)strengthTitleL{
    if (!_strengthTitleL) {
        _strengthTitleL = [[UILabel alloc]init];
        _strengthTitleL.text = @"清扫力度";
        _strengthTitleL.textAlignment = NSTextAlignmentCenter;
    }
    return _strengthTitleL;
}

- (UILabel*)strengthL{
    if (!_strengthL) {
        _strengthL = [[UILabel alloc]init];
        _strengthL.text = @"标准";
        _strengthL.textAlignment = NSTextAlignmentLeft;
        
    }
    return _strengthL;
}

- (UILabel*)repeatTitleL{
    if (!_repeatTitleL) {
        _repeatTitleL = [[UILabel alloc]init];
        _repeatTitleL.text = @"重复规则";
        _repeatTitleL.textAlignment = NSTextAlignmentCenter;
    }
    return _repeatTitleL;
}

- (UILabel*)repeatL{
    if (!_repeatL) {
        _repeatL = [[UILabel alloc]init];
        _repeatL.text = @"周一";
        _strengthL.textAlignment = NSTextAlignmentLeft;
    }
    return _repeatL;
}

- (UISwitch *)offAndOnSwitch{
    if (!_offAndOnSwitch) {
        _offAndOnSwitch = [[UISwitch alloc]init];
        _offAndOnSwitch.on = YES;
        
    }
    return _offAndOnSwitch;
}

@end
