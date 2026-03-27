//
//  ZYLifeCostHouseholdBottomView.m
//  Community
//
//  Created by ZY on 2022/1/6.
//

#import "ZYLifeCostHouseholdBottomView.h"

@interface ZYLifeCostHouseholdBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation ZYLifeCostHouseholdBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.addButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [self.addButton addTarget:self action:@selector(addButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)addButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addButtonEvent)]) {
        [self.delegate addButtonEvent];
    }
}

@end
