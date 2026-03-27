//
//  MoneyOfThridBangDingWeiXinEditVc.m
//  Community
//
//  Created by 余莹 on 2021/10/18.
// 微信授权

#import "MoneyOfThridBangDingWeiXinEditVc.h"
#import "MoneyOfThridBangDingInfoAddDeletData.h"

#import "MoneyOfThridBangDingWeiXinOrZfbEditVcTableViewCell.h"
#define MoneyOfThridBangDingWeiXinEditVcTableViewCell_Identifier @"MoneyOfThridBangDingWeiXinEditVcTableViewCell"

#import "ZYMoneyOfThridBangDingWeiXinEditBottomCell.h"
static NSString *const moneyOfThridBangDingWeiXinEditBottomCellID = @"ZYMoneyOfThridBangDingWeiXinEditBottomCell";

@interface MoneyOfThridBangDingWeiXinEditVc ()
@property (nonatomic,strong) UIView *footerAllView;
@property (nonatomic,strong) UILabel *footerLabel;
@property (nonatomic,strong) BaseTableViewFooterView *footerViewOk;
@property (nonatomic,strong) UIButton *footerViewCancel;
@end

@implementation MoneyOfThridBangDingWeiXinEditVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavBackColorWithDIsCountBlueAndWW];
    self.title = @"微信授权";
    self.tableView.tableFooterView = self.footerAllView;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYMoneyOfThridBangDingWeiXinEditBottomCell" bundle:nil] forCellReuseIdentifier:moneyOfThridBangDingWeiXinEditBottomCellID];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 145;
    }else{
        return 70;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        MoneyOfThridBangDingWeiXinOrZfbEditVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MoneyOfThridBangDingWeiXinEditVcTableViewCell_Identifier ];
        if (!cell) {
            cell = [[MoneyOfThridBangDingWeiXinOrZfbEditVcTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MoneyOfThridBangDingWeiXinEditVcTableViewCell_Identifier];
            cell.separatorInset = UIEdgeInsetsMake(0, 26, 0, 26);
        }
        return cell;
    }else{
        ZYMoneyOfThridBangDingWeiXinEditBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:moneyOfThridBangDingWeiXinEditBottomCellID forIndexPath:indexPath];
        
        return cell;
    }
  
}
 
#pragma mark ==
- (UIView *)footerAllView{
    if (!_footerAllView) {
        _footerAllView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 150)];
        [_footerAllView addSubview:self.footerLabel];
        [_footerAllView addSubview:self.footerViewOk];
        [_footerAllView addSubview:self.footerViewCancel];
    }
    return _footerAllView;
}
- (UILabel *)footerLabel{
    if (!_footerLabel) {
        _footerLabel = [[UILabel alloc]init];
        _footerLabel.text = @"确认授权即表示同意《用户授权协议》";
        _footerLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _footerLabel.font = [UIFont systemFontOfSize:13];
        _footerLabel.frame = CGRectMake(26, 10, Screen_W-50, 20);//H=30
    }
    return _footerLabel;
}
- (BaseTableViewFooterView *)footerViewOk{
    if (!_footerViewOk) {
        _footerViewOk = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(16, 30, Screen_W-32, 90)];//H90
        [_footerViewOk.footerBtn newAnBtnWithTextStr:@"确认授权"];
        [_footerViewOk.footerBtn addTarget:self action:@selector(footerViewOkAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerViewOk;
}
- (UIButton *)footerViewCancel{
    if (!_footerViewCancel) {
        _footerViewCancel = [UIButton buttonWithType:UIButtonTypeCustom];//H40
        _footerViewCancel.frame = CGRectMake(16, 120, Screen_W-32, 40);
        [_footerViewCancel newAnBtnWithTextStr:@"暂不授权"];
        [_footerViewCancel newAnBtnWithFont:[UIFont systemFontOfSize:15]];
        [_footerViewCancel newAnBtnWithTextColor: [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7] ];
        [_footerViewCancel addTarget:self action:@selector(footerViewCancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerViewCancel;
}
- (void)footerViewCancelAction{
    [self popVC];
}
- (void)footerViewOkAction{
    DLog(@"");
    if (self.codeStrWithWxOrZfb.length==0) {
        Y_SVP_SHOW_ERR_MES(@"未获取到授权码");
        return;
    }
    WEAKSELF
    [MoneyOfThridBangDingInfoAddDeletData weixinBangDingWithCodeStr:self.codeStrWithWxOrZfb withBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            Y_SVP_SHOW_SUCCESS_MES(@"绑定成功");
            [ShareUserInfo sharedUserInfo].userInfo.isBindWechat = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                // 发送通知
                Y_NSNotificationCenter_PostNotice_NilObject_Name(@"BANG_DING_WECHAT_BACK")
                [weakSelf popVC];
            });
        }
    }];
}
#pragma mark ===
//
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
