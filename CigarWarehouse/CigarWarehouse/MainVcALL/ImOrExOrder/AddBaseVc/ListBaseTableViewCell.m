//
//  ListBaseTableViewCell.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/20.
//

#import "ListBaseTableViewCell.h"

@implementation ListBaseTableViewCell

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
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titL];
        [self.contentView addSubview:self.textF];
        [self.contentView addSubview:self.rightBtn];

        [_titL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titL.superview).offset(20);
            make.top.bottom.equalTo(_titL.superview);
        }];
        [_textF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_textF.superview).offset(-16);
            make.top.bottom.equalTo(_textF.superview);
            make.width.equalTo(_textF.superview).multipliedBy(0.80);
        }];
        self.rightBtn.hidden = YES;
    }
    return self;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn newAnBtnWithFont:[UIFont systemFontOfSize:6]];
        [_rightBtn newAnBtnWithTextColor:CC_Red_Drak_B];
        [_rightBtn newAnBtnWithBackColor:CC_Brown_C];
        [_rightBtn newAnBtnWithLayerCorNerNum:2 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
    }
    return _rightBtn;
}

- (UILabel *)titL{
    if (!_titL) {
        _titL = [[UILabel alloc]init];
        _titL.textColor = CC_Red_Drak_A;
        _titL.font = [UIFont systemFontOfSize:14.0];
    }
    return _titL;
}
- (UITextField *)textF{
    if (!_textF) {
        _textF = [[UITextField alloc]init];
        _textF.textColor = CC_Red_Drak_B;
        _textF.font = [UIFont systemFontOfSize:14.0];
        _textF.textAlignment = NSTextAlignmentRight;
        _textF.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self setTextPStr:@"请填写..."];//_textF.placeholder = @"请填写";

    }
    return _textF;
}

- (void)setTextPStr:(NSString *)pStr{
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:pStr attributes:@{NSForegroundColorAttributeName:CC_Brown_C}];
    self.textF.attributedPlaceholder = placeholderString;
}


- (void)showRightBtnWithTextStr:(NSString *)str{
    CGFloat w_btn = 30;
    [_textF mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_textF.superview).offset(-16-w_btn);
    }];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rightBtn.superview).offset(-10);
        make.width.height.offset(w_btn);
        make.centerY.equalTo(_rightBtn.superview);
    }];
    if (str.length>0) {
        [_rightBtn newAnBtnWithTextStr:str];
    }
    self.rightBtn.hidden = NO;
}
- (void)notShowRightBtn{
    self.rightBtn.hidden = NO;
    [_textF mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_textF.superview).offset(-16);
    }];
}

@end

@implementation ListBaseTableViewCell_Switch

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
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titL];
        [self.contentView addSubview:self.swi];
         ;

        [_titL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titL.superview).offset(20);
            make.top.bottom.equalTo(_titL.superview);
        }];
        [_swi mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_swi.superview).offset(-16);
            make.centerY.equalTo(_swi.superview);
            make.width.offset(52);//w80
            make.height.offset(32);//h50
        }];
    }
    return self;
}


- (UILabel *)titL{
    if (!_titL) {
        _titL = [[UILabel alloc]init];
        _titL.textColor = CC_Red_Drak_A;
        _titL.font = [UIFont systemFontOfSize:14.0];
    }
    return _titL;
}
-(UISwitch *)swi{
    if (!_swi) {
        _swi = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 52, 32)];//65h的cell 位置{51, 31}默认大小
        [_swi setOn:false];//初始状态无铝管
        //_swi.onTintColor = CC_Brown_A;
    }
    return _swi;
}


@end
