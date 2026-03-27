//
//  VipCellSubFourCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/3.
//

#import "VipCellSubFourCollectionViewCell.h"

@implementation VipCellSubFourCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgV.image = [UIImage imageNamed:@"Members_chart"];
        [self setColorAndFont];
        [self setUI]; 
    }
    return self;
}
- (void)setUI{
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.backV).insets(UIEdgeInsetsMake(0, 0, -60, 0));
        make.top.left.right.equalTo(self.backV);
        make.height.offset(110);
    }];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.imgV);
        make.height.offset(20);
        make.top.equalTo(self.imgV.mas_bottom);
    }];
    [self.centerL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.backV);
        make.top.equalTo(self.titleL.mas_bottom);
    }];
    [self.bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerL.mas_right);
        make.centerY.equalTo(self.centerL.mas_centerY);
        make.right.equalTo(self.backV.mas_right);
    }];
    self.titleL.textAlignment = NSTextAlignmentLeft;
    self.centerL.textAlignment = NSTextAlignmentLeft;
    self.bottomL.textAlignment = NSTextAlignmentLeft;
}
- (void)setColorAndFont{
    //font color
    self.titleL.font = FontSize_Vip_Nomail(15);
    self.centerL.font = FontSize_Vip_Bold(22);
    self.bottomL.font = FontSize_Vip_Nomail(12);
    self.titleL.textColor = [UIColor blackColor];
    self.centerL.textColor = [UIColor blackColor];
    self.bottomL.textColor = Y_RGBA(153, 153, 153, 1);
}
@end
