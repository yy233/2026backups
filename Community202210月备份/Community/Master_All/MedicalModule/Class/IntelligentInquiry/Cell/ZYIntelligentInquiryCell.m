//
//  ZYIntelligentInquiryCell.m
//  Community
//
//  Created by ZY on 2021/12/2.
//

#import "ZYIntelligentInquiryCell.h"

@interface ZYIntelligentInquiryCell ()

@property (weak, nonatomic) IBOutlet UIView *pfView;

@property (weak, nonatomic) IBOutlet UIView *kfView;

@property (weak, nonatomic) IBOutlet UIView *kqView;

@property (weak, nonatomic) IBOutlet UIView *tjView;

@property (weak, nonatomic) IBOutlet UIView *rtView;

@property (weak, nonatomic) IBOutlet UIView *zyView;

@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@end

@implementation ZYIntelligentInquiryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.pfView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pfViewTap)]];
    [self.kfView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(kfViewTap)]];
    [self.kqView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(kqViewTap)]];
    [self.tjView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tjViewTap)]];
    [self.rtView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rtViewTap)]];
    [self.zyView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zyViewTap)]];
    [self.recordButton addTarget:self action:@selector(recordButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 处理点击事件
- (void)pfViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pfViewEvent)]) {
        [self.delegate pfViewEvent];
    }
}

- (void)kfViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(kfViewEvent)]) {
        [self.delegate kfViewEvent];
    }
}

- (void)kqViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(kqViewEvent)]) {
        [self.delegate kqViewEvent];
    }
}

- (void)tjViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tjViewEvent)]) {
        [self.delegate tjViewEvent];
    }
}

- (void)rtViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rtViewEvent)]) {
        [self.delegate rtViewEvent];
    }
}

- (void)zyViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(zyViewEvent)]) {
        [self.delegate zyViewEvent];
    }
}

- (void)recordButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordButtonEvent)]) {
        [self.delegate recordButtonEvent];
    }
}

@end
