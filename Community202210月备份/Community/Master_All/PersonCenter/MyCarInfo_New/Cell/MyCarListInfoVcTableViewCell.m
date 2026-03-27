//
//  MyCarListInfoVcTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/5/9.
//

#import "MyCarListInfoVcTableViewCell.h"

@implementation MyCarListInfoVcTableViewCell

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
 
        self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD;

        [self.backView addSubview:self.deletBtn];
        [self setDeletUI];
    }
    return self;
}

//重写 车牌
- (void)setBaseUI{
    self.carPlateL.font = [UIFont boldSystemFontOfSize:18.0];
    WEAKSELF
    [weakSelf.carPlateL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(weakSelf.carPlateL.superview);
        make.height.equalTo(weakSelf.carPlateL.superview).offset(-0);//高度等高
        make.width.equalTo(weakSelf.carPlateL.superview).offset(-0);//外间距16 内间距0
    }];
    [self carPlateLOtherUI];

}
- (void)carPlateLOtherUI{
    //kMyCarSpotListCellSubConentViewUseJianJu16
    CGRect carPlateBounds =  CGRectMake(0, 0, Screen_W-(16)*2, 60);//60为cell_h 也是label的高

    CGSize carPlateCornerRadiSize = CGSizeMake(10, 10);
    //上半的圆角
    self.carPlateL.layer.mask = [BezierPathTool bezierPathToolWithThisViewBounds:carPlateBounds
                                                              withCornerRadi:carPlateCornerRadiSize
                                                         withRoundingCorners: (UIRectCornerTopLeft | UIRectCornerTopRight)];
}


//
- (void)setDeletUI{
     
    [_deletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_deletBtn.superview);
        make.width.height.offset(25.0);
        make.right.equalTo(_deletBtn.superview).offset(-20.0);
    }];
}
- (UIButton *)deletBtn{
    if (!_deletBtn) {
        _deletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deletBtn newAnBtnWithImg:[UIImage imageNamed:@"clsc_icon_green"]];
        [_deletBtn addTarget:self action:@selector(deletBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deletBtn;
}

- (void)deletBtnAction{
    if (isNil(self.touchDelActionBlock)) {
        return;
    }
    self.touchDelActionBlock();
}
@end
