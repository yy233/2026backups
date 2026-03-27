//
//  ZYEditEventVC.m
//  Community
//
//  Created by ZY on 2021/11/11.
//

#import "ZYEditEventVC.h"
#import "ZYEditEventTopView.h"
#import "ZYEditEventHeaderView.h"
#import "ZYEditEventBottomView.h"
#import "ZYEditEventDateCell.h"
#import "ZYEditEventContentCell.h"
#import "ZYEditEventRemindMemberCell.h"
#import "ZYEditEventRemindMemberModel.h"
#import "ZYEditEventRemindWeekModel.h"
#import "ZYFamilyArchiveModel.h"
#import "ZBLocalNotification.h"

static NSString * const editEventDateCellID = @"ZYEditEventDateCell";
static NSString * const editEventContentCellID = @"ZYEditEventContentCell";
static NSString * const editEventRemindMemberCellID = @"ZYEditEventRemindMemberCell";
#define kEditEventTopViewHeight status_height+44
#define kEditEventHeaderViewHeight 50
#define kEditEventBottomViewHeight button_bottom_height+80
#define kEditEventDateCellHeight 126
#define kEditEventContentCellHeight 120

@interface ZYEditEventVC () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIViewControllerTransitioningDelegate, ZYEditEventTopViewDelegate, ZYEditEventBottomViewDelegate, TTGTextTagCollectionViewDelegate>

@property (nonatomic, strong) ZYEditEventTopView *topView;

@property (nonatomic, strong) ZYEditEventBottomView *bottomView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) CGFloat textTagCollectionViewHeight;

@property (nonatomic, assign) CGFloat textTagCollectionViewWeekHeight;

@property (nonatomic, strong) NSMutableArray *memberArray;

@property (nonatomic, strong) NSMutableArray *memberTagArray;

@property (nonatomic, strong) NSMutableArray *memberTagTempArray;

@property (nonatomic, strong) NSMutableArray *weekArray;

@property (nonatomic, strong) NSMutableArray *weekTagArray;

@property (nonatomic, strong) NSMutableArray *weekTagTempArray;

@property (nonatomic, strong) ZYEventRemindModel *eventModel;

// 标签相关配置
@property (nonatomic, strong) TTGTextTagStringContent *content;

@property (nonatomic, strong) TTGTextTagStringContent *selectedContent;

@property (nonatomic, strong) TTGTextTagStyle *style;

@property (nonatomic, strong) TTGTextTagStyle *selectedStyle;

@end

@implementation ZYEditEventVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self customTableView];
    [self initRemindWayData];
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initMemberData];
    
    // 添加返回手势
    self.transitioningDelegate = self;
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePan];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self hiddenNavigationBar];
}

- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePan {
    CGFloat progress = fabs([edgePan translationInView:[UIApplication sharedApplication].windows.lastObject].x / [UIApplication sharedApplication].windows.lastObject.bounds.size.width);
    if ((edgePan.edges == UIRectEdgeLeft) && (progress > 0.2)) {
        [self showSaveAlert];
    }
}

- (void)showSaveAlert {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"确认取消编辑吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self popVC];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)setUI {
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topView.superview);
        make.height.offset(kEditEventTopViewHeight);
    }];
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_bottomView.superview);
        make.height.offset(kEditEventBottomViewHeight);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_tableView.superview);
        make.top.equalTo(_topView.mas_bottom);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

#pragma mark - 懒加载
- (ZYEditEventTopView *)topView {
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:@"ZYEditEventTopView" owner:nil options:nil].lastObject;
        if ([self.type isEqual:@"add"]) {
            _topView.titleLabel.text = @"新增事件";
        }else {
            _topView.titleLabel.text = @"编辑事件";
        }
        _topView.delegate = self;
    }
    
    return _topView;
}

- (ZYEditEventBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYEditEventBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }
    
    return _tableView;
}

- (NSMutableArray *)memberArray {
    if (!_memberArray) {
        _memberArray = [NSMutableArray array];
    }
    
    return _memberArray;
}

- (NSMutableArray *)memberTagArray {
    if (!_memberTagArray) {
        _memberTagArray = [NSMutableArray array];
    }
    
    return _memberTagArray;
}

- (NSMutableArray *)memberTagTempArray {
    if (!_memberTagTempArray) {
        _memberTagTempArray = [NSMutableArray array];
    }
    
    return _memberTagTempArray;
}

- (NSMutableArray *)weekArray {
    if (!_weekArray) {
        _weekArray = [NSMutableArray array];
    }
    
    return _weekArray;
}

- (NSMutableArray *)weekTagArray {
    if (!_weekTagArray) {
        _weekTagArray = [NSMutableArray array];
    }
    
    return _weekTagArray;
}

- (NSMutableArray *)weekTagTempArray {
    if (!_weekTagTempArray) {
        _weekTagTempArray = [NSMutableArray array];
    }
    
    return _weekTagTempArray;
}

- (ZYEventRemindModel *)eventModel {
    if (!_eventModel) {
        _eventModel = [[ZYEventRemindModel alloc] init];
        if ([self.type isEqual:@"edit"]) {
            _eventModel = self.editEvenModel;
        }
    }
    
    return _eventModel;
}

- (TTGTextTagStringContent *)content {
    if (!_content) {
        _content = [[TTGTextTagStringContent alloc] init];
        _content.textFont = [UIFont systemFontOfSize:14];
        _content.textColor = [UIColor zy_colorWithHexString:@"#2B2C2F"];
    }
    
    return _content;
}

- (TTGTextTagStringContent *)selectedContent {
    if (!_selectedContent) {
        _selectedContent = [[TTGTextTagStringContent alloc] init];
        _selectedContent.textFont = [UIFont systemFontOfSize:14];
        _selectedContent.textColor = [UIColor whiteColor];
    }
    
    return _selectedContent;
}

- (TTGTextTagStyle *)style {
    if (!_style) {
        _style = [[TTGTextTagStyle alloc] init];
        _style.backgroundColor = [UIColor clearColor];
        _style.shadowColor = [UIColor clearColor];
        _style.borderWidth = 0.5;
        _style.borderColor = [UIColor zy_colorWithHexString:@"#DDDDDD"];
        _style.cornerRadius = 16;
        _style.extraSpace = CGSizeMake(30, 0);
        _style.exactHeight = 32;
    }
    
    return _style;
}

- (TTGTextTagStyle *)selectedStyle {
    if (!_selectedStyle) {
        _selectedStyle = [[TTGTextTagStyle alloc] init];
        _selectedStyle.backgroundColor = [UIColor zy_colorWithHexString:@"#01AEAF"];
        _selectedStyle.shadowColor = [UIColor clearColor];
        _selectedStyle.borderWidth = 0.5;
        _selectedStyle.borderColor = [UIColor zy_colorWithHexString:@"#01AEAF"];
        _selectedStyle.cornerRadius = 16;
        _selectedStyle.extraSpace = CGSizeMake(30, 0);
        _selectedStyle.exactHeight = 32;
    }
    
    return _selectedStyle;
}

#pragma mark - 加载数据
// 加载周天数据
- (void)initRemindWayData {
    if (self.weekArray) {
        [self.weekArray removeAllObjects];
    }
    for (NSInteger i = 1; i <= 7; i++) {
        ZYEditEventRemindWeekModel *model = [[ZYEditEventRemindWeekModel alloc] init];
        model.week = i;
        model.weekStr = [ZYWeekStringTool weekdayStringWithNum:i];
        model.isSelected = NO;
        [self.weekArray addObject:model];
    }
    [self handleWeekData];
    [self.tableView reloadData];
}

// 处理周天数据
- (void)handleWeekData {
    if ([self.type isEqual:@"add"]) {
        self.eventModel.warnHour = [NSDate date].br_hour;
        self.eventModel.warnMinute = [NSDate date].br_minute;
        [self.weekArray enumerateObjectsUsingBlock:^(ZYEditEventRemindWeekModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                model.isSelected = YES;
            }else {
                model.isSelected = NO;
            }
        }];
    }else {
        for (NSString *week in self.eventModel.weeks) {
            for (ZYEditEventRemindWeekModel *model in self.weekArray) {
                if (model.week == [week integerValue]) {
                    model.isSelected = YES;
                }
            }
        }
    }
    if (self.weekTagArray.count) {
        [self.weekTagArray removeAllObjects];
    }
    if (self.weekTagTempArray.count) {
        [self.weekTagTempArray removeAllObjects];
    }
    for (int i = 0; i < self.weekArray.count; i++) {
        ZYEditEventRemindWeekModel *model = self.weekArray[i];
        TTGTextTagStringContent *stringContent = [self.content copy];
        stringContent.text = model.weekStr;
        TTGTextTagStringContent *selectedStringContent = [self.selectedContent copy];
        selectedStringContent.text = model.weekStr;
        TTGTextTag *tag = [[TTGTextTag alloc] init];
        tag.content = stringContent;
        tag.selectedContent = selectedStringContent;
        tag.style = self.style;
        tag.selectedStyle = self.selectedStyle;
        [self.weekTagArray addObject:tag];
        [self.weekTagTempArray addObject:tag];
    }
}

// 加载被提醒成员数据
- (void)initMemberData {
    [[ToolOfNetWork sharedTools] YYrequestALLURLPostNotMainQueue:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kFamilyListUrl] withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if (self.memberArray.count > 0) {
                    [self.memberArray removeAllObjects];
                }
                NSArray *array = [NSArray yy_modelArrayWithClass:[ZYFamilyArchiveModel class] json:responsObject[@"data"]];
                for (ZYFamilyArchiveModel *tempModel in array) {
                    ZYEditEventRemindMemberModel *model = [[ZYEditEventRemindMemberModel alloc] init];
                    model.nameId = tempModel.ID;
                    model.name = tempModel.name;
                    model.isOneself = tempModel.oneself;
                    model.isSelected = NO;
                    [self.memberArray addObject:model];
                }
                [self handleMemberData];
                [self.tableView reloadData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 处理被提醒成员数据
- (void)handleMemberData {
    if ([self.type isEqual:@"add"]) {
        [self.memberArray enumerateObjectsUsingBlock:^(ZYEditEventRemindMemberModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (model.isOneself) {
                model.isSelected = YES;
            }else {
                model.isSelected = NO;
            }
        }];
    }else {
        for (ZYEventRemindRecordsModel *recordsModel in self.eventModel.records) {
            for (ZYEditEventRemindMemberModel *model in self.memberArray) {
                if ([model.nameId isEqual:recordsModel.ID]) {
                    model.isSelected = YES;
                }
            }
        }
    }
    if (self.memberTagArray.count) {
        [self.memberTagArray removeAllObjects];
    }
    if (self.memberTagTempArray.count) {
        [self.memberTagTempArray removeAllObjects];
    }
    for (int i = 0; i < self.memberArray.count; i++) {
        ZYEditEventRemindMemberModel *model = self.memberArray[i];
        TTGTextTagStringContent *stringContent = [self.content copy];
        stringContent.text = model.name;
        TTGTextTagStringContent *selectedStringContent = [self.selectedContent copy];
        selectedStringContent.text = model.name;
        TTGTextTag *tag = [[TTGTextTag alloc] init];
        tag.content = stringContent;
        tag.selectedContent = selectedStringContent;
        tag.style = self.style;
        tag.selectedStyle = self.selectedStyle;
        [self.memberTagArray addObject:tag];
        [self.memberTagTempArray addObject:tag];
    }
}

// 加载新增事件提醒数据
- (void)initAddEvenData {
    NSDictionary *params = @{@"content" : self.eventModel.content, @"warnHour" : @(self.eventModel.warnHour), @"warnMinute" : @(self.eventModel.warnMinute), @"families" : self.eventModel.families, @"weeks" : self.eventModel.weeks};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kAddEventUrl] withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                self.eventModel.ID = [NSString stringWithFormat:@"%@", responsObject[@"data"]];
                // 创建本地定时通知
                [self createLocalNotification];
                // 发送通知
                Y_NSNotificationCenter_PostNotice_NilObject_Name(@"PENSION_ADD_EDIT_EVENT_BACK")
                [self popVC];
                [ZYProgressHUDTool showCustomHUDTextMessage:@"添加成功" toView:self.view.window];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 加载修改事件提醒数据
- (void)initUploadEventData {
    NSDictionary *params = @{@"id" : self.eventModel.ID, @"content" : self.eventModel.content, @"warnHour" : @(self.eventModel.warnHour), @"warnMinute" : @(self.eventModel.warnMinute), @"families" : self.eventModel.families, @"weeks" : self.eventModel.weeks};
    [[ToolOfNetWork sharedTools] YrequestPUTALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kUpdateEventUrl] withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if (self.eventModel.status == 1) {
                    // 创建本地定时通知
                    [self cancelLocalNotification];
                    [self createLocalNotification];
                }
                // 发送通知
                Y_NSNotificationCenter_PostNotice_NilObject_Name(@"PENSION_ADD_EDIT_EVENT_BACK")
                [self popVC];
                [ZYProgressHUDTool showCustomHUDTextMessage:@"修改成功" toView:self.view.window];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:editEventDateCellID bundle:nil] forCellReuseIdentifier:editEventDateCellID];
    [self.tableView registerNib:[UINib nibWithNibName:editEventContentCellID bundle:nil] forCellReuseIdentifier:editEventContentCellID];
    [self.tableView registerNib:[UINib nibWithNibName:editEventRemindMemberCellID bundle:nil] forCellReuseIdentifier:editEventRemindMemberCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZYEditEventDateCell *cell = [tableView dequeueReusableCellWithIdentifier:editEventDateCellID forIndexPath:indexPath];
        cell.model = self.eventModel;
        
        return cell;
    }else if (indexPath.section == 1) {
        ZYEditEventRemindMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:editEventRemindMemberCellID forIndexPath:indexPath];
        cell.textTagCollectionView.tag = 300;
        if (self.weekTagTempArray.count > 0) {
            cell.textTagCollectionView.delegate = self;
            [cell.textTagCollectionView addTags:self.weekTagArray];
            self.textTagCollectionViewWeekHeight = cell.textTagCollectionView.contentSize.height;
            for (NSInteger i = 0; i < self.weekArray.count; i++) {
                ZYEditEventRemindWeekModel *model = self.weekArray[i];
                if (model.isSelected) {
                    [cell.textTagCollectionView updateTagAtIndex:i selected:YES];
                }
            }
            [self.weekTagTempArray removeAllObjects];
        }
        
        return cell;
    }else if (indexPath.section == 2) {
        ZYEditEventContentCell *cell = [tableView dequeueReusableCellWithIdentifier:editEventContentCellID forIndexPath:indexPath];
        cell.textView.delegate = self;
        cell.model = self.eventModel;
        
        return cell;
    }else if (indexPath.section == 3) {
        ZYEditEventRemindMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:editEventRemindMemberCellID forIndexPath:indexPath];
        cell.textTagCollectionView.tag = 200;
        if (self.memberTagTempArray.count > 0) {
            cell.textTagCollectionView.delegate = self;
            [cell.textTagCollectionView addTags:self.memberTagArray];
            self.textTagCollectionViewHeight = cell.textTagCollectionView.contentSize.height;
            for (NSInteger i = 0; i < self.memberArray.count; i++) {
                ZYEditEventRemindMemberModel *model = self.memberArray[i];
                if (model.isSelected) {
                    [cell.textTagCollectionView updateTagAtIndex:i selected:YES];
                }
            }
            [self.memberTagTempArray removeAllObjects];
        }
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        return kEditEventDateCellHeight;
    }else if (indexPath.section == 1) {
        
        return self.textTagCollectionViewWeekHeight;
    }else if (indexPath.section == 2) {
        
        return kEditEventContentCellHeight;
    }else if (indexPath.section == 3) {
        
        return self.textTagCollectionViewHeight;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kEditEventHeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        ZYEditEventHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"ZYEditEventHeaderView" owner:nil options:nil].lastObject;
        headerView.titleLabel.text = @"时间";
        
        return headerView;
    }else if (section == 1) {
        ZYEditEventHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"ZYEditEventHeaderView" owner:nil options:nil].lastObject;
        headerView.titleLabel.text = @"提醒时间";
        
        return headerView;
    }else if (section == 2) {
        ZYEditEventHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"ZYEditEventHeaderView" owner:nil options:nil].lastObject;
        headerView.titleLabel.text = @"内容";
        
        return headerView;
    }else if (section == 3) {
        ZYEditEventHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"ZYEditEventHeaderView" owner:nil options:nil].lastObject;
        headerView.titleLabel.text = @"被提醒成员";
        
        return headerView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 4) {
        
        return 20;
    }
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.eventModel.content = textView.text;
}

#pragma mark - TTGTextTagCollectionViewDelegate
- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(TTGTextTag *)tag atIndex:(NSUInteger)index {
    if (textTagCollectionView.tag == 200) {
        ZYEditEventRemindMemberModel *model = self.memberArray[index];
        if (model.isOneself) {
            model.isSelected = YES;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
            ZYEditEventRemindMemberCell *cell = (ZYEditEventRemindMemberCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell.textTagCollectionView updateTagAtIndex:index selected:YES];
        }else {
            model.isSelected = !model.isSelected;
        }
    }else if (textTagCollectionView.tag == 300) {
        ZYEditEventRemindWeekModel *model = self.weekArray[index];
        model.isSelected = !model.isSelected;
    }
}

#pragma mark - ZYEditEventTopViewDelegate
- (void)backButtonEvent {
    [self showSaveAlert];
}

#pragma mark - ZYEditEventBottomViewDelegate
- (void)okButtonEvent {
    
    NSLog(@"确认");
    [self handleSubmitData];
    if (self.eventModel.weeks.count > 0) {
        if (self.eventModel.content.length > 0) {
            if (self.eventModel.families.count > 0) {
                if ([self.type isEqual:@"add"]) {
                    [self initAddEvenData];
                }else {
                    [self initUploadEventData];
                }
            }else {
                [ZYProgressHUDTool showCustomHUDTextMessage:@"请选择被提醒成员" toView:self.view delay:3.0];
            }
        }else {
            [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入您需要提醒的内容" toView:self.view delay:3.0];
        }
    }else {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"请选择被提醒时间" toView:self.view delay:3.0];
    }
}

// 处理提交数据
- (void)handleSubmitData {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    ZYEditEventDateCell *cell = (ZYEditEventDateCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    self.eventModel.warnHour = cell.datePicker.date.br_hour;
    self.eventModel.warnMinute = cell.datePicker.date.br_minute;
    NSMutableArray *nameIdArray = [NSMutableArray array];
    for (ZYEditEventRemindMemberModel *tempModel in self.memberArray) {
        if (tempModel.isSelected) {
            [nameIdArray addObject:tempModel.nameId];
        }
    }
    self.eventModel.families = [nameIdArray copy];
    NSMutableArray *weekArray = [NSMutableArray array];
    for (ZYEditEventRemindWeekModel *tempModel in self.weekArray) {
        if (tempModel.isSelected) {
            [weekArray addObject:[NSString stringWithFormat:@"%ld", tempModel.week]];
        }
    }
    self.eventModel.weeks = [weekArray copy];
}

#pragma mark - 本地闹钟通知
// 创建本地定时通知
- (void)createLocalNotification {
    NSInteger currentWeek = [ZYWeekStringTool weekdayNumWithString:[NSDate date].br_weekdayString];
    NSString *currentDateStr = [NSDate br_stringFromDate:[NSDate date] dateFormat:[NSString stringWithFormat:@"yyyy-MM-dd %02ld:%02ld", self.eventModel.warnHour, self.eventModel.warnMinute]];
    NSDate *startDate = [[NSDate xh_dateWithFormat_yyyy_MM_dd_HH_mm_string:currentDateStr] dateByAddingTimeInterval:-24*60*60*currentWeek];
    NSMutableArray *notiIdArray = [NSMutableArray array];
    NSArray *eventNotiIds = [[NSUserDefaults standardUserDefaults] valueForKey:@"eventNotiIds"];
    if (eventNotiIds.count > 0) {
        [notiIdArray addObjectsFromArray:eventNotiIds];
    }
    for (NSString *week in self.eventModel.weeks) {
        NSString *notiId = [NSString stringWithFormat:@"%@_%@", self.eventModel.ID, week];
        [ZBLocalNotification createLocalNotificationWithAttribute:
                                        @{ZBNotificationUserInfoName:notiId,
                                          ZBNotificationAlertTitle:@"闹钟",
                                          ZBNotificationAlertBody:self.eventModel.content,
                                          ZBNotificationFireDate:[startDate dateByAddingTimeInterval:24*60*60*[week integerValue]],
                                          ZBNotificationSoundName:ZBNotificationSoundAlarm,
                                          ZBNotificationRepeat:@(ZBLocalNotificationRepeatEveryWeek)}];
        BOOL isAdd = YES;
        for (NSString *tempId in notiIdArray) {
            if ([tempId isEqual:notiId]) {
                isAdd = NO;
            }
        }
        if (isAdd) {
            [notiIdArray addObject:notiId];
        }
    }
    [[NSUserDefaults standardUserDefaults] setValue:[notiIdArray copy] forKey:@"eventNotiIds"];
}

// 取消本地定时通知
-(void)cancelLocalNotification {
    NSMutableArray *notiIds = [NSMutableArray array];
    for (NSString *week in self.eventModel.weeks) {
        [notiIds addObject:[NSString stringWithFormat:@"%@_%@", self.eventModel.ID, week]];
    }
    [ZBLocalNotification cancelLocalNotificationWithNotiIds:[notiIds copy]];
}

@end
