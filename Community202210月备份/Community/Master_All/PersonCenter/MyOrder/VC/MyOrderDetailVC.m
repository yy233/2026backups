//
//  MyOrderDetailVC.m
//  Community
//
//  Created by 余莹 on 2021/2/5.
//

#import "MyOrderDetailVC.h"

@interface MyOrderDetailVC () <MyOrderDetailVcTopBtnsTableViewCellDelegate>

@end

@implementation MyOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarTextColor:[UIColor blackColor] andBarItemsColor:[UIColor blackColor] andBackViewCustomColor:Color_245Gray];
}
- (void)initView{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = Color_245Gray;
    switch ( self.listType) {
        case MyOrderListCell_Type_WillPay:
            self.title = @"等待支付";
            break;
//        case MyOrderListCell_Type_IsCancel:
//            self.title = @"订单已取消";
//            break;
        case MyOrderListCell_Type_ReturnCom:
            self.title = @"订单已取消";
            break;
        case MyOrderListCell_Type_WillUse:
            self.title = @"商家已经接单";
            break;
//        case MyOrderListCell_Type_EndDeal:
//            self.title = @"订单已完成";
//            break;
        case MyOrderListCell_Type_WillEvaluation:
            self.title = @"订单已完成";//@"评价"
            break;
     
        default:
            self.title = @"其他类型";//暂无
            break;
    }
    
}
- (void)initData{
//    self.orderModel ;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (isNil(self.orderModel)) {
        return 0;
    }
    if (self.listType==MyOrderListCell_Type_WillUse) {
        return 5;
    }else{
        return 4;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 2;
    }else if (section==1){//菜品区
//        return 8;
        return  self.orderModel.orderCommodityDtos.count+2;//topshopinfo|bottomMoneyinfo
        //包装费 配送费 满减数据 等数据
    }else if (section==2){//配送信息
        return 4;
    }else if(section==([tableView numberOfSections]-1)){//订单信息
        return 5;
    }else{//服务保障
        return 2;
    }
     return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==([tableView numberOfSections]-1)) {
        return 50;
    }else{
        return 0.1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //
    if (indexPath.section==0) {
        return 60;
    }else if (indexPath.section==1){//菜品区
        if (indexPath.row==0 || indexPath.row==[tableView numberOfRowsInSection:indexPath.section]-1) {//topshopinfo|bottomMoneyinfo
            return 60;
//        }else if ((indexPath.row==[tableView numberOfRowsInSection:indexPath.section]-2) || (indexPath.row==[tableView numberOfRowsInSection:indexPath.section]-3)){//优惠券等
//            return 30;
        }else{
            return 80;
        }
    }else if (indexPath.section==2){//配送信息
        if (indexPath.row==0) {
            return 60;
        }else{
            return 45;
        }
        return 45;
    }else if(indexPath.section==([tableView numberOfSections]-1)){//订单信息
        return 45;
    }else{//服务保障
        if (indexPath.row==0) {
            return 60;
        }else{
            return 40;
        }
    }
     return 0;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return [self tableView:tableView topInfoCellForRowAtIndexPath:indexPath];
    }else if (indexPath.section==1){//菜品区
        return [self tableView:tableView dishesInfoCellForRowAtIndexPath:indexPath];
    }else if (indexPath.section==2){//配送信息
        return [self tableView:tableView peiSongInfoCellForRowAtIndexPath:indexPath];
    }else if(indexPath.section==([tableView numberOfSections]-1)){//订单信息
        return [self tableView:tableView dingDanInfoCellForRowAtIndexPath:indexPath];
    }else{//服务保障
        return [self tableView:tableView fuWuBaoZhangCellForRowAtIndexPath:indexPath];
    }
  
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView topInfoCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        MyOrderDetailVcBaseTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderDetailVcBaseTextTableViewCell_Identifier];
        if (!cell) {
            cell = [[MyOrderDetailVcBaseTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyOrderDetailVcBaseTextTableViewCell_Identifier];
        }
        cell.topTitleL.text = @"请尽快支付";
        cell.detailL.text = self.orderModel.deliveryWay==1 ? @"商家配送" : @"门店自提";
        return cell;
    }else{
        MyOrderDetailVcTopBtnsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderDetailVcTopBtnsTableViewCell_Identifier];
        if (!cell) {
            cell = [[MyOrderDetailVcTopBtnsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyOrderDetailVcTopBtnsTableViewCell_Identifier];
        }
        cell.delegate = self;
        [cell fillBtnsWithArr:@[@"取消订单",@"立即支付",@"联系商家"].mutableCopy andImgNameArr:@[@"取消订单",@"立即支付",@"联系商家"].mutableCopy whitType:MyOrderListCell_Type_WillPay];
        return cell;
    }
}
//菜品组 0shopinfo bottomX2money other=comms
- (UITableViewCell *)tableView:(UITableView *)tableView dishesInfoCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {//top
        MyOrderDetailVcBaseTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderDetailVcBaseTextTableViewCell_Identifier];
        if (!cell) {
            cell = [[MyOrderDetailVcBaseTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyOrderDetailVcBaseTextTableViewCell_Identifier];
        }
//        cell.topTitleL.text = [NSString stringWithFormat:@"%@(%@)",[TextShowWithModelStr textShowWithModelStr:self.orderModel.shopName],[TextShowWithModelStr textShowWithModelStr:self.orderModel.address]]; //@"阔斧重庆豆花小碗菜（人和店）";
        cell.topTitleL.text = [TextShowWithModelStr textShowWithModelStr:self.orderModel.shopName];
        cell.detailL.text = @"";//置空
        return cell;
    }else if(indexPath.row==[tableView numberOfRowsInSection:indexPath.section]-1){//bottom money
        MyOrderDetailVcCostMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderDetailVcCostMoneyTableViewCell_Identifier];
        if (!cell) {
            cell = [[MyOrderDetailVcCostMoneyTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyOrderDetailVcCostMoneyTableViewCell_Identifier];
        }
        cell.detailL.text = [NSString stringWithFormat:@"已优惠 ¥%0.2f 实付 ¥",self.orderModel.subtractPrice];
        cell.topTitleL.text = [NSString stringWithFormat:@"%0.2f",self.orderModel.orderPrice];
//        cell.detailL.text = @"已优惠 ¥10 实付 ¥";
//        cell.topTitleL.text = @"59.8";
        return cell;
//    }else if( (indexPath.row==[tableView numberOfRowsInSection:indexPath.section]-2) || (indexPath.row==[tableView numberOfRowsInSection:indexPath.section]-3) ){//券
//        MyOrderDetailVcSendInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderDetailVcSendInfoTableViewCell_Identifier];
//            if (!cell) {
//                cell = [[MyOrderDetailVcSendInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyOrderDetailVcSendInfoTableViewCell_Identifier];
//            }
//        cell.topTitleL.text = @"劵";
////        cell.detailL.text = @"¥5.1";
//        cell.detailL.text = [NSString stringWithFormat:@"¥%0.2f",self.orderModel.subtractPrice];
//            return cell;
    }else{
        //内cell
        MyOrderListVcDishesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderListVcDishesTableViewCell_Identifier];
        if (!cell) {
            cell = [[MyOrderListVcDishesTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyOrderListVcDishesTableViewCell_Identifier];
        }
        MyOrderModelSubCommodityModel *commModel = self.orderModel.orderCommodityDtos[indexPath.row-1];
        [cell fillDataWithCommModel:commModel];
//        cell.dishesImgV.image = [UIImage imageNamed:@"Shop_product"];//Orders_commodity_picture
//        cell.titleL.text = @"白菜心";
//        cell.numberL.text = @"x1";
//        cell.oldMoneyL.text = @"¥30";
//        cell.nowMoneyL.text = @"¥15.98";
        return cell;
    }
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView peiSongInfoCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        MyOrderDetailVcBaseTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderDetailVcBaseTextTableViewCell_Identifier];
        if (!cell) {
            cell = [[MyOrderDetailVcBaseTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyOrderDetailVcBaseTextTableViewCell_Identifier];
        }
        cell.topTitleL.text = self.peiSongSectionTitleArr[indexPath.row];
        cell.detailL.text = @"";//置空
        return cell;
    }else{
        MyOrderDetailVcSendInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderDetailVcSendInfoTableViewCell_Identifier];
        if (!cell) {
            cell = [[MyOrderDetailVcSendInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyOrderDetailVcSendInfoTableViewCell_Identifier];
        }
        cell.topTitleL.text = self.peiSongSectionTitleArr[indexPath.row];
        cell.detailL.text = self.peiSongSectionContentArr[indexPath.row];;
        return cell;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView dingDanInfoCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        MyOrderDetailVcBaseTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderDetailVcBaseTextTableViewCell_Identifier];
        if (!cell) {
            cell = [[MyOrderDetailVcBaseTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyOrderDetailVcBaseTextTableViewCell_Identifier];
        }
        cell.topTitleL.text = self.dingdanSectionTitleArr[indexPath.row];
        cell.detailL.text = @"";//置空
        return cell;
    }else{
        MyOrderDetailVcSendInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderDetailVcSendInfoTableViewCell_Identifier];
        if (!cell) {
            cell = [[MyOrderDetailVcSendInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyOrderDetailVcSendInfoTableViewCell_Identifier];
        }
        cell.topTitleL.text = self.dingdanSectionTitleArr[indexPath.row];
        cell.detailL.text = self.dingdanSectionContentArr[indexPath.row];
        return cell;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView fuWuBaoZhangCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        MyOrderDetailVcBaseTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderDetailVcBaseTextTableViewCell_Identifier];
        if (!cell) {
            cell = [[MyOrderDetailVcBaseTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyOrderDetailVcBaseTextTableViewCell_Identifier];
        }
        cell.topTitleL.text = @"服务保障";
        cell.detailL.text = @"";//置空
        return cell;
    }else{
        MyOrderDetailVcSendInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderDetailVcSendInfoTableViewCell_Identifier];
        if (!cell) {
            cell = [[MyOrderDetailVcSendInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyOrderDetailVcSendInfoTableViewCell_Identifier];
        }
        cell.topTitleL.text = @"号码保护";
        cell.detailL.text = @"隐藏手机号，保护隐私";
        return cell;
    }
}


#pragma mark == MyOrderDetailVcTopBtnsTableViewCell delegate
- (void)topBtncellType:(MyOrderListCell_Type)type subBtnTouchBtnIndex:(NSInteger)index{
    DLog(@"");
    switch (type) {
        case MyOrderListCell_Type_WillPay:
            if (index==0) {
                DLog(@"取消订单");
            }else if (index==1){
                DLog(@"立即支付");
            }else{
                DLog(@"联系商家");
            }
            break;
            
        default:
            break;
    }
}
#pragma mark ==
- (NSMutableArray *)peiSongSectionTitleArr{
    if (!_peiSongSectionTitleArr) {
        _peiSongSectionTitleArr = [NSMutableArray arrayWithObjects:@"配送信息",@"送达时间",@"收货地址",@"配送服务", nil];
    }
    return _peiSongSectionTitleArr;
}
- (NSMutableArray *)dingdanSectionTitleArr{
    if (!_dingdanSectionTitleArr) {
        _dingdanSectionTitleArr = [NSMutableArray arrayWithObjects:@"订单信息",@"订单号",@"支付方式",@"下单时间",@"订单备注", nil];
    }
    return _dingdanSectionTitleArr;
}
//
- (NSMutableArray *)dingdanSectionContentArr{
    if (!_dingdanSectionContentArr) {
        NSString *orderNum = [TextShowWithModelStr textShowWithModelStr:self.orderModel.orderNum];
        NSString *orderTime = [TextShowWithModelStr textShowWithModelStr:self.orderModel.createTime];
        NSString *orderRemark = [TextShowWithModelStr textShowWithModelStr:self.orderModel.orderMessage];//备注
        _dingdanSectionContentArr = [NSMutableArray arrayWithObjects:@"",orderNum,@"在线支付",orderTime,orderRemark, nil];
    }
    return _dingdanSectionContentArr;
}
- (NSMutableArray *)peiSongSectionContentArr{
    if (!_peiSongSectionContentArr) {
        NSString *orderServiceTime = @"";
        if ( self.orderModel.deliveryWay==2) {
           orderServiceTime = [TextShowWithModelStr textShowWithModelStr:self.orderModel.serviceTime].length<=0 ? @"尽快送达" : [TextShowWithModelStr textShowWithModelStr:self.orderModel.serviceTime];
        }else{
            orderServiceTime = @"门店自提";
        }
    
        NSString *orderAddress = [TextShowWithModelStr textShowWithModelStr:self.orderModel.address];
        NSString *orderPersonInfo = [NSString stringWithFormat:@"%@(%@)",[TextShowWithModelStr textShowWithModelStr:self.orderModel.username], [TextShowWithModelStr textShowWithModelStr:self.orderModel.phone]];
        NSString *getComsInfo = [NSString stringWithFormat:@"%@\n%@",orderAddress,orderPersonInfo];
        NSString *orderDeliveryWay = self.orderModel.deliveryWay==1 ? @"商家配送" : @"门店自提";
        _peiSongSectionContentArr = [NSMutableArray arrayWithObjects:@"",orderServiceTime,getComsInfo,orderDeliveryWay, nil];//第一个空置
    }
    return _peiSongSectionContentArr;
}

@end
