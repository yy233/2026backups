//
//  MyOrderDetailVcWillEvaluation.m
//  Community
//
//  Created by 余莹 on 2021/2/18.
//

#import "MyOrderDetailVcIsCancel.h"

@interface MyOrderDetailVcIsCancel () <MyOrderDetailVcTopBtnsTableViewCellDelegate>

@end

@implementation MyOrderDetailVcIsCancel  
- (void)viewDidLoad {
//    self.listType = MyOrderListCell_Type_IsCancel;
    [super viewDidLoad];
    [self initData];
}
 
- (void)initData{
   
}
#pragma mark - Table view data source
//
- (UITableViewCell *)tableView:(UITableView *)tableView topInfoCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        MyOrderDetailVcBaseTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderDetailVcBaseTextTableViewCell_Identifier];
        if (!cell) {
            cell = [[MyOrderDetailVcBaseTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyOrderDetailVcBaseTextTableViewCell_Identifier];
        }
        cell.topTitleL.text = @"订单超时未支付";
        cell.detailL.text = @"超过15分钟未支付，订单已自动取消";
        return cell;
    }else{
        MyOrderDetailVcTopBtnsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderDetailVcTopBtnsTableViewCell_Identifier];
        if (!cell) {
            cell = [[MyOrderDetailVcTopBtnsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyOrderDetailVcTopBtnsTableViewCell_Identifier];
        }
        cell.delegate = self;
//        [cell fillBtnsWithArr:@[@"逛逛别家",@"再来一单"].mutableCopy andImgNameArr:@[@"Cancelled_Otherstores",@"Cancelled_Onemoreorder"].mutableCopy whitType:MyOrderListCell_Type_IsCancel];
        return cell;
    }
}

#pragma mark == MyOrderDetailVcTopBtnsTableViewCell delegate
- (void)topBtncellType:(MyOrderListCell_Type)type subBtnTouchBtnIndex:(NSInteger)index{
    DLog(@"");
    if (index==0) {
        DLog(@"逛逛别家");
    }else if (index==1){
        DLog(@"再来一单");
    }else{
        DLog(@"");
    }
}
@end
