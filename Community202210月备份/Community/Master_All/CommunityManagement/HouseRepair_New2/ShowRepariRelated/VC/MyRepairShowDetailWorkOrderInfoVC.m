//
//  MyRepairShowDetailWorkOrderInfoVC.m
//  Community
//
//  Created by 余莹 on 2022/4/11.
// 工单信息 提交的信息详情

#import "MyRepairShowDetailWorkOrderInfoVC.h"
#import "MyRepariHeader.h"
#import "MyRepariShwoDetailUserInfoWithTopUseTextTableViewCel.h"
#import "MyRepariShwoDetailUserInfoWithBottomUseTextTableViewCel.h"
#import "MyRepariShwoDetailUserInfoWithPhoneCallInfoTableViewCel.h"
#import "MyRepariShwoDetailEvaluationStarTableViewCell.h"
#import "HouseRepairOldInputLookDetailShowContentTextTableViewCell.h"//评价文本
 
#import "ZYHouseRepairIssueRecordCell.h"
static NSString * const ZYHouseRepairIssueRecordCellID = @"ZYHouseRepairIssueRecordCell";

//vc
#import "MyRepairEvaluationVC.h"

//数据
#import "MyRepairDataVM.h" 

#define URL_Repair_Detail             @"proprietor/repair/getRepairById"
#define ReqData_SubListKeyStr         @"records"
 
static NSInteger topAllDataSectionNum = 1;
static NSInteger topAllDataAnSectionHaveAllRowN = 7;
static NSInteger const rowNum_WorkNumCell    = 0;
static NSInteger const rowNum_UpTimeCell     = 1;
static NSInteger const rowNum_UserInfoCell   = 2;
static NSInteger const rowNum_AddressCell    = 3;
static NSInteger const rowNum_YuYueTimeCell  = 4;
static NSInteger const rowNum_MsgAndImgsCell = 5;
static NSInteger const rowNum_voiceCell      = 6;
static NSInteger const rowNum_EvaluationStarCell = 0;


@interface MyRepairShowDetailWorkOrderInfoVC () <ZYHouseRepairIssueRecordCellDelegate> //<ZYReportAboutRepairApplyVoiceCellDelegate>
//大图
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;
//
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) MyRepairShowDetailWorkOrderInfoModel *detailWorkOrderInfoModel;
// 本处为语音专用model
@property (nonatomic, strong) ZYHouseRepairIssueUploadModel *voiceUseModel;

@property (nonatomic, assign) BOOL isHaveEvaluationInfoBool;//已经平论过了的状态
@end

@implementation MyRepairShowDetailWorkOrderInfoVC


 - (BaseTableViewFooterView *)footerView{
     if (!_footerView) {
         _footerView = [[HouseRepairListVcFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 90)];
         [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
     }
     return _footerView;
 }


- (MyRepairShowDetailWorkOrderInfoModel *)detailWorkOrderInfoModel{
    if (!_detailWorkOrderInfoModel) {
        _detailWorkOrderInfoModel = [[MyRepairShowDetailWorkOrderInfoModel alloc]init];
    }
    return _detailWorkOrderInfoModel;
}


- (ZYHouseRepairIssueUploadModel *)voiceUseModel {
    if (!_voiceUseModel) {
        _voiceUseModel = [[ZYHouseRepairIssueUploadModel alloc] init];
    }
    return _voiceUseModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self addRefresh];
    [self initData];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeNavBackColorWithDDndWIsGW];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    WEAKSELF
    if (weakSelf.voiceUseModel.isPlay) {
        [weakSelf stopVoicePlayer];//离开时停止语音
    }
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
     self.tableView.mj_header = headeerRefresh;
}
 
- (void)initView{
        self.tableView.separatorColor =  [UIColor clearColor];
        [self.tableView registerClass:[MyRepairPageBaseListOfMsgAndImgsTableViewCell class]  forCellReuseIdentifier:MyRepairPageBaseListOfMsgAndImgsTableViewCell_I]; //文本和图片cell
        [self.tableView registerNib:[UINib nibWithNibName:ZYHouseRepairIssueRecordCellID bundle:nil] forCellReuseIdentifier:ZYHouseRepairIssueRecordCellID];
        [self.tableView registerClass:[HouseRepairOldInputLookDetailShowContentTextTableViewCell class] forCellReuseIdentifier:HouseRepairOldInputLookDetailShowContentTextTableViewCell_I];//评价文本cell
        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 20+KIndicatorHeight)];

}
- (void)initData{
    [self thisRepairDetailData];
}
#pragma mark == 本次报修详情 （列表和详情同接口结构）
- (void)thisRepairDetailData{
    WEAKSELF
    [MyRepairDataVM myRepairOneDetailInfoWithIdInfo:self.model.ID withBlock:^(NSDictionary * _Nonnull getDic, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            
            NSMutableArray *getArr =    ( [[getDic allKeys] containsObject:ReqData_SubListKeyStr]  \
                                         && isNotNil([getDic objectForKey:ReqData_SubListKeyStr]) ) \
            ? [getDic objectForKey:ReqData_SubListKeyStr] : [NSMutableArray array];
            
            if (getArr.count>0) {
                
                weakSelf.detailWorkOrderInfoModel = [MyRepairShowDetailWorkOrderInfoModel mj_objectWithKeyValues:getArr.firstObject];
                
                //语音专用部分
                weakSelf.voiceUseModel.isPlay = NO;
                weakSelf.voiceUseModel.voiceUrl =  self.detailWorkOrderInfoModel.voiceUrl;
                weakSelf.voiceUseModel.voiceLength =  self.detailWorkOrderInfoModel.voiceLength;
    
                //评价展示bool类型
                if (self.detailWorkOrderInfoModel.comment.length > 0 || self.detailWorkOrderInfoModel.commentStatus >0) {//有提交的评价数据
                    self.isHaveEvaluationInfoBool = YES;
                }else{
                    self.isHaveEvaluationInfoBool = NO;
                }

                /**
                 //类型处理UI
                 【工单状态:0 待处理 1已接单 2处理中 4已完结】--- status数据类型
                 **/
                    
                if (self.detailWorkOrderInfoModel.status == 0) {//待处理状态
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.footerView.footerBtn setTitle:@"取消报事" forState:UIControlStateNormal];
                        weakSelf.tableView.tableFooterView = self.footerView;
                    });
                    
                }else if ( (self.detailWorkOrderInfoModel.status == 4) &&  !self.isHaveEvaluationInfoBool){//完成状态 没提交评论
                    //他方完成未评价类型
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.footerView.footerBtn setTitle:@"评价" forState:UIControlStateNormal];
                        weakSelf.tableView.tableFooterView = self.footerView;
                    });
                    
                }else if ( (self.detailWorkOrderInfoModel.status == 4) &&  self.isHaveEvaluationInfoBool){//完成状态 已经提交评论 需要展示
                    //有评论类型
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 20+KIndicatorHeight)];
                    });
                    
                }else{
                    //其他类型 footer 无按钮
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 20+KIndicatorHeight)];
                    });
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }
        }
    }];
    
}
#pragma mark ===
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   if ( (self.detailWorkOrderInfoModel.status == 4) &&  self.isHaveEvaluationInfoBool){//完成状态 已经提交评论 需要展示
        return topAllDataSectionNum +1;//评论section1
    }else{
        return topAllDataSectionNum;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ( section == 0 ) {
        return topAllDataAnSectionHaveAllRowN;
    }else{
        return 2;//评论2个cell
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == rowNum_WorkNumCell || indexPath.row == rowNum_UpTimeCell) {
            return 35;
            
        }else  if (indexPath.row == rowNum_UserInfoCell || indexPath.row == rowNum_AddressCell || indexPath.row == rowNum_YuYueTimeCell ) {
            if (indexPath.row == rowNum_AddressCell ) {
                return 20;
            }else{
                return 35;
            }
            
        }else  if (indexPath.row == rowNum_MsgAndImgsCell){
            CGFloat cellH =  [tableView fd_heightForCellWithIdentifier:MyRepairPageBaseListOfMsgAndImgsTableViewCell_I cacheByIndexPath:indexPath configuration:^(MyRepairPageBaseListOfMsgAndImgsTableViewCell * cell) {
                [cell fillDetailVcModel:self.detailWorkOrderInfoModel];
               }];
            return cellH;
            
        }else  if (indexPath.row == rowNum_voiceCell){
            return  (self.detailWorkOrderInfoModel.voiceLength >0 ? 68.0 : 8.0);//高度(留下圆角位置)
        }else{
            return 1;
         
        }
    }else{

        if (indexPath.row == rowNum_EvaluationStarCell) {
            return 120;
        }else{
            CGFloat contextH =  [tableView fd_heightForCellWithIdentifier:HouseRepairOldInputLookDetailShowContentTextTableViewCell_I cacheByIndexPath:indexPath configuration:^(HouseRepairOldInputLookDetailShowContentTextTableViewCell * cell) {
                [cell fillContentStr:self.detailWorkOrderInfoModel.comment];
            }];
            return  (contextH+20);//限制高度(留下圆角位置)+本cell旧版的此新版要给上下的空隙
        }
    }
   
}
 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        if (indexPath.row ==  rowNum_MsgAndImgsCell){//msg+img
            WEAKSELF
            MyRepairPageBaseListOfMsgAndImgsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyRepairPageBaseListOfMsgAndImgsTableViewCell_I];
            if (!cell) {
                cell = [[MyRepairPageBaseListOfMsgAndImgsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyRepairPageBaseListOfMsgAndImgsTableViewCell_I];
            }
            [cell fillDetailVcModel:self.detailWorkOrderInfoModel];
            cell.msgAndImgsCellTouchOneImgBlock = ^(NSInteger indexx) {
                [weakSelf msgAndImgsCellTouchImgIndex:indexx];
            };
            return cell;
        }else if (indexPath.row == rowNum_voiceCell){//voice
            if (self.detailWorkOrderInfoModel.voiceLength <= 0) {//nomalCell当作无语音时的占位cell | zyVoiceCell 为正常播放cell
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nomalCell"];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"nomalCell"];
                }
                return cell;
            }else{
                
                ZYHouseRepairIssueRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYHouseRepairIssueRecordCellID forIndexPath:indexPath];
                cell.delegate = self;
                cell.voicePlayCompleteBlock = ^(ZYHouseRepairIssueUploadModel * _Nonnull model) {
                    if (self.voiceUseModel == model) {
                        self.voiceUseModel.isPlay = NO;
                    }
                };
                cell.model = self.voiceUseModel;
                [cell isUseOnDetailVc];
                
                return cell;
            }

      
        //phoneCall
        }else if (indexPath.row == rowNum_UserInfoCell){
            MyRepariShwoDetailUserInfoWithPhoneCallInfoTableViewCel *cell = [tableView dequeueReusableCellWithIdentifier:MyRepariShwoDetailUserInfoWithPhoneCallInfoTableViewCell_I];
            if (!cell) {
                cell = [[MyRepariShwoDetailUserInfoWithPhoneCallInfoTableViewCel alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyRepariShwoDetailUserInfoWithPhoneCallInfoTableViewCell_I];
            }
            cell.titleL.text = @"报事业主：";
            cell.textL.text = [NSString stringWithFormat:@"%@  %@",[TextShowWithModelStr textShowWithModelStr:self.detailWorkOrderInfoModel.name],[TextShowWithModelStr textShowWithModelStr:self.detailWorkOrderInfoModel.phone]];
             return cell;
        //top
        }else if (indexPath.row == rowNum_WorkNumCell){
            MyRepariShwoDetailUserInfoWithTopUseTextTableViewCel *cell = [tableView dequeueReusableCellWithIdentifier:MyRepariShwoDetailUserInfoWithTopUseTextTableViewCel_I];
            if (!cell) {
                cell = [[MyRepariShwoDetailUserInfoWithTopUseTextTableViewCel alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyRepariShwoDetailUserInfoWithTopUseTextTableViewCel_I];
            }
            cell.titleL.text = @"工单编号：";
            cell.textL.text = [TextShowWithModelStr textShowWithModelStr:self.detailWorkOrderInfoModel.number];
            return cell;
        
        //center
        }else if (indexPath.row == rowNum_AddressCell){
            MyRepairPageBaseListOfTextShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyRepairPageBaseListOfTextShowTableViewCell_I];
            if (!cell) {
                cell = [[MyRepairPageBaseListOfTextShowTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyRepairPageBaseListOfTextShowTableViewCell_I];
            }
           
            cell.titleL.text = @"报事地点：";
            cell.textL.text = [TextShowWithModelStr textShowWithModelStr:self.detailWorkOrderInfoModel.address];
            return cell;
        //bottom
        }else{
            MyRepariShwoDetailUserInfoWithBottomUseTextTableViewCel *cell = [tableView dequeueReusableCellWithIdentifier:MyRepariShwoDetailUserInfoWithBottomUseTextTableViewCel_I];
            if (!cell) {
                cell = [[MyRepariShwoDetailUserInfoWithBottomUseTextTableViewCel alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyRepariShwoDetailUserInfoWithBottomUseTextTableViewCel_I];
            }
           

            switch (indexPath.row) {
                case rowNum_UpTimeCell:
                {
                    cell.titleL.text = @"报事时间：";
                    cell.textL.text = [TextShowWithModelStr textShowWithModelStr:self.detailWorkOrderInfoModel.createTime];
                }
                    break;
                case rowNum_YuYueTimeCell:
                {
                    cell.titleL.text = @"预约时间：";
                    cell.textL.text = [TextShowWithModelStr textShowWithModelStr:self.detailWorkOrderInfoModel.appointmentTime];
                    if (cell.textL.text.length<=0) {
                        cell.textL.text = @"暂无";
                    }
                }
                    break;
                default:
                    break;
            }
     
            return cell;
        }
    }else{
        if (indexPath.row == rowNum_EvaluationStarCell) {
            MyRepariShwoDetailEvaluationStarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyRepariShwoDetailEvaluationStarTableViewCell_I];
            if (!cell) {
                cell = [[MyRepariShwoDetailEvaluationStarTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyRepariShwoDetailEvaluationStarTableViewCell_I];
            }
            [cell fillStarNum:self.detailWorkOrderInfoModel.commentStatus];
            return cell;
        }else{
            HouseRepairOldInputLookDetailShowContentTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRepairOldInputLookDetailShowContentTextTableViewCell_I];
            if (!cell) {
                cell = [[HouseRepairOldInputLookDetailShowContentTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRepairOldInputLookDetailShowContentTextTableViewCell_I];
            }
            [cell fillContentStr:self.detailWorkOrderInfoModel.comment];
            return cell;
        }
        
    }
    
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == rowNum_UserInfoCell) {
        if (isNil(self.detailWorkOrderInfoModel.phone) || self.detailWorkOrderInfoModel.phone.length==0) {
            Y_SVP_SHOW_ERR_MES(@"电话号码有误！");
            return;
        }
        [self callPhoneWithStr: [TextShowWithModelStr textShowWithNotNullStr:self.detailWorkOrderInfoModel.phone]];
    }
}
- (void)callPhoneWithStr:(NSString *)phoneStr{
    
    NSMutableString *callStr=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneStr];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callStr] options:@{} completionHandler:nil];
}


#pragma mark === 组圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cornerRadius = 7.5f;
    UIColor *sectionFillColor =  [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    //UIColor *separatoColor = Color_Line_LigntGray;
    UIColor *separatoColor = [ThemeManager shareManager].themeLineColor;
    if ([ThemeManager shareManager].type==ThemeType_White) {
        separatoColor = Y_RGBA(240, 241, 246, 1);
    }else{
        separatoColor = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
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
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-0.5, bounds.size.width-10*2, 0.5);//h_0.5
         
            if (indexPath.section == 0) {
                if (indexPath.row == rowNum_UpTimeCell || indexPath.row == rowNum_YuYueTimeCell ) {
                    lineLayer.backgroundColor = separatoColor.CGColor;
                    [layer addSublayer:lineLayer];//1s 1r底下才显示 其余不显示
                }else{
                    lineLayer.backgroundColor = [UIColor clearColor].CGColor;
                    [layer addSublayer:lineLayer];
                }
            }else{
                if (indexPath.row == rowNum_EvaluationStarCell ) {//评价星星
                    lineLayer.backgroundColor = separatoColor.CGColor;
                    [layer addSublayer:lineLayer];
                }else{
                    lineLayer.backgroundColor = [UIColor clearColor].CGColor;
                    [layer addSublayer:lineLayer];
                }
            }
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}

#pragma mark ==  语音播放 |  停止
#pragma mark - ZYReportAboutRepairApplyVoiceCellDelegate

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


 

#pragma mark == footerBtnAction
- (void)footerBtnAction{  //根据当前状态 处理对应footerAction
    WEAKSELF
    
    if (self.detailWorkOrderInfoModel.status == 0) {//待处理状态_取消报事
        [self cancelThisRepairAction];
      
    }else if ( (self.detailWorkOrderInfoModel.status == 4) &&  !self.isHaveEvaluationInfoBool){//完成状态 没提交评论
        //去评价界面 |评价的草稿文本星星
        MyRepairEvaluationVC *vc = [[MyRepairEvaluationVC alloc]init];
        vc.thisEvalutionUseRepairID = [self.detailWorkOrderInfoModel.repairId integerValue];
        vc.commentDraft = self.detailWorkOrderInfoModel.commentDraft;
        vc.commentStatusDraft = self.detailWorkOrderInfoModel.commentStatusDraft;
         vc.popVcWithNeedUpDateBlock = ^{
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        [self pushVc:vc];
    
    }

}
//取消上报
- (void)cancelThisRepairAction{
    WEAKSELF
    [MyRepairDataVM myRepairOneDetailWithCancelThisRepairWithIdInfo:self.detailWorkOrderInfoModel.ID withBlock:^(NSDictionary * _Nonnull getDic,  BOOL success) {
        if (success) {
            //sucess
            
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_SUCCESS_MES(@"已成功申请取消了本次报修！");

                if (isNotNil(weakSelf.detailVcCancelOneUpInfo)) {
                    weakSelf.detailVcCancelOneUpInfo();
                }
                [weakSelf  popVC];
            });
        }else{
            //fail
            Y_SVP_SHOW_ERR_MES(@"取消失败！");
        }
    
    }];
}



#pragma mark == 大图展示
- (void)msgAndImgsCellTouchImgIndex:(NSInteger)indexx{
    DLog(@"点击了详情页的图片需要大图展示 %ld",indexx);
    
    //禁止刷新动作
    self.tableView.scrollEnabled = NO;
    //大图显示
    [self imgBigWithImgUrlStr:self.detailWorkOrderInfoModel.repairImgs[indexx]];
}

#pragma mark ==
#pragma mark == 图片放大
- (void)imgBigWithImgUrlStr:(NSString *)imgUrlStr{
    //基础fsizecenter
   // CGRect scrollvFram = self.view.bounds;//(全屏时使用)
    CGFloat addTopH = 0;
    CGFloat addBottomH = 0;
    CGRect scrollvFram = CGRectMake(0, -addTopH, self.view.bounds.size.width, self.view.bounds.size.height+(addTopH+addBottomH));//上下加长（非全屏时使用）
    //滑动范围
    CGSize scrollvContentSize = CGSizeMake(self.view.bounds.size.width*1.5, self.view.bounds.size.height*1.5);//可以左右滑
    //CGSize scrollvContentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);//禁止左右滑
    
    CGRect imgvFram = self.view.bounds;
//    CGPoint imgvCenterP = CGPointMake(self.view.center.x, self.view.center.y - KNavBarHeight);//（全屏时使用）
    CGPoint imgvCenterP = CGPointMake(self.view.center.x, self.view.center.y+addTopH );//（非全屏时使用）
    //滚动v
    _scrollView = [[UIScrollView alloc]initWithFrame:scrollvFram];
    _scrollView.contentSize = scrollvContentSize;
    _scrollView.maximumZoomScale=5.0;//图片的放大倍数
    _scrollView.minimumZoomScale=1.0;//图片的最小倍率
    _scrollView.delegate=self;
    _scrollView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    //图片
    _imageView = [[UIImageView alloc]initWithFrame:imgvFram];
    _imageView.center = imgvCenterP;


    //手势
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
    
    //其他
    [_scrollView addSubview:_imageView];
    [self.view addSubview:_scrollView];

    
    //数据
    [_imageView sd_setImageWithURL: [UrlWithString getURLWithStr:imgUrlStr] placeholderImage:[UIImage imageNamed:@"Repair_picture_icon"]];

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
    //开启刷新动作
    self.tableView.scrollEnabled = YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan-----------------------------------------");
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (isNotNil(_scrollView)) {
        [_scrollView removeFromSuperview];
        //开启刷新动作
        self.tableView.scrollEnabled = YES;
    }

}
#pragma mark == 图片放大 end

@end
