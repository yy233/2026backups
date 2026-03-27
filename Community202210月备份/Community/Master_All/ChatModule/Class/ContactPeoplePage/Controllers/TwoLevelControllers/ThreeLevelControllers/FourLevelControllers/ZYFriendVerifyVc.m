//
//  ZYFriendVerifyVc.m
//  Community
//
//  Created by ZY on 2021/4/24.
//

#import "ZYFriendVerifyVc.h"
#import "ZYFriendVerifyCell.h"
//
#import "ChatManagerData.h"
//

static NSString * const friendVerifyCellID = @"ZYFriendVerifyCell";
#define kFriendVerifyCellHeight 350

@interface ZYFriendVerifyVc () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusHeightConstraint;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSString *verifyMessageStr;
@property (nonatomic,strong) NSString *friendRemark;

@end

@implementation ZYFriendVerifyVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.verifyMessageStr = @"";
    self.friendRemark = @"";
    [self setUI];
    [self customTableView];
}

- (void)setUI {
    
    self.statusHeightConstraint.constant = status_height;
}

#pragma mark - 定制TableView
- (void)customTableView {
    
    // 防止tableView刷新漂移问题
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    // 设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // 注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYFriendVerifyCell" bundle:nil] forCellReuseIdentifier:friendVerifyCellID];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYFriendVerifyCell *cell = [tableView dequeueReusableCellWithIdentifier:friendVerifyCellID forIndexPath:indexPath];
    cell.verifyTextView.tag = 200;
    cell.verifyTextView.delegate = self;
    cell.remarkTextView.tag = 300;
    cell.remarkTextView.delegate = self;
    [cell.sendButton addTarget:self action:@selector(sendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kFriendVerifyCellHeight;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.tag == 200) {
        
        NSLog(@"验证信息：%@", textView.text);
        self.verifyMessageStr = textView.text;
    }else {
        
        NSLog(@"设置备注：%@", textView.text);
        self.friendRemark = textView.text;
    }
}

#pragma mark - 处理点击事件
// 取消
- (IBAction)cancelButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 发送
- (void)sendButtonClicked {
    NSLog(@"发送好友请求");
    //好友验证页 self.userModel.otherAccount 改为他人的imid
    [ChatManagerData addFriendWithFriendImIdStr:self.userModel.imId withVerifyMessage:self.verifyMessageStr withFriendRemark:self.friendRemark];
    [self performSelector:@selector(delayPop) withObject:nil/*可传任意类型参数*/ afterDelay:1.0];
}
- (void)delayPop{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
