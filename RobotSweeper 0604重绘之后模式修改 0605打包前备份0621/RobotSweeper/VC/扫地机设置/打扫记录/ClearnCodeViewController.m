//
//  ClearnCodeViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/5/10.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import "ClearnCodeViewController.h"
#import "ClearnMapDetailsViewController.h"
#import "CleanCodeTableViewCell.h"

@interface ClearnCodeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIView *bacViewOfTop;
@property (nonatomic,strong) UIView *bacViewOfHeader;
@property (nonatomic,strong) UITableView *tableViewOfClearnCode;
@property (nonatomic,strong) NSMutableArray *arrOfClearnCode;//请求得到的
@property (nonatomic,strong) NSMutableArray *arrOfClearnCodeStr;//拼接的

//topsubv
@property (nonatomic,strong) UIView *timeView;
@property (nonatomic,strong) UILabel *timeContentL;
@property (nonatomic,strong) UILabel *timeTitleL;

@property (nonatomic,strong) UIView *squareView;
@property (nonatomic,strong) UILabel *squareContentL;
@property (nonatomic,strong) UILabel *squareTitleL;

@property (nonatomic,strong) UIView *numView;
@property (nonatomic,strong) UILabel *numContentL;
@property (nonatomic,strong) UILabel *numTitleL;

@property (nonatomic,strong) UIView *lineView;

//headersubv
@property (nonatomic,strong) UILabel *tabVTitleL;
@property (nonatomic,strong) UIButton *clearnBtn;

@end

@implementation ClearnCodeViewController

- (void)viewDidLoad {
   
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"打扫记录", nil) ;
    [self initView];
    [self initData];
    
}
- (void)initData{
    _arrOfClearnCode = [NSMutableArray array];
    _arrOfClearnCodeStr = [NSMutableArray array];
   
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithObject:[ShareUser sharedUserInfo].userMode.nowRobotJid forKey:@"eqHardwareSerial"];
//    S_RobotCleanLog
    [[ToolOfNetWork sharedTools]YrequestGetURL:S_RobotCleanLog withParams:parm finished:^(id responsObject, NSError *error) {
       
//        NSString *msg = [responsObject objectForKey:@"msg"];
//        if (msg.length>0) {
//            [self.view makeToast:msg duration:1 position:@"center"];
//        }
       
    
        if (_Success) {
            //成功的数据
            NSString *msg = [responsObject objectForKey:@"msg"];
            if ([msg isEqualToString:@"没有清扫记录。"]) {//没有建值 msg数据只用于判断国际化后可能会变
                  [self listDataIsNull];
            }else{

                _clearnBtn.userInteractionEnabled = YES;
                _clearnBtn.backgroundColor = [DataManager shareDataManager].colorOfMainType;//颜色
                _arrOfClearnCode = [NSMutableArray arrayWithArray:[responsObject objectForKey:@"list"]];
                //数据空
                if (_arrOfClearnCode.count==0) {
                    _tabVTitleL.text = [NSString stringWithFormat:NSLocalizedString(@"暂无打扫记录", nil)];
                    _clearnBtn.userInteractionEnabled = NO;

                }else{//数据非空
                    _tabVTitleL.text = [NSString stringWithFormat:NSLocalizedString(@"最近%lu次的打扫记录详情", nil),(unsigned long)_arrOfClearnCode.count];
                    _clearnBtn.userInteractionEnabled = YES;
                }
 
//                _timeContentL.text = [NSString stringWithFormat:@"%@\n分钟",[ToolOfBasic  timeForMinuteswithTalSseconds:[[responsObject objectForKey:@"allTime"] intValue]]];
                //文本中英文：
                if([[NSString stringWithFormat:@"%@",[responsObject objectForKey:@"allTime"]] isEqualToString:@"0"]){
                    if (self.title.length>4) {
                        _timeContentL.text = [NSString stringWithFormat:@"<1\nMin"];
                    }else{
                        _timeContentL.text = [NSString stringWithFormat:@"小于1\n分钟"];
                    }
                    
                }else{
                    if (self.title.length>4) {
                        _timeContentL.text = [NSString stringWithFormat:@"%@\nMin",[responsObject objectForKey:@"allTime"]];
                    }else{
                        _timeContentL.text = [NSString stringWithFormat:@"%@\n分钟",[responsObject objectForKey:@"allTime"]];
                    }
                    
                }
                
                if ([[NSString stringWithFormat:@"%@",[responsObject objectForKey:@"allArea"]] isEqualToString:@"0"]) {
                    if (self.title.length>4) {
                         _squareContentL.text = [NSString stringWithFormat:@"<1\nSquare meter"];
                    }else{
                       _squareContentL.text = [NSString stringWithFormat:@"小于1\n平方米"];
                    }
                    
                }else{
                    if (self.title.length>4) {
                       _squareContentL.text = [NSString stringWithFormat:@"%@\nSquare meter", [responsObject objectForKey:@"allArea"]];
                    }else{
                         _squareContentL.text = [NSString stringWithFormat:@"%@\n平方米", [responsObject objectForKey:@"allArea"]];
                    }
                }
                if (self.title.length>4) {
                     _numContentL.text = [NSString stringWithFormat:@"%@\nTimes", [responsObject objectForKey:@"count"]];
                }else{
                     _numContentL.text = [NSString stringWithFormat:@"%@\n次", [responsObject objectForKey:@"count"]];
                }
               
                
                [self getStrWithArr];
               
            }

        }else{//失败
            NSString *msg = @"";
            if(msg.length==0){
                if (error.code == -1009) {
                    msg = NSLocalizedString(@"网络请求失败，请查看网络是否可用", nil);
                }else{
                    msg = NSLocalizedString(@"网络请求失败，请稍后再试", nil);
                }
                if (_SuccessOrErrCode == 400) {
                    msg = NSLocalizedString(@"机器不存在", nil);
                }else if(_SuccessOrErrCode == 401){
                    msg = NSLocalizedString(@"没有清扫记录", nil);
                    [self listDataIsNull];
                }
                
                [self.view makeToast:msg duration:2 position:@"bottom"];
            }
        }
    }];
    
    
   
}
#pragma mark -- 国际化的文本部分
//topview
- (void)listDataIsNull{
    if (self.title.length<=4) {
        _timeContentL.text = [NSString stringWithFormat:@"0\n分钟"];
        _squareContentL.text = [NSString stringWithFormat:@"0\n平方米"];
        _numContentL.text = [NSString stringWithFormat:@"0\n次"];
        _clearnBtn.backgroundColor = [UIColor lightGrayColor];//灰色颜色
        _clearnBtn.userInteractionEnabled = NO;
        _tabVTitleL.text = [NSString stringWithFormat:@"暂无打扫记录"];
    }else{
        _timeContentL.text = [NSString stringWithFormat:@"0\nMin"];
        _squareContentL.text = [NSString stringWithFormat:@"0\nSq.m"];
        _numContentL.text = [NSString stringWithFormat:@"0\nTime"];
        _clearnBtn.backgroundColor = [UIColor lightGrayColor];//灰色颜色
        _clearnBtn.userInteractionEnabled = NO;
        _tabVTitleL.text = [NSString stringWithFormat:@"No cleaning record"];
    }
   
}
// cell time dataStart
- (void)getStrWithArr{
    _arrOfClearnCodeStr = [NSMutableArray array];
    
    for (int i = 0; i<_arrOfClearnCode.count; i++) {
    
        NSDictionary *indexDic = [NSDictionary dictionaryWithDictionary:_arrOfClearnCode[i]];
        NSString *begTimeStr = @"";
        NSString *strOfTime = @"";
        if([[indexDic allKeys] containsObject:@"dataStart"]){
              strOfTime=[NSString stringWithFormat:@"%@",[indexDic objectForKey:@"dataStart"]];
            if (strOfTime.length>=16) {//国际化则不转为中文
               NSString* getTimeStr = [strOfTime substringWithRange:NSMakeRange(0, 16)];
                if (self.title.length>6) {
                    begTimeStr= getTimeStr;
                }else{
                    begTimeStr =  [ToolOfBasic timeStrChangeNewTimeStrWithOldStr:getTimeStr];//格转换

                }
            }else{
                begTimeStr = strOfTime;
            }
        }else{//没有数据时
            begTimeStr = [ToolOfBasic nowTime];
        }
       
        
        NSString *areaStr = [NSString stringWithFormat:@"%@", [indexDic objectForKey:@"logCleanArea"]];
       
//        NSString *logContenttime = [NSString stringWithFormat:@"%@", [ToolOfBasic  timeForMinuteswithTalSseconds:[[indexDic objectForKey:@"logContent"] intValue]]];
         NSString *logContenttime = [NSString stringWithFormat:@"%@", [indexDic objectForKey:@"logContent"]];
        if ([areaStr isEqualToString:@"0"]) {
            areaStr = @"小于1";
            if (self.title.length>6) {
                areaStr = @"less than 1";
            }
        }
        if([logContenttime isEqualToString:@"0"]){
            logContenttime = @"小于1";
            if (self.title.length>6) {
                 logContenttime = @"less than 1";
            }
        }
       
        if (self.title.length>6) {
            
            [_arrOfClearnCodeStr addObject:[NSString stringWithFormat:@"%@\nIt takes %@ minutes to clean %@ square meters.",begTimeStr,logContenttime,areaStr]];
        }else{
            [_arrOfClearnCodeStr addObject:[NSString stringWithFormat:@"%@\n打扫%@平方米 用时%@分钟。",begTimeStr,areaStr,logContenttime]];
        }
    }
    
     [_tableViewOfClearnCode reloadData];
}

- (void)initView{
    //背景v
    [self.view addSubview:self.bacViewOfTop];
    [self.view addSubview:self.bacViewOfHeader];
    [self.view addSubview:self.tableViewOfClearnCode];
    [self getYueS];
  
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //
    [_bacViewOfTop addSubview:self.timeView];
    [_bacViewOfTop addSubview:self.timeTitleL];
    [_bacViewOfTop addSubview:self.timeContentL];
    [_bacViewOfTop addSubview:self.squareView];
    [_bacViewOfTop addSubview:self.squareTitleL];
    [_bacViewOfTop addSubview:self.squareContentL];
    [_bacViewOfTop addSubview:self.numView];
    [_bacViewOfTop addSubview:self.numTitleL];
    [_bacViewOfTop addSubview:self.numContentL];
    
    //
    [_bacViewOfHeader addSubview:self.tabVTitleL];
    [_bacViewOfHeader addSubview:self.clearnBtn];
 
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getYueShuOfTopAndHeaderSubV];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- clearnBtnAction
- (void)clearnBtnAction:(UIButton *)sender{
    NSLog(@"clearnBtnAction");
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"清除日志", nil) message:NSLocalizedString(@"是否清除全部记录", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *yesAc = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deletAllLog];
    }];
    
    [alertVc addAction:cancelAc];
    [alertVc addAction:yesAc];
    alertVc.view.tintColor = [DataManager shareDataManager].colorOfMainType;
    [self presentViewController:alertVc animated:YES completion:nil];
    
}

#pragma mark -- 清除记录
- (void)deletAllLog{
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithObject:[ShareUser sharedUserInfo].userMode.nowRobotJid forKey:@"eqHardwareSerial"];
    //    S_RobotCleanLog
    [[ToolOfNetWork sharedTools]YrequestDeleteURL:S_RobotdeleteLog withParams:parm finished:^(id responsObject, NSError *error) {
//        NSString *msg = [responsObject objectForKey:@"msg"];
//        if (msg.length>0) {
//             [self.view makeToast:msg duration:1 position:@"center"];
//        }
       
        
        if (_Success) {
            NSString *msg = NSLocalizedString(@"删除记录成功",nil);
            [self.view makeToast:msg duration:2 position:@"bottom"];
            _arrOfClearnCode = [NSMutableArray array];
            [self listDataIsNull];
            [_tableViewOfClearnCode reloadData];

        }else{
            //失败
            NSString *msg = NSLocalizedString(@"删除记录失败", nil);
         
            if (error.code == -1009) {
                msg = NSLocalizedString(@"网络请求失败，请查看网络是否可用",nil);
                
            }else{
                msg = NSLocalizedString(@"网络请求失败，请稍后再试",nil);
            }
           
            if (_SuccessOrErrCode==400) {
                msg = NSLocalizedString(@"机器不存在", nil);
            }else if (_SuccessOrErrCode == 401){
//                 msg = NSLocalizedString(@"删除记录失败", nil);
                msg = NSLocalizedString(@"删除失败，请稍后重试", nil);
            }
            [self.view makeToast:msg duration:2 position:@"bottom"];
        }
        
        
    }];

}

#pragma mark -- tableViewOfClearnCode
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrOfClearnCode.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
//    if (!cell) {
//       cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
//    }
//    cell.imageView.frame = CGRectMake(tableView.width-40, 0, 60, 40);

//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.imageView.backgroundColor = [UIColor grayColor];
//    cell.textLabel.numberOfLines = 3;
//    cell.detailTextLabel.numberOfLines = 2;
//    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
//
//    cell.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
//    cell.detailTextLabel.text = NSLocalizedString(@"地图详情", nil);
//    if (_arrOfClearnCodeStr.count>0) {
//        cell.textLabel.attributedText = [self strOfCellWithRow:indexPath.row];
//    }
    
    CleanCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CleanCodeTableViewCell"];
    if (!cell) {
        cell = [[CleanCodeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CleanCodeTableViewCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.backgroundColor = [UIColor grayColor];
    cell.twoTextLabel.text = NSLocalizedString(@"地图详情", nil);
    if (_arrOfClearnCodeStr.count>0) {
        cell.oneTextLabel.attributedText = [self strOfCellWithRow:indexPath.row];//还是用的一个lable显示
    }
   
  
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (NSMutableAttributedString *)strOfCellWithRow:(NSInteger)i{
  
    NSString *str = _arrOfClearnCodeStr[i];
//    NSString *str = @"";
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange rangeOfN = [str rangeOfString:@"打"];
    if (self.title.length>6) {
           rangeOfN = [str rangeOfString:@"I"];//获取第一次出现的位置 英文 It
    }else{
          rangeOfN = [str rangeOfString:@"打"];//获取第一次出现的位置
    }
 
    NSUInteger rangeI = rangeOfN.location;
    //字体大小
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, rangeI)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.5] range:NSMakeRange(rangeI, attributedStr.length-rangeI)];
    //字体颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, rangeI)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(rangeI, attributedStr.length-rangeI)];
    
    return attributedStr;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ClearnMapDetailsViewController *clearnDetailVc = [[ClearnMapDetailsViewController alloc]init];
    clearnDetailVc.dicOfClearnMapDetails = [NSMutableDictionary dictionaryWithDictionary:_arrOfClearnCode[indexPath.row]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationController pushViewController:clearnDetailVc animated:YES];
}

#pragma mark -- getYueS
- (void)getYueS{
    //顶部
    [_bacViewOfTop mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(100);
        make.width.equalTo(self.view.mas_width).offset(-20);
        make.height.offset((Y_mainW-20)*0.33+30);
    }];
    //头部
    [_bacViewOfHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_bacViewOfTop.mas_bottom);
        make.width.equalTo(self.view.mas_width);
        make.height.offset(40);
    }];
    
    //tableview
    [_tableViewOfClearnCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_bacViewOfHeader.mas_bottom);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    
}

- (void)getYueShuOfTopAndHeaderSubV{
    //top
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bacViewOfTop.mas_left);
        make.top.equalTo(_bacViewOfTop);
        make.width.offset(_bacViewOfTop.width*0.3);
        make.height.offset(_bacViewOfTop.width*0.3);
    }];
    
    [_timeTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_timeView);
        make.width.equalTo(_timeView.mas_width);
        make.top.equalTo(_timeView.mas_bottom);
        make.bottom.equalTo(_bacViewOfTop.mas_bottom);
    }];
    [_timeContentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_timeView);
        make.centerY.equalTo(_timeView);
        make.width.equalTo(_timeView.mas_width);
        make.height.equalTo(_timeView.mas_height);
    }];
    
    //
    [_numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bacViewOfTop.mas_right);
        make.top.equalTo(_bacViewOfTop);
        make.width.offset(_bacViewOfTop.width*0.3);
        make.height.offset(_bacViewOfTop.width*0.3);
    }];
    
    [_numTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_numView);
        make.width.equalTo(_numView.mas_width);
        make.top.equalTo(_numView.mas_bottom);
        make.bottom.equalTo(_bacViewOfTop.mas_bottom);
    }];
    [_numContentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_numView);
        make.centerY.equalTo(_numView);
        make.width.equalTo(_timeView.mas_width);
        make.height.equalTo(_timeView.mas_height);
    }];
    //
    [_squareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bacViewOfTop);
        make.top.equalTo(_bacViewOfTop);
        make.width.offset(_bacViewOfTop.width*0.3);
        make.height.offset(_bacViewOfTop.width*0.3);
    }];
    
    [_squareTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_squareView);
        make.width.equalTo(_squareView.mas_width);
        make.top.equalTo(_squareView.mas_bottom);
        make.bottom.equalTo(_bacViewOfTop.mas_bottom);
    }];
    [_squareContentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_squareView);
        make.centerY.equalTo(_squareView);
        make.width.equalTo(_timeView.mas_width);
        make.height.equalTo(_timeView.mas_height);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bacViewOfTop);
        make.width.equalTo(_bacViewOfTop.mas_width);
        make.height.offset(2);
        make.bottom.equalTo(_bacViewOfTop.mas_bottom);
    }];
    
    _timeView.layer.cornerRadius = _bacViewOfTop.width*0.15;
    _squareView.layer.cornerRadius = _bacViewOfTop.width*0.15;
    _numView.layer.cornerRadius = _bacViewOfTop.width*0.15;
    
    _timeTitleL.text = NSLocalizedString(@"累计时长", nil) ;
    _squareTitleL.text = NSLocalizedString(@"累计打扫", nil) ;
    _numTitleL.text = NSLocalizedString(@"累计次数", nil) ;
    if (self.title.length>5) {
        _timeTitleL.numberOfLines = 2;
        _squareTitleL.numberOfLines = 2;
        _numTitleL.numberOfLines = 2;
        _timeTitleL.font = [UIFont systemFontOfSize:14];
        _squareTitleL.font = [UIFont systemFontOfSize:14];
        _numTitleL.font = [UIFont systemFontOfSize:14];
    }
    

    //heaer部分
    [_clearnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bacViewOfHeader.mas_right).offset(-20);
        make.centerY.equalTo(_bacViewOfHeader);
        make.width.offset(120);
        make.height.offset(30);
    }];
    [_tabVTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bacViewOfHeader.mas_left).offset(20);
        make.right.equalTo(_clearnBtn.mas_left);
        make.centerY.equalTo(_bacViewOfHeader);
        make.height.offset(46);
    }];
}
#pragma mark -- bacViewgetter
- (UIView *)bacViewOfTop{
    if (!_bacViewOfTop) {
        _bacViewOfTop = [[UIView alloc]init];
        _bacViewOfTop.backgroundColor = [UIColor whiteColor];
    }
    return _bacViewOfTop;
}

- (UIView *)bacViewOfHeader{
    if (!_bacViewOfHeader) {
        _bacViewOfHeader = [[UIView alloc]init];
        _bacViewOfHeader.backgroundColor = [DataManager shareDataManager].colorOfGrayBack;
        
    }
    return _bacViewOfHeader;
}

- (UITableView *)tableViewOfClearnCode{
    if (!_tableViewOfClearnCode) {
        _tableViewOfClearnCode = [[UITableView alloc]init];
        _tableViewOfClearnCode.backgroundColor = [DataManager shareDataManager].colorOfGrayBack;
        _tableViewOfClearnCode.delegate = self;
        _tableViewOfClearnCode.dataSource = self;
        _tableViewOfClearnCode.estimatedRowHeight = 45;
        _tableViewOfClearnCode.tableFooterView = [UIView new];
        _tableViewOfClearnCode.tableHeaderView = [UIView new];
    }
    return _tableViewOfClearnCode;
}
#pragma mark -- TopSubv getter
- (UIView *)timeView{
    if (!_timeView) {
        _timeView = [[UIView alloc]init];
        _timeView.layer.borderColor = [DataManager shareDataManager].colorOfMainType.CGColor;
        _timeView.layer.borderWidth = 1;
        
    }
    return _timeView;
}
- (UILabel *)timeTitleL{
    if (!_timeTitleL) {
        _timeTitleL = [[UILabel alloc]init];
        _timeTitleL.font = [UIFont systemFontOfSize:16];
        _timeTitleL.textAlignment = NSTextAlignmentCenter;
        _timeTitleL.textColor = [DataManager shareDataManager].colorOfMainType;
    }
    return _timeTitleL;
}
- (UILabel *)timeContentL{
    if (!_timeContentL) {
        _timeContentL = [[UILabel alloc]init];
        _timeContentL.font = [UIFont systemFontOfSize:15];
        _timeContentL.numberOfLines = 2;
        _timeContentL.textAlignment = NSTextAlignmentCenter;
        _timeContentL.textColor = [DataManager shareDataManager].colorOfMainType;
    }
    return _timeContentL;
}

//
- (UIView *)squareView{
    if (!_squareView) {
        _squareView = [[UIView alloc]init];
        _squareView.layer.borderColor = [DataManager shareDataManager].colorOfMainType.CGColor;
        _squareView.layer.borderWidth = 1;
    }
    return _squareView;
}
- (UILabel *)squareTitleL{
    if (!_squareTitleL) {
        _squareTitleL = [[UILabel alloc]init];
        _squareTitleL.font = [UIFont systemFontOfSize:16];
        _squareTitleL.textAlignment = NSTextAlignmentCenter;
        _squareTitleL.textColor = [DataManager shareDataManager].colorOfMainType;
        
    }
    return _squareTitleL;
}
- (UILabel *)squareContentL{
    if (!_squareContentL) {
        _squareContentL = [[UILabel alloc]init];
        _squareContentL.font = [UIFont systemFontOfSize:15];
        _squareContentL.numberOfLines = 2;
        _squareContentL.textAlignment = NSTextAlignmentCenter;
        _squareContentL.textColor = [DataManager shareDataManager].colorOfMainType;
    }
    return _squareContentL;
}

//
- (UIView *)numView{
    if (!_numView) {
        _numView = [[UIView alloc]init];
        _numView.layer.borderColor = [DataManager shareDataManager].colorOfMainType.CGColor;
        _numView.layer.borderWidth = 1;
        
    }
    return _numView;
}
- (UILabel *)numTitleL{
    if (!_numTitleL) {
        _numTitleL = [[UILabel alloc]init];
        _numTitleL.font = [UIFont systemFontOfSize:16];
        _numTitleL.textAlignment = NSTextAlignmentCenter;
        _numTitleL.textColor = [DataManager shareDataManager].colorOfMainType;
        
    }
    return _numTitleL;
}
- (UILabel *)numContentL{
    if (!_numContentL) {
        _numContentL = [[UILabel alloc]init];
        _numContentL.font = [UIFont systemFontOfSize:15];
        _numContentL.numberOfLines = 2;
        _numContentL.textAlignment = NSTextAlignmentCenter;
        _numContentL.textColor = [DataManager shareDataManager].colorOfMainType;
    }
    return _numContentL;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

#pragma mark --headerSubv  getter

- (UILabel *)tabVTitleL{
    if (!_tabVTitleL) {
        _tabVTitleL = [[UILabel alloc]init];
        _tabVTitleL.font = [UIFont systemFontOfSize:13];
        _tabVTitleL.numberOfLines = 2;
        _tabVTitleL.textColor = [UIColor lightGrayColor];
    }
    return _tabVTitleL;
}

- (UIButton *)clearnBtn{
    if (!_clearnBtn) {
        _clearnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearnBtn.layer.cornerRadius = 5;
        _clearnBtn.backgroundColor = [DataManager shareDataManager].colorOfMainType;
        [_clearnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_clearnBtn setTitle:NSLocalizedString(@"清除所有记录", nil)  forState:UIControlStateNormal];
        _clearnBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_clearnBtn addTarget:self action:@selector(clearnBtnAction:) forControlEvents:UIControlEventTouchUpInside];
         }
    return _clearnBtn;
}
@end
