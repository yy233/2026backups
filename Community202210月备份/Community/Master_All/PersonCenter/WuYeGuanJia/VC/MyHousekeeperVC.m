//
//  MyHousekeeper.m
//  Community
//
//  Created by 余莹 on 2021/7/28.
//

#import "MyHousekeeperVC.h"
#import "MyHousekeeperView.h"
#import "MyHousekeeperPicModel.h"
#import "MyHousekeeperViewHaveWebView.h"

@interface MyHousekeeperVC () <MyHousekeeperViewHaveWebViewDelegate>

//@property (nonatomic,strong) MyHousekeeperView *wuyeGuanjiaView;//无部门数据 只显示顶部轮播和文本 //<MyHousekeeperViewDelegate>
@property (nonatomic,strong) MyHousekeeperViewHaveWebView *wuyeGuanjiaView;
@property (nonatomic,strong) MyHousekeeperPicModel *topShowModel;
@property (nonatomic,strong) NSMutableArray *dataSourceArr;

@end

@implementation MyHousekeeperVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物业管家";
    self.topShowModel = [[MyHousekeeperPicModel alloc]init];
    [self initView];
    [self initData];
     
}
- (void)initView{
    [self.view addSubview:self.wuyeGuanjiaView];
}
- (void)initData{
    
    NSInteger communityId = [ShareUserInfo sharedUserInfo].commuityInfo.ID;
    WEAKSELF
    [MainAddressBookViewModel getAddressBookTopShowInfoWithCommunityId:communityId withBlock:^(NSDictionary * dic, BOOL success) {
        STRONGSELF
        if (success) {
            strongSelf.topShowModel = [MyHousekeeperPicModel mj_objectWithKeyValues:dic];
            NSMutableArray *picArr = [[TextShowWithModelStr textShowWithModelStr:strongSelf.topShowModel.picture] componentsSeparatedByString:@","].mutableCopy;
            NSString *nameBeginStr = [NSString stringWithFormat:@"[%@] ",[TextShowWithModelStr textShowWithModelStr:strongSelf.topShowModel.name] ];
            NSString *centetStr = [nameBeginStr  stringByAppendingString: [TextShowWithModelStr textShowWithModelStr:strongSelf.topShowModel.profile]];
 
            dispatch_async(dispatch_get_main_queue(), ^{
//                [strongSelf.wuyeGuanjiaView fillBText:centetStr];
                [strongSelf.wuyeGuanjiaView fillShowWebViewStr:centetStr];
                [strongSelf.wuyeGuanjiaView fillBannerData:picArr];
                //0407换成单个电话 有电话时显示
                [strongSelf.wuyeGuanjiaView fillOnlyPhoneStr: [TextShowWithModelStr textShowWithModelStr:strongSelf.topShowModel.contactsMobile]];
 
            });
        }
    }];
    
    //0407分部门电话数据结构 更换成一个电话
     
    /**
     [MainAddressBookViewModel getAddressBookListArrWithBlock:^(NSMutableArray * arr) {
         STRONGSELF
         strongSelf.dataSourceArr  = [NSMutableArray arrayWithArray:[MainCenterCollectionViewAddressBookCellModel mj_objectArrayWithKeyValuesArray:arr]];
         dispatch_async(dispatch_get_main_queue(), ^{
             [strongSelf.wuyeGuanjiaView fillCellData:self.dataSourceArr];
         });
     }];
     */
    
}

#pragma mark ==
- (MyHousekeeperViewHaveWebView *)wuyeGuanjiaView{
    if (!_wuyeGuanjiaView) {
        _wuyeGuanjiaView = [[MyHousekeeperViewHaveWebView alloc]initWithFrame:self.view.frame];
        _wuyeGuanjiaView.delegate = self;
    }
    return _wuyeGuanjiaView;
}
#pragma mark =
- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc]init];
    }
    return _dataSourceArr;
}
#pragma mark === MyHousekeeperViewDelegate
- (void)touchFooterBtnActionWithCallPhone{
    
    NSString *phoneStr =  [TextShowWithModelStr textShowWithModelStr:self.topShowModel.contactsMobile];
    if (isNil(phoneStr) || phoneStr.length==0) {
        Y_SVP_SHOW_ERR_MES(@"电话号码有误！");
        return;
    }
    [self callPhoneWithStr:phoneStr];
}

- (void)myHousekeeperViewTouchTopSdcyclviewWithIndex:(NSInteger)index{
    
}
- (void)myHousekeeperViewTouchBottomCellWithIndex:(NSInteger)index{
    MainCenterCollectionViewAddressBookCellModel *model =  [MainCenterCollectionViewAddressBookCellModel mj_objectWithKeyValues:self.dataSourceArr[index]];
    
    Y_SVP_SHOW_MES_IsLoading_15Delay
    [MainAddressBookViewModel getAddressBookDetailPhoneArrWithDepartmentId:model.ID detailPhoneblock:^(NSMutableArray * arr) {
        Y_SVP_DISMISS
       
        dispatch_async(dispatch_get_main_queue(), ^{
            if (arr.count>0) {
                [self showPopAerWithDeapartNameStr:[TextShowWithModelStr textShowWithModelStr: model.department]  andPhoneListArr:arr];
//                [self.popViewPhoneBookList showInView:popViewSuperView thePopViewTableViewHeight:200 WithArray:arr withHeaderViewTitle:aepartmentModel.department];
            }else{
                Y_SVP_SHOW_ERR_MES(@"当前部门 暂无电话");
            }
        });
    }];
}
- (void)showPopAerWithDeapartNameStr:(NSString *)deapartNameStr andPhoneListArr:(NSMutableArray *)phoneDataSource{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
 
//    [alertVC setValue:alertControllerStr forKey:@"attributedTitle"];
    //修改message
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:deapartNameStr];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, deapartNameStr.length)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, deapartNameStr.length)];
    [alertVC setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    //
    WEAKSELF
    for (int i = 0; i < phoneDataSource.count; i ++) {
        MainCenterCollectionViewAddressBookCellModel *model =  [MainCenterCollectionViewAddressBookCellModel mj_objectWithKeyValues:phoneDataSource[i]];
      
        NSString *phoneShowStr = [NSString stringWithFormat:@"%@ %@", [TextShowWithModelStr textShowWithModelStr: model.person],[TextShowWithModelStr textShowWithModelStr: model.phone]];
        UIAlertAction *photoInfoAction = [UIAlertAction actionWithTitle:phoneShowStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (isNil(model.phone) || model.phone.length==0) {
                Y_SVP_SHOW_ERR_MES(@"电话号码有误！");
                return;
            }
            [weakSelf callPhoneWithStr:[TextShowWithModelStr textShowWithModelStr: model.phone]];
        }];
        [alertVC addAction:photoInfoAction];
    }
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancleAction];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)callPhoneWithStr:(NSString *)phoneStr{
    NSMutableString *callStr=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneStr];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callStr] options:@{} completionHandler:nil];
}
@end
