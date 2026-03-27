//
//  LifeCostPayMentListVcHeaderShaiXuanView.m
//  Community
//
//  Created by 余莹 on 2021/7/7.
//

#import "LifeCostPayMentListVcHeaderShaiXuanView.h"
#import "LifeCostShaiXuanHuHaoTypeModel.h"
#define SaiXuanHeaderView_H (50)

@interface LifeCostPayMentListVcHeaderShaiXuanView () <WMZDropMenuDelegate>
@property (nonatomic,strong) WMZDropMenuParam *param;
@property (nonatomic,strong) WMZDropDownMenu *menu ;

//
@property (nonatomic,strong) NSMutableArray*huHaoDataSoureSaveModelArr;
@property (nonatomic,strong) NSMutableArray*timeDataSourceSaveModelArr;
@property (nonatomic,strong) NSMutableArray*huHaoDataSourceShowUseArr;
@property (nonatomic,strong) NSMutableArray*timeDataSourceShowUseArr;
@end

@implementation LifeCostPayMentListVcHeaderShaiXuanView

#pragma mark ==
- (NSMutableArray *)huHaoDataSoureSaveModelArr{
    if (!_huHaoDataSoureSaveModelArr) {
        _huHaoDataSoureSaveModelArr = [[NSMutableArray alloc]init];
    }
    return _huHaoDataSoureSaveModelArr;
}
- (NSMutableArray *)timeDataSourceSaveModelArr{
    if (!_timeDataSourceSaveModelArr) {
        _timeDataSourceSaveModelArr = [[NSMutableArray alloc]init];
    }
    return _timeDataSourceSaveModelArr;
}
- (NSMutableArray *)huHaoDataSourceShowUseArr{
    if (!_huHaoDataSourceShowUseArr) {
        _huHaoDataSourceShowUseArr = [[NSMutableArray alloc]init];
    }
    return _huHaoDataSourceShowUseArr;
}
- (NSMutableArray *)timeDataSourceShowUseArr{
    if (!_timeDataSourceShowUseArr) {
        _timeDataSourceShowUseArr = [[NSMutableArray alloc]init];
    }
    return _timeDataSourceShowUseArr;
}

#pragma mark ==

- (void)fillHuHaoListData:(NSMutableArray *)huhaoArr{
    self.huHaoDataSoureSaveModelArr = [LifeCostShaiXuanHuHaoTypeModel mj_objectArrayWithKeyValuesArray:huhaoArr];
    self.huHaoDataSourceShowUseArr = [[NSMutableArray alloc]initWithArray: [self dealShaiXuanNomalTableViewListDataInfoWithSectionNum:0 andWithModelArr:self.huHaoDataSoureSaveModelArr]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.menu updateUI];
    });
}
- (void)fillTimeListData:(NSMutableArray *)timeArr{
    self.timeDataSourceShowUseArr = [NSMutableArray arrayWithArray:timeArr];
}

#pragma mark ===  数据model 筛选展示用的数据处理
- (NSMutableArray *)dealShaiXuanNomalTableViewListDataInfoWithSectionNum:(NSInteger)section andWithModelArr:(NSMutableArray *)modelArr{
    NSMutableArray *useShaiXuanArr = [[NSMutableArray alloc]init];
    for (int i = 0 ; i <modelArr.count; i++) {
        if (section == 0) {//户号
            LifeCostShaiXuanHuHaoTypeModel *model = modelArr[i];
            NSString *huhaoShowStr = [NSString stringWithFormat:@"%@ %@ %@",[TextShowWithModelStr textShowWithModelStr: model.typeName],[TextShowWithModelStr textShowWithModelStr: model.familyId],[TextShowWithModelStr textShowWithModelStr: model.companyName]];
            NSDictionary *newDic = @{@"name": huhaoShowStr  ,@"otherData":model};
            [useShaiXuanArr addObject:newDic];
        }else{//时间
//            NSDictionary *newDic = @{@"name":  @"时间" ,@"otherData":model};
//            [useShaiXuanArr addObject:newDic];
        }
    }
    return useShaiXuanArr;
}
#pragma mark ==
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBuniessShopAndHouseShaiXuanChooseMenu];
    }
    return self;
}
/**      ___________________________     */
#pragma mark === 商铺 下拉菜单 初始化
- (void)initBuniessShopAndHouseShaiXuanChooseMenu{

    //    UIColor *collviewBgColor = [UIColor whiteColor];
    UIColor *topTitleBgColor =  [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
    UIColor *bomListTableViewBgColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
    UIColor *collViewCellNomalBgColor = [ [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor colorWithAlphaComponent:0.7];
    UIColor *collViewCellSelectedBgColor = Color_38BlueColor;

    self.param =
    MenuParam()
    .wMainRadiusSet(0)
    .wTextAlignmentSet(NSTextAlignmentCenter)
    .wTableViewColorSet( @[bomListTableViewBgColor,bomListTableViewBgColor,bomListTableViewBgColor,bomListTableViewBgColor] )

    .wCollectionViewCellBgColorSet(collViewCellNomalBgColor)
    .wCollectionViewCellSelectBgColorSet( collViewCellSelectedBgColor)
    .wCollectionViewCellTitleColorSet([UIColor whiteColor])
    .wCollectionViewCellSelectTitleColorSet([UIColor whiteColor])
     .wDefaultConfirmHeightSet(50)

    .wMenuTitleEqualCountSet(2);

    self.menu = [[WMZDropDownMenu alloc]initWithFrame:CGRectMake(0, 0, Screen_W, SaiXuanHeaderView_H) withParam:self.param];
    self.menu.titleView.backgroundColor =  topTitleBgColor;
    self.menu.collectionView.backgroundColor  = topTitleBgColor;
    self.menu.delegate = self;
    [self addSubview:self.menu];
}


#pragma mark === 筛选协议部分
- (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu{
    NSString *nomalImgName = @"Allaccountnumbers_Pulldown_night";
    NSString *selectedImgName = @"Allaccountnumbers_Unfold_night";
    if (self.viewType == LiftCost_PaymentRecords_HuHao ) {
    }
    return @[
        @{@"name":@"全部户号",@"normalImage":nomalImgName,@"selectImage":selectedImgName},
        @{@"name":@"全部时间",@"normalImage":nomalImgName,@"selectImage":selectedImgName},
    ];

}


- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSArray *)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{

    if (dropIndexPath.section==LiftCost_PaymentRecords_HuHao) {
        return  self.huHaoDataSourceShowUseArr;
    }else{
        return   self.timeDataSourceShowUseArr;
    }


}
- (MenuEditStyle)menu:(WMZDropDownMenu *)menu editStyleForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{//section 和 row 的多选单选. 每列的编辑类型 单选|多选  默认单选
    return MenuEditOneCheck;
 
}


- (NSString *)menu:(WMZDropDownMenu *)menu titleForHeadViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    return @"";
}
- (CGFloat)menu:(WMZDropDownMenu *)menu heightForHeadViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    return 0;
}

- (CGFloat)menu:(WMZDropDownMenu *)menu heightForFootViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    return 0;//*自定义footView高度 底部的重置确定  值为0也会有条白线
}


- (MenuUIStyle)menu:(WMZDropDownMenu *)menu uiStyleForRowIndexPath:(WMZDropIndexPath *)dropIndexPath{
    return MenuUITableView;
//    return MenuUICollectionView;//自带footerv
}
//- (UICollectionViewCell*)menu:(WMZDropDownMenu *)menu cellForUICollectionView:(WMZDropCollectionView*)collectionView
//              AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath AtIndexPath:(NSIndexPath*)indexpath dataForIndexPath:(WMZDropTree*)model{
//    if (dropIndexPath.section == 2&&dropIndexPath.row == 0) {
//         DemoOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DemoOneCell" forIndexPath:indexpath];
//         cell.textLa.text = model.name;
//         cell.textLa.textColor = model.isSelected?MenuColor(0xff2448):MenuColor(0x333333);
//        return cell;
//    }
//    return nil;
//}
- (void)menu:(WMZDropDownMenu *)menu customDefauultCollectionFootView:(WMZDropConfirmView *)confirmView{
    confirmView.showBorder = YES;
    confirmView.resetBtn.backgroundColor = MenuColor(0xfcfdfd);
    [confirmView.confirmBtn setTitle:@"确定11" forState:UIControlStateNormal];
    confirmView.confirmBtn.backgroundColor = MenuColor(0xff2448);
    [confirmView.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
/*
 *返回section行标题数据视图出现的动画样式   默认
 MenuShowAnimalBottom
 注:最后一个默认是筛选 弹出动画为 MenuShowAnimalRight
 */
- (MenuShowAnimalStyle)menu:(WMZDropDownMenu *)menu
showAnimalStyleForRowInSection:(NSInteger)section{
    return MenuShowAnimalBottom;
}
/*
 *返回section行标题数据视图消失的动画样式   默认 MenuHideAnimalTop
 注:最后一个默认是筛选 消失动画为 MenuHideAnimalLeft
 */
- (MenuHideAnimalStyle)menu:(WMZDropDownMenu *)menu
hideAnimalStyleForRowInSection:(NSInteger)section{
    return MenuHideAnimalTop;
}

/*
 *返回WMZDropIndexPath每行 每列 显示的个数
 注:
 样式MenuUITableView         默认4个
 样式MenuUICollectionView    默认1个 传值无效
 */

- (NSInteger)menu:(WMZDropDownMenu *)menu countForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    return 4;

}
#pragma -mark 交互自定义代理

/*
 *cell点击方法
 */
- (void)menu:(WMZDropDownMenu *)menu
didSelectRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath
dataIndexPath:(NSIndexPath*)indexpath data:(WMZDropTree*)data{
    NSLog(@"cell点击方法");// po data ======== name = m2 ，isSeleted = 1
    NSInteger chooseSectionNum = dropIndexPath.section;//横向section
    NSInteger chooseRowNum = indexpath.row;//纵向arr 的 row

    if (self.viewType == LiftCost_PaymentRecords_HuHao ) {

    }

}
/*
 *标题点击方法
 */
- (void)menu:(WMZDropDownMenu *)menu didSelectTitleInSection:
(NSInteger)section btn:(WMZDropMenuBtn*)selectBtn{
    NSLog(@"标题点击方法");//po selectBtn.normalTitle

}
/*
 *确定方法 多个选择
 selectNoramalData 转化后的的模型数据
 selectData 字符串数据
 */
- (void)menu:(WMZDropDownMenu *)menu didConfirmAtSection:
(NSInteger)section selectNoramelData:(NSMutableArray*)selectNoramalData selectStringData:(NSMutableArray*)selectData{
    NSLog(@"确定方法 ");
}

/*
 *重置方法
 */
- (void)menu:(WMZDropDownMenu *)menu didReSetAtSection:(NSInteger)section{
}
/*
 *监听关闭视图 可做修改标题文本和颜色的操作
 */
- (void)menu:(WMZDropDownMenu *)menu closeWithBtn:(WMZDropMenuBtn*)selectBtn   index:(NSInteger )index{

}

/*
 *自定义标题按钮视图  返回配置 参数说明
 offset       按钮的间距
 y            按钮的y坐标   自动会居中
 */
//- (NSDictionary*)menu:(WMZDropDownMenu *)menu customTitleInSection:(NSInteger)section withTitleBtn:(WMZDropMenuBtn *)menuBtn{
//
//    menuBtn.position = MenuBtnPositionLeft;
//
//    [WMZDropMenuTool viewPathWithColor:MenuColor(0x999999) PathType:MenuShadowPathLeft PathWidth:MenuK1px heightScale:1 button:menuBtn];
//
//    return @{@"offset":@(5)};
//}

/*
 *是否关联 其他标题 即选中其他标题 此标题会不会取消选中状态 default YES 取消，互不关联
 */
- (BOOL)menu:(WMZDropDownMenu *)menu dropIndexPathConnectInSection:(NSInteger)section{
    return NO;
}
/*
 *更改选中后的标题
 @param currentTitle 为当前的标题 返回nil 表示用默认的标题
 @param selectBtn 为当前的标题按钮
 @return 可传字符串(更改的字符串标题)
 可传字典(标题和标题颜色) @{@"name":@"标题",@"selectColor":[UIColor redColor]}
 */
- (nullable id)menu:(WMZDropDownMenu *)menu changeTitle:(NSString*)currentTitle selectBtn:(WMZDropMenuBtn*)selectBtn atDropIndexPath:(WMZDropIndexPath *)dropIndexPath dataIndexPath:(NSInteger)row{
    return @{@"name":currentTitle,@"selectColor":Color_38BlueColor};
}

//动态高度
//如果距离不对 可以自行修改此处
- (CGFloat)popFrameY{


//   CGRect rect = [self.tableView convertRect:[self.tableView rectForHeaderInSection:0] toView:[self.tableView superview]];
//   rect.origin.y+= (self.tableView.superview.frame.origin.y);
//   return CGRectGetMaxY(rect);

//    CGRect rect = [self.tableView convertRect:[self.tableView rectForHeaderInSection:0] toView:[self.tableView superview]];
//    NSLog(@"\n LifeCostPaymentDetailsListVC____ rect=%@ ", NSStringFromCGRect(rect));
//    rect.origin.y+= (self.tableView.superview.frame.origin.y);
//    NSLog(@"\n LifeCostPaymentDetailsListVC____ rectyyyyyyyychange=%@ ", NSStringFromCGRect(rect));//rectyyyyyyyychange={{0, 50}, {414, 10}}
    CGFloat fy = SaiXuanHeaderView_H+kNavBarHeight + 50-10;//间距10
    return fy;
}



/**      ___________________________     */
//
//- (void)initBuniessShopAndHouseShaiXuanChooseMenu{
//
//    //    UIColor *collviewBgColor = [UIColor whiteColor];
//    UIColor *topTitleBgColor =  [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
//    UIColor *bomListTableViewBgColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
//    UIColor *collViewCellNomalBgColor = [ [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor colorWithAlphaComponent:0.7];
//    UIColor *collViewCellSelectedBgColor = Color_38BlueColor;
//
//    self.param =
//    MenuParam()
//    .wMainRadiusSet(0)
//    .wMaxHeightScaleSet(0.8)
//    .wReginerCollectionCellsSet(@[@"DemoOneCell"])
//    .wCollectionViewCellSelectTitleColorSet(MenuColor(0xffffff))
//    .wCollectionViewSectionShowExpandCountSet(10000)
//    .wMenuTitleEqualCountSet(4)
//    .wDefaultConfirmHeightSet(50)
//    .wCollectionViewCellSelectBgColorSet(MenuColor(0xff2448));
//
//    self.menu = [[WMZDropDownMenu alloc]initWithFrame:CGRectMake(0, 0, Screen_W, SaiXuanHeaderView_H) withParam:self.param];
//    self.menu.titleView.backgroundColor =  topTitleBgColor;
//    self.menu.backgroundColor   = topTitleBgColor;
//    self.menu.delegate = self;
//    [self addSubview:self.menu];
//}
//
//
//- (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu{
//    return @[
//         @"全部",
//         @{@"name":@"合/整租"},
//         @{@"name":@"租金"},
//
//    ];
//}
//
//
//- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
//  if (section == 1){
//        return 1;
//    }else if (section == 2){
//        return 1;
//    }
//    return 0;
//}
//
//- (NSArray *)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
//   if (dropIndexPath.section == 1) {
//        return @[@"整租",@"合租"];
//    }else if (dropIndexPath.section == 2) {
//        if (dropIndexPath.row == 0) {
//             return @[@"不限",@"2000以下",@"2000-3000",@"2000-300000"];
//        }
//        return @[];
////        return @[@{@"config":@{@"lowPlaceholder":@"输入最低价",@"highPlaceholder":@"输入最高价",}}];
//    }
//    return @[];
//}
//
//
//
//- (NSInteger)menu:(WMZDropDownMenu *)menu countForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
//   if (dropIndexPath.section == 1) {
//        return 2;
//    }else if (dropIndexPath.section == 2) {
//        if (dropIndexPath.row == 0) {
//            return 1;
//        }
//        return 1;
//    }
//    return 0;
//}
//
//- (CGFloat)menu:(WMZDropDownMenu *)menu heightForHeadViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
//     if (dropIndexPath.section == 1) {
//        return 20;
//    }
//    return 0;
//}
//
//- (CGFloat)menu:(WMZDropDownMenu *)menu heightForFootViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
//    if (dropIndexPath.section == 1) {
//        return 20;
//    }
//    return 10;
//}
//- (MenuUIStyle)menu:(WMZDropDownMenu *)menu uiStyleForRowIndexPath:(WMZDropIndexPath *)dropIndexPath{
////    if (dropIndexPath.section == 0) {
////        return MenuUINone;
////    }else if (dropIndexPath.section == 2) {
////    }
////    return MenuUICollectionView;
//    if (dropIndexPath.section == 0) {
//        return MenuUINone;
//    }else if (dropIndexPath.section == 2) {
//        if (dropIndexPath.row == 1) {
//            return MenuUICollectionRangeTextField;//********************************
//        }else{
//
//        }
//    }
//    return MenuUICollectionView;//******************************** 自带的footer
//}
////
////- (UICollectionViewCell*)menu:(WMZDropDownMenu *)menu cellForUICollectionView:(WMZDropCollectionView*)collectionView
////              AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath AtIndexPath:(NSIndexPath*)indexpath dataForIndexPath:(WMZDropTree*)model{
////    if (dropIndexPath.section == 2&&dropIndexPath.row == 0) {
////         DemoOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DemoOneCell" forIndexPath:indexpath];
////         cell.textLa.text = model.name;
////         cell.textLa.textColor = model.isSelected?MenuColor(0xff2448):MenuColor(0x333333);
////        return cell;
////    }
////    return nil;
////}
//
//
//- (BOOL)menu:(WMZDropDownMenu *)menu closeWithTapAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
//    return NO;
//}
//- (MenuEditStyle)menu:(WMZDropDownMenu *)menu editStyleForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
//    return MenuEditOneCheck;
//}
//- (MenuHideAnimalStyle)menu:(WMZDropDownMenu *)menu hideAnimalStyleForRowInSection:(NSInteger)section{
//    return MenuHideAnimalTop;
//}
//
//- (MenuShowAnimalStyle)menu:(WMZDropDownMenu *)menu showAnimalStyleForRowInSection:(NSInteger)section{
//    return MenuShowAnimalBottom;
//}
//
//- (void)menu:(WMZDropDownMenu *)menu customDefauultCollectionFootView:(WMZDropConfirmView *)confirmView{
//    confirmView.showBorder = YES;
//    confirmView.resetBtn.backgroundColor = MenuColor(0xfcfdfd);
//    [confirmView.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
//    confirmView.confirmBtn.backgroundColor = MenuColor(0xff2448);
//    [confirmView.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//}
//- (NSDictionary *)menu:(WMZDropDownMenu *)menu customTitleInSection:(NSInteger)section withTitleBtn:(WMZDropMenuBtn *)menuBtn{
//    menuBtn.layer.borderWidth = MenuK1px;
//    menuBtn.layer.borderColor = MenuColor(0x999999).CGColor;
//    menuBtn.layer.cornerRadius = 20;
//    menuBtn.layer.masksToBounds = YES;
//    return @{@"offset":@(15),@"y":@(12)};
//}
//- (void)menu:(WMZDropDownMenu *)menu didSelectTitleInSection:(NSInteger)section btn:(WMZDropMenuBtn *)selectBtn{
//
//    [menu.titleBtnArr enumerateObjectsUsingBlock:^(WMZDropMenuBtn*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (selectBtn == obj) {
//            obj.backgroundColor = MenuColor(0xff2448);
//        }else{
//            obj.backgroundColor = MenuColor(0xfffeff);
//        }
//        if ([obj isSelected]) {
//            if (idx == 0 && selectBtn != obj) {
//                 [obj setTitleColor:MenuColor(0x333333) forState:UIControlStateSelected];
//            }else{
//                 [obj setTitleColor:MenuColor(0xFFFFFF) forState:UIControlStateSelected];
//            }
//        }else{
//            [obj setTitleColor:MenuColor(0x333333) forState:UIControlStateNormal];
//        }
//    }];
//}
//
//
////隐藏默认底部示例
////- (UIView *)menu:(WMZDropDownMenu *)menu userInteractionFootViewInSection:(NSInteger)section{
////    if (section == 1) return [UIView new];//隐藏第一section的地步footer
////    return nil;
////}
//
@end

 
