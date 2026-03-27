//
//  HealthSleepTotalVc.m
//  Community
//
//  Created by 余莹 on 2021/11/18.
//

#import "HealthSleepTotalVc.h"
#import "HealthSleepTotalTopView.h"
#import "HealthSleepTotalSectionHeaderView.h"
#import "BaseHealthHeader.h"
#import "HealthBaseDataManager.h"
#import "HealthSleepTool.h"

#define  Color_CellBackGray        Y_ColorWith16FromRGB(0xF0F1F6)
//Height
#define  TopViewHeaderView_Height (60)
#define  SectionHeaderView_Height (40)

#define  Row_Height_DayType_One   (130)
#define  Row_Height_DayType_Two   (190)
#define  Row_Height_DayType_Thr   (300)

#define  Row_Height_WeakType_One   (300)
#define  Row_Height_WeakType_Nomal (30)
#define  Row_Height_WeakType_Last  (60)
//data
#define  Index_DayTypeArr_AllTime        (0)
#define  Index_DayTypeArr_DeepSleepTime  (1)
#define  Index_DayTypeArr_LightSleepTime (2)
#define  Index_DayTypeArr_AwakeSleepTime (3)
//row
#define  Row_Num_WeakType_AllSleeTime            (0)
#define  Row_Num_WeakType_AvgSleepTimeAvg        (1)
#define  Row_Num_WeakType_CommperAvgSleepTime    (2)

#import "HealthSleepTotalWeakTypeNomalTableViewCell.h"
#define  HealthSleepTotalWeakTypeNomalTableViewCell_Identifier       @"HealthSleepTotalWeakTypeNomalTableViewCell"
#define  HealthSleepTotalOnlyTextTableViewCell_Identifier            @"HealthSleepTotalOnlyTextTableViewCell"

#import "HealthSleepTotalWeakTypeHistogramTableViewCell.h"
#define  HealthSleepTotalWeakTypeHistogramTableViewCell_Identifier   @"HealthSleepTotalWeakTypeHistogramTableViewCell"


#import "HealthSleepTotalDayTypeColumnarTableViewCell.h"
#define  HealthSleepTotalDayTypeColumnarTableViewCell_Identifier     @"HealthSleepTotalDayTypeColumnarTableViewCell"

#import "HealthSleepTotalDayTypeDoughnutTableViewCell.h"
#define  HealthSleepTotalDayTypeDoughnutTableViewCell_Identifier     @"HealthSleepTotalDayTypeDoughnutTableViewCell"


static NSString *dayType_greenColor_ShowStr = @"您的睡眠质量良好，充足的睡眠可以改善注意力和记忆力、减轻压力、保持健康的体重、保持心脏健康以及提升运动能力。";
static NSString *dayType_orangeColor_ShowStr = @"您的睡眠时间较短据资料显示，65岁以上的老年人，适合的睡眠时间是每天7-8个小时；您的夜间睡眠少，建议您可以适当进行午休保证每天的睡眠时间。\n建议您也可以尝试通过以下方法提高睡眠质量：\n 1.改善睡眠环境，选择合适的床上用品，避免噪音和强烈光线。\n 2.适当参与身体允许的体育锻炼，改善身体素质。\n 3.消除疾病影响，按时服药治疗。\n 4.睡前可以泡脚、洗热水澡，帮助入睡";
static NSString *dayType_redColor_ShowStr = @"您的睡眠质量非常差，睡眠不足导致黑眼圈、眼袋、皮肤干燥。除此之外，经常睡眠不足，会使人心情忧虑焦急，免疫力降低，由此会导致种种疾病发生，如神经衰弱、感冒、胃肠疾病等。另外专家研究表明，睡眠不足或不规律除了让人们眼睛胀涩之外，还会增加多种重大疾病的患病风险，包括癌症、心脏病、糖尿病和肥胖症等。";
static NSString *weakType_ShowStr_Good = @"您本周的睡眠时长相较上周有明显增长，睡眠质量转好，建议继续保持良好的睡眠习惯。";
static NSString *weakType_ShowStr_NotGood = @"您本周的睡眠时长相较上周有明显减少，睡眠质量降低，建议保持良好的睡眠习惯。";
static NSString *weakType_ShowStr_NotChange = @"您本周的睡眠时长相较上周无明显变化，睡眠质量无变化。";
/** day type
 DaySleepMinutesInv_GreenColorMin
 DaySleepMinutesInv_orange
 6-8小时以上绿色

 4-6小时黄色

 4小时以下红色
 */


 
@interface HealthSleepTotalVc () <UITableViewDelegate,UITableViewDataSource,HealthSleepTotalWeakTypeHistogramTableViewCellDelegate>
@property (nonatomic,strong) HealthSleepTotalTopView *topView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *weakTypeSectionHeaderTitleArr;
@property (nonatomic,strong) NSMutableArray *weakTypeNumTextSectionWithSubRowTitleArr;
@property (nonatomic,strong) NSMutableArray *dayTypeTimeArr;//总时长｜ 深睡｜浅睡｜梦醒时长
@property (nonatomic,strong) HealthGetSleepOneDayModel *saveOneDayModel;
@property (nonatomic,strong) HealthGetSleepOneWeakModel *saveOneWeakModel;

@property (nonatomic,assign) SleepTotalTopView_SubBtn_Choose_Type topViewChooseType;
@property (nonatomic,assign) NSInteger weakPageTurnIndexNum;

@end

@implementation HealthSleepTotalVc
#pragma mark ==
- (HealthSleepTotalTopView *)topView{
    if (!_topView) {
        _topView = [[HealthSleepTotalTopView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, TopViewHeaderView_Height)];
    }
  
    return _topView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView  = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}
#pragma mark ==
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"睡眠";
    self.view.backgroundColor = [UIColor whiteColor];
    self.topViewChooseType = SleepTotalTopView_SubBtn_Choose_Type_OneDay;
    [self initView];
    [self addRefresh];
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarStyleWithSOSColor];
    
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    self.tableView.mj_header = headeerRefresh;
}

#pragma mark ==
- (void)initData{
    [self.tableView reloadData];//有无数据都要先切换界面
    //更新数据
    if (self.topViewChooseType == SleepTotalTopView_SubBtn_Choose_Type_OneDay ) {
        [self getOneDayData];
    }else{
        self.weakPageTurnIndexNum = -1;
        [self getOneWeakData];
    }
}
- (void)getOneDayData{
    WEAKSELF
    [[HealthBaseDataManager share]getUserSleepOneDayDataWithUserId:self.nowUserId withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            HealthGetSleepOneDayModel *model = [HealthGetSleepOneDayModel mj_objectWithKeyValues:dic];
            weakSelf.saveOneDayModel = model;
            [weakSelf.dayTypeTimeArr replaceObjectAtIndex:Index_DayTypeArr_AllTime withObject:@(model.totalSleepTime)];
            [weakSelf.dayTypeTimeArr replaceObjectAtIndex:Index_DayTypeArr_DeepSleepTime withObject:@(model.deepSleepTime)];
            [weakSelf.dayTypeTimeArr replaceObjectAtIndex:Index_DayTypeArr_LightSleepTime withObject:@(model.lightSleepTime)];
            [weakSelf.dayTypeTimeArr replaceObjectAtIndex:Index_DayTypeArr_AwakeSleepTime withObject:@(model.wakeUpTime)];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}
- (void)getOneWeakData{
    WEAKSELF
    [[HealthBaseDataManager share]getUserSleepOneWeakDataWithUserId:self.nowUserId withWeakPageTurnIndexNum:self.weakPageTurnIndexNum withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            HealthGetSleepOneWeakModel *model = [HealthGetSleepOneWeakModel mj_objectWithKeyValues:dic];
            weakSelf.saveOneWeakModel = model;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
    
}
 
#pragma mark === 周 时间切换
- (void)timeChangeWithLastWeak{
    self.weakPageTurnIndexNum -= 1;
    [self getOneWeakData];
    
}
- (void)timeChangeWithNextWeak{
    if (self.weakPageTurnIndexNum < -1) {
        self.weakPageTurnIndexNum += 1;
        [self getOneWeakData];
    }else{
        Y_SVP_SHOW_INFO_MES(@"没有更多数据！");
    }
  
}
#pragma mark ===
- (void)initView{
   
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    WEAKSELF
    self.topView.chooseTypeBlock = ^(SleepTotalTopView_SubBtn_Choose_Type type) {
        weakSelf.topViewChooseType = type;
        [weakSelf initData];
    };
    [self setUI];
}
- (void)setUI{
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topView.superview);
        make.height.offset(TopViewHeaderView_Height);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_tableView.superview);
        make.top.equalTo(_topView.mas_bottom);
        make.bottom.equalTo(_tableView.superview).offset(-20);
    }];
}

#pragma mark ===
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == [tableView numberOfSections]-1) {//最后一section 都是总结cell
        HealthSleepTotalOnlyTextTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:HealthSleepTotalOnlyTextTableViewCell_Identifier];
        if (!cell) {
            cell = [[HealthSleepTotalOnlyTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HealthSleepTotalOnlyTextTableViewCell_Identifier];
        }
        if (self.topViewChooseType == SleepTotalTopView_SubBtn_Choose_Type_OneDay ) {
            //用  总睡眠长度 显示文本
            if (self.saveOneDayModel.totalSleepTime >= DaySleepMinutesInv_GreenColorMin) {
                cell.contentTextView.text = dayType_greenColor_ShowStr;
                
            }else if ( (self.saveOneDayModel.totalSleepTime < DaySleepMinutesInv_GreenColorMin) && (self.saveOneDayModel.totalSleepTime > DaySleepMinutesInv_OrangeColorMin)){
                cell.contentTextView.text = dayType_orangeColor_ShowStr;
                
            }else if((self.saveOneDayModel.totalSleepTime > 0 )&& (self.saveOneDayModel.totalSleepTime <= DaySleepMinutesInv_OrangeColorMin )){
                cell.contentTextView.text = dayType_redColor_ShowStr;
                
            }else if (self.saveOneDayModel.totalSleepTime ==0 ){
                cell.contentTextView.text = @"暂无数据";
            }
            
        }else{
            if (self.saveOneWeakModel.compareAvgSleepTime>0) {
                cell.contentTextView.text = weakType_ShowStr_Good;
            }else if(self.saveOneWeakModel.compareAvgSleepTime<0){
                cell.contentTextView.text = weakType_ShowStr_NotGood;
            }else{
                cell.contentTextView.text = weakType_ShowStr_NotChange;
            }
        }
        return cell;
    }else{
        if (self.topViewChooseType == SleepTotalTopView_SubBtn_Choose_Type_OneDay ) {
            return [self tableView:tableView dayTypeCellForRowAtIndexPath:indexPath];
        }else{
            return [self tableView:tableView weakTypeCellForRowAtIndexPath:indexPath];
        }
    }
    
}
//day_type
- (UITableViewCell *)tableView:(UITableView *)tableView dayTypeCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        HealthSleepTotalDayTypeColumnarTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:HealthSleepTotalDayTypeColumnarTableViewCell_Identifier];
        if (!cell) {
            cell = [[HealthSleepTotalDayTypeColumnarTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HealthSleepTotalDayTypeColumnarTableViewCell_Identifier];
        }
        [cell fillDataWithAllTimeNum:[self.dayTypeTimeArr.firstObject  integerValue] withDeepSleepTime:[self.dayTypeTimeArr[1] integerValue] withLightSleepTime:[self.dayTypeTimeArr[2] integerValue] withAwakeSleepTime:[self.dayTypeTimeArr.lastObject integerValue]];
        return cell;
      
    }else{
        HealthSleepTotalDayTypeDoughnutTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:HealthSleepTotalDayTypeDoughnutTableViewCell_Identifier];
        if (!cell) {
            cell = [[HealthSleepTotalDayTypeDoughnutTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HealthSleepTotalDayTypeDoughnutTableViewCell_Identifier];
        }
        [cell fillDataWithTotalMin:self.saveOneDayModel.totalSleepTime andWithScoreNum:self.saveOneDayModel.sleepScore];//睡眠评分 环形图
        return cell;
    }
    
}

//weak_type
- (UITableViewCell *)tableView:(UITableView *)tableView weakTypeCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        HealthSleepTotalWeakTypeHistogramTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:HealthSleepTotalWeakTypeHistogramTableViewCell_Identifier];
        if (!cell) {
            cell = [[HealthSleepTotalWeakTypeHistogramTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HealthSleepTotalWeakTypeHistogramTableViewCell_Identifier];
        }
        cell.delegate = self;
        if (isNotNil(self.saveOneWeakModel)) {
            [cell fillDataOneWeak:self.saveOneWeakModel];
        }
        return cell;

    }else{
        HealthSleepTotalWeakTypeNomalTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:HealthSleepTotalWeakTypeNomalTableViewCell_Identifier];
        if (!cell) {
            cell = [[HealthSleepTotalWeakTypeNomalTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HealthSleepTotalWeakTypeNomalTableViewCell_Identifier];
        }
        cell.titleL.text = self.weakTypeNumTextSectionWithSubRowTitleArr[indexPath.row];
        switch (indexPath.row) {
            case Row_Num_WeakType_AllSleeTime:
            {
                cell.detailL.text = (self.saveOneWeakModel.lastSevenDayTotalSleepTime==0 ? @"-" : [HealthSleepTool showHMStrTimeWithMinIntValue: self.saveOneWeakModel.lastSevenDayTotalSleepTime]) ;
            }
                break;
            case Row_Num_WeakType_AvgSleepTimeAvg:
            {
                cell.detailL.text = (self.saveOneWeakModel.lastSevenDayAvgSleepTime==0 ? @"-" : [HealthSleepTool showHMStrTimeWithMinIntValue: self.saveOneWeakModel.lastSevenDayAvgSleepTime]);
            }
                break;
            case Row_Num_WeakType_CommperAvgSleepTime:
            {
                cell.detailL.text = (self.saveOneWeakModel.compareAvgSleepTime==0 ? @"-" : [HealthSleepTool showDescribeTheChangeHMStrWithChangeMinIntValue: self.saveOneWeakModel.compareAvgSleepTime] );
            }
                break;
                
            default:
                break;
        }
        
        return cell;
    }
    
}


#pragma mark ==
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.topViewChooseType == SleepTotalTopView_SubBtn_Choose_Type_OneDay ) {
        return 3;
    }else{
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.topViewChooseType == SleepTotalTopView_SubBtn_Choose_Type_OneDay ) {
        return 1;
    }else{
        if (section==0 ||  section == ([tableView numberOfSections]-1)) {
            return 1;
        }else{
            return 3;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.topViewChooseType == SleepTotalTopView_SubBtn_Choose_Type_OneDay ) {
        if (indexPath.section==0) {
            return Row_Height_DayType_One;
        }else if (indexPath.section==1){
            return Row_Height_DayType_Two;
        }else{
            //文本长度随状态变计算高度或者用最大高度
            //用  总睡眠长度 显示文本
            NSString *cellConShowStr = @"暂无数据";
            if (self.saveOneDayModel.totalSleepTime >= DaySleepMinutesInv_GreenColorMin) {
                cellConShowStr = dayType_greenColor_ShowStr;
                
            }else if ( (self.saveOneDayModel.totalSleepTime < DaySleepMinutesInv_GreenColorMin) && (self.saveOneDayModel.totalSleepTime > DaySleepMinutesInv_OrangeColorMin)){
                cellConShowStr = dayType_orangeColor_ShowStr;
                
            }else if((self.saveOneDayModel.totalSleepTime > 0 )&& (self.saveOneDayModel.totalSleepTime <= DaySleepMinutesInv_OrangeColorMin )){
                cellConShowStr = dayType_redColor_ShowStr;
                
            }else{
                return Row_Height_WeakType_Last;
             }
            return ([Tool getTextHeightWhenHaveWidthFloatNum:(Screen_W-32-20) withTextStr:cellConShowStr withFont:[PensionThemeManager shareManager].Pension_TextFont_13] +30);
        }
        
    }else{
        if (indexPath.section==0) {
            return Row_Height_WeakType_One;
        }else if(indexPath.section == ([tableView numberOfSections]-1)){
            return Row_Height_WeakType_Last;//文本长度大致不变 可用固定高度
        }else{
            return Row_Height_WeakType_Nomal;
        }
    }
}
 
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HealthSleepTotalSectionHeaderView *sectionHeaderView = [[HealthSleepTotalSectionHeaderView alloc]initWithFrame:CGRectZero];
    if (self.topViewChooseType == SleepTotalTopView_SubBtn_Choose_Type_OneDay ) {
        if (section==0) {
            sectionHeaderView.showTipLabel.text = [NSString stringWithFormat:@"昨日睡眠:%@",[HealthSleepTool showHMStrTimeWithMinIntValue:self.saveOneDayModel.totalSleepTime]];
            return sectionHeaderView;
        }else{
            return [UIView new];
        }
       
    }else{
        if (section==0) {
            sectionHeaderView.showTipLabel.text = [NSString stringWithFormat:@"总计睡眠%@", [HealthSleepTool showHMStrTimeWithMinIntValue:self.saveOneWeakModel.lastSevenDayTotalSleepTime]];
        }else{
            sectionHeaderView.showTipLabel.text = self.weakTypeSectionHeaderTitleArr[section];
        }
  
        return sectionHeaderView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.topViewChooseType == SleepTotalTopView_SubBtn_Choose_Type_OneDay ) {
        if (section==0) {
            return SectionHeaderView_Height;
        }else{
            return 0;
        }
    }else{
         return SectionHeaderView_Height;
    }
}
#pragma mark ===
- (NSMutableArray *)weakTypeSectionHeaderTitleArr{
    if (!_weakTypeSectionHeaderTitleArr) {
        _weakTypeSectionHeaderTitleArr = [NSMutableArray arrayWithObjects:@"总计",@"一周睡眠统计", @"总结", nil];
    }
    return _weakTypeSectionHeaderTitleArr;
}
- (NSMutableArray *)weakTypeNumTextSectionWithSubRowTitleArr{
    if (!_weakTypeNumTextSectionWithSubRowTitleArr) {
        _weakTypeNumTextSectionWithSubRowTitleArr = [NSMutableArray arrayWithObjects:@"总计睡眠时长",@"平均睡眠时长", @"同比上周",nil];
    }
    return _weakTypeNumTextSectionWithSubRowTitleArr;
}
- (NSMutableArray *)dayTypeTimeArr{
    if (!_dayTypeTimeArr) {
        _dayTypeTimeArr = [[NSMutableArray alloc]initWithObjects:@(0),@(0),@(0),@(0), nil];//总时长｜ 深睡｜浅睡｜梦醒时长
    }
    return _dayTypeTimeArr;
}

#pragma mark == 组圆角
#pragma mark === 组圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIColor *sectionFillColor = Color_CellBackGray;//灰色填充
    if ((self.topViewChooseType == SleepTotalTopView_SubBtn_Choose_Type_OneDay ) && (indexPath.section==1)) {
         //daytype的饼状图cell 白色填充 (return 会导致在切换时刷新不了，换成赋予白色)
        sectionFillColor = [UIColor whiteColor];
    }else{//灰色填充
    }
    if ([cell respondsToSelector:@selector(tintColor)]) {
        UIColor *separatoColor = [PensionThemeManager shareManager].Pension_LineColor;//分割线颜色
        CGFloat cornerRadius = 7.0f;
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 16.0, 0);
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);// 实体剧形状
            separatoColor =  [PensionThemeManager shareManager].Pension_LineColor;//分割线颜色
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
