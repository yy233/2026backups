//
//  ZYZhangManagerVcTableViewCell.m
//  Community
//
//  Created by ZY on 2021/5/10.
//

#import "ZYZhangManagerVcTableViewCell.h"

@interface ZYZhangManagerVcTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *signatureImageView;

@end

@implementation ZYZhangManagerVcTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    [self.titleView cornerRadiusWithRadius:11 corners:UIRectCornerTopRight | UIRectCornerBottomRight];
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.titleView.backgroundColor = Y_RGBA(226, 227, 234, 1);
        self.titleLabel.textColor = Y_RGBA(136, 136, 136, 1);
    }else {
        self.titleView.backgroundColor = Y_RGBA(62, 81, 119, 1);
        self.titleLabel.textColor = Y_RGBA(148, 157, 170, 1);
    }
    [self.deleteButton setImage:[[ZYThemeManager shareManager] themeImageNamed:@"ic_delete"] forState:UIControlStateNormal];
    self.deleteButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
}

// 设置model
- (void)setModel:(ZYZhangManagerDataModel *)model {
    _model = model;
    
    if (model.type == 0) {
        self.titleLabel.text = @"个人系统印章";
        self.deleteButton.userInteractionEnabled = NO;
        self.deleteButton.hidden = YES;
    }else if (model.type == 2) {
        self.titleLabel.text = @"个人印章";
        self.deleteButton.userInteractionEnabled = YES;
        self.deleteButton.hidden = NO;
    }
    [self.signatureImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kElectronicSignatureImageBaseUrl, _model.sealUrl]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
