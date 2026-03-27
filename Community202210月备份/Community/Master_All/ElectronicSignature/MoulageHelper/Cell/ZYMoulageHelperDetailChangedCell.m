//
//  ZYMoulageHelperDetailChangedCell.m
//  Community
//
//  Created by ZY on 2021/5/6.
//

#import "ZYMoulageHelperDetailChangedCell.h"

@implementation ZYMoulageHelperDetailChangedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 设置数据model
- (void)setModel:(ZYMoulageHelperDetailtParamsModel *)model {
    _model = model;
    
    self.titleLabel.text = _model.tName;
    if (model.tEditableParty == 1) {
        self.contentTF.hidden = YES;
        self.clearButton.hidden = YES;
        self.typeButton.hidden = YES;
        self.contentLabel.hidden = NO;
        self.contentLabel.userInteractionEnabled = NO;
        self.contentLabel.text = _model.tValue;
        self.contentLabel.textColor = Y_RGBA(51, 51, 51, 1);
        
        return;
    }
    
    self.contentTF.text = _model.tValue;
    self.contentTF.placeholder = [NSString stringWithFormat:@"请输入%@", _model.tName];
    self.typeButton.hidden = NO;
    if ([_model.tType isEqualToString:@"string"]) {
        self.contentTF.hidden = NO;
        self.contentTF.keyboardType = UIKeyboardTypeDefault;
        self.contentLabel.hidden = YES;
        self.clearButton.hidden = YES;
        [self.typeButton setTitle:@"文本" forState:UIControlStateNormal];
    }else if ([_model.tType isEqualToString:@"number"]) {
        self.contentTF.hidden = NO;
        self.contentTF.keyboardType = UIKeyboardTypeDecimalPad;
        self.contentLabel.hidden = YES;
        self.clearButton.hidden = YES;
        [self.typeButton setTitle:@"数字" forState:UIControlStateNormal];
    }else if ([_model.tType isEqualToString:@"time"]) {
        self.contentTF.hidden = YES;
        self.contentLabel.hidden = NO;
        self.contentLabel.userInteractionEnabled = YES;
        [self.typeButton setTitle:@"时间" forState:UIControlStateNormal];
        if (_model.tValue.length > 0) {
            self.clearButton.hidden = NO;
            self.contentLabel.text = _model.tValue;
            self.contentLabel.textColor = Y_RGBA(51, 51, 51, 1);
        }else {
            self.clearButton.hidden = YES;
            self.contentLabel.text = [NSString stringWithFormat:@"请选择%@", _model.tName];
            self.contentLabel.textColor = Y_RGBA(200, 200, 200, 1);
        }
    }else if ([_model.tType isEqualToString:@"money"]) {
        self.contentTF.hidden = NO;
        self.contentTF.keyboardType = UIKeyboardTypeDecimalPad;
        self.contentLabel.hidden = YES;
        self.clearButton.hidden = YES;
        [self.typeButton setTitle:@"金额" forState:UIControlStateNormal];
    }else if ([_model.tType isEqualToString:@"option"]) {
        self.contentTF.hidden = YES;
        self.contentLabel.hidden = NO;
        self.contentLabel.userInteractionEnabled = YES;
        [self.typeButton setTitle:@"选项" forState:UIControlStateNormal];
        if (_model.tValue.length > 0) {
            self.clearButton.hidden = NO;
            self.contentLabel.text = _model.tValue;
            self.contentLabel.textColor = Y_RGBA(51, 51, 51, 1);
        }else {
            self.clearButton.hidden = YES;
            self.contentLabel.text = [NSString stringWithFormat:@"请选择%@", _model.tName];
            self.contentLabel.textColor = Y_RGBA(200, 200, 200, 1);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
