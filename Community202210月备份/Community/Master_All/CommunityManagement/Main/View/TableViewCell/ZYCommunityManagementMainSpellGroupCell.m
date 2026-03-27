//
//  ZYCommunityManagementMainSpellGroupCell.m
//  Community
//
//  Created by ZY on 2022/4/7.
//

#import "ZYCommunityManagementMainSpellGroupCell.h"

@interface ZYCommunityManagementMainSpellGroupCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (weak, nonatomic) IBOutlet UIView *numView;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *originPriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *spellGroupButton;

@end

@implementation ZYCommunityManagementMainSpellGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    [self.contentV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentVTap)]];
    self.nameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    
    self.numView.layer.borderColor = [UIColor zy_colorWithHexString:@"#FF6231"].CGColor;
    self.numView.layer.borderWidth = 0.5;
    self.numView.layer.cornerRadius = 2;
    self.numView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 设置数据model
- (void)setModel:(ZYSmallShopGoodsSpellGroupDetailModel *)model {
    _model = model;
    
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    [self.contentV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentVTap)]];
    self.nameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    
    if (isNil(_model)) {
        self.contentV.hidden = YES;
        return;
    }
    self.contentV.hidden = NO;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.commodityHeadImg] placeholderImage:[UIImage imageNamed:@"cc_placeholder"]];
    self.nameLabel.text = _model.commodityName;
    if (_model.groupSpellPersonNumber > 0) {
        self.progressViewWidthConstraint.constant = (CGFloat)_model.personSpell/_model.groupSpellPersonNumber*125;
        self.progressLabel.text = [NSString stringWithFormat:@"已抢%.lf%%", (CGFloat)_model.personSpell/_model.groupSpellPersonNumber*100];
    }
    self.numLabel.text = [NSString stringWithFormat:@"限%ld份", _model.groupSpellPersonNumber];
    self.priceLabel.text = [NSString stringWithFormat:@"%@", [ZYDecimalNumberTool stringWithDecimalString:_model.groupSpellPrice]];
    self.originPriceLabel.text = [NSString stringWithFormat:@"原价￥%@", [ZYDecimalNumberTool stringWithDecimalString:_model.commodityOriginalPrice]];
}

#pragma mark - 处理点击事件
- (void)contentVTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentVEvent)]) {
        [self.delegate contentVEvent];
    }
}

@end
