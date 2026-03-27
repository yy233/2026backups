//
//  MoneyOfThridJieBangEditVc.m
//  Community
//
//  Created by 余莹 on 2021/10/13.
// 解除绑定 编辑页

#import "MoneyOfThridJieBangEditVc.h"
#import "MoneyOfThridJieBangEndVc.h"
#import "MoneyOfThridBangDingInfoAddDeletData.h"

#import "MoneyOfThridJieBangEditVcTableViewCell.h"
#define MoneyOfThridJieBangEditVcTableViewCell_Identifier    @"MoneyOfThridJieBangEditVcTableViewCell"
#define MoneyOfThridJieBangEditVcTableViewCellHaveCodeRqBtn_Identifier    @"MoneyOfThridJieBangEditVcTableViewCellHaveCodeRqBtn"
#define Tag_textF    (300)
@interface MoneyOfThridJieBangEditVc () <UITextFieldDelegate>
@property (nonatomic,strong) NSMutableArray *countArr;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;

@end

@implementation MoneyOfThridJieBangEditVc

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableView.tableFooterView = self.footerView;
    [self changeNavBackColorWithDIsCountBlueAndWW];
    
}
- (void)initData{
    self.dataSourceArr = [NSMutableArray arrayWithObjects:@"+86",@"验证码", nil];
    self.countArr = [NSMutableArray arrayWithObjects:[TextShowWithModelStr textShowWithModelStr: [ShareUserInfo sharedUserInfo].userInfo.mobile ],@"", nil];
    [self.tableView reloadData];
}
#pragma mark ==
- (void)textFieldDidChangeSelection:(UITextField *)textField{
    DLog(@"");
    NSInteger index = textField.tag - Tag_textF;

    if (index==0) {
        return;
    }else{
        NSString *codeStr  = textField.text;
        [self.countArr replaceObjectAtIndex:index withObject:codeStr];
        if (codeStr.length>=4) {//textF失去响应
            [self.tableView reloadData];
        }
    }
}
#pragma mark ==
// 验证码按钮
- (void)codeRqBtnAction{
    DLog(@"");
    NSString *wxJieBangAccount = [NSString stringWithFormat:@"%@",self.countArr[0]];
     if (wxJieBangAccount.length==0  || isNil(self.countArr[0])) {
        Y_SVP_SHOW_ERR_MES(@"请填入数据！");
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:wxJieBangAccount forKey:@"account"];
    [params setValue:@(CodeRequestType_MoneyJieBangWx) forKey:@"type"];
    [[ToolOfNetWork sharedTools] YrequestGetURL:URL_USER_SEND_CODE withParams:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                //[cellSubBtn countdown];//验证码btn 点击后做延时 不在成功后再调用不好刷新
                Y_SVP_SHOW_SUCCESS_MESSAGE
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
#pragma mark ==
- (void)footerBtnAction{
  
    DLog(@"");
    NSString *nowJieBangAccount = [NSString stringWithFormat:@"%@",self.countArr[0]];
    NSString *nowJieBangNomalCode = [NSString stringWithFormat:@"%@",self.countArr[1]];
    if (!nowJieBangAccount.length) {
        Y_SVP_SHOW_ERR_MES(@"请输入关联的手机号");
        return;
    }
    if (!nowJieBangNomalCode.length) {
        Y_SVP_SHOW_ERR_MES(@"请输入验证码");
        return;
    }
    WEAKSELF
    if ([self.thridPTypeStr isEqualToString:thirdPlatformType_WECHAT]) {
        //微信
        [MoneyOfThridBangDingInfoAddDeletData weixinJieBangWithAccountStr:nowJieBangAccount andNomalCodeStr:nowJieBangNomalCode withBlock:^(NSDictionary * _Nonnull dic,BOOL success) {
            if (success) {
                [ShareUserInfo sharedUserInfo].userInfo.isBindWechat = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    MoneyOfThridJieBangEndVc *vc = [[MoneyOfThridJieBangEndVc alloc] init];
                    [weakSelf pushVc:vc];
                });
            }
        }];
        
    }else if ([self.thridPTypeStr isEqualToString:thirdPlatformType_ALIPAY]){
        //支付宝
        [MoneyOfThridBangDingInfoAddDeletData zhifubaoJieBangWithAccountStr:nowJieBangAccount andNomalCodeStr:nowJieBangNomalCode withBlock:^(NSDictionary * dic, BOOL success) {
           if (success) {
               [ShareUserInfo sharedUserInfo].userInfo.isBindAlipay = NO;
               dispatch_async(dispatch_get_main_queue(), ^{
                   MoneyOfThridJieBangEndVc *vc = [[MoneyOfThridJieBangEndVc alloc]init];
                   [weakSelf pushVc:vc];
               });
            
           }
       }];
    }else if ([self.thridPTypeStr isEqualToString:thirdPlatformType_iOS]){
        //iOS
        [MoneyOfThridBangDingInfoAddDeletData iosJieBangWithNotUseAccountStr:nowJieBangAccount andNomalCodeStr:nowJieBangNomalCode withBlock:^(NSDictionary * dic, BOOL success) {
            if (success) {
                [ShareUserInfo sharedUserInfo].userInfo.isBindIOS = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    MoneyOfThridJieBangEndVc *vc = [[MoneyOfThridJieBangEndVc alloc]init];
                    [weakSelf pushVc:vc];
                });
            }
        }];
    }else{
        
    }
 
    
   
  
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    LabelYu *headerL = [[LabelYu alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 50)];
    headerL.textInsets = UIEdgeInsetsMake(10, 16, 10, 16);
    headerL.text = @"短信验证通过后，才能解除绑定";
    headerL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
    return headerL;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        MoneyOfThridJieBangEditVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MoneyOfThridJieBangEditVcTableViewCell_Identifier];
        if (!cell) {
            cell = [[MoneyOfThridJieBangEditVcTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MoneyOfThridJieBangEditVcTableViewCell_Identifier];
        }
        cell.titleL.text = self.dataSourceArr[indexPath.row];
        cell.textFiled.text = self.countArr[indexPath.row];
        cell.textFiled.userInteractionEnabled = NO;
        cell.textFiled.tag = indexPath.row+ Tag_textF;
        return  cell;
    }else{
        MoneyOfThridJieBangEditVcTableViewCellHaveCodeRqBtn *cell = [tableView dequeueReusableCellWithIdentifier:MoneyOfThridJieBangEditVcTableViewCellHaveCodeRqBtn_Identifier];
        if (!cell) {
            cell = [[MoneyOfThridJieBangEditVcTableViewCellHaveCodeRqBtn alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MoneyOfThridJieBangEditVcTableViewCellHaveCodeRqBtn_Identifier];
        }
        cell.titleL.text = self.dataSourceArr[indexPath.row];
        cell.textFiled.text = self.countArr[indexPath.row];
        cell.textFiled.delegate = self;
        cell.textFiled.tag = indexPath.row+ Tag_textF;
        WEAKSELF
        cell.touchCodeActionBlock = ^{
            DLog(@"touchCodeActionBlock  *** 验证码按钮");
            [weakSelf codeRqBtnAction];
        };
        return cell;
    }
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
