//
//  MoneyOfThridBangDingZFBEditVc.m
//  Community
//
//  Created by 余莹 on 2021/10/18.
//

#import "MoneyOfThridBangDingZFBEditVc.h"
#import "MoneyOfThridBangDingInfoAddDeletData.h"

#import "MoneyOfThridJieBangEditVcTableViewCell.h"
#define MoneyOfThridJieBangEditVcTableViewCell_Identifier    @"MoneyOfThridJieBangEditVcTableViewCell"
//#define MoneyOfThridJieBangEditVcTableViewCellHaveCodeRqBtn_Identifier    @"MoneyOfThridJieBangEditVcTableViewCellHaveCodeRqBtn"

#import "ZFBAnthorzationManager.h"


#define Tag_textF    (300)
@interface MoneyOfThridBangDingZFBEditVc () <UITextFieldDelegate>
@property (nonatomic,strong) NSMutableArray *countArr;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;

@end

@implementation MoneyOfThridBangDingZFBEditVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加支付宝";
    self.tableView.tableFooterView = self.footerView;
    [self changeNavBackColorWithDIsCountBlueAndWW];
    
}
- (void)initData{
    self.dataSourceArr = [NSMutableArray arrayWithObjects:@"姓名",@"账号", nil];
    self.countArr = [NSMutableArray arrayWithObjects:@"",@"", nil];
    [self.tableView reloadData];
}
#pragma mark ==
- (void)textFieldDidChangeSelection:(UITextField *)textField{
    DLog(@"");
    NSInteger index = textField.tag - Tag_textF;
    [self.countArr replaceObjectAtIndex:index withObject: textField.text];
    
}
#pragma mark ==
- (void)footerBtnAction{
    DLog(@"支付宝授权 footerBtnAction");

/**    WEAKSELF
 //获取支付宝授权code 上传给后台
 [MoneyOfThridBangDingAddDeletViewModel zhifubaoBangDingWithCodeStr:self.code withBlock:^(NSDictionary * _Nonnull dic, BOOL success ) {
     if (success) {
         Y_SVP_SHOW_SUCCESS_MES(@"支付宝授权绑定成功!");
         [ShareUserInfo sharedUserInfo].userInfo.isBindAlipay = YES;
         dispatch_async(dispatch_get_main_queue(), ^{
             // 发送通知
             Y_NSNotificationCenter_PostNotice_NilObject_Name(@"BANG_DING_ALIPAY_BACK")
             [weakSelf popVC];
         });
     }
 }];
 */
  
 
  
    
    /**1215 弃用
     NSString *nameStr = [NSString stringWithFormat:@"%@",self.countArr[0]];
     NSString *accountStr = [NSString stringWithFormat:@"%@",self.countArr[1]];
     if (!nameStr.length) {
         Y_SVP_SHOW_ERR_MES(@"请输入姓名");
         return;
     }
     if (!accountStr.length) {
         Y_SVP_SHOW_ERR_MES(@"请输入账号");
         return;
     }
     WEAKSELF
     [MoneyOfThridBangDingAddDeletViewModel zhifubaoBangDingWithAccountStr:accountStr realNameStr:nameStr withBlock:^(NSDictionary * dic, BOOL success) {
         if (success) {
             Y_SVP_SHOW_SUCCESS_MES(@"绑定成功");
             [ShareUserInfo sharedUserInfo].userInfo.isBindAlipay = YES;
             dispatch_async(dispatch_get_main_queue(), ^{
                 // 发送通知
                 Y_NSNotificationCenter_PostNotice_NilObject_Name(@"BANG_DING_ALIPAY_BACK")
                 [weakSelf popVC];
             });
         }
     }];
     */
   
}

#pragma mark ==
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
        MoneyOfThridJieBangEditVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MoneyOfThridJieBangEditVcTableViewCell_Identifier];
        if (!cell) {
            cell = [[MoneyOfThridJieBangEditVcTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MoneyOfThridJieBangEditVcTableViewCell_Identifier];
        }
        cell.titleL.text = self.dataSourceArr[indexPath.row];
        cell.textFiled.text = self.countArr[indexPath.row];
        cell.textFiled.tag = indexPath.row+ Tag_textF;
        cell.textFiled.delegate = self;
    if (indexPath.row==0) {
        [cell setPlaceholderString:@"请输入支付宝账号真实姓名"];
    }else{
        [cell setPlaceholderString:@"请输入支付宝账号(支持手机号码和邮箱）"];
    }
        return  cell;
   
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

- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 90)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"确定"];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView setBtnFram:CGRectMake(0, 0, Screen_W-32, 50)];
        [_footerView.footerBtn newAnBtnWithLayerCorNerNum:8 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];

    }
    return _footerView;
}
#pragma mark === getter
- (NSMutableArray *)countArr{
    if (!_countArr) {
        _countArr = [[NSMutableArray alloc]init];;
    }
    return _countArr;
}
@end
