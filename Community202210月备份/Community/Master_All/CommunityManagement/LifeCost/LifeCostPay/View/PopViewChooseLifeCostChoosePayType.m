//
//  PopViewChooseLifeCostChoosePayType.m
//  Community
//
//  Created by 余莹 on 2021/3/11.
//

#import "PopViewChooseLifeCostChoosePayType.h"

@interface PopViewChooseLifeCostChoosePayType ()
//@property (nonatomic,strong) NSMutableArray *titleArr;
//@property (nonatomic,strong) NSMutableArray *imgNameArr;
@end

@implementation PopViewChooseLifeCostChoosePayType

#pragma mark == 重写
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.titleArr.count;
    return self.dataSource.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *sectionTextL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 30)];
    sectionTextL.textAlignment = NSTextAlignmentCenter;
    sectionTextL.text = @"选择支付方式";
    return sectionTextL;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.text = self.dataSource[indexPath.row];
    if ([cell.textLabel.text isEqualToString:@"支付宝"]) {
        cell.imageView.image = [UIImage imageNamed:@"Alipay"];
    }else if ([cell.textLabel.text isEqualToString:@"微信"]){
        cell.imageView.image = [UIImage imageNamed:@"WeChat"];
    }
//    cell.textLabel.text = self.titleArr[indexPath.row];
//    cell.imageView.image = [UIImage imageNamed:self.imgNameArr[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(basePopViewTag:OfSubTableViewTouchWithIndexPath:)]) {
        [self.delegate basePopViewTag:0  OfSubTableViewTouchWithIndexPath:indexPath];
        [self dismissThePopView];
    }
    
//    NSInteger payTypeNum = 0;
//    if ([self.delegate respondsToSelector:@selector(basePopViewTag:OfSubTableViewTouchWithIndexPath:)]) {
//        if ([self.dataSource[indexPath.row] isEqualToString:@"支付宝"]) {
//            payTypeNum  =  1;
//        }else if ([self.dataSource[indexPath.row] isEqualToString:@"微信"]){
//            payTypeNum  =  0;
//        }
//        [self.delegate basePopViewTag:0  OfSubTableViewTouchWithIndexPath:payTypeNum];
//        [self dismissThePopView];
//    }
}
#pragma mark ===

//- (NSMutableArray *)titleArr{
//    if (!_titleArr) {
//        if ([WXApi isWXAppInstalled]) {
//            _titleArr = [[NSMutableArray alloc]initWithObjects:@"支付宝",@"微信", nil];
//        }else{
//            _titleArr = [[NSMutableArray alloc]initWithObjects:@"支付宝", nil];
//        }
//    }
//    return _titleArr;
//}
//- (NSMutableArray *)imgNameArr{
//    if (!_imgNameArr) {
//        if ([WXApi isWXAppInstalled]) {
//            _imgNameArr = [[NSMutableArray alloc]initWithObjects:@"Alipay",@"WeChat", nil];
//        }else{
//            _imgNameArr = [[NSMutableArray alloc]initWithObjects:@"Alipay", nil];
//        }
//    }
//    return _imgNameArr;
//}


 
@end
