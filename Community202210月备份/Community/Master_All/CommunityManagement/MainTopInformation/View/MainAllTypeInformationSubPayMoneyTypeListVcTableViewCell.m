//
//  MainAllTypeInformationSubPayMoneyTypeListVcTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/9/6.
//

#import "MainAllTypeInformationSubPayMoneyTypeListVcTableViewCell.h"
#import "MainAllTypeInformationSubPayMoneyTypeSubDataModel.h"

@interface MainAllTypeInformationSubPayMoneyTypeListVcTableViewCell ()
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UILabel *titleL;
//
@property (nonatomic,strong) UILabel *moneyTitleL;
@property (nonatomic,strong) UILabel *moneyNumShowL;
//
@property (nonatomic,strong) UILabel *payInfoL;


@end

@implementation MainAllTypeInformationSubPayMoneyTypeListVcTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillPayMoneyTypeDataWithModel:(MainImInfoSubMsgModel *)model{
    NSString *timeIntervalStr = [TextShowWithModelStr textShowWithModelStr:model.create_time];
    BOOL isThisDay = [ToolOfTimeChangeFormat checkIsThisDayWithTheDateStr:timeIntervalStr];
    NSLog(@"fillPayMoneyTypeDataWithModel = time == %@",model.create_date);
    self.timeL.text = ( isThisDay ? [ToolOfTimeChangeFormat dateToString:timeIntervalStr Format:@"HH:mm"] : [ToolOfTimeChangeFormat dateToString:timeIntervalStr Format:@"YYYY/MM/dd"]);
    //公众号类型 + 且为支付类型
    if ([model.msg_type  isEqualToString: kWebSocketMsgTypeObj_appmsg])  {
        NSDictionary *dic = [Tool dictionaryWithJsonString:model.data];
        MainAllTypeInformationSubPayMoneyTypeSubDataModel *subDataModel = [MainAllTypeInformationSubPayMoneyTypeSubDataModel mj_objectWithKeyValues:dic];
        if ( subDataModel.type == 2) {
            //
            [self.imgV sd_setImageWithURL:[UrlWithString getURLWithStr:subDataModel.sub_head_img_url]];
            self.titleL.text = [TextShowWithModelStr textShowWithModelStr:subDataModel.sub_name];
//            self.moneyNumShowL.text = [NSString stringWithFormat:@"¥%0.2lf%@",subDataModel.pay_amount,subDataModel.currency];//增加币种键值
            self.moneyNumShowL.text = [NSString stringWithFormat:@"¥%0.2lf",subDataModel.pay_amount];//不增加币种键值

    //        self.moneyTitleL.text = [TextShowWithModelStr textShowWithModelStr:subDataModel.pay_type];
            self.payInfoL.text = [NSString stringWithFormat:@"支付方式：%@",subDataModel.pay_type];
            if ([subDataModel.desc isEqualToString:@"desc"]) {
                self.moneyTitleL.text = @"付款金额";
            }else{
                self.moneyTitleL.text = [TextShowWithModelStr textShowWithModelStr:subDataModel.desc].length >0 ? [TextShowWithModelStr textShowWithModelStr:subDataModel.desc] : @"付款金额";

            }
            
        }
       
    }
    
    
 }

#pragma mark ==
//init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor  = [UIColor clearColor];
        self.contentView.backgroundColor  = [UIColor clearColor];
        WEAKSELF
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.backView.superview).insets(UIEdgeInsetsMake(0, 32, 0, 32));
        }];
        
        [self.backView addSubview:self.imgV];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.timeL];
        [self.backView addSubview:self.moneyTitleL];
        [self.backView addSubview:self.moneyNumShowL];
        [self.backView addSubview:self.payInfoL];
      
      
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [self setTopU];
    [self otherUI];
  
}
- (void)setTopU{
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgV.superview).offset(20);
        make.left.equalTo(_imgV.superview).offset(0);
        make.width.height.offset(25);
    }];
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imgV);
        make.right.equalTo(_timeL.superview).offset(-10);
        make.height.offset(20);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imgV);
        make.height.offset(20);
        make.left.equalTo(_imgV.mas_right).offset(10);
        make.right.equalTo(_timeL.mas_left).offset(-10);
    }];
}
- (void)otherUI{
    [_moneyTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_moneyTitleL.superview);
        make.height.offset(30);
        make.top.equalTo(_titleL.mas_bottom).offset(10);
    }];
    [_moneyNumShowL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_moneyTitleL.superview);
        make.height.offset(30);
        make.top.equalTo(_moneyTitleL.mas_bottom).offset(10);
    }];
    [_payInfoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgV);
        make.height.offset(20);
        make.bottom.equalTo(_payInfoL.superview.mas_bottom).offset(-5);
    }];
}
 
#pragma mark ==
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgV;
}
- (UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc]init];
        _timeL.font = [UIFont systemFontOfSize:12.0];
        _timeL.textColor = [ThemeManager shareManager].mainTextColor;
        _timeL.textAlignment = NSTextAlignmentRight;
    }
    return _timeL;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = [UIFont systemFontOfSize:15.0];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.numberOfLines = 1;
    }
    return _titleL;
}

- (UILabel *)moneyTitleL{
    if (!_moneyTitleL) {
        _moneyTitleL = [[UILabel alloc]init];
        _moneyTitleL.font = [UIFont systemFontOfSize:14.0];
        _moneyTitleL.textColor = [ThemeManager shareManager].mainTextColor;
        _moneyTitleL.numberOfLines = 1;
        _moneyTitleL.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyTitleL;
}
- (UILabel *)moneyNumShowL{
    if (!_moneyNumShowL) {
        _moneyNumShowL = [[UILabel alloc]init];
        _moneyNumShowL.font = [UIFont boldSystemFontOfSize:28.0];
        _moneyNumShowL.textColor = [ThemeManager shareManager].mainTextColor;
        _moneyNumShowL.numberOfLines = 1;
        _moneyNumShowL.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyNumShowL;
}
- (UILabel *)payInfoL{
    if (!_payInfoL) {
        _payInfoL = [[UILabel alloc]init];
        _payInfoL.font = [UIFont systemFontOfSize:14.0];
        _payInfoL.textColor = [ThemeManager shareManager].mainTextColor;
        _payInfoL.numberOfLines = 1;
    }
    return _payInfoL;
}

@end


@implementation MainAllTypeInformationSubPayMoneyTypeListVcTableViewCellLate 


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
     
        [self.backView addSubview:self.showDetailBtn];
        [self setGotoDetailBtnAndOtherUI];
    }
    return self;
}
- (void)setGotoDetailBtnAndOtherUI{
    self.timeL.hidden = YES;
    self.payInfoL.hidden = YES;
    self.moneyTitleL.textColor = [ThemeManager shareManager].detailTextColor;
    self.titleL.font = [UIFont boldSystemFontOfSize:15.0];

    WEAKSELF
    [_showDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.moneyNumShowL.mas_bottom).offset(5);
        make.centerX.equalTo(_showDetailBtn.superview);
        make.height.offset(25);
        make.width.offset(75);
    }];
    [_showDetailBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:10];
}

- (UIButton *)showDetailBtn{
    if (!_showDetailBtn) {
        _showDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showDetailBtn newAnBtnWithTextStr:@"账单详情"];
        [_showDetailBtn newAnBtnWithTextColor: [ThemeManager shareManager].detailTextColor];
        [_showDetailBtn newAnBtnWithFont:[UIFont systemFontOfSize:12.0]];
        [_showDetailBtn newAnBtnWithImg: [UIImage imageNamed:@"Settings_arrow"]];
    }
    return _showDetailBtn;
}
 
@end



@implementation MainAllTypeInformationSubPayMoneyTypeListVcPayTypeTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
     
        [self.contentView addSubview:self.lineV];
        [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_lineV.superview).offset(-36*2);
            make.top.centerX.equalTo(_lineV.superview);
            make.height.offset(0.5);
        }];
    }
    return self;
}
- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]init];
        _lineV.backgroundColor = [ThemeManager shareManager].themeLineColor;
    }
    return _lineV;
}
@end
