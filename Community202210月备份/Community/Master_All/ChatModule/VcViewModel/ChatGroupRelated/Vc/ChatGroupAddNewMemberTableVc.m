//
//  ChatGroupAddNewMemberTableVc.m
//  Community
//
//  Created by 余莹 on 2021/5/18.
//

#import "ChatGroupAddNewMemberTableVc.h"

#import "ZYAddGroupFriendCell.h"
//
#import "ChatManagerData.h"
//

static NSString * const addGroupFriendCellID = @"ZYAddGroupFriendCell";
#define kAddGroupFriendCellHeight 66

@interface ChatGroupAddNewMemberTableVc () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic,strong) UITableView *tableView;
//底部完成按钮View
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
//列表数据
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
//选择的状态存储arr
@property (nonatomic,strong) NSMutableArray *saveSelectedTypeArr;
@end

@implementation ChatGroupAddNewMemberTableVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
    [self addRefresh];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupsetupNavigationBarWithChatVcStyle];
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    self.tableView.mj_header = headeerRefresh;
}
- (void)initData{//好友数据 用于建组 待改 新接口
    WEAKSELF
    STRONGSELF
    [ChatManagerData chatGroupAddNewMemberWillExcludeGroupUserStayFriendWithGroupId:self.groupUUID withlistBlock:^(NSArray * arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            strongSelf.dataSourceArr = [NSMutableArray arrayWithArray:arr];
            for (int i = 0 ; i < strongSelf.dataSourceArr.count; i++) {
                if (i == 0) {
                    strongSelf.saveSelectedTypeArr  = [[NSMutableArray alloc]init];
                }
                [strongSelf.saveSelectedTypeArr addObject:@(0)];
            }
                dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
            });
        }
        
    }];
}
 
#pragma mark - 定制TableView
 
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

#pragma mark ===
- (void)initView{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_footerView.superview);
        make.height.offset(60);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_tableView.superview);
        make.bottom.equalTo(_footerView.mas_top);
    }];
}
//
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
- (UITableView *)tableView{
    if (!_tableView ) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView= [[UIView alloc] init];
        // 防止tableView刷新漂移问题
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        // 设置代理
        _tableView.dataSource = self;
        _tableView.delegate = self;
        // 注册单元格
        [_tableView registerNib:[UINib nibWithNibName:@"ZYAddGroupFriendCell" bundle:nil] forCellReuseIdentifier:addGroupFriendCellID];
    }
    return _tableView;
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
    
    
        Y_SVP_SHOW_MES_IsDealing_15Delay
        NSMutableArray  *groupWillCreatWithMemberUUIDArr = [[NSMutableArray alloc]init];
        for ( int i = 0; i < self.saveSelectedTypeArr.count; i ++) {
            NSNumber *selectedTypeNum =  self.saveSelectedTypeArr[i];
            if ([selectedTypeNum isEqualToNumber:@(1)]) {
//                NSString *uuid = [[self.dataSourceArr[i] allKeys]containsObject:@"userUuid"] ? [self.dataSourceArr[i]  objectForKey:@"userUuid"] : @"";//是自己的ID
                NSString *friendUuid = [[self.dataSourceArr[i] allKeys]containsObject:@"friendUuid"] ? [self.dataSourceArr[i]  objectForKey:@"friendUuid"] : @"";//是好友的ID
                if (friendUuid.length>0) {
                    [groupWillCreatWithMemberUUIDArr addObject:friendUuid];
                }
            }
        }
        if (groupWillCreatWithMemberUUIDArr.count>0) {
            //拉人进群
            [ChatManagerData chatAddOtherFriendIntoTheGroupWithGroupId:self.groupUUID WithOhterFriendIdArr:groupWillCreatWithMemberUUIDArr withDicBlock:^(NSDictionary * dic, BOOL success) {
                Y_SVP_DISMISS
                if (success) {
                    DLog(@"新增成员成功");
                    Y_NSNotificationCenter_PostNotice_NilObject_Name(ChatGroupAddOrDeletMember_NoticeName);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                 }
            }];
        }else{
            Y_SVP_SHOW_ERR_MES(@"请选择");
        }
    
    
    
//    [self setGroupNameAction];
       
   
}
//// 要填写备注的同意
//- (void)setGroupNameAction{
//
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"设置群名" preferredStyle:UIAlertControllerStyleAlert];
//    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//            textField.placeholder = @"请输入";
//    }];
//    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *Action) {
//            UITextField *textField = alertVC.textFields.firstObject;
//            NSLog(@"%@",textField.text);
//            //调用方法
//        //    //test
//        [self creatAnGroupWithSetGroupName:textField.text];
//    }];
//    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    [alertVC addAction:okButton];
//    [alertVC addAction:cancelButton];
//    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:alertVC animated:YES completion:nil];
//}
//
//
//
//- (void)creatAnGroupWithSetGroupName:(NSString *)groupNameStr{
//    Y_SVP_SHOW_MES_IsDealing_15Delay
//    NSMutableArray  *groupWillCreatWithMemberUUIDArr = [[NSMutableArray alloc]init];
//    for ( int i = 0; i < self.saveSelectedTypeArr.count; i ++) {
//        NSNumber *selectedTypeNum =  self.saveSelectedTypeArr[i];
//        if ([selectedTypeNum isEqualToNumber:@(1)]) {
//            NSString *uuid = [[self.dataSourceArr[i] allKeys]containsObject:@"userUuid"] ? [self.dataSourceArr[i]  objectForKey:@"userUuid"] : @"";
//            if (uuid.length>0) {
//                [groupWillCreatWithMemberUUIDArr addObject:uuid];
//            }
//        }
//    }
//    if (groupWillCreatWithMemberUUIDArr.count>0) {
//        //带好友
//        [ChatManagerData chatCreatGroupWithGroupName:groupNameStr withFriendsUuidArr:groupWillCreatWithMemberUUIDArr withDicBlock:^(NSDictionary * dic, BOOL success) {
//            Y_SVP_DISMISS
//            if (success) {
//                DLog(@"建群成功");
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.navigationController popViewControllerAnimated:YES];
//                });
//             }
//        }];
//    }else{
//        //不带好友
//        [ChatManagerData chatCreatGroupWithOnlyMeInfoWithGroupName:groupNameStr withDicBlock:^(NSDictionary * dic, BOOL success) {
//            Y_SVP_DISMISS
//            if (success) {
//                DLog(@"建群成功");
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.navigationController popViewControllerAnimated:YES];
//                });            }
//        }];
//    }
//
//}


@end
