//
//  ZYActivityApplyDetatilInfoCell.m
//  Community
//
//  Created by ZY on 2021/8/2.
//

#import "ZYActivityApplyDetatilInfoCell.h"
#import <objc/runtime.h>

@interface ZYActivityApplyDetatilInfoCell ()

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@end

@implementation ZYActivityApplyDetatilInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.topView.backgroundColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    }else {
        self.topView.backgroundColor = [UIColor zy_colorWithHexString:@"#000F26"];
    }
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.nameTF.backgroundColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    }else {
        self.nameTF.backgroundColor = [UIColor zy_colorWithHexString:@"#001027"];
    }
    self.nameTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    Ivar ivarN = class_getInstanceVariable([self.nameTF class], "_placeholderLabel");
    id placeholderLabelN = object_getIvar(self.nameTF, ivarN);
    [placeholderLabelN performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
    
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.telTF.backgroundColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    }else {
        self.telTF.backgroundColor = [UIColor zy_colorWithHexString:@"#001027"];
    }
    self.telTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    Ivar ivarT = class_getInstanceVariable([self.telTF class], "_placeholderLabel");
    id placeholderLabelT = object_getIvar(self.telTF, ivarT);
    [placeholderLabelT performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
    
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.bottomLabel.textColor = [UIColor zy_colorWithHexString:@"#AAAAB9"];
    }else {
        self.bottomLabel.textColor = [UIColor zy_colorWithHexString:@"#638BC6"];
    }
}

// 设置数据model
- (void)setModel:(ZYActivityApplyDetailDataModel *)model {
    _model = model;
    
    if (_model.status == 0) {
        self.nameTF.userInteractionEnabled = YES;
        self.telTF.userInteractionEnabled = YES;
    }else {
        self.nameTF.userInteractionEnabled = NO;
        self.telTF.userInteractionEnabled = NO;
    }
    self.nameTF.text = _model.name;
    self.telTF.text = _model.mobile;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
