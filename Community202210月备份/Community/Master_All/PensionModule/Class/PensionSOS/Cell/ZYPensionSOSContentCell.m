//
//  ZYPensionSOSContentCell.m
//  Community
//
//  Created by ZY on 2021/11/17.
//

#import "ZYPensionSOSContentCell.h"

@interface ZYPensionSOSContentCell ()

@property (weak, nonatomic) IBOutlet UIButton *urgencyButton;

@property (weak, nonatomic) IBOutlet UIButton *findWayButton;

@property (weak, nonatomic) IBOutlet UIButton *addressBookButton;

@end

@implementation ZYPensionSOSContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.findWayButton.layer.borderWidth = 2;
    self.findWayButton.layer.borderColor = [UIColor zy_colorWithHexString:@"#36C8C1"].CGColor;
    self.findWayButton.layer.cornerRadius = 5;
    self.findWayButton.layer.masksToBounds = YES;
    [self.urgencyButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:6];
    [self.findWayButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:4];
    
    [self.urgencyButton addTarget:self action:@selector(urgencyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.findWayButton addTarget:self action:@selector(findWayButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.addressBookButton addTarget:self action:@selector(addressBookButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 处理点击事件
- (void)urgencyButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(urgencyButtonEvent)]) {
        [self.delegate urgencyButtonEvent];
    }
}

- (void)findWayButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(findWayButtonEvent)]) {
        [self.delegate findWayButtonEvent];
    }
}

- (void)addressBookButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addressBookButtonEvent)]) {
        [self.delegate addressBookButtonEvent];
    }
}

@end
