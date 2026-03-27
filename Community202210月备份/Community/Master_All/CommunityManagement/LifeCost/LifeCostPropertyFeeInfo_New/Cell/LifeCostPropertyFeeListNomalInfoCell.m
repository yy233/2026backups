//
//  LifeCostPropertyFeeListNomalInfoCell.m
//  Community
//
//  Created by 余莹 on 2022/5/19.
//

#import "LifeCostPropertyFeeListNomalInfoCell.h"

@implementation LifeCostPropertyFeeListNomalInfoCell

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
  
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        WEAKSELF
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.backView.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        }];
        [self.backView addSubview:self.typeNameL];
        [self.backView addSubview:self.moneyL];
        [self.backView addSubview:self.rigntImgV];
        [self setThisUI];
    }
    return self;
}
- (void)setThisUI{
    [_typeNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_typeNameL.superview).offset(10);
        make.left.equalTo(_typeNameL.superview).offset(15);
        make.width.lessThanOrEqualTo(_typeNameL.superview).offset(-60);
        make.height.offset(20);
    }];
    [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_typeNameL.mas_bottom).offset(5);
        make.left.equalTo(_typeNameL);
        make.width.equalTo(_typeNameL);
        make.height.offset(20);
    }];
    [_rigntImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rigntImgV.superview).offset(-15);
        make.centerY.equalTo(_rigntImgV.superview);
        make.width.offset(6.0);
        make.height.offset(12.0);
    }];
}
 


#pragma mark =========
- (UILabel *)typeNameL{
    if (!_typeNameL) {
        _typeNameL = [[UILabel alloc]init];
        _typeNameL.textColor = [ThemeManager shareManager].mainTextColor;
        _typeNameL.font = [UIFont boldSystemFontOfSize:15.0];
    }
    return _typeNameL;
}

- (UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.textColor = [ThemeManager shareManager].mainTextColor;
        _moneyL.font = [UIFont systemFontOfSize:14.0];
    }
    return _moneyL;
}

- (UIImageView *)rigntImgV{
    if (!_rigntImgV) {
        _rigntImgV = [[UIImageView alloc]init];
        _rigntImgV.image = [UIImage imageNamed:@"Settings_arrow"];
    }
    return _rigntImgV;
    
}

@end

#pragma mark ========================================================================

@implementation LifeCostPropertyFeeListChooseBtnAndInfoCell

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
        [self.backView addSubview:self.leftChooseBtn];
        [self setChooseBtnUI];
        self.moneyL.textColor = Y_ColorWith16FromRGB(0xFF3A3A);//红色
    }
    return self;
}
- (void)setChooseBtnUI{
 
    WEAKSELF
    [_leftChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftChooseBtn.superview).offset(15);
        make.centerY.equalTo(_leftChooseBtn.superview);
        make.width.height.offset(20);
    }];
    [weakSelf.typeNameL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.typeNameL.superview).offset(10);
        make.left.equalTo(_leftChooseBtn.mas_right).offset(10);
        make.width.lessThanOrEqualTo(weakSelf.typeNameL.superview).offset(-60);
        make.height.offset(20);
    }];
    
    //点击范围
    [_leftChooseBtn setHitTestEdgeInsets: UIEdgeInsetsMake(-10, -5, -10, -5)];
    
}

#pragma mark =========

- (UIButton *)leftChooseBtn{
    if (!_leftChooseBtn) {
        _leftChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftChooseBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"gouxuan_Kong"]  selectedImg:[UIImage imageNamed:@"gouxuan_Blue"]];
        [_leftChooseBtn addTarget:self action:@selector(leftChooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _leftChooseBtn.selected = NO;
     }
    return _leftChooseBtn;
}
- (void)leftChooseBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    if (isNil(self.gouXuanBlock)) {
        return;
    }
    self.gouXuanBlock(sender.selected); 
}
@end

#pragma mark =========

@implementation LifeCostPropertyFeeListCenterShowMonthInfoCell

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
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //
        [self.backView addSubview:self.centerL];
   
        [_centerL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_centerL.superview);
        }];
    }
    return self;
}
 
- (UILabel *)centerL{
    if (!_centerL) {
        _centerL = [[UILabel alloc]init];
       _centerL.textColor = [ThemeManager shareManager].mainTextColor;
        _centerL.textAlignment = NSTextAlignmentCenter;
        _centerL.font = [UIFont boldSystemFontOfSize:15.0];
    }
    return _centerL;
}
@end
