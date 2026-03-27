//
//  PensionSOSEmergencyCallTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/12/3.
//

#import "PensionSOSEmergencyCallTableViewCell.h"




@implementation PensionSOSEmergencyCallTableViewCell

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
        [self.contentView addSubview:self.cellMainBtn];
        [self.contentView addSubview:self.cellMainLabel];
        [self.contentView addSubview:self.cellEditBtn];
        [self setBaseUI];
    }
    return self;
}
- (void)setBaseUI{
 
 
    [_cellMainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cellMainBtn.superview).offset(5);
        make.centerX.equalTo(_cellMainBtn.superview);
        make.width.offset(130);
        make.height.offset(45);
    }];
    [_cellMainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cellMainBtn.mas_bottom).offset(5);
        make.centerX.equalTo(_cellMainLabel.superview);
        make.width.equalTo(_cellMainLabel.superview).multipliedBy(0.8);
    }];
    [_cellEditBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cellMainLabel.mas_bottom).offset(5);
        make.centerX.equalTo(_cellEditBtn.superview);
        make.width.offset(50);
        make.height.offset(25);
    }];

}

#pragma MARK ===
- (UIButton *)cellMainBtn{
    if (!_cellMainBtn) {
        _cellMainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cellMainBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:18]];
        [_cellMainBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        [_cellMainBtn addTarget:self action:@selector(cellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _cellMainBtn;
}
- (UILabel *)cellMainLabel{
    if (!_cellMainLabel) {
        _cellMainLabel = [[UILabel alloc]init];
        _cellMainLabel.font = [PensionThemeManager shareManager].Pension_TextFont_15;
        _cellMainLabel.textColor = Y_ColorWith16FromRGB(0x6E727D);
        _cellMainLabel.textAlignment = NSTextAlignmentCenter;
        _cellMainLabel.numberOfLines = 0;
    }
    return _cellMainLabel;
}
- (UIButton *)cellEditBtn{
    if (!_cellEditBtn) {
        _cellEditBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cellEditBtn newAnBtnWithFont:[PensionThemeManager shareManager].Pension_TextFont_15];
        [_cellEditBtn newAnBtnWithTextColor:Color_Green_BtnShow];
        [_cellEditBtn newAnBtnWithTextStr:@"修改"];
        [_cellEditBtn newAnBtnWithImg:[UIImage imageNamed:@"yl_all＿skip"]];
        [_cellEditBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:5];
        [_cellEditBtn addTarget:self action:@selector(cellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cellEditBtn;
}

#pragma mark ==

- (void)cellBtnAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(touchCellSubBtnAction:)]) {
        [_delegate touchCellSubBtnAction:sender];
    }
}
- (void)showEmergencyCallWithHaveInfoBool:(BOOL)haveInfo{
    if (haveInfo) {
        _cellMainBtn.tag = Tag_PensionSOSMainCellSubBtn_EmergencyCall;
        [_cellMainBtn newAnBtnWithTextStr:@"紧急呼救"];
        [_cellMainBtn newAnBtnWithImg:[UIImage imageNamed:@"yl_jjhj"]];
        [_cellMainBtn newAnBtnWithTextColor:[UIColor whiteColor] withBackColor:Color_Red_BtnShow withFont:[UIFont boldSystemFontOfSize:18] withLayerCorNerNum:5.0 withLayerLineWidth:2.0 withLayerLineColor:Color_Red_BtnShow];
        [_cellMainBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(130);
        }];
        _cellMainLabel.text = @"SOS通讯录";
        _cellEditBtn.hidden = NO;
        _cellEditBtn.tag = Tag_PensionSOSMainCellSubBtn_EditPhoneBook;
        
    }else{
        _cellMainBtn.tag = Tag_PensionSOSMainCellSubBtn_AddPhoneBook;
        [_cellMainBtn newAnBtnWithTextStr:@"添加SOS通讯录"];
        [_cellMainBtn newAnBtnWithImg:[UIImage new]];
        [_cellMainBtn newAnBtnWithTextColor:Color_Green_BtnShow  withBackColor:[UIColor whiteColor] withFont:[UIFont boldSystemFontOfSize:18] withLayerCorNerNum:5.0 withLayerLineWidth:2.0 withLayerLineColor:Color_Green_BtnShow];
        [_cellMainBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(145);
        }];
        _cellMainLabel.text = @"呼救信息将一键发送给被添加进sos通讯录的家人和医疗机构";
        _cellEditBtn.hidden = YES;
        _cellEditBtn.tag = Tag_PensionSOSMainCellSubBtn_EditPhoneBook;
    }
}
@end
