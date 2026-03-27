//
//  HouseRepairOldInputLookDetailVC.m
//  Community
//
//  Created by 余莹 on 2022/3/4.
//

#import "HouseRepairOldInputLookDetailVC.h"
#import "ZYReportAboutRepairApplyVoiceCell.h"
static NSString * const ZYReportAboutRepairApplyVoiceCellID = @"ZYReportAboutRepairApplyVoiceCell";

 
#define URL_Repair_Detail             @"proprietor/repair/getRepairById"
#define ReqData_SubListKeyStr         @"records"

//section
static NSInteger const top_Section_Num = 0;
static NSInteger const inuputInfo_Section_Num = 1;
static NSInteger const userInfo_Section_Num = 2;
static NSInteger const deallInfo_Section_Num = 3;

//上报内容
static NSInteger upInfoTitle_Top_Row_Cell = 0;
static NSInteger upInfoTitle_Img_Row_Cell = 3;
static NSInteger inuputInfoDetail_Text_Row_Cell = 1;
static NSInteger inuputInfoDetail_Voice_Row_Cell = 2;
static NSInteger inuputInfoDetail_Img_Row_Cell = 4;
//处理结果
static NSInteger dealInfoTitle_Top_Row_Cell = 0;
static NSInteger dealInfoDetail_Text_Row_Cell = 1;
static NSInteger dealInfoDetail_Img_Row_Cell = 2;

#define Height_TopCell              (44.0)
#define Height_TitleCell            (40.0)
#define Height_OneNumLineTextCell   (35.0)
#define Height_ImgsCell             (100.0)
#define Height_VoiceCell            (68.0)



 
@interface HouseRepairOldInputLookDetailVC () <UIScrollViewDelegate,ZYReportAboutRepairApplyVoiceCellDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) NSArray *showUpUserInfoTitleArr;
@property (nonatomic,strong) NSMutableArray *showUpUserInfoCountArr;

@property (nonatomic,strong)  HouseRepairPageDetailModel *detailModel;
// 上传数据model ｜ 本处为语音专用model
@property (nonatomic, strong) ZYReportAboutRepairApplyUploadModel *voiceUseModel;
@end
 
@implementation HouseRepairOldInputLookDetailVC

- (HouseRepairPageDetailModel *)detailModel{
    if (!_detailModel) {
        _detailModel = [[HouseRepairPageDetailModel alloc]init];
    }
    return _detailModel;
}
- (ZYReportAboutRepairApplyUploadModel *)voiceUseModel{
    if (!_voiceUseModel) {
        _voiceUseModel = [[ZYReportAboutRepairApplyUploadModel alloc]init];
    }
    return _voiceUseModel;
}
- (NSArray *)showUpUserInfoTitleArr{
    if (!_showUpUserInfoTitleArr) {
        _showUpUserInfoTitleArr = @[@"姓  名：",@"手  机：",@"住  址：",@"时  间："];
    }
    return _showUpUserInfoTitleArr;
}
 
- (BaseTableViewFooterView *)footerView{
   if (!_footerView) {
       _footerView = [[HouseRepairListVcFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 90)];
       [_footerView.footerBtn setTitle:@"取消上报" forState:UIControlStateNormal];
       [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
   }
   return _footerView;
}
- (void)footerBtnAction{
    DLog(@"取消上报");
    [self removeThisRepair];
}
#pragma mark  ====
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上报信息";
    [self initView];
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self changeNavBackColorWithDDndWIsGW];

}
 
- (void)initView{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HouseRepairOldInputLookDetailShowContentTextTableViewCell class] forCellReuseIdentifier:HouseRepairOldInputLookDetailShowContentTextTableViewCell_I];
    [self.tableView registerNib:[UINib nibWithNibName:ZYReportAboutRepairApplyVoiceCellID bundle:nil] forCellReuseIdentifier:ZYReportAboutRepairApplyVoiceCellID];//语音更换

    if (self.model.status==0) {
        self.tableView.tableFooterView = self.footerView;
    }else{
        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 20)];
    }
}
- (void)initData{
    [self thisRepairdetailData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.model.status==2) {//已完成
        return 4;
    }else{
        return 3;
    }
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case top_Section_Num:
            return 2;
            break;
        case inuputInfo_Section_Num:
            return 5;
            break;
        case userInfo_Section_Num:
            return self.showUpUserInfoCountArr.count;
            break;
        case deallInfo_Section_Num:
            return 3;
            break;
            
        default:
            return 0;
            break;
    }
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{//提交与处理组的row数量不变 数据决定本cell高度
    switch (indexPath.section) {
        case top_Section_Num:
            return Height_TopCell;
            break;
        case inuputInfo_Section_Num:
        {
            if (indexPath.row == inuputInfoDetail_Text_Row_Cell ){
                return [tableView fd_heightForCellWithIdentifier:HouseRepairOldInputLookDetailShowContentTextTableViewCell_I cacheByIndexPath:indexPath configuration:^(HouseRepairOldInputLookDetailShowContentTextTableViewCell * cell) {
                    [cell fillContentStr:self.detailModel.problem];
                }];
                
            }else if (indexPath.row == inuputInfoDetail_Voice_Row_Cell ){
                return  (self.detailModel.voiceLength <= 0) ? 1 : Height_VoiceCell;
                
            }else if (indexPath.row == inuputInfoDetail_Img_Row_Cell ){
                return  (self.detailModel.inupImgArrs.count <= 0) ? 8.0 : Height_ImgsCell;////给底部cell一个能做圆角的最小高度
       
            }else if (indexPath.row == upInfoTitle_Img_Row_Cell){//“图片照片”
                return  (self.detailModel.inupImgArrs.count <= 0) ? 1 : Height_TitleCell;
                  
            }else{//upInfoTitle_Top_Row_Cell “上报内容”
                return Height_TitleCell;
            }
        }
            break;
        case userInfo_Section_Num:
            return Height_OneNumLineTextCell;
            break;
        case deallInfo_Section_Num:
        {
            if (indexPath.row == dealInfoDetail_Text_Row_Cell ){
                return [tableView fd_heightForCellWithIdentifier:HouseRepairOldInputLookDetailShowContentTextTableViewCell_I cacheByIndexPath:indexPath configuration:^(HouseRepairOldInputLookDetailShowContentTextTableViewCell * cell) {
                    [cell fillContentStr:self.detailModel.orderResult];
                }];
            }else if (indexPath.row == dealInfoDetail_Img_Row_Cell ){
                return  (self.detailModel.dealImgArrs.count <= 0) ? 8.0 : Height_ImgsCell;////给底部cell一个能做圆角的最小高度
             }else{
                return Height_TitleCell;
            }
        }
            break;
            
        default:
            return 0;
            break;
    }
 
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     
    if (indexPath.section == top_Section_Num) {
        HouseRepairOldInputLookDetailTopShowTextAndStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRepairOldInputLookDetailTopShowTextAndStatusTableViewCell_I];
        if (!cell) {
            cell = [[HouseRepairOldInputLookDetailTopShowTextAndStatusTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRepairOldInputLookDetailTopShowTextAndStatusTableViewCell_I];
        }
        if (indexPath.row == 0) {
            [cell fillDataIsShowStatusBool:YES withListModel:self.model];
        }else{
            [cell fillDataIsShowStatusBool:NO withListModel:self.model];
        }

        return cell;
        
    }else if (indexPath.section == inuputInfo_Section_Num){//上报内容（文本语音图片）
       if (indexPath.row == inuputInfoDetail_Text_Row_Cell){//文本
           return [self tableView:tableView contentCellForRowAtIndexPath:indexPath withContentStr: self.detailModel.problem];
           
        }else if (indexPath.row == inuputInfoDetail_Voice_Row_Cell){//语音
            
            if (self.detailModel.voiceLength <= 0) {//旧cell当作无语音时的占位cell | zyVoiceCell 为正常播放cell
                HouseRepairOldInputLookDetailVoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRepairOldInputLookDetailVoiceTableViewCell_I];
                if (!cell) {
                    cell = [[HouseRepairOldInputLookDetailVoiceTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRepairOldInputLookDetailVoiceTableViewCell_I];
                }
                [cell fillVoiceLengthWithInt:self.detailModel.voiceLength];
                cell.touchVoiceBlock = ^{
                };
                return cell;
            }else{
                ZYReportAboutRepairApplyVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYReportAboutRepairApplyVoiceCellID forIndexPath:indexPath];
                cell.delegate = self;
                WEAKSELF
                cell.voicePlayCompleteBlock = ^(ZYReportAboutRepairApplyUploadModel * _Nonnull model) {
                    if (weakSelf.voiceUseModel == model) {
                        weakSelf.voiceUseModel.isPlay = NO;
                    }
                };
                cell.model = weakSelf.voiceUseModel;//model要的是地址和长度 当前播放状态由cellBlock定
                [cell isUseOnDetailVc];
                return cell;
            }

        }else if (indexPath.row == ([tableView numberOfRowsInSection:inuputInfo_Section_Num] - 1)){//图片
            return [self tableView:tableView imgsCellForRowAtIndexPath:indexPath withimgsArr:self.detailModel.inupImgArrs] ;
            
        }else{//子标题
            NSString * willTitleStr =  (indexPath.row == upInfoTitle_Top_Row_Cell) ? @"上报内容" : @"图片照片";
            return [self tableView:tableView titleCellForRowAtIndexPath:indexPath withTitleStr:willTitleStr];
        }
        
    }else if (indexPath.section == userInfo_Section_Num){//用户信息
        HouseRepairOldInputLookDetailBaseShowTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRepairOldInputLookDetailBaseShowTextTableViewCell_I];
        if (!cell) {
            cell = [[HouseRepairOldInputLookDetailBaseShowTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRepairOldInputLookDetailBaseShowTextTableViewCell_I];
        }
        cell.titleL.text = [NSString stringWithFormat:@"%@%@",self.showUpUserInfoTitleArr[indexPath.row], self.showUpUserInfoCountArr[indexPath.row]];
        return cell;
    }else{//处理结果
        
       if (indexPath.row == dealInfoDetail_Text_Row_Cell ){//文本
            return [self tableView:tableView contentCellForRowAtIndexPath:indexPath withContentStr: self.detailModel.orderResult ];
           
        }else if (indexPath.row == dealInfoDetail_Img_Row_Cell ){
            return [self tableView:tableView imgsCellForRowAtIndexPath:indexPath withimgsArr:self.detailModel.dealImgArrs] ;
        }else{//dealInfoTitle_Top_Row_Cell
            return [self tableView:tableView titleCellForRowAtIndexPath:indexPath withTitleStr:@"处理结果"];

        }
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView imgsCellForRowAtIndexPath:(NSIndexPath *)indexPath withimgsArr:(NSArray *)imgsArr{
    HouseRepairOldInputLookDetailShowImgsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRepairOldInputLookDetailShowImgsTableViewCell_I];
    if (!cell) {
        cell = [[HouseRepairOldInputLookDetailShowImgsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRepairOldInputLookDetailShowImgsTableViewCell_I];
    }
    [cell fillDataWithImgsArr:imgsArr];
    WEAKSELF
    cell.touchImgBlock = ^(NSInteger index) {
        [weakSelf showBigImgWithSectionNum:indexPath.section withImgIndex:index];
    };
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView contentCellForRowAtIndexPath:(NSIndexPath *)indexPath withContentStr:(NSString *)contentStr  {
    HouseRepairOldInputLookDetailShowContentTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRepairOldInputLookDetailShowContentTextTableViewCell_I];
    if (!cell) {
        cell = [[HouseRepairOldInputLookDetailShowContentTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRepairOldInputLookDetailShowContentTextTableViewCell_I];
    }
    [cell fillContentStr:contentStr];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView titleCellForRowAtIndexPath:(NSIndexPath *)indexPath withTitleStr:(NSString *)titleStr {
    HouseRepairOldInputLookDetailBaseShowTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRepairOldInputLookDetailBaseShowTitleTableViewCell_I];
    if (!cell) {
        cell = [[HouseRepairOldInputLookDetailBaseShowTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRepairOldInputLookDetailBaseShowTitleTableViewCell_I];
    }
    cell.titleL.text = titleStr;
    return cell;
}
 

#pragma mark ===
 
  #pragma mark === 组圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat cornerRadius = 7.5f;
    UIColor *sectionFillColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    //UIColor *separatoColor = Y_ColorWith16FromRGB(0xF0F1F6);
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
            CALayer *lineLayer = [[CALayer alloc] init];// CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);//过小
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-1.0, bounds.size.width-20, 1.0);
            //
            [layer addSublayer:lineLayer];
            lineLayer.backgroundColor = [UIColor clearColor].CGColor;
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}
 

#pragma mark ==

- (void)showBigImgWithSectionNum:(NSInteger)sectionNum withImgIndex:(NSInteger)imgIndex{
    NSString *willShowBigImgS = @"";
    if (sectionNum == inuputInfo_Section_Num) {
        willShowBigImgS =  self.detailModel.inupImgArrs[imgIndex];
    }
    if (sectionNum == deallInfo_Section_Num) {
        willShowBigImgS =  self.detailModel.dealImgArrs[imgIndex];
    }
    if (willShowBigImgS.length==0) {
        return;
    }
    [self imgBigWithImgUrlStr:willShowBigImgS];
}

#pragma mark == 图片放大
- (void)imgBigWithImgUrlStr:(NSString *)imgUrlStr{
    
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.maximumZoomScale=5.0;//图片的放大倍数
    _scrollView.minimumZoomScale=1.0;//图片的最小倍率
    _scrollView.contentSize=CGSizeMake(self.view.bounds.size.width*1.5, self.view.bounds.size.height*1.5);//可以左右滑
//    _scrollView.contentSize=CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);//禁止左右滑
    _scrollView.delegate=self;
    _scrollView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];

    _imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    _imageView.center = CGPointMake(self.view.center.x, self.view.center.y-KNavBarHeight);
    [_imageView sd_setImageWithURL: [UrlWithString getURLWithStr:imgUrlStr] placeholderImage:[UIImage imageNamed:@"Repair_picture_icon"]];
    [_scrollView addSubview:_imageView];
    [self.view addSubview:_scrollView];
    _imageView.userInteractionEnabled=YES;//注意:imageView默认是不可以交互,在这里设置为可以交互
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    tap.numberOfTapsRequired=1;//单击
    tap.numberOfTouchesRequired=1;//单点触碰
    [_imageView addGestureRecognizer:tap];
    UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired=2;//避免单击与双击冲突
    [tap requireGestureRecognizerToFail:doubleTap];
    [_imageView addGestureRecognizer:doubleTap];
    _imageView.contentMode=UIViewContentModeScaleAspectFit;
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView  //委托方法,必须设置  delegate
{
    return _imageView;//要放大的视图
}

-(void)doubleTap:(id)sender
{
    _scrollView.zoomScale=2.0;//双击放大到两倍
}
- (void)tapImage:(id)sender
{
//    [self dismissViewControllerAnimated:YES completion:nil];//单击图像,关闭图片详情(当前图片页面)
    [_scrollView removeFromSuperview];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan-----------------------------------------");
}

#pragma mark == 图片放大 end

#pragma mark == 本次报修详情 （列表和详情同接口结构）
- (void)thisRepairdetailData{
    NSDictionary *parms = @{
        @"id":@(self.model.ID),
    };
    WEAKSELF
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Repair_Detail withParams:parms.mutableCopy finished:^(id responsObject, NSError *error) {
        
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSMutableDictionary *getDic = Y_ResponsObject_dataDic;
                NSMutableArray *getArr =    ( [[getDic allKeys] containsObject:ReqData_SubListKeyStr]  \
                                             && isNotNil([getDic objectForKey:ReqData_SubListKeyStr]) ) \
                                             ? [getDic objectForKey:ReqData_SubListKeyStr] : [NSMutableArray array];
                if (getArr.count>0) {
                    weakSelf.detailModel = [HouseRepairPageDetailModel mj_objectWithKeyValues:getArr.firstObject];
                    //图片
                    weakSelf.detailModel.inupImgArrs =  weakSelf.detailModel.repairImgs;
                    weakSelf.detailModel.dealImgArrs = [weakSelf.detailModel.repairedImg componentsSeparatedByString:@";"];//维修后照片
                  
                    //提交人信息
                    NSString *inputUserName = [TextShowWithModelStr textShowWithModelStr:self.detailModel.name];
                    NSString *inputUserPhone = [TextShowWithModelStr textShowWithModelStr:self.detailModel.phone];
                    NSString *inputUserAddress = [TextShowWithModelStr textShowWithModelStr:self.detailModel.address];
                    NSString *inputUserTime = [TextShowWithModelStr textShowWithModelStr:self.detailModel.orderTime];
                    weakSelf.showUpUserInfoCountArr = @[inputUserName,inputUserPhone,inputUserAddress,inputUserTime].mutableCopy;
                    
                    //语音专用部分
                    weakSelf.voiceUseModel.isPlay = NO;
                    weakSelf.voiceUseModel.voiceUrl =  self.detailModel.voiceUrl;
                    weakSelf.voiceUseModel.voiceLength =  self.detailModel.voiceLength;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tableView reloadData];
                    });
                }
                }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
        
    }];
}
#pragma mark == 取消本次报修(旧版本同一个接口)
- (void)removeThisRepair{
    //取消
    NSLog(@"取消");
    WEAKSELF
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Post_House_Repari_cancelRepair withParams:@{@"id":@(self.detailModel.ID)}.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                Y_SVP_SHOW_SUCCESS_MES(@"已申请取消本次报修");
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isNotNil(weakSelf.detailVcCancelOneUpInfo)) {
                        weakSelf.detailVcCancelOneUpInfo();
                    }
                    [weakSelf  popVC];
                    
                });
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}


#pragma mark ==  语音播放 |  停止
#pragma mark - ZYReportAboutRepairApplyVoiceCellDelegate
// 播放
- (void)playButtonEvent {
    NSLog(@"播放语音");
    [self.view endEditing:YES];
    
    if (self.voiceUseModel.isPlay) {
        self.voiceUseModel.isPlay = NO;
        [self stopVoicePlayer];
    }else {
        self.voiceUseModel.isPlay = YES;
        [self playVoice];
    }
    [self.tableView reloadData];
}

// 播放录音
- (void)playVoice {
    [[LGAudioPlayer sharePlayer] playAudioWithNotIndexURLString:ReportLocation_Voice_RecordFileUrl_Str];
}

// 暂停播放
- (void)stopVoicePlayer {
    [[LGAudioPlayer sharePlayer] stopAudioPlayer];
}


@end
