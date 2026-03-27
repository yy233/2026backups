//
//  MoneyWalletAddBankCard.m
//  Community
//
//  Created by 余莹 on 2021/2/20.
// 添加银行卡 与bankCards文件相关

#import "MoneyWalletAddBankCard.h"
#import "MoneyWalletAddBankCardInfoTableViewCell.h"
#define  MoneyWalletAddBankCardInfoTableViewCell_Identifier   @"MoneyWalletAddBankCardInfoTableViewCell"
#import "MoneyWalletAddBankCardNameTableViewCell.h"
#define  MoneyWalletAddBankCardNameTableViewCell_Identifier   @"MoneyWalletAddBankCardNameTableViewCell"
#import "MoneyWalletAddBankCardIdTableViewCell.h"
#define  MoneyWalletAddBankCardIdTableViewCell_Identifier     @"MoneyWalletAddBankCardIdTableViewCell"

#import "MoneyWalletAddBankCardSendPhoneNumVC.h"
#import "MoeyWalletAddBankHaVeCardTypeVc.h"
#import "MoeyWalletAddBankScanCardVC.h"
@interface MoneyWalletAddBankCard ()
@property (nonatomic,strong) BaseTableViewFooterView *sectionFooterView;
@property (nonatomic,strong) NSMutableArray *bankImgStrArr;
@property (nonatomic,strong) NSMutableArray *bankNameStrArr;
//
@property (nonatomic,strong) UIAlertController *alertPopShowBankInfoTip;
@property (nonatomic,strong) UILabel *alertNameL;
@property (nonatomic,strong) UILabel *alertCardIdL;
@end

@implementation MoneyWalletAddBankCard

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加银行卡";
    self.bankImgStrArr = [NSMutableArray arrayWithObjects:@"Fast_ccb",@"Fast_BankofChina",@"Fast_Agriculture",@"Fast_attractinvestment",@"Fast_CITIC", nil];
    self.bankNameStrArr = [NSMutableArray arrayWithObjects:@"建设银行",@"中国银行",@"农业银行",@"招商银行",@"中信银行", nil];
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self setupNavigationBarWhiteStyle];
}
- (void)initData{
    
}
#pragma mark ======
- (void)nameCellRightBtnAction{
//    Y_SVP_SHOW_INFO_MES(@"输入真实姓名");
    //test
    self.alertNameL.text = @"姓      名：*德化。|test";
    self.alertCardIdL.text = @"证件号码：5****************7";
    self.alertPopShowBankInfoTip.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:self.alertPopShowBankInfoTip animated:YES completion:nil];
}
- (void)CardIdScanRightBtnAction{
    MoeyWalletAddBankScanCardVC *vc = [[MoeyWalletAddBankScanCardVC alloc]init];
    [self pushVc:vc];
}

#pragma mark ==
- (void)nextStepBtnAction{
    MoneyWalletAddBankCardSendPhoneNumVC *vc = [[MoneyWalletAddBankCardSendPhoneNumVC alloc]init];
    vc.bankCardNumStr = @"1111999";
    vc.bankCardTypeStr = @"建设银行";
    [self pushVc:vc];
}
#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        MoeyWalletAddBankHaVeCardTypeVc *vc = [[MoeyWalletAddBankHaVeCardTypeVc alloc]init];
        vc.bankTypeStr = @"建设银行";
        [self pushVc:vc];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 3;
    }else{
        //快速绑定卡
        return self.bankImgStrArr.count+1;
    }
     return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
                return 60;
                break;
            case 1:
                return 50;
                break;
            case 2:
                return 80;//50
                break;
            default:
                return 80;
                break;
        }
    }else{
        return 60;
    }
}
//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
       return 1;
   }else{
       return 50;
   }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     if (section==0) {
        return [UIView new];
    }else{
        UILabel *sectionHeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 50)];
        sectionHeaderLabel.text = @"或选择以下快捷绑卡";
        sectionHeaderLabel.font = FontSize_MoneyWallet_Nomail(12);
        sectionHeaderLabel.textColor = Color_153GrayColor;
        sectionHeaderLabel.textAlignment = NSTextAlignmentCenter;
        return sectionHeaderLabel;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
       return 90;
   }else{
       return 20;
   }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0) {
        return self.sectionFooterView;
    }else{
        return [UIView new];
    }
}
                                                                        
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                MoneyWalletAddBankCardInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MoneyWalletAddBankCardInfoTableViewCell_Identifier];
                if (!cell) {
                    cell = [[MoneyWalletAddBankCardInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MoneyWalletAddBankCardInfoTableViewCell_Identifier];
                }
                return cell;
            }
                break;
            case 1:
            {
                MoneyWalletAddBankCardNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MoneyWalletAddBankCardNameTableViewCell_Identifier];
                if (!cell) {
                    cell = [[MoneyWalletAddBankCardNameTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MoneyWalletAddBankCardNameTableViewCell_Identifier];
                }
                [cell.rightBtn addTarget:self action:@selector(nameCellRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
                break;
                
            default:
            {
                MoneyWalletAddBankCardIdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MoneyWalletAddBankCardIdTableViewCell_Identifier];
                if (!cell) {
                    cell = [[MoneyWalletAddBankCardIdTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MoneyWalletAddBankCardIdTableViewCell_Identifier];;
                }
                [cell.rightBtn addTarget:self action:@selector(CardIdScanRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
                [cell.bankTypeBottomShowBtn newAnBtnWithTextStr:@"招商银行 储蓄卡"];
                [cell.bankTypeBottomShowBtn newAnBtnWithImg:[UIImage imageNamed:@"Fast_ccb"]];
                return cell;
            }
                break;
        }
    }else{
        if (indexPath.row==0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell_Text"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell_Text"];
                cell.separatorInset = UIEdgeInsetsMake(0, 26,0, 26);
            }
            cell.textLabel.text = @"无需输入银行卡号，快速绑卡";
            cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
            cell.textLabel.font = FontSize_MoneyWallet_Bold(15);
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell_Bank"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell_Bank"];
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Settings_arrow"]];
                cell.accessoryView = accessoryImgView;
                cell.separatorInset = UIEdgeInsetsMake(0, 26,0, 26);
                cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
                cell.textLabel.font = FontSize_MoneyWallet_Nomail(15);

            }
            cell.imageView.image = [UIImage imageNamed:self.bankImgStrArr[(indexPath.row-1)]];
            //
            //img
            CGSize itemSize = CGSizeMake(22+10, 22);//+
//            UIGraphicsBeginImageContext(itemSize);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, [UIScreen mainScreen].scale);//清晰度
            CGRect imageRect = CGRectMake(10, 0, itemSize.width-10, itemSize.height);//-
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
//                cell.imageView.layer.shouldRasterize = YES;//栅栏
//                cell.imageView.layer.allowsEdgeAntialiasing = YES;//锯齿
            cell.textLabel.text =  self.bankNameStrArr[(indexPath.row-1)];
          
            return cell;
        }
    }
  
}
#pragma mark === 列表组圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {//第2组才有灰色
        return;
    }
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.tableView) {
            CGFloat cornerRadius = 7.0f;
            cell.backgroundColor = UIColor.clearColor;
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGRect bounds = CGRectInset(cell.bounds, 16.0, 0);
            BOOL addLine = NO;
            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);// 实体剧形状
            } else  if (indexPath.row==0) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                addLine = YES;
            }else if(indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1){
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            }else{
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
            }
            layer.path = pathRef;
            CFRelease(pathRef);
            
            //颜色修改
            layer.fillColor = [ThemeManager shareManager].themeContentBackGroundColor.CGColor;
            layer.strokeColor= [ThemeManager shareManager].themeContentBackGroundColor.CGColor;
            if (addLine == YES) {
                CALayer *lineLayer = [[CALayer alloc] init];
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height, bounds.size.width-10, 0);
                lineLayer.backgroundColor = tableView.separatorColor.CGColor;//线
                [layer addSublayer:lineLayer];
            }
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            [testView.layer insertSublayer:layer atIndex:0];
            testView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = testView;
        }
    }
}
 
 
#pragma mark ==
- (BaseTableViewFooterView *)sectionFooterView{
    if (!_sectionFooterView) {
        _sectionFooterView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 90)];
        [_sectionFooterView.footerBtn newAnBtnWithTextStr:@"下一步"];
        [_sectionFooterView.footerBtn addTarget:self action:@selector(nextStepBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sectionFooterView;
}
- (UIAlertController *)alertPopShowBankInfoTip{
    if (!_alertPopShowBankInfoTip) {
     
//        _alertPopShowBankInfoTip = [UIAlertController alertControllerWithTitle:@"实名认证后只可绑定本人银行卡" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        _alertPopShowBankInfoTip = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        //
        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"实名认证后只可绑定本人银行卡"];
          [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[ThemeManager shareManager].mainTextColor  range:NSMakeRange(0, alertControllerMessageStr.length)];
          [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, alertControllerMessageStr.length)];
        [_alertPopShowBankInfoTip setValue:alertControllerMessageStr forKey:@"attributedTitle"]; //@"attributedMessage"];
        //
        UIView *alertBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 60, CGRectGetWidth(_alertPopShowBankInfoTip.view.bounds)-20, 70)];//top
        alertBackView.backgroundColor =  [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;//弹出框颜色处理❤️
//        alertBackView.backgroundColor =  [UIColor whiteColor];//弹出框颜色处理 暂时无发处理背景色则本处继续白色
        alertBackView.layer.cornerRadius = 5;
        alertBackView.layer.masksToBounds = YES;
        [alertBackView addSubview:self.alertNameL];
        [alertBackView addSubview:self.alertCardIdL];
        [_alertNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(_alertNameL.superview).offset(10);
            make.right.equalTo(_alertNameL.superview).offset(-10);
            make.height.offset(20);
        }];
        [_alertCardIdL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_alertCardIdL.superview).offset(10);
            make.right.bottom.equalTo(_alertCardIdL.superview).offset(-10);
            make.height.offset(20);
        }];
        //
        [_alertPopShowBankInfoTip.view addSubview:alertBackView];
        [alertBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alertBackView.superview).offset(70);
            make.left.equalTo(alertBackView.superview).offset(10);
            make.right.equalTo(alertBackView.superview).offset(-10);
            make.height.offset(90);
        }];
        //占位
        UIAlertAction *centerZanWeiOneAlertAction = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *centerZanWeiTwoAlertAction = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDefault handler:nil];

        //
        UIAlertAction *bottomKnowAlertAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [_alertPopShowBankInfoTip addAction:centerZanWeiOneAlertAction];
        [_alertPopShowBankInfoTip addAction:centerZanWeiTwoAlertAction];
        [_alertPopShowBankInfoTip addAction:bottomKnowAlertAction];
    }

    //
    UIView *firstSubview = _alertPopShowBankInfoTip.view.subviews.firstObject;
    UIView *alertContentView = firstSubview.subviews.firstObject;
    for (UIView *subSubView in alertContentView.subviews) { //This is main catch
        subSubView.backgroundColor =  [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD;
        subSubView.layer.borderColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW.CGColor;
        subSubView.layer.borderWidth = 1.0;
    }
    //
   
    return _alertPopShowBankInfoTip;
}
- (UILabel *)alertNameL{
    if (!_alertNameL) {
        _alertNameL = [[UILabel alloc]init];
        _alertNameL.textColor = Y_ColorWith16FromRGB(0x6F7D8A);
        _alertNameL.font = FontSize_MoneyWallet_Nomail(14);
    }
    return _alertNameL;
}
- (UILabel *)alertCardIdL{
    if (!_alertCardIdL) {
        _alertCardIdL = [[UILabel alloc]init];
        _alertCardIdL.textColor = Y_ColorWith16FromRGB(0x6F7D8A);
        _alertCardIdL.font = FontSize_MoneyWallet_Nomail(14);
    }
    return _alertCardIdL;
}
@end
