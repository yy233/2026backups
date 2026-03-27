//
//  MyOrderDetailVcWillUse.m
//  Community
//
//  Created by 余莹 on 2021/2/18.
//

#import "MyOrderDetailVcWillUse.h"

@interface MyOrderDetailVcWillUse () <MyOrderDetailVcTopBtnsTableViewCellDelegate>

@end

@implementation MyOrderDetailVcWillUse
- (void)viewDidLoad {
    self.listType = MyOrderListCell_Type_WillUse;
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
        cell.topTitleL.text = self.orderModel.deliveryWay==1 ? @"预计18:32 送达" : @"";//暂时没得这个键
        
        cell.detailL.text = self.orderModel.deliveryWay==1 ? @"由商家提供配送服务" : @"门店自提";
        return cell;
    }else{
        MyOrderDetailVcTopBtnsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderDetailVcTopBtnsTableViewCell_Identifier];
        if (!cell) {
            cell = [[MyOrderDetailVcTopBtnsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyOrderDetailVcTopBtnsTableViewCell_Identifier];
        }
        cell.delegate = self;
        [cell fillBtnsWithArr:@[@"申请退款",@"致电商家"].mutableCopy andImgNameArr:@[@"Tobeused_Applyforarefund",@"Tobeused_Callthemerchant"].mutableCopy whitType:MyOrderListCell_Type_WillUse];
        return cell;
    }
}

#pragma mark == MyOrderDetailVcTopBtnsTableViewCell delegate
- (void)topBtncellType:(MyOrderListCell_Type)type subBtnTouchBtnIndex:(NSInteger)index{
    DLog(@"");
    if (index==0) {
        DLog(@"申请退款");
    }else if (index==1){
        DLog(@"致电商家");
        [MyOrderCallShopTool callShopWithOrderModel:self.orderModel];
    }else{
        DLog(@"");
    }
}
@end
