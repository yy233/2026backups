//
//  SOSSalvageServiceDetailVc.m
//  Community
//
//  Created by 余莹 on 2021/12/6.
//

#import "SOSSalvageServiceDetailVc.h"
#import "SosAddressBookAgencyModel.h"
#import "ZYSOSAddressBookVC.h"


#define Height_TopView           (190)
#define Height_AganceNameCell    (85)
#define Height_PhoneTitleCell    (45)
#define Height_PhoneConnectCell  (35)
@interface SOSSalvageServiceDetailVc ()
@property (nonatomic,strong) SDCycleScrollView *topView;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) NSMutableArray *dataSourceArr;

@end

@implementation SOSSalvageServiceDetailVc
#pragma mark ==
- (SDCycleScrollView *)topView{
    if (!_topView) {
        _topView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Height_TopView)];
        _topView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    return _topView;
}

- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 90)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"确认添加"];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
- (void)footerBtnAction{
    if (self.isEditType) {
         if (self.thisOldArchiveModel.ID <= 0) {
             DLog(@"旧机构数据数据暂无法获取，不能更新");
         }
        DLog(@"确认修改"); 
        WEAKSELF
        [PersionSosData editAgencyOfNowFamilyId:self.saveNowFamilyModel.ID withAgencyIdStr:[NSString stringWithFormat:@"%ld",self.thisNowShowAgencyModel.ID] withOldWillChangeInfoId:[NSString stringWithFormat:@"%ld",self.thisOldArchiveModel.ID]  withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
            if (success) {
                Y_SVP_SHOW_SUCCESS_MES(@"救助机构成功更新！");
                Y_NSNotificationCenter_PostNotice_NilObject_Name(NoticeName_SosAddressUpData);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf popToPhoneAddressListVc];
                });
            }
        }];
    }else{
        DLog(@"确认添加");
        WEAKSELF
        [PersionSosData addAgencyOfNowFamilyId:self.saveNowFamilyModel.ID withAgencyIdStr:[NSString stringWithFormat:@"%ld",self.thisNowShowAgencyModel.ID]  withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
            if (success) {
                Y_SVP_SHOW_SUCCESS_MES(@"救助机构成功添加！");
                Y_NSNotificationCenter_PostNotice_NilObject_Name(NoticeName_SosAddressUpData);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf popToPhoneAddressListVc];
                });
            }
        }];
    }
}
- (void)popToPhoneAddressListVc{

    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ZYSOSAddressBookVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}
#pragma mark ==
- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataSourceArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加救助机构";
    [self initView];
    [self initData];
}
- (void)initView{
    [self setupNavigationBarStyleWithSOSColor];
    //
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.topView;
    self.tableView.tableFooterView = self.footerView;
    [_footerView.footerBtn newAnBtnWithBackColor:Y_ColorWith16FromRGB(0x36C8C1)];
}
- (void)initData{
    if (isNotNil(self.thisNowShowAgencyModel)) {
        NSString *phoneStrA = [TextShowWithModelStr textShowWithNotNullStr:self.thisNowShowAgencyModel.mobile];
        NSString *phoneStrB = [TextShowWithModelStr textShowWithNotNullStr:self.thisNowShowAgencyModel.shopPhone];
        NSString *shopImgURLStr = [TextShowWithModelStr textShowWithNotNullStr:self.thisNowShowAgencyModel.shopLogo];
        if (phoneStrA.length>0) {
            [self.dataSourceArr addObject:phoneStrA];
        }
        if (phoneStrB.length>0) {
            [self.dataSourceArr addObject:phoneStrB];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            self.topView.placeholderImage = [UIImage imageNamed:@"mgzcool"];
            if (shopImgURLStr.length>0) {
                self.topView.imageURLStringsGroup = @[shopImgURLStr];
            }
        });
       
    }
    
    
 
 
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }else{
        return self.dataSourceArr.count+1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return Height_AganceNameCell;
    }else{
        if (indexPath.row==0) {
            return Height_PhoneTitleCell;
        }else{
            return Height_PhoneConnectCell;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"textCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = Y_ColorWith16FromRGB(0x0C0C0C);
        cell.separatorInset = UIEdgeInsetsMake(0, 26, 0, 26);
    }
    if (indexPath.section==0) {
        cell.textLabel.text = [TextShowWithModelStr textShowWithNotNullStr:self.thisNowShowAgencyModel.shopName];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:24];
    }else{
        if (indexPath.row==0) {
            cell.textLabel.text = @"联系电话";
            cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
        }else{
            cell.textLabel.text = self.dataSourceArr[indexPath.row-1];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:23];
        }
    }
    return cell;
}
 

#pragma mark === 组圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cornerRadius = 0.0f;
    UIColor *sectionFillColor =  [UIColor whiteColor];
    UIColor *separatoColor  =  [UIColor whiteColor];
    if (indexPath.section==0) {
        separatoColor =  Y_ColorWith16FromRGB(0xF0F1F6);
    }else{
        separatoColor  =  [UIColor whiteColor];
    }
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
            separatoColor = [UIColor clearColor];
        } else {//填充？
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        //颜色修改
        layer.fillColor = sectionFillColor.CGColor;
        layer.strokeColor= sectionFillColor.CGColor;
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height, bounds.size.width-10, 0);
            if (indexPath.section==0) {
                separatoColor =  Y_ColorWith16FromRGB(0xF0F1F6);
            }else{
                separatoColor  =  [UIColor whiteColor];
            }
            lineLayer.backgroundColor = separatoColor.CGColor;
            [layer addSublayer:lineLayer];
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}
@end
