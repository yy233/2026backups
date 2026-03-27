//
//  SmallShopInfomationVC.m
//  Community
//
//  Created by 余莹 on 2022/3/26.
//

#import "SmallShopInfomationVC.h"
#import "SmallShopInfoListTableViewCell.h"
@interface SmallShopInfomationVC ()

@end

@implementation SmallShopInfomationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息列表";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = Line_Color_LightGray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SmallShopInfoListTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:SmallShopInfoListTableViewCell_I];
    if (!cell) {
        cell = [[SmallShopInfoListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SmallShopInfoListTableViewCell_I];
    }
    [cell fillDataWithModel:self.dataSourceArr[indexPath.row]];
    return cell;
}
@end
