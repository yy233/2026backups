//
//  DeviceScanListShowTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/11/13.
//

#import "DeviceScanListShowTableViewCell.h"

#define Color_Green_ToConnected    Y_ColorWith16FromRGB(0x22D7BB)
#define Color_Orange_ReToConnected   Y_ColorWith16FromRGB(0xFFA82B)


@interface DeviceScanListShowTableViewCell ()
@property (nonatomic,strong)  ZHJBTDevice *cellDev;
@end

@implementation DeviceScanListShowTableViewCell
/**
 //连接中状态 智能用showModelname名字str判断 连接成功后才能用nowBlueToothDevSave

*/

- (void)fillDataWithDev:(ZHJBTDevice *)dev{
    self.cellDev = dev;
    self.titleL.text = _cellDev.name;
    NSLog(@"DeviceScanListShowTableViewCell 本cellDev_mac%@  已经连接过保存的dev_mac%@",_cellDev.mac ,[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.mac);
    
    if ( [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected && ((_cellDev.mac.length==0 || [_cellDev.mac isEqualToString: [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.mac]) && [_cellDev.name isEqualToString:[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.name])) {//mac空 mac || name 同一个设备
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.statusShowBtn newAnBtnWithTextStr:@"已连接"];
            [self.statusShowBtn newAnBtnWithImg:[UIImage imageNamed:@"yl_yilj"]];
            self.rightClickBtn.hidden = YES;
            self.rightIndicatorView.hidden  = YES;
            [self.rightIndicatorView stopAnimating];
        });
        
        return;
    }else{
        
    }
    switch ([TrusangBlueToothSdkDataManager share].nowDevState) {
        case DeviceStateDisconnected://断开状态
        {
            if ([_cellDev.name isEqualToString:[TrusangBlueToothSdkDataManager share].showModel.saveNowDevName]) {//为非连接状态
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.statusShowBtn newAnBtnWithTextStr:@"连接失败！"];
                    [self.statusShowBtn newAnBtnWithImg:[UIImage imageNamed:@"yl_weilj"]];
                    [self.rightClickBtn newAnBtnWithTextStr:@"重新连接"];
                    self.rightClickBtn.backgroundColor = Color_Orange_ReToConnected;
                    self.rightClickBtn.hidden = NO;
                    self.rightIndicatorView.hidden  = YES;
                    [self.rightIndicatorView stopAnimating];
                });
                
            }else{
                [self notConnectView];
            }
            
        }
            break;
        case  DeviceStateConnected:
        {
            if ((_cellDev.mac.length==0 || [_cellDev.mac isEqualToString: [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.mac]) && [_cellDev.name isEqualToString:[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.name]) {//mac空 mac || name 同一个设备
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.statusShowBtn newAnBtnWithTextStr:@"已连接"];
                    [self.statusShowBtn newAnBtnWithImg:[UIImage imageNamed:@"yl_yilj"]];
                    self.rightClickBtn.hidden = YES;
                    self.rightIndicatorView.hidden  = YES;
                    [self.rightIndicatorView stopAnimating];
                });
                
            }else{
                [self notConnectView];
            }
            
        }
            break;
            
        default: //DeviceStateSearching DeviceStateConnecting
        {
            
            NSLog(@"正在连接 == celldev %@ %@  managerDev %@ %@",_cellDev.name,_cellDev.mac,[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.name,[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.mac);
            if ([_cellDev.name isEqualToString: [TrusangBlueToothSdkDataManager share].showModel.saveNowDevName ]) {//为连接ing状态
                
                if ((self.saveOldDevState != DeviceStateSearching && self.saveOldDevState != DeviceStateConnecting) && self.touchDevConnectedYesChangeBool==NO){//断线后 初始本页时 就设备没连接状态cell
                    [self notConnectView];
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.statusShowBtn newAnBtnWithTextStr:@"正在连接"];
                        [self.statusShowBtn newAnBtnWithImg:[UIImage new]];//状态空img
                        self.rightClickBtn.hidden = YES;
                        self.rightIndicatorView.hidden  = NO;//右边
                        [self.rightIndicatorView startAnimating];
                    });
                }
            }else{
                [self notConnectView];
            }
            
        }
            break;
    }
    
}
- (void)notConnectView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.statusShowBtn newAnBtnWithTextStr:@"未连接设备"];
        [self.statusShowBtn newAnBtnWithImg:[UIImage imageNamed:@"yl_weilj"]];
        [self.rightClickBtn newAnBtnWithTextStr:@"点击连接"];
        self.rightClickBtn.backgroundColor = Color_Green_ToConnected;
        self.rightClickBtn.hidden = NO;
        self.rightIndicatorView.hidden  = YES;
    });
    
}


//- (void)fillDataWithDev:(ZHJBTDevice *)dev{
//    self.cellDev = dev;
//    self.titleL.text = _cellDev.name;
//    NSLog(@"DeviceScanListShowTableViewCell 本cellDev_mac%@  已经连接过保存的dev_mac%@",_cellDev.mac ,[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.mac);
//
//
//    if ( [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected  ) { //mac是0字节 + 连接状态 ==》 已连接
//        if ((_cellDev.mac.length==0 || [_cellDev.mac isEqualToString: [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.mac]) && [_cellDev.name isEqualToString:[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.name]) {//同一个设备
//            [self.statusShowBtn newAnBtnWithTextStr:@"已连接"];
//            [self.statusShowBtn newAnBtnWithImg:[UIImage imageNamed:@"yl_yilj"]];
//            self.rightClickBtn.hidden = YES;
//            self.rightIndicatorView.hidden  = YES;
//            [self.rightIndicatorView stopAnimating];
//        }else{
//            [self.statusShowBtn newAnBtnWithTextStr:@"未连接设备"];
//            [self.statusShowBtn newAnBtnWithImg:[UIImage imageNamed:@"yl_weilj"]];
//            [self.rightClickBtn newAnBtnWithTextStr:@"点击连接"];
//            self.rightClickBtn.backgroundColor = Color_Green_ToConnected;
//            self.rightClickBtn.hidden = NO;
//            self.rightIndicatorView.hidden  = YES;
//        }
//        return;
//    }else{ //非 连接状态 以下
//
//        //同一个name
//        if ([_cellDev.name isEqualToString:[TrusangBlueToothSdkDataManager share].showModel.saveNowDevName]) {
//            switch ([TrusangBlueToothSdkDataManager share].nowDevState) {
//                case DeviceStateDisconnected:
//                {
//                    [self.statusShowBtn newAnBtnWithTextStr:@"连接失败！"];
//                    [self.statusShowBtn newAnBtnWithImg:[UIImage imageNamed:@"yl_weilj"]];
//                    [self.rightClickBtn newAnBtnWithTextStr:@"重新连接"];
//                    self.rightClickBtn.backgroundColor = Color_Orange_ReToConnected;
//                    self.rightClickBtn.hidden = NO;
//                    self.rightIndicatorView.hidden  = YES;
//                    [self.rightIndicatorView stopAnimating];
//                }
//                    break;
//                case  DeviceStateConnected:
//                {
//                    [self.statusShowBtn newAnBtnWithTextStr:@"已连接"];
//                    [self.statusShowBtn newAnBtnWithImg:[UIImage imageNamed:@"yl_yilj"]];
//                    self.rightClickBtn.hidden = YES;
//                    self.rightIndicatorView.hidden  = YES;
//                    [self.rightIndicatorView stopAnimating];
//                }
//                    break;
//
//                default: //DeviceStateSearching DeviceStateConnecting
//                {
//                    NSLog(@"正在连接 == celldev %@ %@  managerDev %@ %@",_cellDev.name,_cellDev.mac,[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.name,[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.mac);
//                    if ([_cellDev.name isEqualToString:[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.name] && ([_cellDev.mac isEqualToString:[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.mac])) {//为连接状态 mac
//                        [self.statusShowBtn newAnBtnWithTextStr:@"正在连接"];
//                        [self.statusShowBtn newAnBtnWithImg:[UIImage new]];//状态空img
//                        self.rightClickBtn.hidden = YES;
//                        self.rightIndicatorView.hidden  = NO;//右边
//                        [self.rightIndicatorView startAnimating];
//                    }
//
//
//                }
//                    break;
//            }
//
//         //不同的name
//        }else{
//            [self.statusShowBtn newAnBtnWithTextStr:@"未连接设备"];
//            [self.statusShowBtn newAnBtnWithImg:[UIImage imageNamed:@"yl_weilj"]];
//            [self.rightClickBtn newAnBtnWithTextStr:@"点击连接"];
//            self.rightClickBtn.backgroundColor = Color_Green_ToConnected;
//            self.rightClickBtn.hidden = NO;
//            self.rightIndicatorView.hidden  = YES;
//        }
//
//    }
//
//
//}
//- (void)fillDataWithDev:(ZHJBTDevice *)dev{
//    self.cellDev = dev;
//    self.titleL.text = _cellDev.name;
//    NSLog(@"DeviceScanListShowTableViewCell 本cellDev_mac%@  已经连接过保存的dev_mac%@",_cellDev.mac ,[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.mac);
//    if ([_cellDev.name isEqualToString:[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.name] ) { //设备连接状态时 mac是0字节；则本cell 需要用name做判断
//
//        if (_cellDev.mac.length==0 && [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected ) { //mac是0字节 + 连接状态 ==》 已连接
//            [self.statusShowBtn newAnBtnWithTextStr:@"已连接"];
//            [self.statusShowBtn newAnBtnWithImg:[UIImage imageNamed:@"yl_yilj"]];
//            self.rightClickBtn.hidden = YES;
//            self.rightIndicatorView.hidden  = YES;
//            [self.rightIndicatorView stopAnimating];
//
//            return;
//        }else{ //mac非0字节 或则 连接状态以下
//            switch ([TrusangBlueToothSdkDataManager share].nowDevState) {
//                case DeviceStateDisconnected:
//                {
//                    [self.statusShowBtn newAnBtnWithTextStr:@"连接失败！"];
//                    [self.statusShowBtn newAnBtnWithImg:[UIImage imageNamed:@"yl_weilj"]];
//                    [self.rightClickBtn newAnBtnWithTextStr:@"重新连接"];
//                    self.rightClickBtn.backgroundColor = Color_Orange_ReToConnected;
//                    self.rightClickBtn.hidden = NO;
//                    self.rightIndicatorView.hidden  = YES;
//                    [self.rightIndicatorView stopAnimating];
//                }
//                    break;
//                case  DeviceStateConnected:
//                {
//                    [self.statusShowBtn newAnBtnWithTextStr:@"已连接"];
//                    [self.statusShowBtn newAnBtnWithImg:[UIImage imageNamed:@"yl_yilj"]];
//                    self.rightClickBtn.hidden = YES;
//                    self.rightIndicatorView.hidden  = YES;
//                    [self.rightIndicatorView stopAnimating];
//                }
//                    break;
//
//                default: //DeviceStateSearching DeviceStateConnecting
//                {
//                    NSLog(@"正在连接 == celldev %@ %@  managerDev %@ %@",_cellDev.name,_cellDev.mac,[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.name,[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.mac);
//                    if ([_cellDev.name isEqualToString:[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.name] && ([_cellDev.mac isEqualToString:[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.mac])) {//为连接状态 mac
//                        [self.statusShowBtn newAnBtnWithTextStr:@"正在连接"];
//                        [self.statusShowBtn newAnBtnWithImg:[UIImage new]];//状态空img
//                        self.rightClickBtn.hidden = YES;
//                        self.rightIndicatorView.hidden  = NO;//右边
//                        [self.rightIndicatorView startAnimating];
//                    }
//
//
//                }
//                    break;
//            }
//        }
//
//    }else{
//        [self.statusShowBtn newAnBtnWithTextStr:@"未连接设备"];
//        [self.statusShowBtn newAnBtnWithImg:[UIImage imageNamed:@"yl_weilj"]];
//        [self.rightClickBtn newAnBtnWithTextStr:@"点击连接"];
//        self.rightClickBtn.backgroundColor = Color_Green_ToConnected;
//        self.rightClickBtn.hidden = NO;
//        self.rightIndicatorView.hidden  = YES;
//    }
//
//
//
//}
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
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.backView.superview).insets(UIEdgeInsetsMake(5, 16, 5, 16));
        }];
        self.backView.layer.cornerRadius = 5.0;
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.statusShowBtn];
        [self.backView addSubview:self.rightClickBtn];
        [self.backView addSubview:self.rightIndicatorView];
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
        make.width.offset(72);
        make.height.offset(28);
        make.centerY.equalTo(_rightClickBtn.superview);
        make.right.equalTo(_rightClickBtn.superview.mas_right).offset(-10);
    }];
    [_rightIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(25);
        make.centerY.centerX.equalTo(_rightClickBtn);
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
        [_statusShowBtn newAnBtnWithTextStr:@"连接状态"];
        [_statusShowBtn newAnBtnWithTextColor:  Y_ColorWith16FromRGB(0x6E727D) ];
        [_statusShowBtn newAnBtnWithFont: [PensionThemeManager shareManager].Pension_TextFont_12 ];
        [_statusShowBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:3];

    }
    return _statusShowBtn;
}
- (UIActivityIndicatorView *)rightIndicatorView{
    if (!_rightIndicatorView) {
        _rightIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    }
    return _rightIndicatorView;
}
- (UIButton *)rightClickBtn{
    if (!_rightClickBtn) {
        _rightClickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightClickBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_rightClickBtn newAnBtnWithFont: [PensionThemeManager shareManager].Pension_TextFont_B13];
        [_rightClickBtn addTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _rightClickBtn.layer.cornerRadius = 5;
        
    }
    return _rightClickBtn;
}
- (void)editBtnAction{
    if (isNotNil(self.clickBtnBlock)) {
        self.clickBtnBlock(self.cellDev);
    }
}
@end
