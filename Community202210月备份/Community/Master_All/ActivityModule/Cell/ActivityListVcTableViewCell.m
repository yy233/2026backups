//
//  ActivityListVcTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/6/6.
//

#import "ActivityListVcTableViewCell.h"

@interface ActivityListVcTableViewCell ()
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UIButton *statusTopBtn;
@property (nonatomic,strong) UIButton *statusBottomBtn;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UILabel *personNumL;
@property (nonatomic,strong) UIImageView *timeLeftImgV;
@property (nonatomic,strong) UIImageView *personNumLeftImgV;

@end

@implementation ActivityListVcTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillDataModel:(ActivityListUseModel *)model{
//    self.statusBottomBtn.hidden =
   
    [self.statusBottomBtn newAnBtnWithTextStr:[NSString stringWithFormat:@"还剩%ld人",model.surplusNumber]];
    self.titleL.text = [TextShowWithModelStr textShowWithModelStr:model.theme];
    NSString *getApplyTimeStr = [self detailApplyTimesWithModel: model];
    self.timeL.text = [NSString stringWithFormat:@"报名时间：%@",getApplyTimeStr];
    self.personNumL.text = [NSString stringWithFormat:@"活动名额：%ld人",model.count];
    NSArray *imgUrlArr = [model.picture componentsSeparatedByString:@","];
    [self.imgV sd_setImageWithURL:[UrlWithString getURLWithStr:imgUrlArr.firstObject]  placeholderImage:Main_PlaceholderImg_WeqH];
    
    [self detailStatusWithModel:model];

}

- (NSString *)detailApplyTimesWithModel:(ActivityListUseModel *)model{
    NSString *strOfApplyTime = @"";
    NSString *beginT = @"";
    NSString *endT = @"";
    beginT = [ToolOfTimeChangeFormat smallTimeFormatWithLongTimeStr:[TextShowWithModelStr textShowWithModelStr:model.beginApplyTime]];
    endT = [ToolOfTimeChangeFormat smallTimeFormatWithLongTimeStr:[TextShowWithModelStr textShowWithModelStr:model.overApplyTime]];
    strOfApplyTime = [NSString stringWithFormat:@"%@ - %@", beginT ,endT];
    return strOfApplyTime;
}


- (void)detailStatusWithModel:(ActivityListUseModel *)model{
    switch (model.activityStatus) {
        case 1://    1预发布，2报名进行中，3报名已结束，5活动已结束,6未开始
            [self.statusTopBtn newAnBtnWithTextStr:@"预发布"];
            break;
        case 2:
            [self.statusTopBtn newAnBtnWithTextStr:@"进行中"];
            break;
        case 3:
            [self.statusTopBtn newAnBtnWithTextStr:@"已结束"];

            break;
        case 4:
            [self.statusTopBtn newAnBtnWithTextStr:@"进行中"];
//            [self.statusTopBtn newAnBtnWithTextStr:@""];

            break;
        case 5:
            [self.statusTopBtn newAnBtnWithTextStr:@"已结束"];

            break;
        case 6:
            [self.statusTopBtn newAnBtnWithTextStr:@"即将开始"];

            break;
            
        default:
            break;
    }
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        WEAKSELF
        [weakSelf.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.backView.superview).insets(UIEdgeInsetsMake(5, 16, 5, 16));
        }];
        weakSelf.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        weakSelf.backView.layer.cornerRadius = 10;
        [self.backView addSubview:self.imgV];
        [self.backView addSubview:self.timeLeftImgV];
        [self.backView addSubview:self.personNumLeftImgV];
        [self.backView addSubview:self.statusTopBtn];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.timeL];
        [self.backView addSubview:self.personNumL];
        [self.backView addSubview:self.statusBottomBtn];
      
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_imgV.superview).offset(-20);
        make.height.equalTo(_imgV.mas_width).multipliedBy(0.5);//(340:160)
        make.top.equalTo(_imgV.superview).offset(15);
        make.centerX.equalTo(_imgV.superview);
    }];
    [_statusTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(24.0);
        make.top.equalTo(_imgV.mas_top).offset(15);
        make.right.equalTo(_imgV.mas_right).offset(-15);
        make.width.offset(60);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgV.mas_bottom).offset(15);
//        make.left.right.equalTo(_imgV);
        make.left.equalTo(_imgV).offset(5);
        make.right.equalTo(_imgV).offset(-5);
        
        make.height.offset(20);
    }];
    //
    [_timeLeftImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(20);
        make.left.equalTo(_imgV).offset(5);
        make.top.equalTo(_titleL.mas_bottom).offset(10);
    }];
    [_personNumLeftImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(20);
        make.left.equalTo(_imgV).offset(5);
        make.top.equalTo(_timeLeftImgV.mas_bottom).offset(5);
    }];
    //
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLeftImgV.mas_right).offset(5);
        make.top.equalTo(_timeLeftImgV);
        make.right.equalTo(_imgV);
        make.height.offset(20);
    }];
    [_personNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_personNumLeftImgV.mas_right).offset(5);
        make.top.equalTo(_personNumLeftImgV);
        make.right.equalTo(_imgV);
        make.height.offset(20);
    }];
    [_statusBottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(24.0);
        make.right.equalTo(_statusBottomBtn.superview.mas_right).offset(-10);
        make.width.offset(80);
        make.centerY.equalTo(_personNumL);
    }];
    
    
}
#pragma mark ==
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.layer.cornerRadius = 5.0;
        _imgV.clipsToBounds = YES;
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgV;
}
- (UIButton *)statusTopBtn{
    if (!_statusTopBtn) {
        _statusTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_statusTopBtn newAnBtnWithBackColor: [Y_ColorWith16FromRGB(0x000000) colorWithAlphaComponent:0.75]];
        [_statusTopBtn newAnBtnWithTextColor: Y_ColorWith16FromRGB(0xFFFFFF)];
        [_statusTopBtn newAnBtnWithLayerCorNerNum:3 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_statusTopBtn newAnBtnWithFont: [UIFont systemFontOfSize:12.0]];
    }
    return _statusTopBtn;
}
- (UIButton *)statusBottomBtn{
    if (!_statusBottomBtn) {
        _statusBottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([ThemeManager shareManager].type ==  ThemeType_White) {
            [_statusBottomBtn newAnBtnWithBackColor: Y_ColorWith16FromRGB(0xF4F4F7)];
            [_statusBottomBtn newAnBtnWithTextColor: Y_ColorWith16FromRGB(0x6E727D)];
        }else{
            [_statusBottomBtn newAnBtnWithBackColor: Y_ColorWith16FromRGB(0x2E4674)];
            [_statusBottomBtn newAnBtnWithTextColor: Y_ColorWith16FromRGB(0xFFFFFF)];
        }
        [_statusBottomBtn newAnBtnWithLayerCorNerNum:3 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_statusBottomBtn newAnBtnWithFont: [UIFont systemFontOfSize:12.0]];
    }
    return _statusBottomBtn;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont boldSystemFontOfSize:15.0];
    }
    return _titleL;
}

- (UIImageView *)timeLeftImgV{
    if (!_timeLeftImgV) {
        _timeLeftImgV = [[UIImageView alloc]init];
        _timeLeftImgV.image = [UIImage imageNamed:@"wjdc_jssj_icon"];
    }
    return _timeLeftImgV;
}
- (UIImageView *)personNumLeftImgV{
    if (!_personNumLeftImgV) {
        _personNumLeftImgV = [[UIImageView alloc]init];
        _personNumLeftImgV.image = [UIImage imageNamed:@"personTwoIcon"];
    }
    return _personNumLeftImgV;
}
- (UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc]init];
        _timeL.textColor = [ [ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.95];
        _timeL.font = [UIFont systemFontOfSize:14.0];
    }
    return _timeL;
}
- (UILabel *)personNumL{
    if (!_personNumL) {
        _personNumL = [[UILabel alloc]init];
        _personNumL.textColor = [ [ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.95];
        _personNumL.font = [UIFont systemFontOfSize:14.0];
    }
    return _personNumL;
}

@end
