//
//  ZYIssueActivityTopCell.m
//  Community
//
//  Created by ZY on 2021/11/15.
//

#import "ZYIssueActivityTopCell.h"

@interface ZYIssueActivityTopCell ()

@property (weak, nonatomic) IBOutlet UIView *activityView;

@end

@implementation ZYIssueActivityTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.activityView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activityViewTap)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 处理点击事件
- (void)activityViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(activityViewEvent)]) {
        [self.delegate activityViewEvent];
    }
}

@end
