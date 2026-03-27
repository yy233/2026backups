//
//  ZYElectronicNewsCommentsListFooterView.m
//  Community
//
//  Created by ZY on 2021/4/13.
//

#import "ZYElectronicNewsCommentsListFooterView.h"

@interface ZYElectronicNewsCommentsListFooterView ()

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ZYElectronicNewsCommentsListFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.contentTextView.backgroundColor = Y_RGBA(240, 241, 246, 1);
        self.lineView.backgroundColor = Y_RGBA(237, 237, 237, 1);
    }else {
        self.contentTextView.backgroundColor = Y_RGBA(238, 238, 238, 1);
        self.lineView.backgroundColor = Y_RGBA(17, 41, 87, 1);
    }
    
}

@end
