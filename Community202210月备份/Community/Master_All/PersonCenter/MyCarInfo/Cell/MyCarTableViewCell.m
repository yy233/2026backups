//
//  MyCarTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/8/5.
//

#import "MyCarTableViewCell.h"

@implementation MyCarTableViewCell

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
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backView.layer.cornerRadius = 5;
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.backView.superview).insets(UIEdgeInsetsMake(5, 16, 5, 16));
        }];
//        self.backView.backgroundColor = Color_11BlueColor;
        self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self.backView addSubview:self.imgV];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.rightPopShowBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_imgV.superview);
        make.left.equalTo(_imgV.superview).offset(16);
        make.width.offset(20);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_titleL.superview);
        make.width.equalTo(_titleL.superview).multipliedBy(0.6);
        make.left.equalTo(_imgV.mas_right).offset(5);
    }];
    [_rightPopShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rightPopShowBtn.superview);
        make.width.offset(20);
        make.height.offset(30);
        make.right.equalTo(_rightPopShowBtn.superview).offset(-16);
    }];
}
#pragma mark ==
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        if ([ThemeManager shareManager].type == ThemeType_Drak) {
            _imgV.image = [UIImage imageNamed:@"che"];
        }else{
            _imgV.image = [UIImage imageNamed:@"che_bluecolor"];
        }
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgV;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont systemFontOfSize:15];
    }
    return _titleL;
}
- (UIButton *)rightPopShowBtn{
    if (!_rightPopShowBtn) {
        _rightPopShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if ([ThemeManager shareManager].type == ThemeType_Drak) {
            [_rightPopShowBtn newAnBtnWithImg:[UIImage imageNamed:@"gengduo1"]];
        }else{
            [_rightPopShowBtn newAnBtnWithImg:[UIImage imageNamed:@"gengduo_GrayColor"]];
        }
        [_rightPopShowBtn addTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightPopShowBtn;
}
- (void)editBtnAction{
    self.editActionBlock();   
}
@end
