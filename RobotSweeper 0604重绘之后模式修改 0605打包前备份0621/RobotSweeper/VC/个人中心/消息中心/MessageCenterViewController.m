//
//  MessageCenterViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/6/19.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "MessageCenterTableViewCell.h"
#import "MapMsgLocalizeStrChangeTool.h"//国际化

@interface MessageCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) int pageNo;

@property (nonatomic,assign) int pageSize;

@property (nonatomic,assign) int allListCount;
@property (nonatomic,strong)NSMutableArray *arrOfRobotMessage;
@property (nonatomic,strong)NSMutableArray *arrOfSystemMessage;
@property (nonatomic,strong)UITableView *tableViewOfMessageCenter;

@property (nonatomic,strong) UIView *topBackView;
@property (nonatomic,strong) UIButton *topOneBtn;
@property (nonatomic,strong) UIButton *topTwoBtn;
@end

@implementation MessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = NSLocalizedString(@"消息中心",nil);
     self.view.backgroundColor = [UIColor whiteColor];
    self.topOneBtn.selected = YES;
    self.topTwoBtn.selected = NO;
     _pageSize = 15;
     _pageNo = 1;
    
     [self initView];
 
   
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //初始
    [_tableViewOfMessageCenter.mj_header beginRefreshing];
}
//page1
- (void)refreshLoad{
  
    _pageNo = 1;
    
     NSString *url = @"";
    if (_topOneBtn.selected) {
        url = S_getEquNews;
    }else{
        url = S_getEquNews;
    }
    //暂无url
 
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",_pageNo],@"page",[ShareUser sharedUserInfo].userMode.userNameNoSuffix,@"userPhone",[NSString stringWithFormat:@"%d",_pageSize],@"limit", nil];
    [[ToolOfNetWork sharedTools]YrequestGetURL:url withParams:parms finished:^(id responsObject, NSError *error) {
        
        [MBProgressHUD hideHUD];
        [_tableViewOfMessageCenter.mj_header endRefreshing];
        [_tableViewOfMessageCenter.mj_footer endRefreshing];
        
        if (_Success) {

            NSArray *arr = [NSArray arrayWithArray:responsObject[@"list"]];
            if (arr.count==0) {
                
                _tableViewOfMessageCenter.mj_footer.hidden = YES;
            }else{
                _pageNo+=1;
                _allListCount = [[NSString stringWithFormat:@"%@",responsObject[@"AllCount"]] intValue];
                _tableViewOfMessageCenter.mj_footer.hidden = NO;
            }
            if (_topOneBtn.selected) {
                _arrOfRobotMessage = [NSMutableArray arrayWithArray:arr];
            }else{
                _arrOfSystemMessage = [NSMutableArray arrayWithArray:arr];
            }
            [_tableViewOfMessageCenter reloadData];
//            [self.view makeToast:[NSString stringWithFormat:@"%@",responsObject[@"msg"]] duration:1.5 position:@"bottom"];
            //查询到15条数据
            NSString *msg = NSLocalizedString(@"查询消息记录成功", nil) ;
            [self.view makeToast:msg duration:1.5 position:@"bottom"];
            
        }else{
            //            [self.view makeToast:[NSString stringWithFormat:@"%@",responsObject[@"msg"]] duration:1.5 position:@"bottom"];
             NSString *msg = NSLocalizedString(@"查询消息记录失败", nil) ;
            if (_SuccessOrErrCode==400) {
                
                msg = NSLocalizedString(@"用户名不能为空", nil);
            }else if (_SuccessOrErrCode==401){
                 msg = NSLocalizedString(@"暂无设备消息", nil);
                if (_topOneBtn.selected) {
                    _arrOfRobotMessage = [[NSMutableArray alloc]init];
                }else{
                    _arrOfSystemMessage = [[NSMutableArray alloc]init];
                }
                 [_tableViewOfMessageCenter reloadData];
            }
            [self.view makeToast:msg duration:1.5 position:@"bottom"];
        
        }
    }];
    
}

- (BOOL)canAdd{
    //上拉刷行时 判断是否为最后一页 若是最后一页则不做请求数据
//    _allListCount = 30;//测试数据
    int listOne = _allListCount/_pageSize;
    int listTwo = (_allListCount%_pageSize) >0 ? 1 : 0;
    int allPageCount = listOne+listTwo;
    NSLog(@"%d + %d  = allPageCount = %d",listOne,listTwo,allPageCount);

    if (allPageCount<=_pageNo-1) {//在每次得到数据后page+1过，是下次页数。
        return NO;
    }else{
        return YES;
    }
}
//pageNo !=1；
- (void)refreshAdd{
    
    
    [_tableViewOfMessageCenter.mj_footer beginRefreshing];
     NSString *url = @"";
    if (_topOneBtn.selected) {
        url = S_getEquNews;
    }else{
        url = S_getEquNews;
    }
    //暂无url
    
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",_pageNo],@"page",[ShareUser sharedUserInfo].userMode.userNameNoSuffix,@"userPhone",[NSString stringWithFormat:@"%d",_pageSize],@"limit", nil];
    [[ToolOfNetWork sharedTools]YrequestGetURL:url withParams:parms finished:^(id responsObject, NSError *error) {
        
        [MBProgressHUD hideHUD];
        [_tableViewOfMessageCenter.mj_header endRefreshing];
        [_tableViewOfMessageCenter.mj_footer endRefreshing];
        
        if (_Success) {
            NSArray *arr = [NSArray arrayWithArray:responsObject[@"list"]];
            if (arr.count==0) {
                _tableViewOfMessageCenter.mj_footer.hidden = YES;
            }else{
                _pageNo+=1;
                _allListCount = [[NSString stringWithFormat:@"%@",responsObject[@"AllCount"]] intValue];
                _tableViewOfMessageCenter.mj_footer.hidden = NO;
            }
            if (_topOneBtn.selected) {
                [_arrOfRobotMessage addObjectsFromArray:[NSMutableArray arrayWithArray:arr]];
                
            }else{
                [_arrOfSystemMessage addObjectsFromArray:[NSMutableArray arrayWithArray:arr]];
            }
          
            NSString *msg = NSLocalizedString(@"查询消息记录成功", nil) ;
            [self.view makeToast:msg duration:1.5 position:@"bottom"];
            [_tableViewOfMessageCenter reloadData];
        }else{
            //            [self.view makeToast:[NSString stringWithFormat:@"%@",responsObject[@"msg"]] duration:1.5 position:@"bottom"];
            NSString *msg = NSLocalizedString(@"查询消息记录失败", nil) ;
            if (_SuccessOrErrCode==400) {
                
                msg = NSLocalizedString(@"用户名不能为空", nil);
            }else if (_SuccessOrErrCode==401){
                msg = NSLocalizedString(@"暂无设备消息", nil);
            }
            [self.view makeToast:msg duration:1.5 position:@"bottom"];
            
        }
    }];
    
}

#pragma mark -- view
- (void)initView{
    //
    [self initRightItem];
    //
     [self.view addSubview:self.topBackView];
     [self.topBackView addSubview:self.topOneBtn];
     [self.topBackView addSubview:self.topTwoBtn];
     [self.view addSubview:self.tableViewOfMessageCenter];
     [self ys];
    self.tableViewOfMessageCenter.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if ([ToolOfBasic currentNetworkStatus]) {
            [self refreshLoad];
            [MBProgressHUD showMessage:NSLocalizedString(@"正在加载", nil) ];
        }else{
            [MBProgressHUD showError:NSLocalizedString(@"网络异常,请检查您的网络设置!", nil) ];
        }
    }];
    
    self.tableViewOfMessageCenter.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if ([ToolOfBasic currentNetworkStatus]) {
            if (![self canAdd]) {//判断是否数据已是最后一页
                [self.view makeToast:NSLocalizedString(@"暂无其他数据", nil)  duration:1.0 position:@"center"];
                [_tableViewOfMessageCenter.mj_header endRefreshing];
                [_tableViewOfMessageCenter.mj_footer endRefreshing];
                return;
            }else{
                [self refreshAdd];
                [MBProgressHUD showMessage:NSLocalizedString(@"正在加载",nil)];
            }
            
        }else{
            [MBProgressHUD showError:NSLocalizedString(@"网络异常,请检查您的网络设置!", nil) ];
        }
    }];
   
}
- (void)initRightItem{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(rightItemAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)rightItemAction:(UIBarButtonItem *)sender{
    //弹出框
    
    NSString *strOfTitle = NSLocalizedString(@"删除", nil);
  
    NSString *strOfMessage = NSLocalizedString(@"全部设备信息将被删除",nil);
    if (_topOneBtn.selected) {
        strOfMessage = NSLocalizedString(@"全部设备信息将被删除",nil);
    }else{
        strOfMessage = NSLocalizedString(@"全部系统消息将被删除",nil);
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:strOfTitle message:strOfMessage  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deletAllAction];
    }];
    [alert addAction:noAction];
    [alert addAction:okAction];
 
    alert.view.tintColor = [DataManager shareDataManager].colorOfMainType;
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void)deletAllAction{
    NSString *urlOfallDelet = S_removeAll;
    if (_topOneBtn.selected) {
        urlOfallDelet = S_removeAll;
        if(_arrOfRobotMessage.count == 0){
            [self.view makeToast:NSLocalizedString(@"当前设备信息,已为空",nil) duration:2 position:@"center"];
            return;
        }
    }else{
        return;
//        urlOfallDelet = S_removeAll;
//        [self.view makeToast:@"当前系统消息,已为空" duration:2 position:@"center"];
//        return;
    }
    //删除当前组的全部数据
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithObjectsAndKeys:[ShareUser sharedUserInfo].userMode.userNameNoSuffix,@"userPhone", nil];
    [[ToolOfNetWork sharedTools]YrequestDeleteURL:urlOfallDelet withParams:parm finished:^(id responsObject, NSError *error) {
 
          NSLog(@"removeall=%@",responsObject);
        if (_Success) {
            NSString *msg = NSLocalizedString(@"删除成功", nil) ;
            [self.view makeToast:msg duration:2 position:@"center"];
            [self refreshLoad];
            [_tableViewOfMessageCenter reloadData];
        }else{
            NSString *msg = NSLocalizedString(@"删除失败", nil);
            if (_SuccessOrErrCode == 400) {
//                msg = NSLocalizedString(@"删除失败", nil);
                msg = NSLocalizedString(@"删除失败，请稍后重试", nil);
            }else if (_SuccessOrErrCode == 401){
                msg = NSLocalizedString(@"用户名不能为空", nil);
            }else if (_SuccessOrErrCode==402){
                msg = NSLocalizedString(@"没有找到该用户", nil);
            }
            [self.view makeToast:msg duration:2 position:@"center"];
        }
    }];
}
#pragma mark -- 删除一个cell
- (void)deletOneCell:(NSIndexPath *)indexPath{
    NSString *urlOfOneDelet = S_remove;
    NSString *mGuid = @"";
    if (_topOneBtn.selected) {
        //设备消息
        urlOfOneDelet = S_remove;
       NSDictionary *dicOfWillDelet = [NSDictionary dictionaryWithDictionary: _arrOfRobotMessage[indexPath.row]];
        if ([[dicOfWillDelet allKeys] containsObject:@"mGuid"]) {//消息编号
            mGuid = [NSString stringWithFormat:@"%@",[dicOfWillDelet objectForKey:@"mGuid"]];
        }
 
    }else{//系统消息

    }
    //删除当前组的全部数据
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithObjectsAndKeys:mGuid,@"mGuid", nil];
    [[ToolOfNetWork sharedTools]YrequestDeleteURL:urlOfOneDelet withParams:parm finished:^(id responsObject, NSError *error) {
//        NSString *msg = [responsObject objectForKey:@"msg"];
//        [self.view makeToast:msg duration:3 position:@"center"];
        if (_Success) {
            NSString *msg = NSLocalizedString(@"删除成功", nil) ;
            [self.view makeToast:msg duration:2 position:@"center"];
            if (_topOneBtn.selected) {
                [_arrOfRobotMessage removeObjectAtIndex:indexPath.row];
            }else{
                [_arrOfSystemMessage removeObjectAtIndex:indexPath.row];
            }
            [_tableViewOfMessageCenter reloadData];
        }else{
            NSString *msg = NSLocalizedString(@"删除失败", nil);
            if (_SuccessOrErrCode == 400) {
//                msg = NSLocalizedString(@"删除失败", nil);
                 msg = NSLocalizedString(@"删除失败，请稍后重试", nil);
            }else if (_SuccessOrErrCode == 401){
                msg = NSLocalizedString(@"当前删除条目id为空", nil);//guid不能为空
            }
            [self.view makeToast:msg duration:2 position:@"center"];
        }
    }];
}

#pragma mark -- 约束
- (void)ys{
    
    [_topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width).offset(0);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(Y_getRectNavAndStatusHight);
        make.height.offset(50);
    }];
    [_topOneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_topBackView.mas_width).multipliedBy(0.5);
        make.left.equalTo(_topBackView.mas_left);
        make.centerY.equalTo(_topBackView);
        make.height.offset(50);
    }];
    [_topTwoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_topBackView.mas_width).multipliedBy(0.5);
        make.right.equalTo(_topBackView.mas_right);
        make.centerY.equalTo(_topBackView);
        make.height.offset(50);
    }];
    [_tableViewOfMessageCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width).offset(-20);
        make.centerX.equalTo(self.view);
        make.top.equalTo(_topBackView.mas_bottom).offset(2);
        make.bottom.equalTo(self.view.mas_bottom).offset(10);
    }];
}

#pragma mark -- topBtnAction
- (void)topBtnAction:(UIButton *)sender{
    if(sender.tag-TAG_BTN_C==1){//扫地机消息
        _topOneBtn.selected = YES;
        _topTwoBtn.selected = NO;
        _topOneBtn.backgroundColor = Y_RGB(130, 130, 130);
        _topTwoBtn.backgroundColor = [UIColor clearColor];
        _pageNo = 1;
        _allListCount = 0;
        [self refreshLoad];
        _tableViewOfMessageCenter.contentOffset = CGPointMake(0, 0);

        NSLog(@"扫地机消息");
        
    }else{//系统消息
        [self.view makeToast:NSLocalizedString(@"暂无系统消息功能", nil)  duration:1.5 position:@"center"];
        return;
        //有系统消息后会去掉上面的弹出框
        _topTwoBtn.selected = YES;
        _topOneBtn.selected = NO;
        _topTwoBtn.backgroundColor = Y_RGB(130, 130, 130);
        _topOneBtn.backgroundColor = [UIColor clearColor];
        _pageNo = 1;
        _allListCount = 0;
        [self refreshLoad];
        _tableViewOfMessageCenter.contentOffset = CGPointMake(0, 0);
        NSLog(@"系统消息");
//        NSLog(@"%f",  self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_topOneBtn.selected) {
        return _arrOfRobotMessage.count;
    }else{
        return _arrOfSystemMessage.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageCenterTableViewCell *cell = [[MessageCenterTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MessageCenterTableViewCell"];
    if (_topOneBtn.selected) {//_arrOfRobotMessage
//        cell.mainLabel.text = [_arrOfRobotMessage[indexPath.row] objectForKey:@"mContent"];
        //国际化
//        cell.mainLabel.text = NSLocalizedString([_arrOfRobotMessage[indexPath.row] objectForKey:@"mContent"], nil) ;
        if ([ToolOfBasic haveChinese:[_arrOfRobotMessage[indexPath.row] objectForKey:@"mContent"]]) {//中文
             cell.mainLabel.text = NSLocalizedString([_arrOfRobotMessage[indexPath.row] objectForKey:@"mContent"], nil) ;
        }else{//数据类型
            cell.mainLabel.text = [MapMsgLocalizeStrChangeTool localizeCodeMsgWithIntStr:[_arrOfRobotMessage[indexPath.row] objectForKey:@"mContent"]];
        }
       
        
        cell.subLabel.text = [_arrOfRobotMessage[indexPath.row] objectForKey:@"nickName"];
        cell.timeLabel.text = [[NSString stringWithFormat:@"%@",[_arrOfRobotMessage[indexPath.row] objectForKey:@"mTime"]] substringToIndex:16]; //mTime
        
    }else{
        cell.mainLabel.text = NSLocalizedString([_arrOfRobotMessage[indexPath.row] objectForKey:@"mContent"], nil) ;
        cell.subLabel.text = [_arrOfSystemMessage[indexPath.row] objectForKey:@"nickName"];
        cell.timeLabel.text = [[NSString stringWithFormat:@"%@",[_arrOfSystemMessage[indexPath.row] objectForKey:@"mTime"]] substringToIndex:16]; //mTime
//        cell.mainLabel.text = @"err";
//        cell.subLabel.text = @"昵称";
//        cell.timeLabel.text = @"2018-00-00-00-00";
        
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //
        [self deletOneCell:indexPath];
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NSLocalizedString(@"删除", nil);
    
}



#pragma mark -- getter
- (UIView *)topBackView{
    if (!_topBackView) {
        _topBackView = [[UIView alloc]init];
    }
    return _topBackView;
}

- (UIButton *)topOneBtn{
    if (!_topOneBtn) {
        _topOneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topOneBtn setTitle:NSLocalizedString(@"设备信息",nil) forState:UIControlStateNormal];
        [_topOneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_topOneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _topOneBtn.backgroundColor = Y_RGB(130, 130, 130);;
        [_topOneBtn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _topOneBtn.tag = TAG_BTN_C+1;
    }
    return _topOneBtn;
}
- (UIButton *)topTwoBtn{
    if (!_topTwoBtn) {
        _topTwoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topTwoBtn setTitle:NSLocalizedString(@"系统消息",nil) forState:UIControlStateNormal];
        [_topTwoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_topTwoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_topTwoBtn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _topTwoBtn.tag = TAG_BTN_C+2;
    }
    return _topTwoBtn;
}

- (UITableView *)tableViewOfMessageCenter{
    if (!_tableViewOfMessageCenter) {
        _tableViewOfMessageCenter = [[UITableView alloc]init];
        _tableViewOfMessageCenter.delegate = self;
        _tableViewOfMessageCenter.dataSource  = self;
        _tableViewOfMessageCenter.tableFooterView = [UIView new];
        
    }
    return _tableViewOfMessageCenter;
}

@end
