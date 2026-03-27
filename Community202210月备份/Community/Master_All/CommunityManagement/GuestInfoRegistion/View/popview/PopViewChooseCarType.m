//
//  PopViewChooseCarType.m
//  Community
//
//  Created by 余莹 on 2020/12/15.
//

#import "PopViewChooseCarType.h"
#import "CarTypeModel.h"
#import "CarTypeChooseBtn.h"
#define Car_SubBtn_Tag 260
#define Popview_Tag_CarType 303
 
@implementation PopViewChooseCarType
#pragma mark == 重写
//重写 点击后赋值的部分
- (void)carTypeModeChoose:(CarTypeChooseBtn *)sender{
    self.carTypeMode = self.cartypeModleArr[sender.tag-Car_SubBtn_Tag];
    if (self.delegateOfCarType && [self.delegateOfCarType respondsToSelector:@selector(popViewChooseCarTypeModle:)]) {//PopViewCarTypeDelegate
        [self.delegateOfCarType popViewChooseCarTypeModle:self.carTypeMode];
    }
    [self dismissThePopView];
}

@end
