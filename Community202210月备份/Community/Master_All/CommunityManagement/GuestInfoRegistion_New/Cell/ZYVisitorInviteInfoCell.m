//
//  ZYVisitorInviteInfoCell.m
//  Community
//
//  Created by ZY on 2022/5/20.
//

#import "ZYVisitorInviteInfoCell.h"

@interface ZYVisitorInviteInfoCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *nameTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *nameLineView;

@property (weak, nonatomic) IBOutlet UILabel *telTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (weak, nonatomic) IBOutlet UIView *telLineView;

@property (weak, nonatomic) IBOutlet UILabel *addressTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIView *addressLineView;

@property (weak, nonatomic) IBOutlet UILabel *reasonTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;

@property (weak, nonatomic) IBOutlet UIView *reasonLineView;

@property (weak, nonatomic) IBOutlet UILabel *dateTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ZYVisitorInviteInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.nameTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.nameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.nameLineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.telTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.telLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.telLineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.addressTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.addressLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.addressLineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.reasonTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.reasonLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.reasonLineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.dateTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.dateLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

// 设置数据model
- (void)setModel:(GuestInfoWillRegisterModel *)model {
    _model = model;
    
    self.nameLabel.text = _model.name;
    self.telLabel.text = _model.contact;
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@", [ShareUserInfo sharedUserInfo].commuityInfo.name, _model.address];
    self.reasonLabel.text = _model.reasonStr;
    if (![_model.startTime.xh_formatYueRi isEqual:_model.endTime.xh_formatYueRi]) {
        self.dateLabel.text = [NSString stringWithFormat:@"%@至%@", _model.startTime.xh_formatYueRi, _model.endTime.xh_formatYueRi];
    }else {
        self.dateLabel.text = _model.startTime.xh_formatYueRi;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
