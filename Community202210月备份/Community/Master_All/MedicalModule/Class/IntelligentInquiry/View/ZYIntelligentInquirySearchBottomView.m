//
//  ZYIntelligentInquirySearchBottomView.m
//  Community
//
//  Created by ZY on 2021/12/2.
//

#import "ZYIntelligentInquirySearchBottomView.h"

@implementation ZYIntelligentInquirySearchBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewTap)]];
}

#pragma mark - 处理点击事件
- (void)bottomViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomViewEvent)]) {
        [self.delegate bottomViewEvent];
    }
}

@end
