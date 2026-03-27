//
//  ZYGroupChatVc.m
//  Community
//
//  Created by ZY on 2021/4/29.
//

#import "ZYGroupChatVc.h"
#import "ZYChatVc.h"
#import "ZYGroupChatCell.h"
//
#import "ChatManagerData.h"
//

static NSString * const groupChatCellID = @"ZYGroupChatCell";
#define kGroupChatCellHeight 70

@interface ZYGroupChatVc () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ZYGroupChatVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"群聊列表";
    [self customTableView];
    [self setUI];
    [self initData];
}

- (void)setUI {
    
    self.statusHeightConstraint.constant = status_height;
}

// 加载xib父类的视图
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    
    return self;
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = Y_RGBA(245, 245, 245, 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView= [[UIView alloc] init];
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
}

#pragma mark - 加载数据
- (void)initData {
    WEAKSELF
    [ChatManagerData chatGetAllGroupListWithBlock:^(NSArray * arr, BOOL success) {
        if (success) {
            weakSelf.dataArray = [NSMutableArray arrayWithArray:arr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}

#pragma mark - 定制TableView
- (void)customTableView {
    
    [self.contentView addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(_tableView.superview);
    }];
    // 防止tableView刷新漂移问题
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    // 设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // 注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYGroupChatCell" bundle:nil] forCellReuseIdentifier:groupChatCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYGroupChatCell *cell = [tableView dequeueReusableCellWithIdentifier:groupChatCellID forIndexPath:indexPath];
    NSDictionary *cellDic = [NSDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
    [cell fillCellWithDic:cellDic];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kGroupChatCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ZYChatVc *vc = [[ZYChatVc alloc] init];
    NSDictionary *cellDic = [NSDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
    NSLog(@"待处理组sessionID");
    [vc fillThisGroupTypeChatVcSubInfoWithClearnUseID:0 withSessionID:@"" withChatVcToUseType:ChatVc_Seesion_type_Group withGroupInfoDic:cellDic];
    [self.navigationController pushViewController:vc animated:YES];
    
//    test
    /**
 
    test 改群的名字
    if ([[dic allKeys]containsObject:@"groupUuid"]) {
        [self changeGroupName:@"2群新名字test0" withGroupId:dic[@"groupUuid"]];
    }
    //test 设置我在群里的备注
    if ([[dic allKeys]containsObject:@"groupUuid"]) {
        [self setGroupRemark:@"1群的_1818的号_备注1" withGroupId:dic[@"groupUuid"]];
    }
    test 查询群的全部成员
        if ([[dic allKeys]containsObject:@"groupUuid"]) {
            [self getGroupAllMemberListWithGroupId:dic[@"groupUuid"]];
        }
    test 群踢人 e5778bdaa9b747d5b6bb1d39c90a9ba7
    if ([[dic allKeys]containsObject:@"groupUuid"]) {
        [self  remoOneMemberWithMemberId:@"e5778bdaa9b747d5b6bb1d39c90a9ba7" withGroupId:dic[@"groupUuid"]];
    }
    test 拉人入群
    if ([[dic allKeys]containsObject:@"groupUuid"]) {
        [self addFriendToGroupWithMemberId:@"e5778bdaa9b747d5b6bb1d39c90a9ba7" withGroupId:dic[@"groupUuid"]];
    }
     */
 }

//改名设成员备注
- (void)changeGroupName:(NSString *)newGroupName withGroupId:(NSString *)groupId{
    [ChatManagerData chatGroupNameChangeWithNewNameStr:newGroupName withGroupId:groupId withDicBlock:^(NSDictionary * dic, BOOL success) {
        if(success){
            DLog(@"");
        }
    }];
}

- (void)setGroupRemark:(NSString *)groupRemark withGroupId:(NSString *)groupId{
    [ChatManagerData chatGroupSetRemarkWithRemarkStr:groupRemark withGroupId:groupId withDicBlock:^(NSDictionary * dic, BOOL success) {
        if(success){
            DLog(@"");
        }
    }];
}
/**
 *群成员查询
 */
- (void)getGroupAllMemberListWithGroupId:(NSString *)groupId{
    [ChatManagerData chatGroupAllMemberListWithGroupId:groupId withlistBlock:^(NSArray * arr, BOOL success) {
    
        if(success){
            DLog(@"");
            /**
             {
                 avatar = "2021-02-10/9ac8268a449443c4bff6c3f88775d147-1612951479379.jpg";
                 groupUuid = 20235b866d9f47bfbed4dbedf5ebe41b;
                 identity = 3;
                 remarks = "\U54c8\U54c877";
                 userJoinTime = "2021-05-06T14:18:17";
                 userUuid = e5778bdaa9b747d5b6bb1d39c90a9ba7;
             },
             {
                 avatar = "2021-02-10/9ac8268a449443c4bff6c3f88775d147-1612951479379.jpg";
                 groupUuid = 20235b866d9f47bfbed4dbedf5ebe41b;
                 identity = 1;
                 remarks = "1\U7fa4\U7684_1818\U7684\U53f7_\U5907\U6ce81";
                 userJoinTime = "2021-05-06T14:18:17";
                 userUuid = 2a314f0322884e1b927e89a636ac0ec2;
             }
             )
             */
        }
    }];
}

/**
 群 踢人
 */
- (void)remoOneMemberWithMemberId:(NSString *)groupMemberUUID withGroupId:(NSString *)groupId{
    [ChatManagerData chatGroupRemoveMemberWithGroupId:groupId withMemberIdArr:@[groupMemberUUID].mutableCopy withBlock:^(NSDictionary * dic, BOOL success) {
        if(success){
            DLog(@"");
        }
    }];
}
/**
 拉人入群
 */
 
- (void)addFriendToGroupWithMemberId:(NSString *)groupMemberUUID withGroupId:(NSString *)groupId{
    [ChatManagerData  chatAddOtherFriendIntoTheGroupWithGroupId:groupId WithOhterFriendIdArr:@[groupMemberUUID].mutableCopy withDicBlock:^(NSDictionary * dic, BOOL success) {
        if(success){
            DLog(@"");
        }
    }];
}

// 单元格编辑样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

//Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    return YES;
    return NO;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - 返回
- (void)backButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
