//
//  PopViewAddressBookDetaillPhoneList.m
//  Community
//
//  Created by 余莹 on 2020/12/19.
//

#import "PopViewAddressBookDetaillPhoneList.h"
#define HeaderView_Height 50
@implementation PopViewAddressBookDetaillPhoneList
- (void)showInView:(UIView *)supview thePopViewTableViewHeight:(float)tableViewHeight WithArray:(NSMutableArray *)array withHeaderViewTitle:(NSString *)titleStr{
    self.headertitleStr = titleStr;
    [self showInView:supview thePopViewTableViewHeight:tableViewHeight WithArray:array];
}
#pragma mark == header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HeaderView_Height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_W, HeaderView_Height)];
    headerLabel.backgroundColor = [UIColor whiteColor];
    headerLabel.text = self.headertitleStr;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    return headerLabel;
}
#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"UITableViewCell"];
    }
    cell.separatorInset =  UIEdgeInsetsMake(0, 16, 0, 16);
    MainCenterCollectionViewAddressBookCellModel *model =  [MainCenterCollectionViewAddressBookCellModel mj_objectWithKeyValues:self.dataSource[indexPath.row]];
    cell.textLabel.text = model.person;
    cell.detailTextLabel.text = model.phone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MainCenterCollectionViewAddressBookCellModel *model = [MainCenterCollectionViewAddressBookCellModel mj_objectWithKeyValues:self.dataSource[indexPath.row]];
    [self callPhoneWithStr:model.phone];//
}
- (void)callPhoneWithStr:(NSString *)phoneStr{
    NSMutableString *callStr=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneStr];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callStr]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callStr] options:@{} completionHandler:nil];

    /**
     NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneStr];
     UIWebView * callWebview = [[UIWebView alloc] init];
     [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
     [self.view addSubview:callWebview];
     */
    
}

//***重写高度时使用
- (void)setSubMainViewHeight{
    self.tableViewHeight = Screen_H*0.6;
}
@end
