//
//  ZYHealthDataDeviceCell.m
//  Community
//
//  Created by ZY on 2021/11/8.
//

#import "ZYHealthDataDeviceCell.h"

@interface ZYHealthDataDeviceCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIImageView *deviceStatusImageView;

@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;



@end

@implementation ZYHealthDataDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView addSubview:self.disConBtn];
    [_disConBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_disConBtn.superview);
        make.width.offset(73);
        make.height.offset(28);
        make.right.equalTo(_disConBtn.superview.mas_right).offset(-16);
    }];
    // Initialization code
}
- (UIButton *)disConBtn{
    if (!_disConBtn) {
        _disConBtn = [[UIButton alloc]init];
        _disConBtn.backgroundColor = Y_ColorWith16FromRGB(0xFF7E6E);
        [_disConBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_disConBtn newAnBtnWithFont:[PensionThemeManager shareManager].Pension_TextFont_B13];
        [_disConBtn newAnBtnWithTextStr:@"断开连接"];
        _disConBtn.layer.cornerRadius = 5;
        [_disConBtn addTarget:self action:@selector(disConBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _disConBtn;
}
- (void)disConBtnAction{
    if (isNotNil(self.disConActionBlock)) {
        self.disConActionBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)nowDevNameSet:(NSString *)devNameStr{
    self.deviceNameLabel.text = devNameStr;
}
@end
