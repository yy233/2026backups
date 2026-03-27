//
//  ZYAddGroupFriendVc.m
//  Community
//
//  Created by ZY on 2021/4/24.
//

#import "ZYAddGroupFriendVc.h"
#import "ZYAddGroupFriendCell.h"
//
#import "ChatManagerData.h"
//

static NSString * const addGroupFriendCellID = @"ZYAddGroupFriendCell";
#define kAddGroupFriendCellHeight 66

@interface ZYAddGroupFriendVc () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusHeightConstraint;

@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//底部完成按钮View
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
//列表数据
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
//选择的状态存储arr
@property (nonatomic,strong) NSMutableArray *saveSelectedTypeArr;
@end

@implementation ZYAddGroupFriendVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self customTableView];
    [self initData];
    [self addRefresh];
}
 
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    self.tableView.mj_header = headeerRefresh;
}
- (void)initData{//好友数据 用于建组
//    0913 获取好友列表 改为 获取全部联系人列表
    WEAKSELF
    STRONGSELF
    [ChatManagerData getFriendInfoListWithBlcok:^(NSArray * arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            //
            strongSelf.dataSourceArr = [NSMutableArray arrayWithArray:arr];
        
            //
            for (int i = 0 ; i < strongSelf.dataSourceArr.count; i++) {
                if (i == 0) {
                    strongSelf.saveSelectedTypeArr  = [[NSMutableArray alloc]init];
                }
                [strongSelf.saveSelectedTypeArr addObject:@(0)];
            }
            //
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
            });
        }
        
    }];
}
- (void)setUI {
    
    // pop返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.statusHeightConstraint.constant = status_height;
    self.searchTF.delegate = self;
}

#pragma mark - 定制TableView
- (void)customTableView {
    
    self.tableView.tableFooterView= [[UIView alloc] init];
    // 防止tableView刷新漂移问题
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    // 设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // 注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYAddGroupFriendCell" bundle:nil] forCellReuseIdentifier:addGroupFriendCellID];
 
    [self initFooterView];
}
- (void)initFooterView{
    [self.view addSubview:self.footerView];
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSourceArr.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYAddGroupFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:addGroupFriendCellID forIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:self.dataSourceArr[indexPath.row]];
    [cell fillCellWithDic:dic];
    [cell leftSelectedImgTypeIsSelected:[self.saveSelectedTypeArr[indexPath.row] boolValue]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kAddGroupFriendCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%ld", indexPath.row);
    //选择后建群
    
    if ([self.saveSelectedTypeArr[indexPath.row] boolValue] == 0) {
        [self.saveSelectedTypeArr replaceObjectAtIndex:indexPath.row withObject:@(1)];
    }else{
        [self.saveSelectedTypeArr replaceObjectAtIndex:indexPath.row withObject:@(0)];
    }
    [UIView performWithoutAnimation:^{
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - 处理点击事件
- (IBAction)backButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc]init];
    }
    return _dataSourceArr;
}
- (NSMutableArray *)saveSelectedTypeArr{
    if (!_saveSelectedTypeArr) {
        _saveSelectedTypeArr = [[NSMutableArray alloc]init];
    }
    return _saveSelectedTypeArr;
}
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, Screen_H-50+2, Screen_W+2, 50)];
        _footerView.layer.cornerRadius = 0.5;
        _footerView.layer.borderWidth = 0.5;
        _footerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _footerView.backgroundColor = [UIColor whiteColor];
        [_footerView setBtnFramWithNotCenterxIsCenteryOfMasWithFram:CGRectMake(Screen_W-100, 10, 65, 33)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"完成"];
        [_footerView.footerBtn addTarget:self action:@selector(footerOkBtnAction) forControlEvents: UIControlEventTouchUpInside];
    }
    return _footerView;
}

#pragma mark ==
- (void)changeFooterBtnText{
//    self.saveSelectedTypeArr
}
#pragma mark == footerOkBtnAction
- (void)footerOkBtnAction{
    DLog(@"");
    Y_SVP_SHOW_ERR_MES(@"创建群组功能暂未开放!");
    return;
    //_____这版本先不做群
    if ([self.saveSelectedTypeArr containsObject:@(1)]) {
        [self setGroupNameAction];
    }else{
        Y_SVP_SHOW_ERR_MES(@"请选择好友，单个用户暂不能独自创建群！");
    }
}
// 要填写备注的同意
- (void)setGroupNameAction{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"设置群名" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入";
    }];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *Action) {
            UITextField *textField = alertVC.textFields.firstObject;
            NSLog(@"%@",textField.text);
            //调用方法
        //    //test
        [self creatAnGroupWithSetGroupName:textField.text];
    }];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:okButton];
    [alertVC addAction:cancelButton];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}



- (void)creatAnGroupWithSetGroupName:(NSString *)groupNameStr{
    Y_SVP_SHOW_MES_IsDealing_15Delay
    NSMutableArray  *groupWillCreatWithMemberUUIDArr = [[NSMutableArray alloc]init];
    for ( int i = 0; i < self.saveSelectedTypeArr.count; i ++) {
        NSNumber *selectedTypeNum =  self.saveSelectedTypeArr[i];
        if ([selectedTypeNum isEqualToNumber:@(1)]) {
//            NSString *uuid = [[self.dataSourceArr[i] allKeys]containsObject:@"userUuid"] ? [self.dataSourceArr[i]  objectForKey:@"userUuid"] : @"";
            NSString *uuid = [[self.dataSourceArr[i] allKeys]containsObject:@"otherAccount"] ? [self.dataSourceArr[i]  objectForKey:@"otherAccount"] : @"";
            if (uuid.length>0) {
                [groupWillCreatWithMemberUUIDArr addObject:uuid];
            }
        }
    }
    if (groupWillCreatWithMemberUUIDArr.count>0) {
        //带好友
        [ChatManagerData chatCreatGroupWithGroupName:groupNameStr withFriendsUuidArr:groupWillCreatWithMemberUUIDArr withDicBlock:^(NSDictionary * dic, BOOL success) {
            Y_SVP_DISMISS
            if (success) {
                DLog(@"建群成功");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
             }
        }];
    }else{
        //不带好友
        [ChatManagerData chatCreatGroupWithOnlyMeInfoWithGroupName:groupNameStr withDicBlock:^(NSDictionary * dic, BOOL success) {
            Y_SVP_DISMISS
            if (success) {
                DLog(@"建群成功");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });            }
        }];
    }
      
}

@end
