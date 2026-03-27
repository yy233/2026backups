//
//  IssueHouseVc.m
//  Community
//
//  Created by 余莹 on 2021/1/19.
//

#import "IssueHouseMainVc.h"
#import "IssHouseMainVcHeaderView.h"
#import "ShopBuniessIssueVc.h"
#import "HouseAllTypeBaseIssueVc.h"
#import "ZYAlreadyElectronicRealNameAuthenticationVc.h" //实名认证

@interface IssueHouseMainVc ()
@property (nonatomic,strong) IssHouseMainVcHeaderView *headerView;
@property (nonatomic,strong) NSMutableArray *arrOfSectioOneImg;
@property (nonatomic,strong) NSMutableArray *arrOfSectioOneTitle;
@property (nonatomic,strong) NSMutableArray *arrOfSectioOneDetailTitle;
@end

@implementation IssueHouseMainVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择发布类别";
//    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.tableHeaderView = self.headerView;
    [self initNavRightItem];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];
    self.tableView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
}
- (void)initNavRightItem{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"发布规则" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItems:@[rightItem]];
}
- (void)rightBtnAction:(UIButton *)sender{
    DLog(@"发布规则");
    Y_SVP_SHOW_INFO_MES_5Delay(@"发布规则\n请使用已认证的房屋信息");
}
- (void)initData{
    [self.tableView reloadData];
}
#pragma mark ===
- (BOOL)isShiMing{
    DLog(@"实名认证");
    if (ZY_IsRealName) {
        return YES;
    }else {
        ZYElectronicRealNameAuthenticationVc *vc = [[ZYElectronicRealNameAuthenticationVc alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
        return NO;
    }
    
}
#pragma mark ===
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![self isShiMing]) {
        return;
    }
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {//整套出租
            HouseAllTypeBaseIssueVc *issueVc = [[HouseAllTypeBaseIssueVc alloc]init];
            issueVc.type = IssueHouse_Type_ZhengZu;
            [self.navigationController pushViewController:issueVc animated:YES];
        }else if (indexPath.row==1){//单间出租
            HouseAllTypeBaseIssueVc *issueVc = [[HouseAllTypeBaseIssueVc alloc]init];
            issueVc.type = IssueHouse_Type_DanJian;
            [self.navigationController pushViewController:issueVc animated:YES];
        }else{//室友合租
            HouseAllTypeBaseIssueVc *issueVc = [[HouseAllTypeBaseIssueVc alloc]init];
            issueVc.type = IssueHouse_Type_HeZu;
            [self.navigationController pushViewController:issueVc animated:YES];
        }
    }else{
        //商铺
        ShopBuniessIssueVc *issueVc = [[ShopBuniessIssueVc alloc]init];
        [self.navigationController pushViewController:issueVc animated:YES];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SectionHeaderViewWithTextLabel *sectionV = [[SectionHeaderViewWithTextLabel alloc]init];
    if (section==0) {
        sectionV.titleLabel.text = @"民居住宅";
    }else{
        sectionV.titleLabel.text = @"商业用地";
    }
    return sectionV;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;//合租去掉
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if ([ThemeManager shareManager].type == ThemeType_Drak) {
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightSkip_white"]];//skip
        }
        cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.detailTextLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    if (indexPath.section==1) {
        cell.textLabel.text = @"商铺";
        cell.detailTextLabel.text = @"卖场、底商、摊位、柜台等";
        cell.imageView.image = [UIImage imageNamed:@"Selectcategory_shops"];
    }else{
        cell.imageView.image = [UIImage imageNamed:self.arrOfSectioOneImg[indexPath.row]];
        cell.textLabel.text = self.arrOfSectioOneTitle[indexPath.row];
        cell.detailTextLabel.text = self.arrOfSectioOneDetailTitle[indexPath.row];
    }
    return cell;
}

#pragma mark ==
- (IssHouseMainVcHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[IssHouseMainVcHeaderView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 60)];
    }
    return _headerView;
}

//
- (NSMutableArray *)arrOfSectioOneImg{
    if (!_arrOfSectioOneImg) {
        _arrOfSectioOneImg = [NSMutableArray arrayWithObjects:@"Selectcategory_acompleteset",@"Selectcategory_asingleroom",@"Selectcategory_roommate", nil];
    }
    return _arrOfSectioOneImg;
}
- (NSMutableArray *)arrOfSectioOneTitle{
    if (!_arrOfSectioOneTitle) {
       // _arrOfSectioOneTitle = [NSMutableArray arrayWithObjects:@"整套出租",@"单间出租",@"室友合租", nil];
        _arrOfSectioOneTitle = [NSMutableArray arrayWithObjects:@"整套出租",@"单间出租", nil];
    }
    return _arrOfSectioOneTitle;
}
- (NSMutableArray *)arrOfSectioOneDetailTitle{
    if (!_arrOfSectioOneDetailTitle) {
        //_arrOfSectioOneDetailTitle = [NSMutableArray arrayWithObjects:@"一整套房子，也包括开间",@"一个房间",@"找一起住的人，分摊房租", nil];
        _arrOfSectioOneDetailTitle = [NSMutableArray arrayWithObjects:@"一整套房子，也包括开间",@"一个房间", nil];
    }
    return _arrOfSectioOneDetailTitle;
}
@end
