//
//  ZYCommunityFairIssueInputCell.m
//  Community
//
//  Created by ZY on 2022/6/13.
//

#import "ZYCommunityFairIssueInputCell.h"

@interface ZYCommunityFairIssueInputCell ()

@property (weak, nonatomic) IBOutlet UILabel *categoryTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *categoryView;

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *nameView;

@property (weak, nonatomic) IBOutlet UILabel *priceTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *priceView;

@property (weak, nonatomic) IBOutlet UILabel *discussLabel;

@property (weak, nonatomic) IBOutlet UIButton *discussButton;

@end

@implementation ZYCommunityFairIssueInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.categoryTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.categoryView.layer.borderWidth = 0.5;
    self.categoryView.layer.borderColor = [ZYThemeManager shareManager].borderThemeColor.CGColor;
    self.categoryLabel.textColor = [ZYThemeManager shareManager].placeholderThemeColor;
    
    self.nameTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.nameView.layer.borderWidth = 0.5;
    self.nameView.layer.borderColor = [ZYThemeManager shareManager].borderThemeColor.CGColor;
    self.nameTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    Ivar ivarN = class_getInstanceVariable([self.nameTF class], "_placeholderLabel");
    id placeholderLabelN = object_getIvar(self.nameTF, ivarN);
    [placeholderLabelN performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
    
    self.priceTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.priceView.layer.borderWidth = 0.5;
    self.priceView.layer.borderColor = [ZYThemeManager shareManager].borderThemeColor.CGColor;
    self.priceTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    Ivar ivarP = class_getInstanceVariable([self.priceTF class], "_placeholderLabel");
    id placeholderLabelP = object_getIvar(self.priceTF, ivarP);
    [placeholderLabelP performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
    
    self.discussLabel.textColor = [ZYThemeManager shareManager].placeholderThemeColor;
    self.discussButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    
    [self.categoryView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(categoryViewTap)]];
    [self.discussButton addTarget:self action:@selector(discussButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

// 设置数据model
- (void)setModel:(ZYCommunityFairIssueModel *)model {
    _model = model;
    
    if (_model.categoryName.length > 0) {
        self.categoryLabel.text = _model.categoryName;
        self.categoryLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    }else {
        self.categoryLabel.text = @"请选择类别";
        self.categoryLabel.textColor = [ZYThemeManager shareManager].placeholderThemeColor;
    }
    self.nameTF.text = _model.goodsName;
    self.priceTF.text = _model.price;
    if (_model.negotiable) {
        self.priceTF.text = @"";
        self.priceTF.userInteractionEnabled = NO;
        self.discussButton.selected = YES;
    }else {
        self.priceTF.userInteractionEnabled = YES;
        self.discussButton.selected = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 处理点击事件
- (void)categoryViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryViewEvent)]) {
        [self.delegate categoryViewEvent];
    }
}

- (void)discussButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(discussButtonEvent)]) {
        [self.delegate discussButtonEvent];
    }
}

@end
