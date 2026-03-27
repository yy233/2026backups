//
//  MoneyOfThridBangDingListVc.m
//  Community
//
//  Created by 余莹 on 2021/10/13.
//

#import "MoneyOfThridBangDingListVc.h"
#import "MoneyOfThridJieBangEditVc.h"
#import "ChongZhiAndTiXianVC.h"
#import "MoneyOfThridBangDingWeiXinEditVc.h"
#import "MoneyOfThridBangDingZFBEditVc.h"
#import "MoneyOfThridJieBangEndVc.h"
#import "MoneyOfThridBangDingZFBEditVcLate.h"
//
#import "MoneyOfThridBangDingInfoAddDeletData.h"
#import "ZFBAnthorzationManager.h"
#import "WeiXinAuthorizationManager.h"
#import "ThridBangDingListVcModel.h"
//
#import "AppleAnthorationManager.h"




@interface MoneyOfThridBangDingListVc ()
//@property (nonatomic,strong) NSMutableArray *countTextArr;
@property (nonatomic,strong) NSMutableArray *selfListModelArr;
 
@end

@implementation MoneyOfThridBangDingListVc

- (NSMutableArray *)selfListModelArr{
    if (!_selfListModelArr) {
        _selfListModelArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _selfListModelArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"第三方账号绑定"; 
//    [self changeNavBackColorWithDIsCountBlueAndWW];
    
    [self setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
}
- (void)initData{
//    self.dataSourceArr = [NSMutableArray arrayWithObjects:@"微信",@"支付宝", nil];
//    self.countTextArr = [NSMutableArray arrayWithObjects:@"",@"", nil];
    /**
     1216更换查询类
     if ([ShareUserInfo sharedUserInfo].userInfo.isBindWechat) {
         [self.countTextArr replaceObjectAtIndex:0 withObject:@"已绑定"];
     }
     [self.tableView reloadData];
     if ([ShareUserInfo sharedUserInfo].userInfo.isBindAlipay) {
         WEAKSELF
           [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Post_Query_Bind_Alipay withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
               if (isNotNil(responsObject)) {
                   if (Y_IS_Success) {
                       NSDictionary *getZfbBangDingInfo = [NSDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                       if ([[getZfbBangDingInfo allKeys]containsObject:@"account"] && [[getZfbBangDingInfo allKeys]containsObject:@"realname"]) {
                           NSString *allShowStr = [NSString stringWithFormat:@"%@%@",[getZfbBangDingInfo objectForKey:@"realname"],[getZfbBangDingInfo objectForKey:@"account"]];
                           [weakSelf.countTextArr replaceObjectAtIndex:1 withObject:allShowStr];
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [weakSelf.tableView reloadData];
                           });
                       }
                       
                   }
                   
               }
              
           }];
     }
     */
    WEAKSELF
    [MoneyOfThridBangDingInfoAddDeletData getThridAuthorizationBangDingInfoWithBlock:^(NSArray * _Nonnull arr, BOOL success) {
        if (success) {
          weakSelf.selfListModelArr = [NSMutableArray arrayWithArray:  [ThridBangDingListVcModel mj_objectArrayWithKeyValuesArray:arr] ];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
  
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isMemberOfClass:[ChongZhiAndTiXianVC class]]) {
            [vcs removeObject:vc];
        }
    }
    self.navigationController.viewControllers = [vcs copy];
}

#pragma mark == 解除绑定
//wx
- (void)jieBangWeiXin{
    DLog(@"");
    MoneyOfThridJieBangEditVc *vc = [[MoneyOfThridJieBangEditVc alloc]init];
    vc.title = @"解除微信绑定";
    vc.thridPTypeStr =  thirdPlatformType_WECHAT;
    [self pushVc:vc];
}
//zfb
- (void)jieBangZhiFuBao{
    DLog(@"");
    MoneyOfThridJieBangEditVc *vc = [[MoneyOfThridJieBangEditVc alloc]init];
    vc.title = @"解除支付宝绑定";
    vc.thridPTypeStr = thirdPlatformType_ALIPAY;
    [self pushVc:vc];
  
}
- (void)jieBangiOS{
    DLog(@"");
    MoneyOfThridJieBangEditVc *vc = [[MoneyOfThridJieBangEditVc alloc]init];
    vc.title = @"解除iOS绑定";
    vc.thridPTypeStr = thirdPlatformType_iOS;
    [self pushVc:vc];
}

#pragma mark ==
#pragma mark ==
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WEAKSELF
    ThridBangDingListVcModel *model = self.selfListModelArr[indexPath.row];
  
    if ([model.thirdPlatformType isEqualToString: thirdPlatformType_WECHAT]) {
        if (!model.thirdPlatformBindStatus) {//@"未绑定"; 去绑定
            
            [[WeiXinAuthorizationManager share]weiXinMoneyBangDingActionWithWeixinCodeStrBlock:^(NSString * codeS) {
                if (codeS.length>0) {
                    MoneyOfThridBangDingWeiXinEditVc *vc = [[MoneyOfThridBangDingWeiXinEditVc alloc]init];
                    vc.codeStrWithWxOrZfb = codeS;
                    [weakSelf pushVc:vc];
                    return;
                }
            }];
        }else{//已经绑定 解绑弹出框
           //;
            
            NSString *titleS = [NSString stringWithFormat:@"是否解除%@绑定?", model.thirdPlatformTypeString];
            [self showAlertWithThirdPlatformTypeStr:model.thirdPlatformType AndShowTitleStr:titleS];
        }
    }

    if ([model.thirdPlatformType isEqualToString: thirdPlatformType_ALIPAY]) {
        if (!model.thirdPlatformBindStatus) {//@"未绑定"; 去绑定
            //1216新版
            [[ZFBAnthorzationManager shareManager] getZFBAnthorzationCodeWithBLock:^(NSString * _Nonnull codeStr, BOOL success) {
                if (codeStr.length>0) {
                    MoneyOfThridBangDingZFBEditVcLate *vc = [[MoneyOfThridBangDingZFBEditVcLate alloc]init];
                    vc.codeStrWithWxOrZfb = codeStr;
                    [weakSelf pushVc:vc];
                    return;
                }
            }];
        }else{//已经绑定 解绑弹出框
            NSString *titleS = [NSString stringWithFormat:@"是否解除%@绑定?", model.thirdPlatformTypeString];
            [self showAlertWithThirdPlatformTypeStr:model.thirdPlatformType AndShowTitleStr:titleS];
        }
    }
    
    
    if ([model.thirdPlatformType isEqualToString: thirdPlatformType_iOS]) {
        if (!model.thirdPlatformBindStatus) {//@"未绑定"; 去绑定
            //1221
            DLog(@"ios");
            [self iOSBingDingActionNotToOtherVC];
        }else{//已经绑定 解绑弹出框
            NSString *titleS = [NSString stringWithFormat:@"是否解除%@绑定?", model.thirdPlatformTypeString];
            [self showAlertWithThirdPlatformTypeStr:model.thirdPlatformType AndShowTitleStr:titleS];
        }
    }
     
     
}
#pragma mark == iOS绑定
- (void)iOSBingDingActionNotToOtherVC{
    
    Y_SVP_SHOW_INFO_MES_5Delay(@"仅允许苹果三方登录流程的主动绑定。");
    return;
    /**
    暂时不做绑定 做提示信息
    */
    NSString *titleStr = @"是否要绑定iOS";
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:titleStr message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //
    NSMutableAttributedString *alertControllerTitleStr = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [alertControllerTitleStr addAttribute:NSForegroundColorAttributeName value:[ThemeManager shareManager].mainTextColor  range:NSMakeRange(0, alertControllerTitleStr.length)];
    [alertControllerTitleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, alertControllerTitleStr.length)];
    [alertC setValue:alertControllerTitleStr forKey:@"attributedTitle"];
   
    //action
    UIAlertAction *oneAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *twoAction = [UIAlertAction actionWithTitle:@"去绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
    }];
    [alertC addAction:oneAction];
    [alertC addAction:twoAction];
    
    //
    UIView *firstSubview = alertC.view.subviews.firstObject;
    UIView *alertContentView = firstSubview.subviews.firstObject;
    for (UIView *subSubView in alertContentView.subviews) { //This is main catch
        subSubView.backgroundColor =  [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        subSubView.layer.borderColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW.CGColor;
        subSubView.layer.borderWidth = 1.0;
    }
    alertC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertC animated:YES completion:^{
    }];
}
- (void)doIOSBingDingCodeUpDate{
    [[AppleAnthorationManager shareManager]getIOSAppleAnthorzationCodeWithBLock:^(NSString * _Nonnull codeStr, BOOL success) {
        if (success) {
        }
    }];
}
#pragma mark ==
- (void)showAlertWithThirdPlatformTypeStr:(NSString *)thirdPlatformType AndShowTitleStr:(NSString *)titleStr{
    NSString *subMsgStr = @"解除后部分功能无法使用";
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:titleStr message:subMsgStr preferredStyle:UIAlertControllerStyleAlert];
    //
    NSMutableAttributedString *alertControllerTitleStr = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [alertControllerTitleStr addAttribute:NSForegroundColorAttributeName value:[ThemeManager shareManager].mainTextColor  range:NSMakeRange(0, alertControllerTitleStr.length)];
    [alertControllerTitleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, alertControllerTitleStr.length)];
    [alertC setValue:alertControllerTitleStr forKey:@"attributedTitle"];
    //
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:subMsgStr];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7]  range:NSMakeRange(0, alertControllerMessageStr.length)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, alertControllerMessageStr.length)];
    [alertC setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    //action
    UIAlertAction *oneAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *twoAction = [UIAlertAction actionWithTitle:@"确认解除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([thirdPlatformType containsString:thirdPlatformType_WECHAT]) {//微信 解绑
            [self jieBangWeiXin];
        }else if ([thirdPlatformType containsString:thirdPlatformType_ALIPAY]){//解绑支付宝
            [self jieBangZhiFuBao];
        }else{
           DLog(@"解绑ios")
            [self jieBangiOS];
        }
    }];
    [alertC addAction:oneAction];
    [alertC addAction:twoAction];
    
    //
    UIView *firstSubview = alertC.view.subviews.firstObject;
    UIView *alertContentView = firstSubview.subviews.firstObject;
    for (UIView *subSubView in alertContentView.subviews) { //This is main catch
        subSubView.backgroundColor =  [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        subSubView.layer.borderColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW.CGColor;
        subSubView.layer.borderWidth = 1.0;
    }
    
    alertC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertC animated:YES completion:^{
    }];
}
 
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.selfListModelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoneyOfThridBangDingCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MoneyOfThridBangDingCell"];
        UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Settings_arrow"]];
        CGRect frame = accessoryImgView.frame;
        frame.size.width = frame.size.width + 10;
        accessoryImgView.frame = frame;
        [accessoryImgView setContentMode:UIViewContentModeLeft];
        cell.accessoryView = accessoryImgView;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.separatorInset = UIEdgeInsetsMake(0, 26, 0, 26 );
        //
        cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }

    ThridBangDingListVcModel *model = self.selfListModelArr[indexPath.row];
    cell.textLabel.text = [TextShowWithModelStr textShowWithNotNullStr:model.thirdPlatformTypeString];
    if (!model.thirdPlatformBindStatus) {
        cell.detailTextLabel.text =   @"未绑定";
        cell.detailTextLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
    }else{
        NSString *nameStr = [TextShowWithModelStr textShowWithNotNullStr:model.nickName];
        if (nameStr.length<=0) {
            cell.detailTextLabel.text = @"已绑定"; 
        }else{
            cell.detailTextLabel.text = nameStr;
        }
        cell.detailTextLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(tintColor)]) {
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
  
}
 

@end
