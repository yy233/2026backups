//
//  PopviewWithBaseChoose.m
//  Community
//
//  Created by 余莹 on 2022/1/6.
//

#import "PopviewWithBaseChoose.h"


@implementation PopviewWithBaseChoose
#pragma mark == 重写
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
        [self initSubUI];
    }
    return self;
}

#pragma mark == 内容高度 重写
- (void)initSubMainHeight{
    self.subMainViewHeight  = Screen_H*0.35;
}
#pragma mark == 边角 重写
- (void)changMainBackViewCornerRadius{
    self.subMainBackView.layer.cornerRadius = 10;
}
 
#pragma mark == UI

- (PopViewSubHeaderView *)headerView{
   if (!_headerView) {
       _headerView = [[PopViewSubHeaderView alloc]initWithFrame:CGRectMake(-1, -1, Screen_W+2, 44)];
       _headerView.layer.masksToBounds = YES;
       _headerView.clipsToBounds = YES;
   }
   return _headerView;
}
#pragma mark ==
- (void)initSubView{
    self.subMainBackView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor;
    [self.subMainBackView addSubview:self.headerView];
    WEAKSELF
    self.headerView.isTouchhOkBtnBoolBlock = ^(BOOL isTouchhOkBtnBool) {
        if (isTouchhOkBtnBool) {
            //选择yes
            [weakSelf touchOkAction];
            [weakSelf dismissThePopView];
        }else{
            [weakSelf dismissThePopView];
        }
    };
    [self addSubPickV];
}
- (void)addSubPickV{
    
}
- (void)initSubUI{
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerView.superview).offset(-1);
        make.width.equalTo(_headerView.superview).offset(2);
        make.centerX.equalTo(_headerView.superview);
        make.height.offset(44);
    }];
   
    [self setSubPickvUI];
}
- (void)setSubPickvUI{
  
}

#pragma mark ===
- (void)touchOkAction{
    DLog(@"");

}
 


@end
