//
//  ZYVisitorInviteEditCell.m
//  Community
//
//  Created by ZY on 2022/5/20.
//

#import "ZYVisitorInviteEditCell.h"

@interface ZYVisitorInviteEditCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *nameTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *nameLineView;

@property (weak, nonatomic) IBOutlet UILabel *telTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *telLineView;

@property (weak, nonatomic) IBOutlet UILabel *addressTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIView *addressLineView;

@property (weak, nonatomic) IBOutlet UILabel *reasonTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;

@property (weak, nonatomic) IBOutlet UIView *reasonLineView;

@property (weak, nonatomic) IBOutlet UILabel *dateTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *dateContentView;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ZYVisitorInviteEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.nameTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.nameLineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.telTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.telLineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.addressTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.addressLineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.reasonTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.reasonLineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.dateTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    
    self.addressLabel.textColor = [ZYThemeManager shareManager].placeholderThemeColor;
    self.reasonLabel.textColor = [ZYThemeManager shareManager].placeholderThemeColor;
    self.dateLabel.textColor = [ZYThemeManager shareManager].placeholderThemeColor;
    
    self.nameTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    Ivar ivarN = class_getInstanceVariable([self.nameTF class], "_placeholderLabel");
    id placeholderLabelN = object_getIvar(self.nameTF, ivarN);
    [placeholderLabelN performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
    
    self.telTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    Ivar ivarT = class_getInstanceVariable([self.telTF class], "_placeholderLabel");
    id placeholderLabelT = object_getIvar(self.telTF, ivarT);
    [placeholderLabelT performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
    
    [self.addressContentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressViewTap)]];
    [self.reasonContentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reasonViewTap)]];
    [self.dateContentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateViewTap)]];
}

// 设置数据model
- (void)setModel:(ZYVisitorInviteUploadModel *)model {
    _model = model;
    
    self.nameTF.text = _model.name;
    self.telTF.text = _model.contact;
    if (_model.address.length > 0) {
        self.addressLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@", [ShareUserInfo sharedUserInfo].commuityInfo.name, _model.address];
    }else {
        self.addressLabel.textColor = [ZYThemeManager shareManager].placeholderThemeColor;
        self.addressLabel.text = @"请选择来访小区地址";
    }
    if (_model.reasonStr.length > 0) {
        self.reasonLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
        self.reasonLabel.text = _model.reasonStr;
    }else {
        self.reasonLabel.textColor = [ZYThemeManager shareManager].placeholderThemeColor;
        self.reasonLabel.text = @"请选择来访事由";
    }
    if (_model.startTime.length > 0) {
        self.dateLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
        if (![_model.startTime.xh_formatYueRi isEqual:_model.endTime.xh_formatYueRi]) {
            self.dateLabel.text = [NSString stringWithFormat:@"%@至%@", _model.startTime.xh_formatYueRi, _model.endTime.xh_formatYueRi];
        }else {
            self.dateLabel.text = _model.startTime.xh_formatYueRi;
        }
    }else {
        self.dateLabel.textColor = [ZYThemeManager shareManager].placeholderThemeColor;
        self.dateLabel.text = @"请选择有效日期";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 处理点击事件
- (void)addressViewTap {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(addressViewEvent)]) {
        [self.delegate addressViewEvent];
    }
}

- (void)reasonViewTap {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(reasonViewEvent)]) {
        [self.delegate reasonViewEvent];
    }
}

- (void)dateViewTap {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(dateViewEvent)]) {
        [self.delegate dateViewEvent];
    }
}

@end
