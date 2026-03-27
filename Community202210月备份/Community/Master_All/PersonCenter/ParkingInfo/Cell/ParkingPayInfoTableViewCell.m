//
//  ParkingPayInfoTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/8/7.
//

#import "ParkingPayInfoTableViewCell.h"

@implementation ParkingPayInfoTableViewCell

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
            make.edges.equalTo(self.backView.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        }];
//        self.backView.backgroundColor = Color_11BlueColor;
        self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        self.backView.layer.cornerRadius = 8;
        self.backView.layer.masksToBounds = YES;
        [self.backView addSubview:self.nameL];
        [self.backView addSubview:self.moneyL];
        [self.backView addSubview:self.typeInfoBtn];
        
        [self setBaseUI];
    }
    return self;
}
- (void)setTypeTemporary{
    [_typeInfoBtn newAnBtnWithTextColor:[UIColor whiteColor] withBackColor:Y_ColorWith16FromRGB(0x4072CB) withFont:[UIFont systemFontOfSize:11] withLayerCorNerNum:8 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
    [_typeInfoBtn newAnBtnWithTextStr:@"临时车"];
}
- (void)setTypeMonth{
    [_typeInfoBtn newAnBtnWithTextColor:[UIColor whiteColor] withBackColor:Y_ColorWith16FromRGB(0xEBAC4F) withFont:[UIFont systemFontOfSize:11] withLayerCorNerNum:8 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
    [_typeInfoBtn newAnBtnWithTextStr:@"月租车"];
}

- (void)setBaseUI{
    
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(_nameL.superview);
        make.centerY.equalTo(_nameL.superview);
        make.left.equalTo(_nameL.superview).offset(20);
        make.width.lessThanOrEqualTo(_nameL.superview).multipliedBy(0.7);
    }];
    [_typeInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameL.mas_right).offset(10);
        make.width.offset(45);
        make.height.offset(20);
        make.centerY.equalTo(_nameL);
    }];
    [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.centerY.equalTo(_nameL);
        make.right.equalTo(_moneyL.superview).offset(-16);
    }];
    
}
- (UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc]init];
//        _nameL.font =  [UIFont systemFontOfSize:13];
        _nameL.font =  [UIFont boldSystemFontOfSize:15];
    }
    _nameL.textColor = [ThemeManager shareManager].mainTextColor;
    return _nameL;
}

- (UIButton *)typeInfoBtn{
    if (!_typeInfoBtn) {
        _typeInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_typeInfoBtn newAnBtnWithTextStr:@"临时车"];
    }
    [_typeInfoBtn newAnBtnWithTextColor:[UIColor whiteColor] withBackColor:Y_ColorWith16FromRGB(0x4072CB) withFont:[UIFont systemFontOfSize:11] withLayerCorNerNum:8 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
    return _typeInfoBtn;
}
- (UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.font =  [UIFont boldSystemFontOfSize:15];
        _moneyL.textAlignment = NSTextAlignmentRight;
     }
    _moneyL.textColor =  Y_ColorWith16FromRGB(0xF12727);
    return _moneyL;
   
}
 
@end


@implementation  ParkingPayInfoOnlyTextTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.backView.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        }];
//        self.backView.backgroundColor = Color_11BlueColor;
        self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        self.backView.layer.cornerRadius = 8;
        self.backView.layer.masksToBounds = YES;
        [self.backView addSubview:self.textAllShowL];
        [self setBaseUI];
    }
    return self;
}
- (void)setBaseUI{
 
    [_textAllShowL  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_textAllShowL.superview).offset(-10);
//        make.bottom.equalTo(_textAllShowL.superview);
        make.centerY.equalTo(_textAllShowL.superview).offset(-3);//微微上一点点距离 让列表数据适中 详情数据不大变
        make.left.equalTo(_textAllShowL.superview).offset(20);
        make.width.lessThanOrEqualTo(_textAllShowL.superview).multipliedBy(0.7);
    }];
}
- (UILabel *)textAllShowL{
    if (!_textAllShowL) {
        _textAllShowL = [[UILabel alloc]init];
        _textAllShowL.font =  [UIFont systemFontOfSize:14];
        _textAllShowL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];//初始化色 放在内部  后续子类做更改时 可以被更改颜色
    }
    return _textAllShowL;
}
@end

 
@implementation  ParkingPayInfoOnlyTextColorRedTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        WEAKSELF
        [self.textAllShowL  mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.textAllShowL.superview);
        }];
        self.textAllShowL.textColor = Y_ColorWith16FromRGB(0xF12727);
        self.textAllShowL.textAlignment = NSTextAlignmentCenter;
        self.textAllShowL.font =  [UIFont boldSystemFontOfSize:15];
    }
    return self;
}
@end
