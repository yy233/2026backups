//
//  UnitSubPoPview.m
//  Community
//
//  Created by 余莹 on 2020/12/3.
//

#import "SubPoPViewWithFloor.h"

#define Tag_SubPopView_Floor  360 //单元
@implementation SubPoPViewWithFloor

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    FloorModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.floor;
    return cell;
}
- (void)setTopText:(NSString *)titleStr{
    self.tableViewbackViewTopLabel.text = @"楼层";
}
#pragma mark == 点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(popViewTag:OfSubTableViewTouchWithIndexPath:)]) {
        [self dismissThePopView];
        [self.delegate popViewTag:Tag_SubPopView_Floor OfSubTableViewTouchWithIndexPath:indexPath];
    }
}
@end
