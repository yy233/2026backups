//
//  MyHistoryDevTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/12/6.
//

#import "MyHistoryDevTableViewCell.h"

@implementation MyHistoryDevTableViewCell

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
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backView.backgroundColor = Y_ColorWith16FromRGB(0xF0F1F6);
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.backView.superview).insets(UIEdgeInsetsMake(5, 16, 5, 16));
        }];
        self.backView.layer.cornerRadius = 5.0;
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.statusShowBtn];
        [self.backView addSubview:self.rightClickBtn];
        [self setBaseUI];
    }
    return self;
}
- (void)setBaseUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview).offset(20);
        make.left.equalTo(_titleL.superview).offset(10);
        make.height.offset(20);
    }];
    [_statusShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(_titleL);
        make.top.equalTo(_titleL.mas_bottom).offset(5);
    }];
    
    [_rightClickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(30);
        make.height.offset(30);
        make.centerY.equalTo(_rightClickBtn.superview);
        make.right.equalTo(_rightClickBtn.superview.mas_right).offset(-10);
    }];
}
#pragma mark ==
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font =  [PensionThemeManager shareManager].Pension_TextFont_B15;
        _titleL.textColor = Y_ColorWith16FromRGB(0x0C0C0C);
    }
    return _titleL;
}
- (UIButton *)statusShowBtn{
    if (!_statusShowBtn) {
        _statusShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_statusShowBtn newAnBtnWithTextStr:@"离线设备"];
        [_statusShowBtn newAnBtnWithTextColor:  Y_ColorWith16FromRGB(0x6E727D) ];
        [_statusShowBtn newAnBtnWithFont: [PensionThemeManager shareManager].Pension_TextFont_12 ];
        [_statusShowBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:3];

    }
    return _statusShowBtn;
}
 
- (UIButton *)rightClickBtn{
    if (!_rightClickBtn) {
        _rightClickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightClickBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_rightClickBtn newAnBtnWithFont: [PensionThemeManager shareManager].Pension_TextFont_B13];
        [_rightClickBtn addTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _rightClickBtn.layer.cornerRadius = 5;
        [_rightClickBtn newAnBtnWithImg:[UIImage imageNamed:@"yl_delete02"]];
        
    }
    return _rightClickBtn;
}
- (void)editBtnAction{
    if (isNotNil(self.historyDevDeletBlock)) {
        self.historyDevDeletBlock();
       
    }
}

- (void)fillDataWithModel:(DevGetNowUsersDevInfoModel *)model{
    //cell 当前手环设备的连接状态 isConnected= 1 nowDevState=3  (null) S5-AA3E
    NSLog(@"cell 当前手环设备的连接状态 isConnected= %d nowDevState=%ld  %@ %@",[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected,[TrusangBlueToothSdkDataManager share].nowDevState,[TrusangBlueToothSdkDataManager share].showModel.saveNowDevMac,[TrusangBlueToothSdkDataManager share].showModel.saveNowDevName);
    self.titleL.text = [TextShowWithModelStr textShowWithModelStr:model.mdeviceName];
    NSString *modelName= [TextShowWithModelStr textShowWithModelStr:model.mdeviceName];
    NSString *modelMacAddress = [TextShowWithModelStr textShowWithModelStr:model.mdeviceAddress];

     if ([TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected) {
      
         if (([modelMacAddress isEqualToString:[TrusangBlueToothSdkDataManager share].showModel.saveNowDevMac] || [TrusangBlueToothSdkDataManager share].showModel.saveNowDevMac.length==0) && [modelName isEqualToString:[TrusangBlueToothSdkDataManager share].showModel.saveNowDevName] ) {//同名 && 同mac||空mac
            [self.statusShowBtn newAnBtnWithTextStr:@"当前在线设备!"];
            [self.statusShowBtn newAnBtnWithImg:[UIImage imageNamed:@"yl_yilj"]];
        }else{
            [self.statusShowBtn newAnBtnWithTextStr:@"离线设备"];
            [self.statusShowBtn newAnBtnWithImg:[UIImage new]];
        }

    }else{
        [self.statusShowBtn newAnBtnWithTextStr:@"离线设备"];
        [self.statusShowBtn newAnBtnWithImg:[UIImage new]];
    }
}
@end
