//
//  ZYOwnersVoteDetailContentCell.m
//  Community
//
//  Created by ZY on 2021/8/3.
//

#import "ZYOwnersVoteDetailContentCell.h"

@interface ZYOwnersVoteDetailContentCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ZYOwnersVoteDetailContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    
    self.radioButton.hitTestEdgeInsets = UIEdgeInsetsMake(-6, -6, -6, -6);
}

// 设置数据model
- (void)setModel:(ZYOwnersVoteDetailDataVoteTopicEntityOptionsModel *)model {
    _model = model;
    
    self.contentLabel.text = model.content;
    if (_model.status == 0) {
        self.radioButton.selected = NO;
    }else {
        self.radioButton.selected = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
