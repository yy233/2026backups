//
//  ImorExInfoTotalVC.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/15.
// 出入库 /1入库 2出库入口  3新增品牌 4新增位置 5统计等/

#import "ImorExOrderMainVC.h"
#import "ImExOrderMainVcSubCollectionViewCell.h"
#import "QROrImExChoosePopview.h"
#import <SGQRCode/SGQRCode.h>
#import "ScanQR_BaseViewController.h"
#import "WBQRCodeVC.h"
#import "SetStockPosAndBrandsInfoBaseVC.h"
#import "SetStockPosAndBrandsInfoWithHaveChooseSectionVC.h"



@interface ImorExOrderMainVC () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
@property (nonatomic,assign) NSInteger dayNum;
@property (nonatomic,strong) QROrImExChoosePopview *popv;
@end

@implementation ImorExOrderMainVC
#pragma mark ===
- (NSMutableArray *)dataSourceArr{
    if(!_dataSourceArr){
        _dataSourceArr = @[].mutableCopy;
    }
    return _dataSourceArr;
}

#define  ThisVcCollectionView_Tag     (1100)

#define  ShowList_NumOfHorz    (3)
#define  ShowList_All_W        (Screen_W-32)
#define  Item_W                (ShowList_All_W/ShowList_NumOfHorz)
#define  Item_H                (Item_W*1.0)
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(Item_W,Item_H);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 10;//行之间的间距
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ImExOrderMainVcSubCollectionViewCell class] forCellWithReuseIdentifier:ImExOrderMainVcSubCollectionViewCell_I];
        _collectionView.scrollEnabled = YES;
        _collectionView.tag = ThisVcCollectionView_Tag;
    }
    return _collectionView;
    
}
- (void)initViews{
    [self.view addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_collectionView.superview);
        make.bottom.equalTo(_collectionView.superview).offset(kBottom_SafeHeight);
    }];
}
#pragma mark ====

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self initDatas];
}

- (void)initDatas{
    NSArray *titleArr = @[@"入库",@"出库",@"新增\n品牌",@"新增\n品牌型号",@"新增\n仓库",@"新增\n柜子",@"新增\n层",@"移动\n库存",@"出入库\n统计"];
    for (int i = 0; i < titleArr.count; i++) {
        IEOvcShowUseModel *model = [[IEOvcShowUseModel alloc]init];
        model.title = titleArr[i];
        model.icon = @"";
        model.type = i;
        [self.dataSourceArr addObject:model];
    }
    [self.collectionView reloadData];
}

#pragma mark ==
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(Screen_W-32, 10);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImExOrderMainVcSubCollectionViewCell *cell = (ImExOrderMainVcSubCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ImExOrderMainVcSubCollectionViewCell_I  forIndexPath:indexPath];
    IEOvcShowUseModel *model = self.dataSourceArr[indexPath.row];
    cell.titleLabel.text = model.title;
    cell.imgView.hidden = YES;
    return cell;
}

#define  subAction_BaseTag      (200)
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    IEOvcShowUseModel *model = self.dataSourceArr[indexPath.row];

    switch (model.type) {
        case ImorExOrder_SubType_ImAction:
        {
            NSLog(@"入库");
//            [self showChoosePopViewWithType:model.type];
            NSLog(@"入库 填单"); //入库 不走扫码了
            ImportOrderFillVC *vc = [[ImportOrderFillVC alloc]init];
            vc.qrResDic = @{};
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case ImorExOrder_SubType_ExAction:
        {
            NSLog(@"出库");
            [self showChoosePopViewWithType:model.type];

        }
            break;
        case ImorExOrder_SubType_AddNewBrands:
        {
            NSLog(@"新增品牌");
            [self goAddInfoVcWIthType:model.type];
        }
            break;
        case ImorExOrder_SubType_AddNewBrandSubTypes:
        {
            NSLog(@"新增品牌型号");
            [self goAddInfoVcWIthType:model.type];
        }
            break;
        case ImorExOrder_SubType_AddNewPos:
        {
            NSLog(@"新增位置");
            [self goAddInfoVcWIthType:model.type];
        }
            break;
        case ImorExOrder_SubType_AddNewPos_Cib://柜子
        {
            NSLog(@"新增位置 柜子");
            [self goAddInfoVcWIthType:model.type];
        }
            break;
        case ImorExOrder_SubType_AddNewPos_Leve://层
        {
            NSLog(@"新增位置 层");
            [self goAddInfoVcWIthType:model.type];
        }
            break;
        case ImorExOrder_SubType_MoveStockPos://移动库存
        {
            NSLog(@"移动库存");
            MoveStockPosVC *vc = [[MoveStockPosVC alloc]init];
            vc.title = @"移动库存";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;

        case ImorExOrder_SubType_TatalInfoShow:
        {
            NSLog(@"出入库统计");
            Y_SVP_SHOW_INFO_MES(@"敬请期待");
        }
            break;
            
        default:
            NSLog(@"出入库---sub 其他类型");
            break;
    }

    
}
- (void)goAddInfoVcWIthType:(ImorExOrder_SubType)type{
    switch (type) {
        case ImorExOrder_SubType_AddNewBrands:
        case ImorExOrder_SubType_AddNewPos:
        {
            SetStockPosAndBrandsInfoBaseVC *vc= [[SetStockPosAndBrandsInfoBaseVC alloc]init];
            vc.type = type;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default: //有需要选择上级的添加信息的
        {
            SetStockPosAndBrandsInfoWithHaveChooseSectionVC *vc = [[SetStockPosAndBrandsInfoWithHaveChooseSectionVC alloc]init];
            vc.type = type;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    }
   
}

#pragma mark === popv

- (void)showChoosePopViewWithType:(ImorExOrder_SubType)type{

    if (self.dayNum>0) {//防治多个popv
        return;
    }
    self.popv=   [[QROrImExChoosePopview alloc]init];
    [self.popv showPopViewWithDataArr:nil
                    withShowType:type
                   withOtherData:nil
                   withBkvHeight:0
                      withSuperV:nil];
    self.popv.doQRBtn.tag = subAction_BaseTag + type;
    self.popv.doFormBtn.tag = subAction_BaseTag + type;
    [self.popv.doQRBtn addTarget:self action:@selector(qrAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.popv.doFormBtn addTarget:self action:@selector(formAction:) forControlEvents:UIControlEventTouchUpInside];
    self.dayNum = 3;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.dayNum = 0;
    });
    
   
}
- (void)qrAction:(UIButton *)sender{
    [self.popv dismissPopView];
   NSInteger indexType = sender.tag - subAction_BaseTag;
    switch (indexType) {
        case ImorExOrder_SubType_ImAction:
        {
            NSLog(@"入库 QR");
            [self scanCodeInitWithImorEx:ImorExOrder_SubType_ImAction];
        }
            break;
        case ImorExOrder_SubType_ExAction:
        {
            NSLog(@"出库 QR");
            [self scanCodeInitWithImorEx:ImorExOrder_SubType_ExAction];
        }
            break;
            
        default:
            break;
    }
}
- (void)formAction:(UIButton *)sender{
    [self.popv dismissPopView];

   NSInteger indexType = sender.tag - subAction_BaseTag;
    switch (indexType) {
        case ImorExOrder_SubType_ImAction:
        {
            NSLog(@"入库 填单"); //入库 暂时不走扫码了
            ImportOrderFillVC *vc = [[ImportOrderFillVC alloc]init];
            vc.qrResDic = @{};
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case ImorExOrder_SubType_ExAction:
        {
            NSLog(@"出库 填单");
            ExportOrderFillVC *vc = [[ExportOrderFillVC alloc]init];
            vc.qrResDic =@{};
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
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
//扫码跳转的
- (void)getQrStr:(NSString *)res withImorEx:(ImorExOrder_SubType)type{
    self.hidesBottomBarWhenPushed = NO;

    NSString *posStr =  [CigarQRTool rRStr_GetPosWithStr:res];
    NSString *productStr =   [CigarQRTool rRStr_GetProductWithStr:res];
    
    NSDictionary *getDic = @{QR_pos:posStr,
                             QR_product:productStr};
    
    NSLog(@" type %ld ,will fill dic-%@",type,getDic);

    if (productStr.length == 0) {
        Y_SVP_SHOW_INFO_MES(@"没有该产品！");
        return;
    }
    switch (type) {
        case ImorExOrder_SubType_ImAction:
        {
            ImportOrderFillVC *vc = [[ImportOrderFillVC alloc]init];
            vc.qrResDic = getDic;
            vc.hidesBottomBarWhenPushed = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:vc animated:YES];
            });
        }
            break;
        case ImorExOrder_SubType_ExAction:
        {
            ExportOrderFillVC *vc = [[ExportOrderFillVC alloc]init];
            vc.qrResDic = getDic;
            vc.hidesBottomBarWhenPushed = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:vc animated:YES];
            });
        }
            break;
            
        default:
            break;
    }
}
@end
