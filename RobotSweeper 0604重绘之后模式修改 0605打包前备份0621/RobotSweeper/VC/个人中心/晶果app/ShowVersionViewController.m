//
//  ShowVersionViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/6/13.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import "ShowVersionViewController.h"
#import "CopyrightInfoViewController.h"
#import "AppVersionInfoListTableViewController.h"

@interface ShowVersionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIImageView *imgv;
@property (nonatomic,strong) UIButton *oneOfVersionBtn;
@property (nonatomic,strong) UILabel *oneOfVersionLabel;

@property (nonatomic,strong)UITableView *tableV;

@property (nonatomic,strong) NSString *strOfName;
@property (nonatomic,strong) NSString *strOfVersion;
@property (nonatomic,strong) NSString *strOfBuild;

@property (nonatomic,strong) NSString *strOfItunesVersion;
@property (nonatomic,assign) BOOL isCanUp;
@end

@implementation ShowVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"版本", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    
    [self initView];
    // Do any additional setup after loading the view.
}
- (void)initData{
    _isCanUp = NO;
    _strOfName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    _strOfVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    _strOfBuild =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    //
    [self noticeHttpGetNewVInfo];
}
#pragma mark -- 让后台请求版本数据 
- (void)noticeHttpGetNewVInfo{
     [[ToolOfNetWork sharedTools]endXml];
    //post @{@"url":@"https://itunes.apple.com/lookup?id=1294153308"}.mutableCopy
    [[ToolOfNetWork sharedTools]YrequestURL:S_insertIOSLogByURL withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        
        if (_Success) {
            NSLog(@"更新列表成功,%@",responsObject);
        }else{
            NSLog(@"更新列表失败,%@",responsObject);
        }
    }];
    /**
     @"https://itunes.apple.com/cn/lookup?id=1294153308"
     @"https://itunes.apple.com/en/lookup?id=1294153308"
     @"http://itunes.apple.com/lookup?id=1294153308&country=cn"
     @"http://itunes.apple.com/lookup?id=1294153308&country=us"
     */
   
    
}


#pragma mark -- view
- (void)initView{
    self.view.backgroundColor = [DataManager shareDataManager].colorOfGroupGrayBack;
    //
    [self.view addSubview:self.imgv];
    _imgv.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.tableV];
    [self getYs];
    //    [self.view addSubview:self.oneOfVersionBtn];
    //    [self.view addSubview:self.oneOfVersionLabel];
    //    [self getNewYs];
}

#pragma mark -- //判断是否升级
- (void)comVersion{
    if (_strOfItunesVersion.length>0) {
        //可以比较 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
        
        NSInteger i =  [ToolOfBasic itunesVersionAndAppVersionCompareVersion:_strOfItunesVersion to:_strOfVersion];
        if (i == 1) {//v》v2返回1  v1<v2返回-1 1则商店版更大 -1则当前版更大
            //可以更新
            _isCanUp = YES;
            [_tableV reloadData];
        }else{
            
        }
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- tableV
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;//1220新增
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
   
    if (indexPath.row==0) {
        cell.textLabel.text = NSLocalizedString(@"当前版本",nil);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"V%@",_strOfVersion];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else if(indexPath.row==1){
        cell.textLabel.text = NSLocalizedString(@"版权信息",nil);
        cell.detailTextLabel.text = @"";
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.textLabel.text = NSLocalizedString(@"客户端更新日志",nil);
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}
#pragma mark -- didselect
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        // [self showAlertV]; //不弹出提示框
    }else if(indexPath.row==1){
        CopyrightInfoViewController *copyrightInfo = [[CopyrightInfoViewController alloc]init];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        [self.navigationController pushViewController:copyrightInfo animated:YES];
    }else{
        AppVersionInfoListTableViewController *appVersionInfoList = [[AppVersionInfoListTableViewController alloc]init];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        [self.navigationController pushViewController:appVersionInfoList animated:YES];
    }
}
- (void)showAlertV{
    
    
}
#pragma mark -- ys
- (void)getYs{
    [_imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(100);
        make.width.offset(100);
        make.height.offset(100);
    }];
    [_tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.imgv.mas_bottom).offset(10);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
    }];
}

#pragma mark -- getter
- (UITableView *)tableV{
    if (!_tableV) {
        _tableV = [[UITableView alloc]init];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.tableFooterView = [UIView new];
        _tableV.backgroundColor = [UIColor clearColor];
        
    }
    return _tableV;
}

#pragma mark -- 暂不用这个view
- (void)getNewYs{
    [_imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(100);
        make.width.offset(80);
        make.height.offset(80);
    }];
    [_oneOfVersionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.imgv.mas_bottom).offset(10);
        make.width.equalTo(self.view.mas_width);
        make.height.offset(50);
    }];
    [_oneOfVersionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(_oneOfVersionBtn);
        make.width.offset(100);
        make.left.equalTo(_oneOfVersionBtn.mas_left).offset(10);
        make.height.offset(22);
    }];
    
}
- (UIImageView *)imgv{
    if (!_imgv) {
        _imgv = [[UIImageView alloc]init];
        _imgv.layer.cornerRadius = 40;
        _imgv.image = [UIImage imageNamed:[DataManager shareDataManager].homeCellImgNameStr];
    }
    return _imgv;
}

- (UIButton *)oneOfVersionBtn{
    if (!_oneOfVersionBtn) {
        
        _oneOfVersionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_oneOfVersionBtn setTitle:[NSString stringWithFormat:@"APP版本：V%@",_strOfVersion]forState:UIControlStateNormal];//正式版
        [_oneOfVersionBtn setTintColor:[UIColor lightGrayColor]];
        [_oneOfVersionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _oneOfVersionBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        //         [_oneOfVersionBtn setTitle:[NSString stringWithFormat:@"APP内测版：V%@ (beta)",_strOfVersion]forState:UIControlStateNormal];//测试版
        _oneOfVersionBtn.backgroundColor = [UIColor whiteColor];
    }
    return _oneOfVersionBtn;
    
}

- (UILabel *)oneOfVersionLabel{
    if (!_oneOfVersionLabel) {
        _oneOfVersionLabel = [[UILabel alloc]init];
        _oneOfVersionLabel.text = @"检查更新";
    }
    
    return _oneOfVersionLabel;
}
@end

