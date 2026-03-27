//
//  PopViewWithTiXianAndChongZhi.m
//  Community
//
//  Created by 余莹 on 2021/10/13.
//

#import "PopViewWithTiXianAndChongZhi.h"
static NSString *weiXinImgStr = @"BalanceWeiXinLogo";
static NSString *zhiFuBaoImgStr = @"Balance_zhifubao";

@implementation PopViewWithTiXianAndChongZhi
#pragma mark - UITableViewDataSource
//数据部分
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;//self.dataSource.count;
}
//header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   return 40;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"请选择";
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *sectionTextL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 30)];
    sectionTextL.textAlignment = NSTextAlignmentCenter;
    sectionTextL.textColor =  [ThemeManager shareManager].mainTextColor;
    sectionTextL.text = @"选择方式";
    return sectionTextL;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
   return [UIView new];
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
   if (!cell) {
       cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
       cell.backgroundColor = [UIColor clearColor];
       cell.contentView.backgroundColor = [UIColor clearColor];
     // cell.accessoryType = UITableViewCellAccessoryCheckmark;
   }
   cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
   cell.textLabel.textAlignment = NSTextAlignmentCenter;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"微信";
            cell.imageView.image = [UIImage imageNamed:weiXinImgStr];
            cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
            break;
        case 1:
            cell.textLabel.text = @"支付宝";
            cell.imageView.image = [UIImage imageNamed:zhiFuBaoImgStr];
            cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
            break;
        default:
            cell.imageView.image =  nil;
            break;
    }
   return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_chooseTypeDelegate && [_chooseTypeDelegate respondsToSelector:@selector(popViewWithChooseType:)]) {
        [self dismissThePopView];
         switch (indexPath.row) {
             case 0:
                 [self.chooseTypeDelegate popViewWithChooseType:ChooseType_WeiXin];
                 break;
             case 1:
                 [self.chooseTypeDelegate popViewWithChooseType:ChooseType_ZhiFuBao];
                 break;
             default:
                // [self.chooseTypeDelegate popViewWithChooseType:ChooseType_Null];
                 break;
         }
    }
  
}

- (void)tableViewOtherSet{
    self.tableView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
}

@end
