//
//  AddInvoiceTypeCell.m
//  Community
//
//  Created by 刘久炼 on 2021/2/23.
//

#import "AddInvoiceTypeCell.h"

@interface AddInvoiceTypeCell ()

@property(nonatomic, strong) UILabel *titleL;

@property(nonatomic, strong) UIButton *companyBtn;

@property(nonatomic, strong) UIButton *personBtn;

@property(nonatomic, strong) UIView *lineV;

@property(nonatomic, weak) UIButton *selectedBtn;

@end

@implementation AddInvoiceTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initView];
    }
    return self;
}

- (void)initView{
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.personBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.mas_equalTo(self.contentView);
        make.width.offset(150);
        make.height.offset(30);
    }];
    
    [self.companyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.personBtn.mas_left).offset(5);
        make.centerY.mas_equalTo(self.contentView);
        make.width.offset(80);
        make.height.offset(30);
    }];
    
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView);
        make.right.offset(0);
        make.left.offset(15);
        make.height.offset(0.5);
    }];
    
}

#pragma mark - 懒加载

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.text = @"抬头类型";
        _titleL.font = FontSize_Vip_Nomail(16);
        _titleL.textColor = [Tool getColorWithHexString:@"#202020"];
        _titleL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleL];
    }
    return _titleL;
}

- (UIButton *)companyBtn{
    if (!_companyBtn) {
        _companyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_companyBtn setTitle:@"单位" forState:UIControlStateNormal];
        [_companyBtn setTitleColor:[Tool getColorWithHexString:@"#202020"] forState:UIControlStateNormal];
        [_companyBtn setImage:[UIImage imageNamed:@"Lookup_Type_normal"] forState:UIControlStateNormal];
        [_companyBtn setImage:[UIImage imageNamed:@"Lookup_Type_choice"] forState:UIControlStateSelected];
        [_companyBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _companyBtn.tag = 0;
        _companyBtn.titleLabel.font = FontSize_Vip_Nomail(16);
        _companyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
        _companyBtn.selected = YES;
        _selectedBtn = _companyBtn;
        [self.contentView addSubview:_companyBtn];
    }
    return _companyBtn;
}

- (UIButton *)personBtn{
    if (!_personBtn) {
        _personBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_personBtn setTitle:@"个人/非企业单位" forState:UIControlStateNormal];
        [_personBtn setTitleColor:[Tool getColorWithHexString:@"#202020"] forState:UIControlStateNormal];
        [_personBtn setImage:[UIImage imageNamed:@"Lookup_Type_normal"] forState:UIControlStateNormal];
        [_personBtn setImage:[UIImage imageNamed:@"Lookup_Type_choice"] forState:UIControlStateSelected];
        [_personBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _personBtn.tag = 1;
        _personBtn.titleLabel.font = FontSize_Vip_Nomail(16);
        _personBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
        [self.contentView addSubview:_personBtn];
    }
    return _personBtn;
}


- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = [Tool getColorWithHexString:@"#EEEEEE"];
        [self.contentView addSubview:_lineV];
    }
    return _lineV;
}

#pragma mark - 按钮点击

- (void)btnClicked: (UIButton *)sender{
    if (self.selectedBtn == sender) {
        return;
    }
    self.selectedBtn.selected = NO;
    self.selectedBtn.userInteractionEnabled = YES;
    sender.selected = YES;
    sender.userInteractionEnabled = NO;
    self.selectedBtn = sender;
    if ([self.delegate respondsToSelector:@selector(typeSelectedWithType:)]) {
        [self.delegate typeSelectedWithType:self.selectedBtn.tag];
    }
}

#pragma mark - 模型赋值

- (void)setType:(NSInteger)type{
    _type = type;
    if (type == 0) {
        self.companyBtn.selected = YES;
        self.companyBtn.userInteractionEnabled = NO;
        self.personBtn.selected = NO;
        self.personBtn.userInteractionEnabled = YES;
        self.selectedBtn = self.companyBtn;
    }else{
        self.personBtn.selected = YES;
        self.personBtn.userInteractionEnabled = NO;
        self.companyBtn.selected = NO;
        self.companyBtn.userInteractionEnabled = YES;
        self.selectedBtn = self.personBtn;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
