//
//  ZYElectronicNewsDetailShowFooterView.m
//  Community
//
//  Created by ZY on 2021/4/13.
//

#import "ZYElectronicNewsDetailShowFooterView.h"

@interface ZYElectronicNewsDetailShowFooterView ()

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ZYElectronicNewsDetailShowFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.collectionButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    self.commentsButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    self.likeButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
}

@end
