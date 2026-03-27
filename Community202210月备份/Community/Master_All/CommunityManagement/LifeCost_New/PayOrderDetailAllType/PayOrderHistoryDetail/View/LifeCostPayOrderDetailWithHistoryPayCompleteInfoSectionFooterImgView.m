//
//  LifeCostPayOrderDetailWithHistoryPayCompleteInfoSectionFooterImgView.m
//  Community
//
//  Created by 余莹 on 2022/1/7.
//

#import "LifeCostPayOrderDetailWithHistoryPayCompleteInfoSectionFooterImgView.h"

@implementation LifeCostPayOrderDetailWithHistoryPayCompleteInfoSectionFooterImgView

- (void)setUI{//重写
    WEAKSELF
    [self.imgV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.imgV.superview).insets(UIEdgeInsetsMake(0, 6, 0, 6));
    }];
}
- (void)fillDataWithSectionOneBool:(BOOL)isSectionOneBool{
   
    if (isSectionOneBool) {//中心间隔图片
        if ([ThemeManager shareManager].type == ThemeType_White) {
            self.imgV.image = [UIImage imageNamed:@"OrderDetailCenterV"];
        }else{
            self.imgV.image = [UIImage imageNamed:@"OrderDetailCenterV_D"];
        }
    }else{//底部带齿图片
        if ([ThemeManager shareManager].type == ThemeType_White) {
            self.imgV.image = [UIImage imageNamed:@"OrderDetailFooterV"];
        }else{
            self.imgV.image = [UIImage imageNamed:@"OrderDetailFooterV_D"];
        }
    }
}

@end
