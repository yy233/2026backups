//
//  PopViewChooseAuthorisation.m
//  Community
//
//  Created by 余莹 on 2020/12/9.
//

#import "PopViewChooseAuthorisation.h"

@implementation PopViewChooseAuthorisation

//***重写高度时使用
- (void)setSubMainViewHeight{
    self.tableViewHeight = 200;
}
#pragma mark == 点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(basePopViewTag:OfSubTableViewTouchWithIndexPath:)]) {
        [self dismissThePopView];
        [self.delegate basePopViewTag:self.tag OfSubTableViewTouchWithIndexPath:indexPath];//base=tag=0
    }
}

#pragma mark == cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    AccessModel *model = self.dataSource[indexPath.row];//社区授权or楼栋授权的model
    cell.textLabel.text = model.name;
    return cell;
}

@end
