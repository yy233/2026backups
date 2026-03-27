//
//  ZYMedicalMainNearShopCell.m
//  Community
//
//  Created by ZY on 2021/12/1.
//

#import "ZYMedicalMainNearShopCell.h"
#import "CDZStarsControl.h"

@interface ZYMedicalMainNearShopCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *stopTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *decLabel;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (nonatomic, strong) CDZStarsControl *starsControl;

@end

@implementation ZYMedicalMainNearShopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.iconImageView zy_cornerRadiusAdvance:2 rectCornerType:UIRectCornerAllCorners];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.starView addSubview:self.starsControl];
}

- (CDZStarsControl *)starsControl{
    if (!_starsControl) {
        _starsControl = [CDZStarsControl.alloc initWithFrame:CGRectMake(0, 0, 66, 11) stars:5 starSize:CGSizeMake(11, 11) noramlStarImage:[UIImage imageNamed:@"yl_huixing"] highlightedStarImage:[UIImage imageNamed:@"yl_nonexing"]];
        _starsControl.userInteractionEnabled = NO;
    }
    
    return _starsControl;
 }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillDataWithStoreShopModel:(MedicalStoresBaseModel *)model{
    self.shopNameLabel.text = [TextShowWithModelStr textShowWithNotNullStr:model.shopName];
    self.scoreLabel.text = [NSString stringWithFormat:@"%0.1f分",model.grade];
    self.stopTypeLabel.text = [TextShowWithModelStr textShowWithNotNullStr:model.shopTreeIdName];
    self.distanceLabel.text =  [NSString stringWithFormat:@"%0.1fkm",(double)(model.distance/1000)];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    self.decLabel.text = [TextShowWithModelStr textShowWithNotNullStr:model.title];
    [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr:model.shopLogo] placeholderImage:[UIImage imageNamed:@"yl_yytox"]];
    self.starsControl.score = model.grade;
}
@end
