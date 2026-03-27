//
//  ActivityInputInfoVC.m
//  Community
//
//  Created by 余莹 on 2022/6/7.
//

#import "ActivityInputInfoVC.h"
#import "ActivityInputInfoVcTableViewCell.h"
#import "ActivityAddSuccessVC.h"
#import "ActivityOtherData.h"

#define  TextF_tag_input (300)
@interface ActivityInputInfoVC () <UITextFieldDelegate>
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) NSString *strName;
@property (nonatomic,strong) NSString *strPhone;

@end

@implementation ActivityInputInfoVC
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView  alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 120)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"提交报名"];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
- (void)footerBtnAction{
    DLog(@"");
 
    if (self.strPhone.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"请输入手机号！");
        
    }else if (self.strName.length <= 0){
        Y_SVP_SHOW_ERR_MES(@"请输入个人名称！");
        
    }else if (self.strPhone.length < 8 || self.strPhone.length > 11){
        Y_SVP_SHOW_ERR_MES(@"手机号格式不正确！");
    }else{
    }
    [self.view endEditing:YES];
    
    //
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:self.thisActivityIdStr forKey:@"activityId"];
    [parms setValue:self.strName forKey:@"name"];
    [parms setValue:self.strPhone forKey:@"mobile"];

    
    WEAKSELF
    [ActivityOtherData activityInputInfo:parms withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                ActivityAddSuccessVC *vc = [[ActivityAddSuccessVC alloc]init];
                [weakSelf pushVc:vc];
            });
        }
    }];
 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.strName = @"";
    self.strPhone  = @"";
    [self initView];
}
- (void)initView{
    [self changeNavBackColorWithDIsCountBlueAndWW];
    self.tableView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD;
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 10)];
    self.tableView.tableFooterView = self.footerView;
    self.tableView.separatorColor = [UIColor clearColor];
}
 
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        return 35;
    }
    return 50.0;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ActivityInputInfoVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: ActivityInputInfoVcTableViewCell_I ];
        if (!cell) {
            cell = [[ActivityInputInfoVcTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ActivityInputInfoVcTableViewCell_I];
        }
        cell.titleL.text = @"个人信息";
        return cell;
    }else if (indexPath.row == 3){//占位行当作bottom
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nomall_0" ];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"nomall_0"];
        }
        return cell;
    }else{
        ActivityInputInfoVcTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: ActivityInputInfoVcTextFieldTableViewCell_I ];
        if (!cell) {
            cell = [[ActivityInputInfoVcTextFieldTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ActivityInputInfoVcTextFieldTableViewCell_I];
            cell.textF.delegate = self;
            cell.textF.tag = TextF_tag_input+indexPath.row;
        }
        if (indexPath.row == 1) {
            [cell changePlaceholderStrInfoWithStr:@"姓名"];
            cell.textF.keyboardType = UIKeyboardTypeDefault;
            cell.textF.text = self.strName;
            
        }else{
            [cell changePlaceholderStrInfoWithStr:@"电话"];
            cell.textF.keyboardType = UIKeyboardTypePhonePad;
            cell.textF.text = self.strPhone;
        }
        return cell;
    }
 
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
  [self getTextSave:textField];

}
- (void)textFieldDidChangeSelection:(UITextField *)textField{
  [self getTextSave:textField];
}

- (void)getTextSave:(UITextField *)textField{
    NSInteger tagIndex = textField.tag-TextF_tag_input;
  switch (tagIndex) {
      case 1:
      {
          self.strName = [TextShowWithModelStr textShowWithModelStr:textField.text];
      }
          break;
          
      case 2:
      {
          self.strPhone = [TextShowWithModelStr textShowWithModelStr:textField.text];
      }
          break;
          
      default:
          break;
  }
  
}


#pragma mark === 组圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cornerRadius = 7.5f;
    UIColor *sectionFillColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;

    UIColor *separatoColor = Y_ColorWith16FromRGB(0xF0F1F6);
     if ([cell respondsToSelector:@selector(tintColor)]) {
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
        layer.fillColor = sectionFillColor.CGColor;
        layer.strokeColor= sectionFillColor.CGColor;
         
         addLine = NO;//不需要系统分割线
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10+35, bounds.size.height-1.0, bounds.size.width-20-35, 1.0);
            [layer addSublayer:lineLayer];
            if (indexPath.section == 0 && indexPath.row==0) {
                lineLayer.backgroundColor = separatoColor.CGColor;
            }else{
                lineLayer.backgroundColor = [UIColor clearColor].CGColor;
            }
           
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}


 

@end
