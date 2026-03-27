//
//  AddInvoiceDefalutCell.m
//  Community
//
//  Created by 刘久炼 on 2021/2/23.
//

#import "AddInvoiceDefaultCell.h"

@interface AddInvoiceDefaultCell ()

@property(nonatomic, strong) UILabel *titleL;

@property(nonatomic, strong) UISwitch *btn;


@property(nonatomic, strong) UIView *lineV;

@end

@implementation AddInvoiceDefaultCell

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
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.mas_equalTo(self.contentView);
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
        _titleL.text = @"设为默认";
        _titleL.font = FontSize_Vip_Nomail(16);
        _titleL.textColor = [Tool getColorWithHexString:@"#202020"];
        _titleL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleL];
    }
    return _titleL;
}

- (UISwitch *)btn{
    if (!_btn) {
        _btn = [[UISwitch alloc] init];
        _btn.onTintColor = [Tool getColorWithHexString:@"#008FFC"];
        [_btn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [_btn setOn:YES];
        [self.contentView addSubview:_btn];
    }
    return _btn;
}


- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = [Tool getColorWithHexString:@"#EEEEEE"];
        [self.contentView addSubview:_lineV];
    }
    return _lineV;
}

- (void)setIsdefault:(NSInteger)isdefault{
    _isdefault = isdefault;
    [self.btn setOn:isdefault];
}


#pragma mark - switch监听

- (void)switchAction: (UISwitch *)btn{
    self.isdefault = btn.isOn;
    if ([self.delegate respondsToSelector:@selector(isdefaultChagedWithsIsdefalut:)]) {
        [self.delegate isdefaultChagedWithsIsdefalut:self.isdefault];
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
