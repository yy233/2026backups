//
//  EIntergralMallGoodsDatailVC.m
//  Community
//
//  Created by 余莹 on 2021/2/22.
//

#import "EIntergralMallGoodsDatailVC.h"
#import "EIntergralMallGoodsDatailVcFooterView.h"
#import "EIntergralMallGoodsDatailTextContentTableViewCell.h"
#define  EIntergralMallGoodsDatailTextContentTableViewCell_Identifier          @"EIntergralMallGoodsDatailTextContentTableViewCell"

@interface EIntergralMallGoodsDatailVC ()
@property (nonatomic,strong) UIImageView *headerView;
@property (nonatomic,strong) EIntergralMallGoodsDatailVcFooterView *footerView;

@end

@implementation EIntergralMallGoodsDatailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    [self initView];
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarWhiteStyle];
}
- (void)initView{
    self.tableView.backgroundColor = Color_245Gray;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    self.tableView.sectionHeaderHeight = 1;
    self.tableView.sectionFooterHeight = 10;
}
- (void)initData{
//    self.dataSourceArr = [NSMutableArray arrayWithObjects:@"商品简介",@"使用范围",@"有效期",@"温馨提示", nil];
    //
    NSString *str = @"200E币";
    self.footerView.eNumL.attributedText = [self getEnumLTextWithStr:str];
    [self.tableView reloadData];
}
#pragma mark ==
- (void)footerViewOkAction{
    DLog(@"");
    Y_SVP_SHOW_INFO_MES(@"确认兑换");
}
#pragma mark ==
- (NSMutableAttributedString *)getEnumLTextWithStr:(NSString *)str{
  
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    NSUInteger length = [str length];
    //设置字体
    UIFont *baseFont = FontSize_MoneyWallet_Bold(15);
    [attrString addAttribute:NSFontAttributeName value:baseFont range:NSMakeRange(0, length)];//设置所有的字体
    // 设置颜色
    UIColor *colorRed = COlor_Red255;
    UIColor *colorGray =  Color_138GrayColor;
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:colorRed
                       range:[str rangeOfString:@"200"]];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:colorGray
                       range:[str rangeOfString:@"E币"]];
    return attrString;
}
#pragma mark===
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;//大文本部分
            break;
        default:
            return 0;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 2:
            return 220;//待处理文本高度计算
            break;
        default:
            return 50;
            break;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==[tableView numberOfSections]-1) {
        return 1;
    }else{
        return 10;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell_Section_One"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell_Section_One"];
            }
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.font = FontSize_MoneyWallet_Bold(18);
            cell.textLabel.text = @"Beats头戴试耳机抽奖";
            return cell;
        }
            break;
        case 1:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell_Section_Two"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell_Section_Two"];
                cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16 );
            }
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.font = FontSize_MoneyWallet_Nomail(15);
            if (indexPath.row==0) {
                cell.textLabel.text = @"支付方式";
                cell.detailTextLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:@""];//置空
            }else{
                cell.textLabel.text = @"E币";
                NSString *str = @"200E币";
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
                NSUInteger length = [str length];
                //设置字体
                UIFont *baseFont = FontSize_MoneyWallet_Bold(15);
                [attrString addAttribute:NSFontAttributeName value:baseFont range:NSMakeRange(0, length)];//设置所有的字体
                // 设置颜色
                UIColor *colorRed = COlor_Red255;
                UIColor *colorGray =  Color_138GrayColor;
                [attrString addAttribute:NSForegroundColorAttributeName
                                   value:colorRed
                                   range:[str rangeOfString:@"200"]];
                [attrString addAttribute:NSForegroundColorAttributeName
                                   value:colorGray
                                   range:[str rangeOfString:@"E币"]];
                cell.detailTextLabel.attributedText = attrString;
            }
      
            return cell;
        }
            break;
        default:
        {
            EIntergralMallGoodsDatailTextContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EIntergralMallGoodsDatailTextContentTableViewCell_Identifier];
            if (!cell) {
                cell = [[EIntergralMallGoodsDatailTextContentTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:EIntergralMallGoodsDatailTextContentTableViewCell_Identifier];
            }
            cell.textView.text = @"1.本活动为*****会员专属优惠活动。凭券购飞科全身水洗剃须刀(SF366)即可享受120元立减补贴。产品原价197元，券后到手价77元(包邮，偏远地区除外)。\n2.飞科剃须刀采用3D智能浮动设计剃须，刀头灵敏贴合轮廓，双环刀网增大进须面积，提升体系效率，彰显您利落型男风范。\
            \n1.兑换过程如有任何问题，请咨询在线客服: http://1497007878\
            13.im.n.neigob.com工作时间周一至周日9: 00~23:00.\
            \n⒉售后客服电话︰4002266874，工作时间周一至周五9:30~18: 0\
            0。\
            \n3.物流查询方式:点此查看物流信息:http://wrw.cn/bdMLH6d7\
            \n 4.虚拟权益一经兑换不支持退款/退积分";
            return cell;
        }
            break;
    }
}


#pragma mark===
- (UIImageView *)headerView{
    if (!_headerView) {
        _headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 200)];
        _headerView.image = [UIImage imageNamed:@"Merchandise_picture"];
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headerView;
}
- (EIntergralMallGoodsDatailVcFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[EIntergralMallGoodsDatailVcFooterView alloc]initWithFrame:CGRectZero];
        [_footerView.okBtn  addTarget:self action:@selector(footerViewOkAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
@end
