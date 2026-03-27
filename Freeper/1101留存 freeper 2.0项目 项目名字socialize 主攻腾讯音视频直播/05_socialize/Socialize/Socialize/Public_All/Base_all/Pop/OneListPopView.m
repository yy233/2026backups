//
//  OneListPopView.m
//  Socialize
//
//  Created by 余莹 on 2023/5/30.
//

#import "OneListPopView.h"

@implementation OneListPopView

- (void)tableViewOtherSet{
    self.closeBtn.hidden = YES;
    self.tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    self.tableView.layer.cornerRadius = 0.1;
}
 
 
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.textColor =  [UIColor whiteColor];
    cell.textLabel.text =  [TextShowWithModelStr textShowWithModelStr:  self.dataSource[indexPath.row]];
    return cell;
}
 
@end
