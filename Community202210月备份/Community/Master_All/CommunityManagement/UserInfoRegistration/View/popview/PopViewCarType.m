//
//  PopViewCarType.m
//  Community
//
//  Created by 余莹 on 2020/12/11.
//

#import "PopViewCarType.h"
#import "CarTypeChooseBtn.h"
#define Car_SubBtn_Tag 260
@implementation PopViewCarType

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.hidden = YES;
        self.oneBackV.hidden = YES;
    }
    return self;
}
//重写 点击后赋值的部分
- (void)carTypeModeChoose:(CarTypeChooseBtn *)sender{
    self.carTypeMode = self.cartypeModleArr[sender.tag-Car_SubBtn_Tag];
    if (_delegateOfCarType && [_delegateOfCarType respondsToSelector:@selector(popViewChooseCarTypeModle:)]) {
        [_delegateOfCarType popViewChooseCarTypeModle:self.carTypeMode];
    }
    [self dismissThePopView];
}
//重写UI
- (void)setUI{
    [self.cartypeItemBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.cartypeItemBackView.superview).insets(UIEdgeInsetsMake(20, 16, 20, 16));
    }];
}
#pragma mark == 内容高度 重写
- (void)initSubMainHeight{
    self.subMainViewHeight  = 180;
}
@end
