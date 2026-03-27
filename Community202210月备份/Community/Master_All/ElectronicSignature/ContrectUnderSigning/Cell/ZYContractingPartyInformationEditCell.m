//
//  ZYContractingPartyInformationEditCell.m
//  Community
//
//  Created by ZY on 2021/5/18.
//

#import "ZYContractingPartyInformationEditCell.h"

@interface ZYContractingPartyInformationEditCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *TFView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ZYContractingPartyInformationEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.contentTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    Ivar ivarC = class_getInstanceVariable([self.contentTF class], "_placeholderLabel");
    id placeholderLabelC = object_getIvar(self.contentTF, ivarC);
    [placeholderLabelC performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
}

// 设置数据
- (void)setModel:(ZYContractingPartyInformationEditModel *)model {
    _model = model;
    
    self.titleLabel.text = _model.title;
    if ([_model.type isEqualToString:@"TF"]) {
        self.TFView.hidden = NO;
        self.selectView.hidden = YES;
        self.contentTF.text = _model.content;
        self.contentTF.placeholder = [NSString stringWithFormat:@"请输入%@", _model.title];
    }else {
        self.TFView.hidden = YES;
        self.selectView.hidden = NO;
        if (_model.content.length > 0) {
            self.contentLabel.text = _model.content;
            self.contentLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
        }else {
            self.contentLabel.text = [NSString stringWithFormat:@"请选择%@", _model.title];
            self.contentLabel.textColor = [ZYThemeManager shareManager].placeholderThemeColor;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
