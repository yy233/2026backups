//
//  AddInvoiceNormalCell.m
//  Community
//
//  Created by 刘久炼 on 2021/2/23.
//

#import "AddInvoiceNormalCell.h"

@interface AddInvoiceNormalCell ()

@property(nonatomic, strong) UILabel *titleL;

@property(nonatomic, strong) UITextField *textF;

@property(nonatomic, strong) UIView *lineV;

@end

@implementation AddInvoiceNormalCell

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
    
    [self.textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.left.mas_equalTo(self.titleL.mas_right);
        make.centerY.mas_equalTo(self.contentView);
        make.height.offset(40);
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
        //        _titleL.text = @"作者页面的个人中心";
        _titleL.font = FontSize_Vip_Nomail(16);
        _titleL.textColor = [Tool getColorWithHexString:@"#202020"];
        _titleL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleL];
    }
    return _titleL;
}

- (UITextField *)textF{
    if (!_textF) {
        _textF = [[UITextField alloc] init];
        _textF.placeholder = @"";
        _textF.textAlignment = NSTextAlignmentRight;
        _textF.font = FontSize_Vip_Nomail(16);
        [_textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:_textF];
    }
    return _textF;
}

- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = [Tool getColorWithHexString:@"#EEEEEE"];
        [self.contentView addSubview:_lineV];
    }
    return _lineV;
}


#pragma mark - 模型赋值

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleL.text = title;
}

- (void)setSub:(NSString *)sub{
    _sub = sub;
    self.textF.text = sub;
}

- (void)setPliceholder:(NSString *)pliceholder{
    _pliceholder = pliceholder;
    self.textF.placeholder = pliceholder;
}


#pragma mark - 输入框监听

- (void)textFieldDidChange: (UITextField *)textf{
    self.sub = textf.text;
    if ([self.delegate respondsToSelector:@selector(subChangedWithTitle:Sub:)]) {
        [self.delegate subChangedWithTitle:self.title Sub:self.sub];
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
