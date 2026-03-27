//
//  ZYSearchVc.m
//  Community
//
//  Created by ZY on 2021/4/24.
//

#import "ZYSearchVc.h"
#import "ZYFriendVerifyVc.h"
#import "ZYChatUserInfoVc.h"
#import "ZYSearchFriendsCell.h"
//
#import "ChatManagerData.h"
//

static NSString * const searchFriendsCellID = @"ZYSearchFriendsCell";
#define kSearchFriendsCellHeight 66

@interface ZYSearchVc () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusHeightConstraint;

@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//
@property (nonatomic,strong) NSMutableArray *dataSourceArr;

@end

@implementation ZYSearchVc

- (void)viewDidLoad {//搜索昵称申请添加
    [super viewDidLoad];
    
    [self setUI];
    [self customTableView];
}

- (void)setUI {
    
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
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYSearchFriendsCell" bundle:nil] forCellReuseIdentifier:searchFriendsCellID];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    return 3;
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYSearchFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:searchFriendsCellID forIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
    cell.addView.tag = 200 + indexPath.row;
    [cell.addView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addFriendView:)]];
    [cell fillDataWithDic:self.dataSourceArr[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kSearchFriendsCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%ld", indexPath.row);
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary: self.dataSourceArr[indexPath.row]];
    BOOL isOnline = NO;
    if ([[dic allKeys]containsObject:@"state"]) {//在线状态
        isOnline = [dic[@"state"] boolValue];
    }
    ZYChatUserInfoVc *vc = [[ZYChatUserInfoVc alloc] init];
    ChatUserModel *model = [ChatUserModel mj_objectWithKeyValues:dic];
    vc.imId = model.imId;//
//    vc.isFriendState = agreeS;//内层处理
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 处理点击事件
// 取消
- (IBAction)cancelButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 添加朋友
- (void)addFriendView:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag-200;
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary: self.dataSourceArr[index]];
 
    if ([[dic allKeys]containsObject:@"state"]) {
         BOOL isOnline = [dic[@"state"] boolValue];
    }
    ChatUserModel *model = [ChatUserModel mj_objectWithKeyValues:self.dataSourceArr[index]];
    ZYFriendVerifyVc *vc = [[ZYFriendVerifyVc alloc] init];
    vc.userModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark === searchTF

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length>0) {
        WEAKSELF
        [ChatManagerData chatSeatchPersonWithNickName:textField.text withBlock:^(NSArray * arr, BOOL success) {
            if (success) {
                weakSelf.dataSourceArr = [[NSMutableArray alloc]initWithArray:arr];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }
        }];
    }
}

#pragma mark ==
- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc]init];
    }
    return _dataSourceArr;
}
@end
