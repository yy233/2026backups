//
//  MyCarAddOrEditVC.m
//  Community
//
//  Created by 余莹 on 2021/8/5.
//

#import "MyCarAddOrEditVC.h"
#import "MyCarAddOrEditView.h"
#import "MyCarInfoData.h"
#import "CarPaltWebViewVC.h"

@interface MyCarAddOrEditVC ()
@property (nonatomic,strong) MyCarAddOrEditView *selfTopView;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@end

@implementation MyCarAddOrEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的车辆";
    [self initView];
    if (!_isAddCarBool) {//修改编辑状态
        self.selfTopView.textF.text = self.oldCarPlate;
    }
 
}
- (void)initView{
    [self.view addSubview:self.selfTopView];
    [self.selfTopView.textFTopTuchBtn addTarget:self action:@selector(textFTopTuchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.footerView];
    [_selfTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_selfTopView.superview);
        make.height.equalTo(_selfTopView.superview).multipliedBy(0.5);
    }];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_footerView.superview);
        make.height.offset(90);
        make.bottom.equalTo(_footerView.superview).offset(-20); 
    }];
}

#pragma mark ==
- (MyCarAddOrEditView *)selfTopView{
    if (!_selfTopView) {
        _selfTopView = [[MyCarAddOrEditView alloc]init];
    }
    return _selfTopView;
}
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 120)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"确认"];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView setBtnFram:CGRectMake(0, 0, Screen_W-32, 50)];
        [_footerView.footerBtn newAnBtnWithLayerCorNerNum:20 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
    }
    return _footerView;
}
#pragma mark ===
- (void)footerBtnAction{
    NSLog(@"footerBtnAction    ----   %@",self.selfTopView.textF.text);
    if (self.selfTopView.textF.text.length < 7) {
        Y_SVP_SHOW_ERR_MES(@"请输入正确车牌!");
        return;
    }
    NSMutableDictionary *carInfoDic = [[NSMutableDictionary alloc]init];
    [carInfoDic setValue:self.selfTopView.textF.text forKey:@"carPlate"];
//    [carInfoDic setValue:@(self.nowCommunityId) forKey:@"communityId"];//车辆不做小区限制
    [carInfoDic setValue:@( [ShareUserInfo sharedUserInfo].commuityInfo.ID ) forKey:@"communityId"];//0415增加当前小区ID
    //
    if(!self.isAddCarBool){
        [carInfoDic setValue:self.idStr forKey:@"id"];
        [self upDataCarWithDic:carInfoDic];
    }else{
        [self addCarWithDic:carInfoDic];
    }
}
 
#pragma mark ==
- (void)addCarWithDic:(NSMutableDictionary *)carInfo{
    WEAKSELF
    [MyCarInfoData addMyCarWithCarInfoDic:carInfo withBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf popVC];
            });
        }
    }];
}
- (void)upDataCarWithDic:(NSMutableDictionary *)carInfo{
    WEAKSELF
    [MyCarInfoData editMyCarWithCarInfoDic:carInfo withBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf popVC];
            });
        }
    }];
}


#pragma mark ==
- (void)textFTopTuchBtnAction{
    DLog(@"view  点击tf 跳转去h5 输车牌");

    CarPaltWebViewVC *vc = [[CarPaltWebViewVC alloc]init];
    WEAKSELF
    vc.carPlatBlock = ^(NSString * _Nonnull carPlatStr) {
        STRONGSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.navigationController.navigationBarHidden = NO;
            strongSelf.selfTopView.textF.text = carPlatStr;
        });
    };
    [self pushVc:vc];
}
@end
