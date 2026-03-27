//
//  BaseAddressAndPhoneInfoListVC.m
//  Community
//
//  Created by 余莹 on 2022/3/2.
//

#import "BaseAddressAndPhoneInfoListVC.h"

#import "SmallShopAddressInfoHeader.h"


@interface BaseAddressAndPhoneInfoListVC ()
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) NSMutableArray *oldInfoListArr;
@property (nonatomic,strong) NSString *saveWillAddAddressStr;
@property (nonatomic,strong) NSString *saveWillAddPhoneStr;
@end

@implementation BaseAddressAndPhoneInfoListVC

- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView  alloc]initWithFrame:CGRectMake(0, 0, Screen_W-100, 120)];
        [_footerView.footerBtn newAnBtnWithLayerCorNerNum:20.0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_footerView.footerBtn newAnBtnWithTextStr:@"保存"];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
- (NSMutableArray *)oldInfoListArr{
    if (!_oldInfoListArr) {
        _oldInfoListArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _oldInfoListArr;
}


#pragma mark ===
- (void)viewDidLoad {
    //初始
    if (isNil([SmallShopAddressShare share].nomallAddressInfoModel)) {
        [SmallShopAddressShare share].nomallAddressInfoModel = [[SmallShopAddressInfoModel alloc]init];
    }
    [super viewDidLoad];
    self.title = @"信息修改";
    [self initBaseView];
    [self initData];
   
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarWhiteStyle];
}
- (void)initBaseView{
 
    self.view.backgroundColor = Y_ColorWith16FromRGB(0xF0F1F6);
    //
    self.tableView.separatorColor = [UIColor clearColor];
    UIView *hV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 20)];
    hV.backgroundColor = Y_ColorWith16FromRGB(0xF0F1F6);
    self.tableView.tableHeaderView = hV;
    self.tableView.tableFooterView = self.footerView;
    [self.tableView registerClass:[BaseAddressWillUseBtnTableViewCell class] forCellReuseIdentifier:BaseAddressWillUseBtnTableViewCell_I];

    [self.footerView.footerBtn newAnBtnWithBackColor:Y_ColorWith16FromRGB(0x22D1AD)];

}
- (void)initData{
    WEAKSELF
    //section=0
    [SmallShopAddressData smallShopNomalFirstAddressAndPhoneWithBlock:^(SmallShopAddressInfoModel * _Nonnull addressInfoModel, BOOL isHaveBool) {
        if (isHaveBool) {// yes = share 拿到了最新默认值 | no 做暂无
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
    //列表数据
    [SmallShopAddressData smallShopAddressInfoHaveUsedListWithArrBlock:^(NSArray * _Nonnull arr, BOOL success) {
        if (success) {
            weakSelf.oldInfoListArr = [SmallShopAddressInfoModel mj_objectArrayWithKeyValuesArray:arr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
    
    
   
}
#pragma mark -
- (void)footerBtnAction{
    DLog(@"保存");
    [self.view endEditing:YES];
    SmallShopAddressInfoModel *model = [[SmallShopAddressInfoModel alloc]init];
    model.detail = self.saveWillAddAddressStr;
    model.phone = self.saveWillAddPhoneStr;
   
    if (model.detail.length<=0 ) {
        Y_SVP_SHOW_ERR_MES(@"请输入地址");
        return;
    }
    
    if ( model.phone.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"请输入联系电话");
        return;
    }
    
    WEAKSELF
    [SmallShopAddressData smallShopAddressAddNewInfoModel:model  withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            //滞空
            weakSelf.saveWillAddAddressStr = @"";
            weakSelf.saveWillAddPhoneStr = @"";
            //刷新
            [weakSelf initData];
        }
    }];
    
    
}
- (void)deleteWithDataIndex:(NSInteger)dataIndex{
    DLog(@"删除历史 %ld",dataIndex);
    WEAKSELF
    [SmallShopAddressData smallShopAddressDeletOneInfoModel:self.oldInfoListArr[dataIndex] withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            [weakSelf initData];
        }
    }];
}
- (void)chooseHistoryAddressWithDataIndex:(NSInteger)chooseDataIndex{
    WEAKSELF
    SmallShopAddressInfoModel *model =  self.oldInfoListArr[chooseDataIndex];
    DLog(@"使用这个地址 %ld %@",chooseDataIndex , [model mj_keyValues]);
    [SmallShopAddressData smallShopAddressUseThisOneInfoModel:model withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            [weakSelf initData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.oldInfoListArr.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 2;
    }else{
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 70;
        
    }else{
        return [tableView fd_heightForCellWithIdentifier:BaseAddressWillUseBtnTableViewCell_I cacheByIndexPath:indexPath configuration:^(BaseAddressWillUseBtnTableViewCell * cell) {
            SmallShopAddressInfoModel *model = self.oldInfoListArr[indexPath.section -1];
            [cell fillHistoryAddressStr:[TextShowWithModelStr textShowWithNotNullStr: model.detail] andPhoneStr: [TextShowWithModelStr textShowWithNotNullStr: model.phone] ];
        }];

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 1;
        
    }else if (section==1){
        return 45;
        
    }else{
        return 10;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.oldInfoListArr.count<=0) {
        return [UIView new];
    }else{
        if (section==1) {
            LabelYu *sectionTitleL = [[LabelYu alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 45)];
            sectionTitleL.textInsets = UIEdgeInsetsMake(10, 16, 0, 0);
            sectionTitleL.text = @"历史记录";
            return sectionTitleL;
            
        }else{
            return [UIView new];
        }
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        BaseAddressEditTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BaseAddressEditTextTableViewCell_I];
        if (!cell) {
            cell = [[BaseAddressEditTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BaseAddressEditTextTableViewCell_I];
        }
        cell.nowTextFStrChangeBlock = ^(NSString * _Nonnull textStr) {
            if (indexPath.row == 0) {
                self.saveWillAddAddressStr = textStr;
            }else{
                self.saveWillAddPhoneStr = textStr;
            }
        };
        if (indexPath.row==0) {
            cell.titleL.text = @"地址";
            [cell setTextPStr:[SmallShopAddressShare share].nomallAddressInfoModel.detail];
        }else{
            cell.titleL.text = @"电话";
            [cell setTextPStr: [SmallShopAddressShare share].nomallAddressInfoModel.phone ];
        }
        return cell;
    }else{
        BaseAddressWillUseBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BaseAddressWillUseBtnTableViewCell_I];
        if (!cell) {
            cell = [[BaseAddressWillUseBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BaseAddressWillUseBtnTableViewCell_I];
        }
        WEAKSELF
        cell.touchUseBtnBlock = ^{
            [weakSelf chooseHistoryAddressWithDataIndex:(indexPath.section-1)];
        };
        SmallShopAddressInfoModel *model = self.oldInfoListArr[indexPath.section -1];
        [cell fillHistoryAddressStr:[TextShowWithModelStr textShowWithNotNullStr: model.detail] andPhoneStr: [TextShowWithModelStr textShowWithNotNullStr: model.phone] ];
        return cell;
    }
}
 
 
//cell删除相关
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 0) {
        return YES;
    }else{
        return NO;
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 0) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
  
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 0) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [self deleteWithDataIndex:(indexPath.section-1)];
        }
    }
   
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 0) {
        return @"删除";
    }else{
        return @"";
    }
     
}


#pragma mark === 组圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cornerRadius = 7.5f;
    UIColor *sectionFillColor = [UIColor whiteColor];
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
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10+35, bounds.size.height-1.0, bounds.size.width-20-35, 1.0);
            //
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
