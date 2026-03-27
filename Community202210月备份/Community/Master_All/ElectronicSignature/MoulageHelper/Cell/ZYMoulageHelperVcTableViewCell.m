//
//  ZYMoulageHelperVcTableViewCell.m
//  Community
//
//  Created by zhsj on 2021/4/15.
//

#import "ZYMoulageHelperVcTableViewCell.h"

@interface ZYMoulageHelperVcTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *yrzImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yrzImageViewWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yrzImageViewRightConstraint;

@end

@implementation ZYMoulageHelperVcTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.dateLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 设置数据model
- (void)setModel:(ZYAllContractTemplatesDataListModel *)model {
    _model = model;
    
    self.titleLabel.text = _model.name;
    self.dateLabel.text = _model.createTime;
    self.showButton.layer.borderWidth = 1;
    self.showButton.layer.borderColor = Y_RGBA(38, 114, 249, 1).CGColor;
    
    if (_model.approvalStatus == 1) {
        self.yrzImageView.hidden = NO;
        self.yrzImageViewWidthConstraint.constant = 18;
        self.yrzImageViewRightConstraint.constant = 2;
    }else {
        self.yrzImageView.hidden = YES;
        self.yrzImageViewWidthConstraint.constant = 0;
        self.yrzImageViewRightConstraint.constant = 0;
    }
}

@end
