//
//  AccountCancelView.m
//  Community
//
//  Created by 刘久炼 on 2021/2/27.
//

#import "AccountCancelView.h"

@interface AccountCancelView ()

@property(nonatomic, strong) UIImageView *imageV;

@property(nonatomic, strong) UILabel *titleL;

@property(nonatomic, strong) UILabel *textL;

@property(nonatomic, strong) UILabel *remarkL;

@property(nonatomic, strong) UILabel *protocolL;

@property(nonatomic, strong) UIView *bgView;

@property(nonatomic, strong) UIButton *nextBtn;

@property(nonatomic, strong) UIButton *protocolBtn;


@property(nonatomic, strong) UIView *lineV;
@end

@implementation AccountCancelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.offset(40);
        make.width.offset(55);
        make.height.offset(55);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.imageV.mas_bottom).offset(13);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(30);
        make.left.offset(37);
        make.height.offset(205);
    }];
    
    [self.textL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.bgView).offset(18);
        make.left.offset(18);
        make.height.offset(101);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.textL.mas_bottom).offset(18);
        make.left.offset(18);
        make.height.offset(0.5);
    }];
    
    [self.remarkL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.lineV.mas_bottom).offset(18);
        make.left.offset(18);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(30);
        make.left.offset(37);
        make.height.offset(45);
    }];
    
    [self.protocolL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_centerX).offset(45);
        make.top.mas_equalTo(self.nextBtn.mas_bottom).offset(10);
        make.left.offset(37);
        make.height.offset(20);
    }];
    
    [self.protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.protocolL);
        make.left.mas_equalTo(self.protocolL.mas_right).offset(0);
        make.height.offset(20);
        make.width.offset(100);
    }];
    
}

#pragma mark - 懒加载

- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
        _imageV.image = [UIImage imageNamed:@"warning"];
        [self addSubview:_imageV];
    }
    return _imageV;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.text = @"以下信息将本清空且无法找回";
        _titleL.font = FontSize_Vip_Nomail(15);
        _titleL.textColor = [Tool getColorWithHexString:@"#333333"];
        _titleL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleL];
    }
    return _titleL;
}

- (UILabel *)textL{
    if (!_textL) {
        _textL = [[UILabel alloc] init];

        NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        // 行间距设置为30
        [paragraphStyle  setLineSpacing:10];
        NSString  *testString = @"• 身份、账号信息\n• 交易记录\n• 个人隐私信息\n• 红包、T币等\n• 会员红包、奖励金等";
        NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:testString];
        [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [testString length])];
        [_textL  setAttributedText:setString];
        _textL.font = FontSize_Vip_Bold(14);
        _textL.numberOfLines = 0;
        _textL.textColor = [Tool getColorWithHexString:@"#999999"];
        _textL.textAlignment = NSTextAlignmentLeft;
        [self.bgView addSubview:_textL];
    }
    return _textL;
}

- (UILabel *)remarkL{
    if (!_remarkL) {
        _remarkL = [[UILabel alloc] init];
        NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        // 行间距设置为30
        [paragraphStyle  setLineSpacing:5];
        NSString  *testString = @"请先确保所有交易已完结且无纠纷，账号删除后的历史交易可能产生的资金退回权益等将视作自动放弃";
        NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:testString];
        [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [testString length])];
        [_remarkL  setAttributedText:setString];
        _remarkL.font = FontSize_Vip_Nomail(11);
        _remarkL.numberOfLines = 0;
        _remarkL.textColor = [Tool getColorWithHexString:@"#999999"];
        _remarkL.textAlignment = NSTextAlignmentLeft;
        [self.bgView addSubview:_remarkL];
    }
    return _remarkL;
}

- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = [Tool getColorWithHexString:@"#DDDDDD"];
        [self.bgView addSubview:_lineV];
    }
    return _lineV;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [Tool getColorWithHexString:@"#F5F5F5"];
        _bgView.layer.cornerRadius = 7.5;
        _bgView.clipsToBounds = YES;
        [self addSubview:_bgView];
    }
    return _bgView;
}

- (UILabel *)protocolL{
    if (!_protocolL) {
        _protocolL = [[UILabel alloc] init];
        _protocolL.text = @"点击【下一步】即代表你已经同意";
        _protocolL.font = FontSize_Vip_Nomail(12);
        _protocolL.textColor = [Tool getColorWithHexString:@"#999999"];
        _protocolL.textAlignment = NSTextAlignmentRight;
        [self addSubview:_protocolL];
    }
    return _protocolL;
}

- (UIButton *)protocolBtn{
    if (!_protocolBtn) {
        _protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_protocolBtn setTitle:@"《用户注销协议》" forState:UIControlStateNormal];
        [_protocolBtn setTitleColor:[Tool getColorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _protocolBtn.titleLabel.font = FontSize_Vip_Nomail(12);
        [_protocolBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _protocolBtn.tag = 0;
        [self addSubview:_protocolBtn];
    }
    return _protocolBtn;
}

- (UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = FontSize_Vip_Nomail(15);
        [_nextBtn setTitleColor:[Tool getColorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [_nextBtn setBackgroundColor:[Tool getColorWithHexString:@"#2672F9"]];
        [_nextBtn setImage:[UIImage imageNamed:@"white_arrow"] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _nextBtn.layer.cornerRadius = 3.5;
        _nextBtn.clipsToBounds = YES;
        _nextBtn.tag = 1;
        [self addSubview:_nextBtn];
    }
    return _nextBtn;
}

#pragma mark - 按钮点击

- (void)btnClicked: (UIButton *)sender{
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
