//
//  MyCarListInfoVcAddBtnTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/5/9.
//

#import "MyCarListInfoVcAddBtnTableViewCell.h"

@implementation MyCarListInfoVcAddBtnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//重写 add cell
- (void)setBaseUI{
    WEAKSELF
    [weakSelf.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(weakSelf.imgV.superview);
        make.height.equalTo(weakSelf.imgV.superview).offset(-0);
        make.width.equalTo(weakSelf.imgV.superview).offset(-0);
    }];
    [weakSelf.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.imgV);
    }];
    [self imgOtherUI];
}
- (void)imgOtherUI{
    
    CGRect carPlateBounds =  CGRectMake(0, 0, Screen_W-(16)*2, 60);//60为cell_h 框的h
    CAShapeLayer * border = [BezierPathTool drawDotLineWithThisViewBounds:carPlateBounds
                                                            withLineColor: Y_ColorWith16FromRGB(0xC5C9D4)
                                                            withFillColor:nil
                                                            withLineWidth:1.f
                                                              AndLineType:nil
                                                         withCornerRadius:10.f
                                                      withRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)];
    [self.imgV.layer addSublayer:border];//虚线框
    self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD;

}
@end
