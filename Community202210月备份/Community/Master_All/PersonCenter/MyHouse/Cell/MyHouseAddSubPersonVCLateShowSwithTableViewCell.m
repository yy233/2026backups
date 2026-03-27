//
//  MyHouseAddSubPersonVCLateShowSwithTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/4/25.
//

#import "MyHouseAddSubPersonVCLateShowSwithTableViewCell.h"

@implementation MyHouseAddSubPersonVCLateShowSwithTableViewCell

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
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.switchV];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(150);
        make.height.offset(20);
        make.centerY.equalTo(_titleL.superview);
        make.left.equalTo(_titleL.superview).offset(32);
    }];
    [_switchV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_switchV.superview).offset(-32);
        make.centerY.equalTo(_titleL);
        make.width.offset(51);
        make.height.offset(31);
    }]; 
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"关怀模式";//是否开启手机号
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont systemFontOfSize:15.0];
    }
    return _titleL;
}
- (UISwitch *)switchV{
    if (!_switchV) {
        _switchV = [[UISwitch alloc]init];//_switchV= [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 51, 31)];
        _switchV.tintColor = [UIColor lightGrayColor];
        _switchV.onTintColor = Y_ColorWith16FromRGB(0x2672F9);
        [_switchV addTarget:self action:@selector(switchVOpenOrCloseAction:) forControlEvents:UIControlEventValueChanged];
        //_switchV.transform = CGAffineTransformMakeScale(1.0,0.70);//UISwitch大小更改 全部会变型
    }
    return _switchV;
}


- (void)switchVOpenOrCloseAction:(UISwitch *)sender{
    NSLog(@"switchVOpenOrCloseAction = %d",sender.on);
    if (isNil(self.cellSubSwitchSelectedBlock)) {
        return;
    }
    if (sender.on) {
        self.cellSubSwitchSelectedBlock(YES);
    }else{
        self.cellSubSwitchSelectedBlock(NO);
    }
    
}
@end


#pragma mark ===========================


@implementation MyHouseAddSubPersonVCLateShowSwithWithOpenPhoneOrNotOpenPhoneTableViewCell

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
        self.titleL.text = @"是否开启手机号";
  
    }
    return self;
}
@end
