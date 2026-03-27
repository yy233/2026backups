//
//  PopViewWithChangeFamilyTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/11/26.
//

#import "PopViewWithChangeFamilyTableViewCell.h"
#define Color_TypeTextBtn            Y_ColorWith16FromRGB(0x539CFC)

@interface PopViewWithChangeFamilyTableViewCell ()
@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UIButton *typeStrShowBtn;
@end

@implementation PopViewWithChangeFamilyTableViewCell

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
//        self.backgroundColor = [UIColor whiteColor];
//        self.contentView.backgroundColor = [UIColor whiteColor];
//        self.textLabel.textColor = Y_ColorWith16FromRGB(0x6E727D);
//        self.textLabel.font = [PensionThemeManager shareManager].Pension_TextFont_14;
//        self.detailTextLabel.textColor = Y_ColorWith16FromRGB(0xFF0033);
//        self.detailTextLabel.font = [PensionThemeManager shareManager].Pension_TextFont_14;
        [self.contentView addSubview:self.nameL];
        [self.contentView addSubview:self.typeStrShowBtn];
        [self.contentView addSubview:self.rightBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameL.superview).offset(26);
        make.centerY.height.equalTo(_nameL.superview);
    }];
    [_typeStrShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameL);
        make.left.equalTo(_nameL.mas_right).offset(10);
        make.width.offset(49);
        make.height.offset(20);
    }];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_nameL.superview).offset(-26);
        make.centerY.height.equalTo(_nameL.superview);
        make.width.offset(20);
    }];
}

#pragma mark ===
- (UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc]init];
        _nameL.font = [PensionThemeManager shareManager].Pension_TextFont_B15;
        _nameL.textColor = [UIColor blackColor];
    }
    return _nameL;
}
- (UIButton *)typeStrShowBtn{
    if (!_typeStrShowBtn) {
        _typeStrShowBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
        [_typeStrShowBtn newAnBtnWithLayerCorNerNum:8.5 withLayerLineWidth:0.5 withLayerLineColor:Color_TypeTextBtn];
        [_typeStrShowBtn newAnBtnWithTextColorNomal:Color_TypeTextBtn
                              withTextColorSelected:Color_TypeTextBtn
                                           withFont:[PensionThemeManager shareManager].Pension_TextFont_12
                                 withLayerCorNerNum:8.5
                                 withLayerLineWidth:0.5
                                 withLayerLineColor:Color_TypeTextBtn ];

    }
    return _typeStrShowBtn;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"yl_quanquan"] selectedImg:[UIImage imageNamed:@"yl_gouxuan"]];
        _rightBtn.userInteractionEnabled = NO;
    }
    return _rightBtn;
}
- (void)fillDataWithModel:(ZYFamilyArchiveModel *)model{
    self.nameL.text = [TextShowWithModelStr textShowWithModelStr:model.name];

    if ([TextShowWithModelStr textShowWithModelStr: model.relationText].length>0) {
        [self.typeStrShowBtn newAnBtnWithTextStr: [TextShowWithModelStr textShowWithModelStr: model.relationText]];
        self.typeStrShowBtn.hidden  = NO;
    }else{
        self.typeStrShowBtn.hidden  = YES;
    }
  
}

@end
