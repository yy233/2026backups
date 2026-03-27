//
//  ZYCommunityFairIssueVideoCell.m
//  Community
//
//  Created by ZY on 2022/6/13.
//

#import "ZYCommunityFairIssueVideoCell.h"

@interface ZYCommunityFairIssueVideoCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ZYCommunityFairIssueVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.videoView.backgroundColor = [UIColor zy_colorWithHexString:@"#EFF1F7"];
    }else {
        self.videoView.backgroundColor = [UIColor zy_colorWithHexString:@"#11254B"];
    }
    self.videoView.layer.borderWidth = 0.5;
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.videoView.layer.borderColor = [UIColor zy_colorWithHexString:@"#C5C9D4"].CGColor;
    }else {
        self.videoView.layer.borderColor = [UIColor zy_colorWithHexString:@"#2E4674"].CGColor;
    }
    
    [self.videoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoViewTap)]];
    
    [self.playButton addTarget:self action:@selector(playButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton addTarget:self action:@selector(deleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 处理点击事件
- (void)videoViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoViewEvent)]) {
        [self.delegate videoViewEvent];
    }
}

- (void)playButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playButtonEvent)]) {
        [self.delegate playButtonEvent];
    }
}

- (void)deleteButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoDeleteButtonEvent)]) {
        [self.delegate videoDeleteButtonEvent];
    }
}

@end
