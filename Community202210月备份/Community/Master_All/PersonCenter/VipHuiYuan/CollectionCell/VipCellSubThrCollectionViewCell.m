//
//  VipCellSubThrCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/3.
//

#import "VipCellSubThrCollectionViewCell.h"

@implementation VipCellSubThrCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgV.image = [UIImage imageNamed:@"Members_Dosingpackage_bottom"];
        [self setBaseLabelUI];
        [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.backV);
        }];
        //font color
        self.titleL.font = FontSize_Vip_Bold(12);
        self.centerL.font = FontSize_Vip_Nomail(11);
        self.centerL.textColor = Color_brown192;
        self.bottomL.font = FontSize_Vip_Nomail(12);
        self.bottomL.textColor = COlor_Red255;
    }
    return self;
}

@end
