//
//  ZYRentContractDetailCell.m
//  Community
//
//  Created by ZY on 2021/8/21.
//

#import "ZYRentContractDetailCell.h"

@interface ZYRentContractDetailCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIView *nameContentView;

@property (weak, nonatomic) IBOutlet UILabel *nameTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *arrowsImageView;

@property (weak, nonatomic) IBOutlet UIView *nameLineView;

@property (weak, nonatomic) IBOutlet UILabel *startDateTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;

@property (weak, nonatomic) IBOutlet UIView *startDateLineView;

@property (weak, nonatomic) IBOutlet UILabel *endDateTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;

@property (weak, nonatomic) IBOutlet UIView *endDateLineView;

@property (weak, nonatomic) IBOutlet UILabel *sendTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *sendLabel;

@property (weak, nonatomic) IBOutlet UIView *sendLineView;

@property (weak, nonatomic) IBOutlet UILabel *acceptTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *acceptLabel;

@end

@implementation ZYRentContractDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    
    self.nameTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.nameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.arrowsImageView.image = [[ZYThemeManager shareManager] themeImageNamed:@"ic_weirenz"];
    self.nameLineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    
    self.startDateTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.startDateLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.startDateLineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    
    self.endDateTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.endDateLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.endDateLineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    
    self.sendTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.sendLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.sendLineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    
    self.acceptTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.acceptLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    
    [self.nameContentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameContentViewTap)]];
}

// 设置数据model
- (void)setModel:(ZYSigningDetailDataModel *)model {
    _model = model;
    
    self.nameLabel.text = _model.conName;
    self.startDateLabel.text = _model.createTime;
    self.endDateLabel.text = [NSString stringWithFormat:@"%@-%@", _model.startDate.xh_format_yyyyMMdd, _model.endDate.xh_format_yyyyMMdd];
    self.sendLabel.text = _model.initiator;
    self.acceptLabel.text = _model.signatory;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 点击事件
- (void)nameContentViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(nameContentViewTapEvent)]) {
        [self.delegate nameContentViewTapEvent];
    }
}

@end
