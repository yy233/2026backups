//
//  PopViewWithChangeCommunity.m
//  Community
//
//  Created by 余莹 on 2021/6/18.
//

#import "PopViewWithChangeCommunity.h"

@implementation PopViewWithChangeCommunity

//重写
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *sectionHeaderL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 50)];
    sectionHeaderL.backgroundColor = Color_245Gray;
    sectionHeaderL.textAlignment = NSTextAlignmentCenter;
    sectionHeaderL.font = [UIFont boldSystemFontOfSize:20];
    sectionHeaderL.textColor = [UIColor blackColor];
    if (self.selfType == IssuLastAddressCellSubBasePopView_Type_Community) {
        sectionHeaderL.text = @"切换社区";
    }
    if (self.selfType== MyHouseListChangeShowHouseList_Type_House) {
        sectionHeaderL.text = @"切换房屋";
    }
    return sectionHeaderL;
}
@end
