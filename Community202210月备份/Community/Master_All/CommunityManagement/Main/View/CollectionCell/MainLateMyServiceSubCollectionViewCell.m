//
//  MainLateMyServiceSubCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2021/8/9.
//

#import "MainLateMyServiceSubCollectionViewCell.h"

@implementation MainLateMyServiceSubCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backImgView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.phoneImgBtn];
        self.phoneImgBtn.userInteractionEnabled = NO;//不交互 防止影响cell点击
        [self setUI];
  
    }
    return self;
}
 
- (void)fillType:(MyServiceSubCollectionViewCell_Type)selfType{
    
    UIColor *Btn_BgeinColor = [UIColor whiteColor];
    UIColor *Btn_EndColor = [UIColor whiteColor];
    
    if ( kMYAPP_Now_IS_HIDDEN_MORE_INDEX == 1) {
        switch (selfType) {
            case MyServiceSubCollectionViewCell_Type_Repair:
            {
                _backImgView.image =  [UIImage imageNamed:@"click_repair_fw"];
                Btn_BgeinColor =  Y_ColorWith16FromRGB(0xFF8C19);
                Btn_EndColor = Y_ColorWith16FromRGB(0xFFA834);
                _titleLabel.textColor = Y_ColorWith16FromRGB(0x3E1E00);
                _titleLabel.text = @"报事报修";
            }
                break;
            case MyServiceSubCollectionViewCell_Type_Visitor:
            {
                _backImgView.image = [UIImage imageNamed:@"Visitor_invitation_fw"];
                Btn_BgeinColor =  Y_ColorWith16FromRGB(0x1FC099);
                Btn_EndColor = Y_ColorWith16FromRGB(0x08DDB4);
                _titleLabel.textColor = Y_ColorWith16FromRGB(0x22634F);
                _titleLabel.text = @"访客邀请";
            }
                break;
            case MyServiceSubCollectionViewCell_Type_WuYe:
            {
                _backImgView.image = [UIImage imageNamed:@"Property_housekeeper_fw"];

                Btn_BgeinColor =  Y_ColorWith16FromRGB(0x4D78AF);
                Btn_EndColor = Y_ColorWith16FromRGB(0x819BD4);
                _titleLabel.textColor = Y_ColorWith16FromRGB(0x213867);
                _titleLabel.text = @"物业缴费";
            }
                break;
            default:
                break;
        }
    }else{
        switch (selfType) {
            case MyServiceSubCollectionViewCell_Type_Repair:
            {
                
    //            _backImgView.image = ([ThemeManager shareManager].type==ThemeType_White) ?  [UIImage imageNamed:@"One_click_repair"] : [UIImage imageNamed:@"One_click_repair_Night"];
                _backImgView.image =  [UIImage imageNamed:@"One_click_repair"];
                Btn_BgeinColor =  Y_ColorWith16FromRGB(0xFF8C19);
                Btn_EndColor = Y_ColorWith16FromRGB(0xFFA834);
                _titleLabel.textColor = Y_ColorWith16FromRGB(0x3E1E00);
                _titleLabel.text = @"报事报修";
            }
                break;
            case MyServiceSubCollectionViewCell_Type_Visitor:
            {
    //            _backImgView.image = ([ThemeManager shareManager].type==ThemeType_White) ?  [UIImage imageNamed:@"Visitor_invitation"]: [UIImage imageNamed:@"Visitor_invitation_Night"];
                _backImgView.image = [UIImage imageNamed:@"Visitor_invitation"];

                Btn_BgeinColor =  Y_ColorWith16FromRGB(0x1FC099);
                Btn_EndColor = Y_ColorWith16FromRGB(0x08DDB4);
                _titleLabel.textColor = Y_ColorWith16FromRGB(0x22634F);
                _titleLabel.text = @"访客邀请";
            }
                break;
            case MyServiceSubCollectionViewCell_Type_WuYe:
            {
    //            _backImgView.image = ([ThemeManager shareManager].type==ThemeType_White) ? [UIImage imageNamed:@"Property_housekeeper"] : [UIImage imageNamed:@"Property_housekeeper_Night"];
                _backImgView.image = [UIImage imageNamed:@"Property_housekeeper"];

                Btn_BgeinColor =  Y_ColorWith16FromRGB(0x4D78AF);
                Btn_EndColor = Y_ColorWith16FromRGB(0x819BD4);
                _titleLabel.textColor = Y_ColorWith16FromRGB(0x213867);
                _titleLabel.text = @"物业管家";
            }
                break;
            default:
                break;
        }
    }
    
    
  
    _phoneImgBtn.backgroundColor = [UIColor y_colorGradientChangeWithSize:CGSizeMake(52, 20) direction:IHGradientChangeDirectionLevel startColor:Btn_BgeinColor endColor:Btn_EndColor];
}
 
- (void)setUI{
    [_backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backImgView.superview);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.superview.mas_top).offset(10);
        make.left.equalTo(_titleLabel.superview.mas_left).offset(15);//img适配h的时候有w间隙留多点
        make.right.equalTo(_titleLabel.superview.mas_right);
        make.height.offset(20);
    }];
    [_phoneImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.equalTo(_titleLabel.mas_left);
        make.width.offset(50);
        make.height.offset(20);
    }];
}
- (UIImageView *)backImgView{
    if (!_backImgView) {
        _backImgView = [[UIImageView alloc]init];
        _backImgView.contentMode = UIViewContentModeScaleAspectFit;
        _backImgView.layer.cornerRadius = 5;
        _backImgView.layer.masksToBounds = YES;
    }
    return _backImgView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}
- (UIButton *)phoneImgBtn{
    if (!_phoneImgBtn) {
        _phoneImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_phoneImgBtn newAnBtnWithFont:[UIFont systemFontOfSize:11]];
        [_phoneImgBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_phoneImgBtn newAnBtnWithTextStr:@"去看看"];
        _phoneImgBtn.layer.cornerRadius = 9;
    }
    return _phoneImgBtn;
}
@end
