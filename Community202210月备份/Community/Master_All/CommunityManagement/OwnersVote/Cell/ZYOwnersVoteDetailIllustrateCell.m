//
//  ZYOwnersVoteDetailIllustrateCell.m
//  Community
//
//  Created by ZY on 2021/8/3.
//

#import "ZYOwnersVoteDetailIllustrateCell.h"

@interface ZYOwnersVoteDetailIllustrateCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ZYOwnersVoteDetailIllustrateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

// 设置数据model
- (void)setModel:(ZYOwnersVoteDetailDataModel *)model {
    _model = model;
    
    self.contentLabel.text = [NSString stringWithFormat:@"投票内容说明：%@", _model.content];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
