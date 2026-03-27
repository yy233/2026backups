//
//  HouseRepairEditVC.m
//  Community
//
//  Created by 余莹 on 2020/12/25.
//

#import "HouseRepairEditVC.h"
#import "HouseRepairEditVCTopView.h"
#import "HouseRepairEditVCBottomView.h"
#import "HouseRepairEditVCFooterView.h"
#import "HouseRepariEditVcToChooseHouseVc.h"
//
#import "PopViewWithChooseUserCommunityList.h"
#import "PopViewWithChooseUserHouseList.h"
//
#define Notice_name_AddressAllInfoPost @"noticeActionWithDetailedAddressInfo"


@interface HouseRepairEditVC () <HouseRepairEditVCTopViewDelegate,HouseRepairEditVCBottomViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PopViewWithChooseUserCommunityListDelegate>

@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) UIView  *mainBackView;

@property (nonatomic,strong) HouseRepairEditVCTopView *topView;
@property (nonatomic,strong) HouseRepairEditVCBottomView *bottomView;
@property (nonatomic,strong) HouseRepairEditVCFooterView *footerView;

@property (nonatomic,strong) NSMutableArray *arrOfSaveType;
@property (nonatomic,assign) NSInteger nowSendCommnuitId;
@property (nonatomic,strong) NSString *nowSendAddressStr;
@property (nonatomic,strong) NSString *nowSendPublicTypeDetailAddressStr;
@property (nonatomic,strong) NSMutableArray *arrOfSaveImgUrl;
@property (nonatomic,assign) NSInteger nowImgDealNum;//123 4是新增
@property (nonatomic,assign) Repair_Type_PersonalOrPublic repairType; //个人报修0 公共报修1
//房屋地址
@property (nonatomic,strong) PopViewWithChooseUserCommunityList *popViewCommunityList;
@property (nonatomic,strong) PopViewWithChooseUserHouseList *popViewHouseList;

@end

@implementation HouseRepairEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initNotice];
    [self initView];
    [self initData];
}
- (void)initView{
    self.title = @"房屋报修";
    [self.view addSubview:self.scrollview];
    [_scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollview.superview);
    }];
    [self.scrollview addSubview:self.mainBackView];
    [_mainBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(_mainBackView.superview);
        make.width.equalTo(_mainBackView.superview);
    }];
    //
    [self.mainBackView addSubview:self.topView];
    [self.mainBackView addSubview:self.bottomView];
    [self.mainBackView addSubview:self.footerView];
    [self setUI];
}
#pragma mark ==  报修事项list 由 类别而定
- (void)initData{
    Y_SVP_SHOW_MES_IsLoading_15Delay
    self.arrOfSaveType = [[NSMutableArray alloc]init];
    [HouseRepairTypeViewModel  getTypeListWithRepairType:self.repairType withListBlock:^(NSArray * arr, BOOL success) {
        if (success) {
            self.arrOfSaveType = [NSMutableArray arrayWithArray:[HouseRepairTypeModel mj_objectArrayWithKeyValuesArray:arr]];
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_DISMISS
                self.topView.typeArr =  self.arrOfSaveType;
            });
        }else{
        }
    }];
}
 
#pragma mark ==
- (void)popViewChooseCommunityOrHouseListCellWithPopType:(RepairHousesPopView_Type)type withCellData:(NSDictionary *)dic{
    if (type == RepairHousesPopView_Type_House) {
        DLog(@" 房屋   %@",dic);
        //communityName addresss
        [self.topView setAddressShowStr:[NSString stringWithFormat:@"%@ %@",dic[@"communityName"],dic[@"address"]]];
        self.nowSendAddressStr = [NSString stringWithFormat:@"%@ %@",dic[@"communityName"],dic[@"address"]];
        self.nowSendCommnuitId = [dic[@"communityId"] integerValue];
    }
    if (type ==  RepairHousesPopView_Type_Community) {
        DLog(@" 社区  %@",dic);
        [self.topView setAddressShowStr:dic[@"name"]];//小区名显示
        //
        self.nowSendAddressStr = dic[@"name"];
        self.nowSendCommnuitId = [dic[@"id"] integerValue];
    }
}

- (void)changRepairType:(Repair_Type_PersonalOrPublic)type{
    self.repairType = type;
    [self initData];
    //
    self.topView.model = [[HouseRepairEditModel alloc]init];//清空之前的数据
    [self changUI];
    
}

#pragma mark ==
- (void)popViewChooseCommunityArrIndex:(NSInteger)index{
    DLog(@"");
    
}

- (void)popViewChooseHouseListIndex:(NSInteger)index{
    DLog(@"");
}
#pragma mark ==
//- (void)okBtnAction:(UIButton *)sender{
//    [self allImgSend];
//}

- (void)okBtnAction:(UIButton *)sender{
    NSLog(@"okBtnAction");
    HouseRepairEditModel *willSendmodel = [[HouseRepairEditModel alloc]init];
    willSendmodel.repairType = self.repairType;
    willSendmodel.name = self.topView.model.name;
    willSendmodel.phone = self.topView.model.phone;
    willSendmodel.problem = self.bottomView.textView.text.length>0 ? self.bottomView.textView.text : @"";
    
    if (self.repairType == Repair_Type_PersonalOrPublic_Public) {
        self.nowSendPublicTypeDetailAddressStr = self.topView.model.detailAddress;//公共报修情况下的详细地址
        willSendmodel.address = [[TextShowWithModelStr textShowWithModelStr:self.nowSendAddressStr] stringByAppendingString: [TextShowWithModelStr textShowWithModelStr:self.nowSendPublicTypeDetailAddressStr]];
        willSendmodel.communityId = self.nowSendCommnuitId;//id
    }else{
        willSendmodel.address = self.nowSendAddressStr;
        willSendmodel.communityId = self.nowSendCommnuitId;//id
    }

    if ( willSendmodel.problem.length>200) {
        Y_SVP_SHOW_INFO_MES(@"当前文本限制200");
        return;
    }
    if (willSendmodel.name.length==0) {
        Y_SVP_SHOW_ERR_MES(@"请输入姓名！");
        return;
    }
    if (willSendmodel.phone.length==0) {
        Y_SVP_SHOW_ERR_MES(@"请输入电话！");
        return;
    }

    if (willSendmodel.communityId==0) {
        Y_SVP_SHOW_ERR_MES(@"请选择报修房屋！");
        return;
    }
    //类型
    if (self.topView.arrOfTypeSelected.count>0) {
        NSInteger index =[self.topView.arrOfTypeSelected indexOfObject:@(1)];
        if (index != NSNotFound) {
            HouseRepairTypeModel *typeModel = self.arrOfSaveType[index];
            willSendmodel.type = typeModel.id;
            willSendmodel.typeName = typeModel.constName;
        }else{
            Y_SVP_SHOW_ERR_MES(@"请选择报修类型！");
            return;
        }
    }else{
        Y_SVP_SHOW_SUCCESS_MES(@"报修类型选择失败");
    }
    //图URL数据

    if (self.arrOfSaveImgUrl.count>0) {
        willSendmodel.repairImg = [NSString stringWithFormat:@"%@",[self.arrOfSaveImgUrl componentsJoinedByString:@";"]];
    }else{
        willSendmodel.repairImg = @"";
    }
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]initWithDictionary:[NSDictionary dictionaryWithDictionary:[willSendmodel mj_keyValuesWithKeys:@[@"name",@"phone",@"problem",@"repairImg",@"address",@"typeName"]]]];
    [parm setValue:@(self.nowSendCommnuitId) forKey:@"communityId"];
    [parm setValue:@(willSendmodel.type) forKey:@"type"];
    [parm setValue:@(self.repairType) forKey:@"repairType"];
    WEAKSELF
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_Post_House_Repari_Add withParams:parm finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_SUCCESS_MES(@"已发起报修");
                    [weakSelf popVC];
                });
               
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];

}
#pragma mark ==
- (void)touchUpToChooseHousel{
    NSLog(@"选房屋");
    WEAKSELF
    if (self.repairType == Repair_Type_PersonalOrPublic_Person) {//个人报修
        
        [UserHouseOrCommunityListModel getUserAllHouseListWithBlock:^(NSArray * arr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.popViewHouseList showInViewWithPopType:RepairHousesPopView_Type_House withListArray:arr.mutableCopy];
            });
        }];
    }else{//公共
//        getUerAllCommunityListWithBlock//作为业主租客家属身份的总小区信息
//        getUerAllCommunityListWhenMyRightIsYeZhuWithBlock//只是作为业主身份所拥有的小区列表
        [UserHouseOrCommunityListModel getUerAllCommunityListWithBlock:^(NSArray * arr, BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(success){
                    [weakSelf.popViewHouseList showInViewWithPopType:RepairHousesPopView_Type_Community withListArray:arr.mutableCopy];
                }
            });
           
        }];
    }
    //getUerAllCommunityListWithBlock
  
    
//    HouseRepariEditVcToChooseHouseVc *vc = [[HouseRepariEditVcToChooseHouseVc alloc]init];
//    [self pushVc:vc];
}
#pragma mark ===
- (void)chooseBtnIsTouchWitllToChoose{
    NSLog(@"去图库");
    NSInteger count = self.arrOfSaveImgUrl.count;
    if (count>=3) {
        Y_SVP_SHOW_ERR_MES(@"当前仅支持3张图");
        return;
    }else{
//        self.nowImgDealNum = self.arrOfSaveImgUrl.count;//012 新增
        self.nowImgDealNum = 4;
    }
    [self iconImgTap];
 
}
- (void)changeImgWithTouchImgBtnWithNum:(NSInteger)imgNum{//012
    NSLog(@"换图");
    self.nowImgDealNum = imgNum;//012
    [self iconImgTap];

}
#pragma mark == img pick
- (void)iconImgTap{
    DLog(@"");
        //非处理状态
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        __weak typeof(self) weakSelf = self;
        UIAlertAction *photographAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //图片拍照
            [weakSelf chooseImageWithType:Photo_Choose_Type_Grapht];
        }];
        UIAlertAction *photoalbumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //图片相册选择
            [weakSelf chooseImageWithType:Photo_Choose_Type_Album];
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:photographAction];
        [alertVC addAction:photoalbumAction];
        [alertVC addAction:cancleAction];
        alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:alertVC animated:YES completion:nil];
   
}

- (void)chooseImageWithType:(Photo_Choose_Type)type {
   
   UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
   pickVC.delegate = self;
   if (type == Photo_Choose_Type_Grapht) {
       
       pickVC.allowsEditing = NO;
       pickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
   }else {
       
       pickVC.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
   }
   pickVC.modalPresentationStyle = UIModalPresentationFullScreen;
   [self presentViewController:pickVC animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate 图片 回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *photo = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self imgDetalWithPhoto:photo];
}

- (void)imgDetalWithPhoto:(UIImage *)img{
    if (img==nil) {
        return;
    }
    [[ToolOfNetWork sharedTools]YrequestPostHouseRepairOneImageWithURL:URL_Post_House_Repari_Img withParams:@{}.mutableCopy fileData:@[img].mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSString *url = [NSString stringWithFormat:@"%@",[responsObject objectForKey:@"data"]];
                if (url.length>0) {
                  NSString *lastStr = [url substringWithRange:NSMakeRange(url.length-1,1)];
                    if ([lastStr isEqualToString:@";"]) {//分号去除
                       url = [url substringToIndex:url.length - 1];
                    }
                }
                if (self.nowImgDealNum>=4) {//新增
                    NSInteger count = self.arrOfSaveImgUrl.count;
                    if (count<=2) {
                        [self.arrOfSaveImgUrl addObject:url];
                        [self showImgNum:self.arrOfSaveImgUrl.count-1 withImg:img];//012
                    }else{
                        Y_SVP_SHOW_ERR_MES(@"当前仅支持3张图");
                    }
                }else{//换图 012
                    self.arrOfSaveImgUrl[self.nowImgDealNum] = url;
                    [self showImgNum:self.nowImgDealNum  withImg:img];
                }
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
            
    }];
}
- (void)allImgSend{
    /**
     暂不用  只单传*/
//    NSArray *arr = [NSArray arrayWithObjects:self.bottomView.imgOneBtn.imageView.image,self.bottomView.imgTwoBtn.imageView.image,self.bottomView.imgThrBtn.imageView.image, nil];
//    [[ToolOfNetWork sharedTools]YrequestPostHouseRepairOneImageWithURL:URL_Post_House_Repari_Img withParams:@{}.mutableCopy fileData:arr.mutableCopy finished:^(id responsObject, NSError *error) {
//        if (isNotNil(responsObject)) {
//            if (Y_IS_Success) {
//            }else{
//                Y_SVP_SHOW_ERR_MESSAGE
//            }
//        }else{
//            Y_SVP_SHOW_ERR_DESCRIPTION
//        }
//    }];
}
- (void)showImgNum:(NSInteger)num  withImg:(UIImage *)img{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (num) {
            case 0:
                [self.bottomView.imgOneBtn setImage:img forState:UIControlStateNormal];
                break;
            case 1:
                [self.bottomView.imgTwoBtn setImage:img forState:UIControlStateNormal];
                break;
            case 2:
                [self.bottomView.imgThrBtn setImage:img forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        [self.bottomView imgShowNum:self.arrOfSaveImgUrl.count];
    });
    NSLog(@" showImgNum  --- %ld",(long)num);
   
}
#pragma mark == UI
- (void)setUI{
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {//1
        make.top.equalTo(_topView.superview.mas_top).offset(5);
        make.left.equalTo(_topView.superview.mas_left).offset(16);
        make.right.equalTo(_topView.superview.mas_right).offset(-16);
//        make.height.offset(Screen_H*0.5-20);
        make.height.offset(435);
    }];

   
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {//选择图片
        make.top.equalTo(_topView.mas_bottom).offset(10);
        make.left.equalTo(_bottomView.superview.mas_left).offset(16);
        make.right.equalTo(_bottomView.superview.mas_right).offset(-16);
        make.height.offset(255);
    }];
    
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {//提交
        make.height.offset(90);
        make.left.equalTo(_footerView.superview.mas_left).offset(16);
        make.right.equalTo(_footerView.superview.mas_right).offset(-16);
        make.top.equalTo(_bottomView.mas_bottom).offset(10);
    }];
  
    // ____ 设置过渡视图的底边距（此设置将影响到scrollView的contentSize）
    [_mainBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_footerView.mas_bottom).offset(200);
    }];
 
}
- (void)changUI{//顶部多一项
//    [_topView
    if ( self.repairType == Repair_Type_PersonalOrPublic_Person) {
        [self.topView  changeRepairTypePersonalWithChangUI];
    }else{
        [self.topView  changeRepairTypePublicWithChangUI];
    }
  
    
}
#pragma mark == getter
- (UIScrollView *)scrollview{
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc]initWithFrame:self.view.frame];
        _scrollview.scrollEnabled = YES;
       }
    return _scrollview;
}
- (UIView *)mainBackView{
    if (!_mainBackView) {
        _mainBackView = [[UIView alloc]init];
    }
    return _mainBackView;
}
 
- (HouseRepairEditVCTopView *)topView{
    if (!_topView) {
        _topView = [[HouseRepairEditVCTopView alloc]init];
        _topView.layer.cornerRadius = 10;
        _topView.delegate = self;
    }
    return _topView;
}
- (HouseRepairEditVCBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[HouseRepairEditVCBottomView alloc]init];
        _bottomView.layer.cornerRadius = 10;
        _bottomView.delegate = self;
    }
    return _bottomView;
}
 
- (HouseRepairEditVCFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[HouseRepairEditVCFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 80)];
        [_footerView.footerBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_footerView.footerBtn addTarget:self action:@selector(okBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
 
- (NSInteger)nowSendCommnuitId{
    if (!_nowSendCommnuitId) {
        _nowSendCommnuitId = 0;
    }
    return _nowSendCommnuitId;
}
- (NSMutableArray *)arrOfSaveImgUrl{
    if (!_arrOfSaveImgUrl) {
        _arrOfSaveImgUrl = [[NSMutableArray alloc]init];//WithObjects:@"",@"",@"", nil];
    }
    return _arrOfSaveImgUrl;
}
- (NSInteger)nowImgDealNum{
    if (!_nowImgDealNum) {
        _nowImgDealNum = 0;
    }
    return _nowImgDealNum;
}
- (Repair_Type_PersonalOrPublic)RepairType{
    if (!_repairType) {
        _repairType = Repair_Type_PersonalOrPublic_Person;
    }
    return _repairType;
}

#pragma mark ===
- (PopViewWithChooseUserCommunityList *)popViewCommunityList{
    _popViewCommunityList = [[PopViewWithChooseUserCommunityList alloc]init];
    _popViewCommunityList.delegate = self;
    return _popViewCommunityList;
}
- (PopViewWithChooseUserHouseList *)popViewHouseList{
    _popViewHouseList = [[PopViewWithChooseUserHouseList alloc]init];
    _popViewHouseList.delegate = self;
    return _popViewHouseList;
}
@end
