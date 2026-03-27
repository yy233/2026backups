//
//  SmallShopMyBoxCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2022/3/10.
//

#import "SmallShopMyBoxCollectionViewCell.h"

@interface SmallShopMyBoxCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@property (weak, nonatomic) IBOutlet UILabel *boxNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (weak, nonatomic) IBOutlet UIButton *addDayBtn;

@end


@implementation SmallShopMyBoxCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.addDayBtn newAnBtnWithLayerCorNerNum:12.5 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
    self.iconImageView.contentMode = UIViewContentModeScaleToFill;
}
- (void)fillDataWithBoxModel:(SmallShopMyBoxModel *)boxModel{
    self.titleLabel.text = [TextShowWithModelStr textShowWithNotNullStr:boxModel.title];// @"货柜名字";
    self.sizeLabel.text = [NSString stringWithFormat:@"尺寸：%ld立方米",boxModel.cabinetSize];// @"尺寸：1立方米";
    self.boxNumberLabel.text = [NSString stringWithFormat:@"编号：%@",[TextShowWithModelStr textShowWithNotNullStr:boxModel.cabinetNumber]]; //@"编号：001";
    self.dayLabel.text = [NSString stringWithFormat:@"%ld天",boxModel.residueDay];//@"0天";
    [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr: boxModel.cabinetImg]   placeholderImage:[UIImage imageNamed:@"cc_placeholder"]];
}
- (IBAction)addDayBtnAction:(UIButton *)sender {
    if (isNotNil(self.cellSubAddDayBtnBlock)) {
        self.cellSubAddDayBtnBlock();
    }
}

@end
