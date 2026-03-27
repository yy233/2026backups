//
//  HouseRentDetailHousesDetailCallAndChatTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/6.
//

#import "HouseRentDetailHousesDetailCallAndChatTableViewCell.h"
#define Color_OneLineGreenBtn     Y_RGBA(3, 197, 108, 1)
#define Color_LookHouseBlueBtn    Y_RGBA(38, 114, 249, 1)
@interface HouseRentDetailHousesDetailCallAndChatTableViewCell ()

@end
@implementation HouseRentDetailHousesDetailCallAndChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(HouseRentDetailVcHouseModel *)model{
    _model = model;
}
#pragma mark ==
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self.contentView addSubview:self.oneBtn];
        [self.contentView addSubview:self.onLineBtn];
        [self.contentView addSubview:self.thrBtn];
        [self setUI];
     
    }
    return self;
}
- (void)setUI{
    [_oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_oneBtn.superview.mas_centerY);
        make.left.equalTo(_oneBtn.superview.mas_left).offset(16);
        make.height.equalTo(_oneBtn.superview.mas_height).offset(-20);
        make.width.offset((Screen_W-32-20)/3);
    }];
    [_onLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_onLineBtn.superview.mas_centerY);
        make.left.equalTo(_oneBtn.mas_right).offset(10);
        make.height.equalTo(_onLineBtn.superview.mas_height).offset(-20);
        make.width.offset((Screen_W-32-20)/3);
    }];
    [_thrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_thrBtn.superview.mas_centerY);
        make.left.equalTo(_onLineBtn.mas_right).offset(10);
        make.height.equalTo(_thrBtn.superview.mas_height).offset(-20);
        make.width.offset((Screen_W-32-20)/3);
    }];
    
}
- (UIButton *)oneBtn{
    if (!_oneBtn) {
        _oneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _oneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_oneBtn setTitle:@"在线签约" forState:UIControlStateNormal];
        [_oneBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        [_oneBtn addTarget:self action:@selector(qianYueBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        if ([ThemeManager shareManager].type==ThemeType_Drak) {
            [_oneBtn setImage:[UIImage imageNamed:@"Let_Details_QianYue_W"] forState:UIControlStateNormal];
         }else{
            [_oneBtn setImage:[UIImage imageNamed:@"Let_Details_QianYue"] forState:UIControlStateNormal];
        }
        [_oneBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:5];
    }
    return _oneBtn;
}
- (UIButton *)onLineBtn{
    if (!_onLineBtn) {
        _onLineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _onLineBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_onLineBtn setTitle:@"在线了解" forState:UIControlStateNormal];
//        [_onLineBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        _onLineBtn.backgroundColor = Color_OneLineGreenBtn;
        _onLineBtn.layer.cornerRadius = 5;
        _onLineBtn.layer.masksToBounds = YES;
        [_onLineBtn addTarget:self action:@selector(onLineBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [_onLineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return _onLineBtn;
}
- (UIButton *)thrBtn{
    if (!_thrBtn) {
        _thrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _thrBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_thrBtn setTitle:@"打电话" forState:UIControlStateNormal];
//        [_thrBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        _thrBtn.backgroundColor = Color_LookHouseBlueBtn;
        _thrBtn.layer.cornerRadius = 5;
        _thrBtn.layer.masksToBounds = YES;
        [_thrBtn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    }
    [_thrBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    return _thrBtn;
}

#pragma mark== 电话
- (void)callPhone{
    if ([TextShowWithModelStr textShowWithModelStr:_model.houseContact].length>0 && [TextShowWithModelStr textShowWithModelStr:_model.houseContact].length<=11) {
        [self callPhoneWithStr:[TextShowWithModelStr textShowWithModelStr:_model.houseContact]];
    }
}
- (void)callPhoneWithStr:(NSString *)phoneStr{
 
    NSMutableString *callStr=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneStr];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callStr]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callStr] options:@{} completionHandler:nil];

    /**
     NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneStr];
     UIWebView * callWebview = [[UIWebView alloc] init];
     [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
     [self.view addSubview:callWebview];
     */
}
- (void)onLineBtnAction:(UIButton *)sender{
    NSLog(@"在线了解");
    if (_delegate && [_delegate respondsToSelector:@selector(houseRentOfOnLineChatWithModel:)]) {
        [_delegate houseRentOfOnLineChatWithModel:self.model];
    }
}
- (void)lookHouseBtnAction:(UIButton *)sender{//暂时不使用预约功能
    NSLog(@"预约看房");
    if (_delegate && [_delegate respondsToSelector:@selector(houseRentOfAppointmentActionWithModel:)]) {
        [_delegate houseRentOfAppointmentActionWithModel:self.model];
    }
}
- (void)qianYueBtnAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(houseRentOfQianYueActionWithModel:)]) {
        [_delegate houseRentOfQianYueActionWithModel:self.model];
    }
}

@end
