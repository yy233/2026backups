//
//  ExportOrderQRLastShowVC.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/31.
//

#import "ExportOrderQRLastShowVC.h"
#import "AllStockRoomThingsShowCollectionViewCell.h"
#import <SGQRCode/SGQRCode.h>
#import "ScanQR_BaseViewController.h"
#import "WBQRCodeVC.h"
@interface ExportOrderQRLastShowVC () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UIButton *footerB;
@property (nonatomic,strong) NSMutableArray *saveWillExGoodsArr;//存储当前待出库 加入到购物车的Model数据
@end



@implementation ExportOrderQRLastShowVC
//  设置头底部视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {//这是头部视图
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind  withReuseIdentifier:ksectionTitileHeaderView_I   forIndexPath:indexPath];
        [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [view addSubview:[self collectionHeader_sectionTitileHeaderViewAtIndexPath:indexPath]];
        return view;
        
    }else{//15后foot复用UICollectionElementKindSectionHeader闪退。都得注册
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind  withReuseIdentifier:ksectionTitileHeaderView_I   forIndexPath:indexPath];
        return view;
    }
    
}
#define sectionMainTypeBtn_baseTag (200)
- (UIView *)collectionHeader_sectionTitileHeaderViewAtIndexPath:(NSIndexPath *)indexPath{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake( 0, 0,Screen_W, 100)];
    [v addSubview:self.footerB];
    return v;
}

//  底部视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(Screen_W, 100);
}
#pragma mark ==
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.productCodeSearchOkShowThisTimesModelArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(Screen_W-32, 10);
}
#pragma mark ====

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AllStockRoomThingsShowCollectionViewCell_subHaveTabv *cell = (AllStockRoomThingsShowCollectionViewCell_subHaveTabv *)[collectionView dequeueReusableCellWithReuseIdentifier:AllStockRoomThingsShowCollectionViewCell_subHaveTabv_I forIndexPath:indexPath];
    cell.buyAddBtn.tag = buyAddBtn_baseTag+indexPath.row;
    [cell.buyAddBtn addTarget:self action:@selector(buyAddBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    BrandStockInFoModel *model;
    model =  self.productCodeSearchOkShowThisTimesModelArr[indexPath.row];
    [cell fillDataModel:model haveAddBtnShow:YES];
 
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    BrandStockInFoModel *model;
    model = self.productCodeSearchOkShowThisTimesModelArr[indexPath.row];
}


#pragma mark ===
- (NSMutableArray *)saveWillExGoodsArr{
    if (!_saveWillExGoodsArr) {
        _saveWillExGoodsArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _saveWillExGoodsArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CC_Brown_D;
    
    [self initViews];
    if (self.productCodeStr.length <=0) {
        return;
    }else{
        [self doNewQrResultNet];//重新获取数据
    }

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"添加出库物品到购物车";
    self.navigationItem.hidesBackButton = YES;
}

- (NSMutableArray<BrandStockInFoModel *> *)productCodeSearchOkShowThisTimesModelArr{
    if (!_productCodeSearchOkShowThisTimesModelArr) {
        _productCodeSearchOkShowThisTimesModelArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _productCodeSearchOkShowThisTimesModelArr;
}
 
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake((Screen_W-32),((Screen_W-32)*0.5));
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[AllStockRoomThingsShowCollectionViewCell class]
            forCellWithReuseIdentifier:AllStockRoomThingsShowCollectionViewCell_I];
        [_collectionView registerClass:[AllStockRoomThingsShowCollectionViewCell_subHaveTabv class]
            forCellWithReuseIdentifier:AllStockRoomThingsShowCollectionViewCell_subHaveTabv_I];
        [_collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:ksectionTitileHeaderView_I];
        [_collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:ksectionTitileHeaderView_I];
        _collectionView.scrollEnabled = YES;
        _collectionView.tag = ThisVcMainCollectionView_Tag;
    }
    return _collectionView;
    
}
- (UIButton *)footerB{
    if(!_footerB){
        _footerB = [UIButton buttonWithType:UIButtonTypeCustom];
        _footerB.frame = CGRectMake(50, 25, Screen_W-100, 50);
        [_footerB newAnBtnWithTextStr:@"继续扫码添加到待出库购物车"];
        [_footerB newAnBtnWithTextColor:[UIColor whiteColor]
                          withBackColor:CC_Red_Drak_B
                               withFont:[UIFont systemFontOfSize:16.0]
                     withLayerCorNerNum:24.0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_footerB addTarget:self action:@selector(footerGoQr) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerB;
}

#pragma mark ============================
- (void)initViews{
    [self.view addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_collectionView.superview);
    }];
    [self addNavItem];
    
   
}
#pragma mark ====  nav
- (void)addNavItem{
    UIBarButtonItem *rightMaxItem = [[UIBarButtonItem alloc]initWithTitle:@"去结算" style:UIBarButtonItemStylePlain target:self action:@selector(rightNavAction)];
    [self.navigationItem setRightBarButtonItems:@[rightMaxItem] animated:YES];
}
#pragma mark =========
- (void)doNewQrResultNet{
    //根据产品码查询到这个库存数据
    WEAKSELF
    [[GetDatasTool share]getProductInfoWithProductCodeId:self.productCodeStr
                                  withTypesListWithBlock:^(BOOL succ, NSArray * _Nonnull dataList) {
        BrandStockInFoModel *qrModel;
        if ([dataList isKindOfClass:[NSArray class]] || [dataList isKindOfClass:[NSMutableArray class]]) {
            weakSelf.productCodeSearchOkShowThisTimesModelArr = [BrandStockInFoModel mj_objectArrayWithKeyValuesArray:dataList];

        } else if ([dataList isKindOfClass:[NSDictionary class]] || [dataList isKindOfClass:[NSMutableDictionary class]]){
            qrModel  = [BrandStockInFoModel mj_objectWithKeyValues:dataList];
            weakSelf.productCodeSearchOkShowThisTimesModelArr = @[qrModel].mutableCopy;
        }else{
            weakSelf.productCodeSearchOkShowThisTimesModelArr = @[].mutableCopy;
           
        }
        //strongSelf.tfCanEditBool = NO; 允许更改
        [weakSelf.collectionView reloadData];
    }];
}

#pragma mark ============================
//@"去结算"
- (void)rightNavAction{
    
    if (isNotNil(self.goodsModelArrBlock)) {
        if (self.saveWillExGoodsArr.count>0) {
            self.goodsModelArrBlock(self.saveWillExGoodsArr);

        } else {
            self.goodsModelArrBlock(self.saveWillExGoodsArr);
            
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ============================
//@"qr 继续"
- (void)footerGoQr{
    [self scanCodeInitWithImorEx:ImorExOrder_SubType_ExAction];
}
#pragma mark === QR
- (void)scanCodeInitWithImorEx:(ImorExOrder_SubType)type{
    WEAKSELF
    [SGPermission permissionWithType:SGPermissionTypeCamera completion:^(SGPermission * _Nonnull permission, SGPermissionStatus status) {
        if (status == SGPermissionStatusNotDetermined) {
            [permission request:^(BOOL granted) {
                if (granted) {
                    NSLog(@"第一次授权成功");
                    WBQRCodeVC *qrVC = [[WBQRCodeVC alloc] init];
                    weakSelf.hidesBottomBarWhenPushed = YES;
                    qrVC.qrResultStrBlock = ^(NSString * _Nonnull resultStr) {
                        NSLog(@"QR resultStr - %@",resultStr);
                        [weakSelf getQrStr:resultStr withImorEx:type];
                    };
                    [weakSelf.navigationController pushViewController:qrVC animated:YES];
                    weakSelf.hidesBottomBarWhenPushed = NO;
                } else {
                    NSLog(@"第一次授权失败");
                }
            }];
        } else if (status == SGPermissionStatusAuthorized) {
            NSLog(@"SGPermissionStatusAuthorized");
            WBQRCodeVC *qrVC = [[WBQRCodeVC alloc] init];
            weakSelf.hidesBottomBarWhenPushed = YES;
            qrVC.qrResultStrBlock = ^(NSString * _Nonnull resultStr) {
                NSLog(@"QR resultStr - %@",resultStr);
                [weakSelf getQrStr:resultStr withImorEx:type];
            };
            [weakSelf.navigationController pushViewController:qrVC animated:YES];
            weakSelf.hidesBottomBarWhenPushed = NO;


        } else if (status == SGPermissionStatusDenied) {
            NSLog(@"SGPermissionStatusDenied");
            [weakSelf failed];
        } else if (status == SGPermissionStatusRestricted) {
            NSLog(@"SGPermissionStatusRestricted");
            [weakSelf unknown];
        }
    }];
    
}

- (void)failed {
    WEAKSELF
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"[前往：设置 - 隐私 - 相机 - SGQRCode] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertA];
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf presentViewController:alertC animated:YES completion:nil];
    });
}
- (void)unknown {
    WEAKSELF
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertC addAction:alertA];
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf presentViewController:alertC animated:YES completion:nil];
    });
}
#pragma mark ===
//扫码结果
- (void)getQrStr:(NSString *)res withImorEx:(ImorExOrder_SubType)type{
    self.hidesBottomBarWhenPushed = NO;
    
    //NSString *posStr =  [CigarQRTool rRStr_GetPosWithStr:res];
    NSString *productStr =   [CigarQRTool rRStr_GetProductWithStr:res];
    if (productStr.length>0) {
        self.productCodeStr = productStr;//符合的 更新数据 去调接口
        [self doNewQrResultNet];//数据更新
    }else{
        Y_SVP_SHOW_INFO_MES(@"无法匹配到产品编码信息！");
        //清空当前列表
        self.productCodeSearchOkShowThisTimesModelArr = @[].mutableCopy;
        [self.collectionView reloadData];
    }
}

#pragma mark ============================
#pragma mark ==== cell addbtnAction
- (void)buyAddBtnAction:(UIButton *)sender{
    
    NSInteger addIndex = sender.tag - buyAddBtn_baseTag;
    BrandStockInFoModel *model;
    model = self.productCodeSearchOkShowThisTimesModelArr[addIndex];
    [self dealBuyAddBtnChooseModel:model];
}
#pragma mark ====  addbtnAction
- (void)dealBuyAddBtnChooseModel:(BrandStockInFoModel *)model{
    //做卖价格和数量提交到购物车
    
    
    //价格数量填入弹出框
    
    NSString *titls = [NSString stringWithFormat:@"%@的成本价格为%@\n当前支数%ld",
                       [TextShowWithModelStr textShowWithModelStr:model.Name.s],[TextShowWithModelStr textShowWithModelStr:model.BuyPrice],model.Pieces];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titls
                                                                             message:@"请填写卖出价格和数量" preferredStyle:UIAlertControllerStyleAlert];
    
    //添加取消类型按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消");
    }]];
    //添加常规类型按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击确认");
        NSDecimalNumber *money = 0;
        NSInteger num = 0;
        if (alertController.textFields.firstObject.text.length>0 ) {
            money = [NSDecimalNumber decimalNumberWithString:alertController.textFields.firstObject.text];
        } else {
            Y_SVP_SHOW_INFO_MES(@"请填写卖价");
        }
        if (alertController.textFields.lastObject.text.length>0 ) {
            num = [alertController.textFields.lastObject.text integerValue];
        } else {
            Y_SVP_SHOW_INFO_MES(@"请填写数量");
        }
        if(num > model.Pieces){
            Y_SVP_SHOW_ERR_MES(@"库存不足！请更改数量");
            return;
        }
        model.BuyPrice = money;
        model.Pieces = num;
        [self addWillExNewModel:model];
        
    }]];
    
    //添加文本框1
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSLog(@"1 tf");
    }];
    //添加文本框2
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSLog(@"2 tf");
    }];
    alertController.textFields.firstObject.keyboardType = UIKeyboardTypeDecimalPad;
    alertController.textFields.lastObject.keyboardType  = UIKeyboardTypeNumberPad;
    alertController.textFields.firstObject.placeholder = @"卖出价格";
    alertController.textFields.lastObject.placeholder = @"出库数量";
    
    //显示
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
    
}

- (void)addWillExNewModel:(BrandStockInFoModel *)model{
    
    for (int i = 0 ; i < self.saveWillExGoodsArr.count; i++) {
        BrandStockInFoModel *objM  = self.saveWillExGoodsArr[i];
        if (objM.Id == model.Id) {
            [self.saveWillExGoodsArr replaceObjectAtIndex:i withObject:model];
            Y_SVP_SHOW_SUCCESS_MES(@"已经更新!");
            return;//已经添加 --做更改动作
        }
    }
    //非重复
    [self.saveWillExGoodsArr addObject:model];
    Y_SVP_SHOW_SUCCESS_MES(@"添加成功，待出库。");
}

@end
