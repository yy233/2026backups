//
//  ParkingTemporaryTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/8/6.
//

#import "ParkingTemporaryTableViewCell.h"

@implementation ParkingTemporaryTableViewCell

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
        [self.backView addSubview:self.nameL];
        [self.backView addSubview:self.editBtn];
        [self.backView addSubview:self.typeInfoBtn];
        [self setBaseUI]; 
    }
    return self;
}
- (void)setBaseUI{
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_nameL.superview);
        make.left.equalTo(_nameL.superview).offset(20);
        make.width.lessThanOrEqualTo(_nameL.superview).multipliedBy(0.7);
    }];
    [_typeInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameL.mas_right).offset(10);
        make.width.offset(36);
        make.height.offset(20);
        make.centerY.equalTo(_nameL);
    }];
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_editBtn.superview);
        make.width.offset(20);
        make.height.offset(30);
        make.right.equalTo(_editBtn.superview).offset(-16);
    }];
    
}
- (UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc]init];
        _nameL.font =  [UIFont systemFontOfSize:13];
        _nameL.textColor = Y_ColorWith16FromRGB(0x6A9EFF);
    }
    return _nameL;
}

- (UIButton *)typeInfoBtn{
    if (!_typeInfoBtn) {
        _typeInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_typeInfoBtn newAnBtnWithTextStr:@"默认"];
    }
    [_typeInfoBtn newAnBtnWithTextColor:[UIColor whiteColor] withBackColor:Y_ColorWith16FromRGB(0x5DCF70) withFont:[UIFont systemFontOfSize:11] withLayerCorNerNum:8 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];

    return _typeInfoBtn;
}
- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn newAnBtnWithImg:[UIImage imageNamed:@"gengduo1"]];
        [_editBtn newAnBtnWithFont:[UIFont systemFontOfSize:15]];
        [_editBtn addTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}
- (void)editBtnAction{
    self.eBlock();
}
@end
