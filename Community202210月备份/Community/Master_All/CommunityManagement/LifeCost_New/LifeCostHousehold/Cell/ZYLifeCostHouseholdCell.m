//
//  ZYLifeCostHouseholdCell.m
//  Community
//
//  Created by ZY on 2022/1/6.
//

#import "ZYLifeCostHouseholdCell.h"

@interface ZYLifeCostHouseholdCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation ZYLifeCostHouseholdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.infoLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    
    [self.deleteButton addTarget:self action:@selector(deleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

// 设置数据model
- (void)setModel:(ZYLifeCostHouseholdListModel *)model {
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.typePicUrl] placeholderImage:[UIImage imageNamed:@"morenjiaofei_icon"]];
    self.titleLabel.text = _model.typeName;
    self.infoLabel.text = [NSString stringWithFormat:@"%@|%@",  [TextShowWithModelStr textShowWithModelStr:_model.account], [TextShowWithModelStr textShowWithModelStr:_model.householder]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 处理点击事件
- (void)deleteButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteButtonEventWithModel:)]) {
        [self.delegate deleteButtonEventWithModel:self.model];
    }
}

@end
