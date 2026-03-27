//
//  ParkingPayInfoVC.m
//  Community
//
//  Created by 余莹 on 2021/8/7.
//

#import "ParkingPayInfoVC.h"
#import "ParkingPayInfoDetailVC.h"
#import "ParkingPayInfoHeaderView.h"
#import "ParkingPayInfoTableViewCell.h"
#define  ParkingPayInfoTableViewCell_Identifier   @"ParkingPayInfoTableViewCell"
#define  ParkingPayInfoOnlyTextTableViewCell_Identifier   @"ParkingPayInfoOnlyTextTableViewCell"
#import "ParkingCarData.h"
#import "ParkingCarBaseModel.h"

@interface ParkingPayInfoVC ()
@property (nonatomic,assign) ParkingPayInfo_Type selfType;
@property (nonatomic,strong) ParkingPayInfoHeaderView *headerView;
@end

@implementation ParkingPayInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缴费记录";
//    self.selfType = ParkingPayInfo_Type_Temporary;
    self.selfType = ParkingPayInfo_Type_Monthly;//月租
    [self initView];
    [self initData];
    [self addRefresh];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeNavBackColorWithDIsCountBlueAndWW];
}
 
- (void)initView{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.tableHeaderView = self.headerView;//暂时只使用用月租缴费 headerv 暂时隐藏
    WEAKSELF
    self.headerView.touchUpBlock = ^(NSInteger i) {
        if (i==0) {
            //临时列表
            weakSelf.selfType = ParkingPayInfo_Type_Temporary;
        }else{
            //月租列表
            weakSelf.selfType = ParkingPayInfo_Type_Monthly;
        }
        [weakSelf initData]; 
    };

    
}
#pragma mark ==
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    self.tableView.mj_header = headeerRefresh;
    [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        DLog(@"intt加载");
    }];
}
- (void)initData{
    
    ParkingCar_Type t =  (self.selfType == ParkingPayInfo_Type_Temporary) ? ParkingCar_Type_Temporary : ParkingCar_Type_Monthly;
    WEAKSELF
    [ParkingCarData payParkingHistoryListWithType:t withListBlock:^(NSArray * arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            weakSelf.dataSourceArr = [[NSMutableArray alloc]initWithArray: [ParkingCarBaseModel  mj_objectArrayWithKeyValuesArray:arr]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}

#pragma mark ==

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//     self.dataSourceArr[indexPath.section];
    ParkingPayInfoDetailVC *vc = [[ParkingPayInfoDetailVC alloc]init];
    vc.selfType = self.selfType;
    vc.model = self.dataSourceArr[indexPath.section];
    [self pushVc:vc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return self.dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return  3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 50;
    }else{
        return 30;
    }
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParkingCarBaseModel *model = self.dataSourceArr[indexPath.section];
    if (indexPath.row == 0) {
        //基础信息
        ParkingPayInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ParkingPayInfoTableViewCell_Identifier];
        if (!cell) {
            cell = [[ParkingPayInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ParkingPayInfoTableViewCell_Identifier];
        }
        if (self.selfType == ParkingPayInfo_Type_Temporary) {
            [cell setTypeTemporary];
        }else{
            [cell setTypeMonth];
        }
        cell.nameL.text = [TextShowWithModelStr textShowWithModelStr:model.carPlate];
        cell.moneyL.text = [NSString stringWithFormat:@"-¥%0.2f",model.money];
        return cell;
    }else{
        //时间信息
        ParkingPayInfoOnlyTextTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:ParkingPayInfoOnlyTextTableViewCell_Identifier];
        if (!cell) {
            cell = [[ParkingPayInfoOnlyTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ParkingPayInfoOnlyTextTableViewCell_Identifier];
        }
      
        NSString *timeBeginStr = [TextShowWithModelStr textShowWithModelStr:model.orderTime]; 
        //NSString *timeEndStr = [TextShowWithModelStr textShowWithModelStr:model.overTime];
        NSString *carPositionTextStr = [TextShowWithModelStr textShowWithModelStr:model.carPositionText];
        if (self.selfType == ParkingPayInfo_Type_Temporary) {//临时
        //cell.timeAllShwoL.text =  (indexPath.row==1) ?  [@"进场：" stringByAppendingString:timeBeginStr] : [@"出场：" stringByAppendingString:timeEndStr];
            cell.textAllShowL.text =  (indexPath.row==1) ?  [@"进场：" stringByAppendingString:timeBeginStr] : [@"小区信息：" stringByAppendingString:carPositionTextStr];

        }else{//月缴费
           // cell.timeAllShwoL.text =  (indexPath.row==1) ? [@"缴费时间：" stringByAppendingString:timeBeginStr] : [@"到期时间：" stringByAppendingString:timeEndStr];
            cell.textAllShowL.text =  (indexPath.row==1) ? [@"缴费时间：" stringByAppendingString:timeBeginStr] : [@"小区信息：" stringByAppendingString:carPositionTextStr];
        }

        return cell;
    }
}
#pragma mark ==
- (ParkingPayInfoHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[ParkingPayInfoHeaderView alloc]initWithFrame:CGRectZero];
    }
    return _headerView;
}


#pragma mark ===
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 圆角弧度半径
    CGFloat cornerRadius = 8.f;
    // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
    cell.backgroundColor = UIColor.clearColor;
    
    // 创建一个shapeLayer
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
    // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
    CGMutablePathRef pathRef = CGPathCreateMutable();
    // 获取cell的size
    // 第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
    CGRect bounds = CGRectInset(cell.bounds, 16, 0);
    
    // CGRectGetMinY：返回对象顶点坐标
    // CGRectGetMaxY：返回对象底点坐标
    // CGRectGetMinX：返回对象左边缘坐标
    // CGRectGetMaxX：返回对象右边缘坐标
    // CGRectGetMidX: 返回对象中心点的X坐标
    // CGRectGetMidY: 返回对象中心点的Y坐标
    
    // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
    
    // CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
    if (indexPath.row == 0) {
        // 初始起点为cell的左下角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        // 起始坐标为左下角，设为p，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        // 初始起点为cell的左上角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
    } else {
        // 添加cell的rectangle信息到path中（不包括圆角）
        CGPathAddRect(pathRef, nil, bounds);
    }
    // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
    layer.path = pathRef;
    backgroundLayer.path = pathRef;
    // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
    CFRelease(pathRef);
    // 按照shape layer的path填充颜色，类似于渲染render
    // layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
//    layer.fillColor = [UIColor redColor].CGColor;
//    layer.fillColor = Color_11BlueColor.CGColor;
    layer.fillColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW.CGColor;
    
    // view大小与cell一致
    UIView *roundView = [[UIView alloc] initWithFrame:bounds];
    // 添加自定义圆角后的图层到roundView中
    [roundView.layer insertSublayer:layer atIndex:0];
    roundView.backgroundColor = UIColor.clearColor;
    // cell的背景view
    cell.backgroundView = roundView;
    
    // 以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
    // 如果你 cell 已经取消选中状态的话,那以下方法是不需要的.
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
    backgroundLayer.fillColor = [UIColor cyanColor].CGColor;
    [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
    selectedBackgroundView.backgroundColor = UIColor.clearColor;
    cell.selectedBackgroundView = selectedBackgroundView;
    
}
@end
