//
//  SubPoPViewWithAddressDetail.m
//  Community
//
//  Created by 余莹 on 2020/12/3.
//

#import "SubPoPViewWithAddressDetail.h"

#define Tag_SubPopView_AddressDetail  361 //门牌

@implementation SubPoPViewWithAddressDetail

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    AddressModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.door;
    return cell;
}
- (void)setTopText:(NSString *)titleStr{
    self.tableViewbackViewTopLabel.text = @"门牌";
}
#pragma mark == 点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(popViewTag:OfSubTableViewTouchWithIndexPath:)]) {
        [self dismissThePopView];
        [self.delegate popViewTag:Tag_SubPopView_AddressDetail OfSubTableViewTouchWithIndexPath:indexPath];
    }
}
@end
