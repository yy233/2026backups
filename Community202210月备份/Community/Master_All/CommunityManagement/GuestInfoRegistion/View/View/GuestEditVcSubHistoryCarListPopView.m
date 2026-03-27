//
//  GuestEditVcSubHistoryCarListPopView.m
//  Community
//
//  Created by 余莹 on 2021/10/27.
//

#import "GuestEditVcSubHistoryCarListPopView.h"
#define Popview_Tag_CarHistoryList 305
@implementation GuestEditVcSubHistoryCarListPopView
#pragma mark == 重写
 
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
//    CarInfoModel *model = [CarInfoModel mj_objectWithKeyValues:self.dataSource[indexPath.row]];
//    NSString *carNameStr = self.dataSource[indexPath.row];
    CarInfoModel *carModel = [CarInfoModel mj_objectWithKeyValues:self.dataSource[indexPath.row]]; 
    NSString *carNameStr = [TextShowWithModelStr textShowWithModelStr:carModel.carPlate];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",carNameStr];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(basePopViewTag:OfSubTableViewTouchWithIndexPath:)]) {
        [self dismissThePopView];
        [self.delegate basePopViewTag:Popview_Tag_CarHistoryList  OfSubTableViewTouchWithIndexPath:indexPath];
    }
}

@end
