//
//  ZYContractSignCompleteDetailCell.m
//  Community
//
//  Created by ZY on 2021/5/26.
//

#import "ZYContractSignCompleteDetailCell.h"

@interface ZYContractSignCompleteDetailCell ()

// 合同名称
@property (weak, nonatomic) IBOutlet UILabel *conNameLabel;

// 签署完成时间
@property (weak, nonatomic) IBOutlet UILabel *signCompleteDateLabel;

// 发起方视图
@property (weak, nonatomic) IBOutlet UIView *partAView;

@property (weak, nonatomic) IBOutlet UIView *partALineView;

@property (weak, nonatomic) IBOutlet UILabel *partATitleLabel;

// 发起方
@property (weak, nonatomic) IBOutlet UILabel *partALabel;

// 发起方签署图片
@property (weak, nonatomic) IBOutlet UIImageView *partAImageView;

// 发起方签署状态
@property (weak, nonatomic) IBOutlet UILabel *partASignStateLabel;

@property (weak, nonatomic) IBOutlet UILabel *partATitleTelLabel;

// 发起方联系方式
@property (weak, nonatomic) IBOutlet UILabel *partATelLabel;

@property (weak, nonatomic) IBOutlet UILabel *partATitleSignDateLabel;

// 发起方签署时间
@property (weak, nonatomic) IBOutlet UILabel *partASignDateLabel;

// 签约方视图
@property (weak, nonatomic) IBOutlet UIView *partBView;

@property (weak, nonatomic) IBOutlet UIView *partBLineView;

@property (weak, nonatomic) IBOutlet UILabel *partBTitleLabel;

// 签约方
@property (weak, nonatomic) IBOutlet UILabel *partBLabel;

// 签约方签署图片
@property (weak, nonatomic) IBOutlet UIImageView *partBImageView;

// 签约方签署状态
@property (weak, nonatomic) IBOutlet UILabel *partBSignStateLabel;

@property (weak, nonatomic) IBOutlet UILabel *partBTitleTelLabel;

// 签约方联系方式
@property (weak, nonatomic) IBOutlet UILabel *partBTelLabel;

@property (weak, nonatomic) IBOutlet UILabel *partBTitleSignDateLabel;

// 签约方签署时间
@property (weak, nonatomic) IBOutlet UILabel *partBSignDateLabel;

// 合同视图
@property (weak, nonatomic) IBOutlet UIView *contractView;

@end

@implementation ZYContractSignCompleteDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.conNameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.signCompleteDateLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_D949daa;
    
    self.partAView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_Lf0f1f6;
    self.partALineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.partATitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.partALabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.partASignStateLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.partATitleTelLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_D949daa;
    self.partATelLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_D949daa;
    self.partATitleSignDateLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_D949daa;
    self.partASignDateLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_D949daa;
    
    
    self.partBView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_Lf0f1f6;
    self.partBLineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.partBTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.partBLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.partBSignStateLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.partBTitleTelLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_D949daa;
    self.partBTelLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_D949daa;
    self.partBTitleSignDateLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_D949daa;
    self.partBSignDateLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_D949daa;
    
    [self.contractView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contractViewTap)]];
}

// 设置数据model
- (void)setModel:(ZYContrectAllListDataListModel *)model {
    _model = model;
    
    self.conNameLabel.text = _model.conName;
    self.signCompleteDateLabel.text = [NSString stringWithFormat:@"签署完成时间：%@", _model.signedTime];
    self.partALabel.text = _model.partAName;
    self.partATelLabel.text = _model.partAPhone;
    self.partASignDateLabel.text = _model.partASignTime;
    self.partBLabel.text = _model.partBName;
    self.partBTelLabel.text = _model.partBPhone;
    self.partBSignDateLabel.text = _model.partBSignTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 点击事件
- (void)contractViewTap {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(contractViewTapEvent)]) {
        [self.delegate contractViewTapEvent];
    }
}

@end
