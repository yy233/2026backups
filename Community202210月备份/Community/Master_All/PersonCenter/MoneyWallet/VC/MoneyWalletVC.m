//
//  MoneyWalletVC.m
//  Community
//
//  Created by 余莹 on 2021/2/2.
//

#import "MoneyWalletVC.h"
#import "MoneyWalletVCTopTableViewCell.h"
#define   MoneyWalletVCTopTableViewCell_Identifier @"MoneyWalletVCTopTableViewCell"

#import "MoneyWalletYuEVc.h"
#import "MoneyWalletAddBankCard.h"
//
#import "XianjingJuanVC.h"
#import "EIntergralMallMainVC.h"
//
#import "PersonMoneyModelData.h"
@interface MoneyWalletVC () <MoneyWalletVCTopTableViewCellDelegate,PopViewWithGoToRealCertificationDelegate>
@property (nonatomic,strong) PopViewWithGoToRealCertification *popViewGotoCertification;

@property (nonatomic) PersonMoneyModel *moneyAndOtherModel;

@end

@implementation MoneyWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupNavigationBarWhiteStyle];
    self.title = @"我的钱包";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.estimatedSectionFooterHeight = 0.01;
    self.tableView.estimatedSectionHeaderHeight = 0.01;
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView  = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.separatorColor  = [ThemeManager shareManager].themeLineColor;
    [self initBaseData];
    [self initMoneyShowData];
}
 
- (void)initBaseData{
    self.dataSourceArr = [NSMutableArray arrayWithObjects:@"",@"现金劵",@"我的E币",@"领劵中心", nil];
    [self.tableView reloadData];
}
- (void)initMoneyShowData{
        WEAKSELF
    
        [PersonMoneyModelData getPersonMoneyDataWithBlock:^(NSDictionary * dic, BOOL success) {
            if (success) {
                weakSelf.moneyAndOtherModel = [PersonMoneyModel mj_objectWithKeyValues:dic];
                //@(model.bankCard)银行卡 @(model.balance)余额 @(model.tickets)现金券
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }
        }];
}
#pragma mark ===
//未实名认证popView
- (PopViewWithGoToRealCertification *)popViewGotoCertification{
    _popViewGotoCertification = [[PopViewWithGoToRealCertification alloc]init];
    _popViewGotoCertification.delegate = self;
    return _popViewGotoCertification;
}
#pragma mark ===
- (BOOL)isShiMing{
    DLog(@"是否实名认证过的");
    if (ZY_IsRealName) {
        return YES;
    }else {
        return NO;
    }
}
- (void)goToBangKaBtnAction{//绑定银行卡 （去绑卡按钮）
    // 实名才能绑卡
    if ([self isShiMing]) {
        MoneyWalletAddBankCard *vc = [[MoneyWalletAddBankCard alloc]init];
        [self pushVc:vc];
    }else{
        [self.popViewGotoCertification showInView:self.view thePopViewSubViewHeight:0 WithArray:@[].mutableCopy];
    }
}
//去实名认证页面
- (void)popViewBtnActionWithGoToRealCertificationAction{
    ZYElectronicRealNameAuthenticationVc *vc = [[ZYElectronicRealNameAuthenticationVc alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}
- (void)showYuEMingXiBtnAction{//余额明细
    MoneyWalletYuEVc *vc = [[MoneyWalletYuEVc alloc]init];
    vc.yuE = self.moneyAndOtherModel.balance;
    [self pushVc:vc];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 1://@"现金劵"
        {
            Y_SVP_SHOW_INFO_MES_5Delay(@"当前暂未开放现金券,敬请期待");
            return;
            /**
             XianjingJuanVC *vc = [[XianjingJuanVC alloc]init];
             [self pushVc:vc];
             */
            
        }
            
            break;
        case 2://@@"我的E币"
        {
            EIntergralMallMainVC *vc = [[EIntergralMallMainVC alloc]init];
            [self pushVc:vc];
        }
            
            break;
        case 3://@"领劵中心"
            
            break;
            
        default:
            break;
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
//    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 165;
    }else{
        return 60;
    }
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row ==0) {
        MoneyWalletVCTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MoneyWalletVCTopTableViewCell_Identifier];
        if (!cell) {
            cell = [[MoneyWalletVCTopTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MoneyWalletVCTopTableViewCell_Identifier];
        }
        cell.delegate = self;
        [cell fillDataWithYuE:self.moneyAndOtherModel.balance andBCardNum:self.moneyAndOtherModel.bankCard];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell1"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell1"];
//            cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
            UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Settings_arrow"]];
            cell.accessoryView = accessoryImgView;
//            cell.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            //
            cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
            cell.detailTextLabel.textColor = [ThemeManager shareManager].mainTextColor;
        }
        cell.textLabel.text = self.dataSourceArr[indexPath.row];
        if (indexPath.row==1) {//现金劵
            cell.detailTextLabel.text =  [NSString stringWithFormat:@"%ld张",self.moneyAndOtherModel.tickets];
            cell.separatorInset = UIEdgeInsetsMake(0, 26, 0, 26);
        }else if (indexPath.row==2){//E币
            cell.detailTextLabel.text = @"30币";
            cell.separatorInset = UIEdgeInsetsMake(0, 26, 0, 26);
        }else{//无数据
            cell.detailTextLabel.text = @"";
            cell.separatorInset = UIEdgeInsetsMake(0, 26, 0, 26);
        }
        return cell;
    }
}
 
#pragma mark ===
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return;
    }
    if ([cell respondsToSelector:@selector(tintColor)]) {
//        if (tableView == self.tableView) {
        CGFloat cornerRadius = 7.0f;
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 16.0, 0);
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);// 实体剧形状
        } else if (indexPath.row == 0) {//上部分有圆角
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
            
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {//下部分有圆角
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        } else {//填充？
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        //颜色修改
        layer.fillColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW.CGColor;
        layer.strokeColor= [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW.CGColor;
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
//            CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
//            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight);
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height, bounds.size.width-10, 0);

            lineLayer.backgroundColor = tableView.separatorColor.CGColor;
            [layer addSublayer:lineLayer];
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
//    }
}

#pragma mark ====
- (PersonMoneyModel *)moneyAndOtherModel{
    if (!_moneyAndOtherModel) {
        _moneyAndOtherModel = [[PersonMoneyModel alloc]init];
    }
    return _moneyAndOtherModel;
}
@end
