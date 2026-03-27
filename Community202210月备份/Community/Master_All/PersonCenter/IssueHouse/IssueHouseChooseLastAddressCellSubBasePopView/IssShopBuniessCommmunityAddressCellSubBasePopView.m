//
//  IssShopBuniessCommmunityAddressCellSubBasePopView.m
//  Community
//
//  Created by 余莹 on 2021/3/5.
//

#import "IssShopBuniessCommmunityAddressCellSubBasePopView.h"

@implementation IssShopBuniessCommmunityAddressCellSubBasePopView
//
- (void)showInViewWithPopType:(IssuLastAddressCellSubBasePopView_Type)type
                withListArray:(NSMutableArray *)array{
    self.showDataArr = [[NSMutableArray alloc]init];
    //
    if (type==IssuLastAddressCellSubBasePopView_Type_Community) {
        //小区 id name
    }
    if (type==IssuLastAddressCellSubBasePopView_Type_Address) {
        //门牌相关  id  mergeName
    }
    if (type==IssShopBuniessCommmunityAddressCellSubBasePopView_Type_CommunityAddress) {
       //商铺地址 ==== 是用区域id查的社区
    }
    self.selfType = type;
    for (int i = 0 ; i <array.count; i ++) {
        [self.chooseTypeSaveArr addObject:@(0)];
    }
    //
    [self showInView:self.superview thePopViewSubViewHeight:0 WithArray:array];
}
 
@end
