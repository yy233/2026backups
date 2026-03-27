//
//  WaitForKaiBoViewController.m
//  Socialize
//
//  Created by 余莹 on 2023/7/4.
//

#import "WaitForKaiBoViewController.h"
#define  MainGreenColpr    rgba(128, 238, 238, 1)
@interface WaitForKaiBoViewController ()
{
    dispatch_source_t gcdTimer;
}

@property (nonatomic,strong) UILabel *timeShowL;
@property (nonatomic,strong) UILabel *okL;
@property (nonatomic,strong) UIImageView *okImgv;
@property (nonatomic,strong) UIButton *rightCloseBtn;
@property (nonatomic,strong) WaitForKaiBoSubView *subView;
@end

@implementation WaitForKaiBoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self dealDataModel];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self willNavClearnBk];
    
    
}
 
- (void)willNavClearnBk{
    [self.navigationItem setBackButtonTitle:@""];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];//白色返回按钮
    [self.navigationController.navigationBar setTintColor:[UIColor clearColor]];//透明的返回按钮
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    NSDictionary *attDic = @{
        NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor clearColor]};
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];//bk
    [self.navigationController.navigationBar setTranslucent:YES]; //透明
    [self.navigationController setNavigationBarHidden:NO animated:YES];//不隐藏
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = [UIColor clearColor];//bk
        appearance.shadowColor = [UIColor clearColor];//阴影线
        appearance.backgroundEffect = nil;//这是关键
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }
    
    
    
    self.rightCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightCloseBtn newAnBtnWithImg:[UIImage imageNamed:@"btn_close"]];
    [self.rightCloseBtn addTarget:self action:@selector(rightBtnAct:) forControlEvents:UIControlEventTouchUpInside];

    //位置被nav遮住了 点击不了 换成item
//    [self.view addSubview:self.rightCloseBtn];
//    [self.rightCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_rightCloseBtn.superview).offset(-20);
//        make.width.height.offset(30.0);
//        make.bottom.equalTo(_okImgv.mas_top).offset(-10);
//    }];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightCloseBtn];
    [self.navigationItem setRightBarButtonItems:@[rightItem] animated:YES];

}


#pragma mark ===
- (void)initViews{
    UIColor *beginColor = rgba(50, 28, 28, 1);
    self.view.backgroundColor = [UIColor bm_colorGradientChangeWithSize:CGSizeMake(Screen_W, Screen_H) direction:IHGradientChangeDirectionVertical startColor:beginColor endColor:[UIColor blackColor]];

    
    self.okImgv = [[UIImageView alloc]init];
    self.okImgv.image = [UIImage imageNamed:@"完成"];
    self.okL = [[UILabel alloc]init];
    self.okL.textColor = [UIColor whiteColor];
    self.okL.text = Y_LocaleTypeFile_NSLocalString(@"完成");
    self.okL.textAlignment = NSTextAlignmentCenter;
    self.okL.font = [UIFont boldSystemFontOfSize:20.0];

    self.timeShowL = [[UILabel alloc]init];
    self.timeShowL.textColor = [UIColor whiteColor];
    self.timeShowL.textAlignment = NSTextAlignmentCenter;
    self.timeShowL.font = [UIFont systemFontOfSize:14.0];
    self.timeShowL.numberOfLines = 2;
    
    [self.view addSubview:self.okImgv];
    [self.view addSubview:self.okL];
    [self.view addSubview:self.timeShowL];
    
    [self.okImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_okImgv.superview);
        make.top.equalTo(_okImgv.superview).offset(100);
        make.width.height.offset(52.0);
    }];
    [self.okL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(_okL.superview);
        make.height.offset(30.0);
        make.top.equalTo(_okImgv.mas_bottom).offset(10);
    }];
    [self.timeShowL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(_timeShowL.superview);
        make.height.offset(30.0);
        make.top.equalTo(_okL.mas_bottom).offset(0);
    }];
    
    self.subView = [[WaitForKaiBoSubView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 80.0)];
    [self.view addSubview:self.subView];
    [_subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeShowL.mas_bottom).offset(50);
        make.height.offset(80);
        make.width.equalTo(_subView.superview).offset(-20);
        make.centerX.equalTo(_subView.superview);
    }];
    
   
    
    
}
- (void)rightBtnAct:(UIButton *)sender{
    NSLog(@"rightBtnAct ---- ")
    [self popVC];
}



#pragma mark ===
- (void)dealDataModel{
    if(self.showMode){
        self.showMode.startDatetime = [self zhuanLocaTimeWithGetSt: self.showMode.startDatetime];//处理成本地时间
        NSLog(@"initListData = %@",self.showMode.startDatetime);
        [self dealUIs];
        [self upDataTimerrrInfo];

    }
}
#pragma mark ============================================

- (NSString *)zhuanLocaTimeWithGetSt:(NSString *)getstartDatetime{
    NSString *UTC = @"UTC";
    NSString *getSt = [NSString stringWithFormat:@"%@",getstartDatetime];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithAbbreviation:UTC]; //UTC本地时区
    [formatter setTimeZone:timeZone];

    NSDate* thisDate = [formatter dateFromString:getSt]; //------------将字符串按formatter转成nsdate
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[thisDate timeIntervalSince1970]];
    NSLog(@"前端 是加UTC  转成时间戳 =  %@",timeSp);
    
    NSDateFormatter *formatterY = [[NSDateFormatter alloc] init] ;
    [formatterY setDateStyle:NSDateFormatterMediumStyle];
    [formatterY setTimeStyle:NSDateFormatterShortStyle];
    [formatterY setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZoneY = [NSTimeZone localTimeZone];  //可取别的本地时区
    [formatterY setTimeZone:timeZoneY];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeSp integerValue]];
    NSString *confromTimespStr = [formatterY stringFromDate:confromTimesp];
    NSLog(@"前端 是加UTC  转成时间戳 再转成本地时间的 =  %@",timeSp);

    return confromTimespStr;
}


- (void)dealUIs{
    [self.subView.imgView sd_setImageWithURL:[NSURL URLWithString:self.showMode.picture] placeholderImage:Y_gray_img];
    [self.subView.shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    self.subView.titleL.text = self.showMode.title;
    self.subView.timeL.text = self.showMode.startDatetime;
    NSString *typeS = (self.showMode.category==2) ?  Y_LocaleTypeFile_NSLocalString(@"语音") : Y_LocaleTypeFile_NSLocalString(@"视频");

    self.subView.typeL.text = typeS;

}

#define kShareStr_Open_Freeper_Des  Y_LocaleTypeFile_NSLocalString(@"在Freeper，记录美好生活，来和我一起支持Ta吧。复制下方链接，打开【Freeper】，直接观看直播！")
#define kShareStr_Open_Freeper_Io   @"https://freeper.io"
#define kShareStr_ActivityId_Prex   @"?actid="
- (void)shareAction{
    NSLog(@"shareAction");
    NSString *textToShare = kShareStr_Open_Freeper_Des;
    UIImage *imageToShare = [UIImage new];//[UIImage imageNamed:@"iosshare.jpg"];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",@"https://freeper.io?actid=",self.showMode.activityId];
    NSString *showAllText = [NSString stringWithFormat:@"%@%@",kShareStr_Open_Freeper_Des,urlStr];
    if(_showMode.recode.length <= 0){
        NSLog(@"showAllText == %@",showAllText);
        dispatch_async(dispatch_get_main_queue(), ^{
             [Y_ToolOfOthers shareActionWithArr:@[showAllText] withNowVc:self];
        });
    }else{
        NSString *urlStrWithRecode = [NSString stringWithFormat:@"%@%@ [%@]",@"https://freeper.io?actid=",self.showMode.activityId,self.showMode.recode];
        NSString *showAllText = [NSString stringWithFormat:@"%@%@",kShareStr_Open_Freeper_Des,urlStrWithRecode];
        NSLog(@"showAllText == %@",showAllText);
        dispatch_async(dispatch_get_main_queue(), ^{
//            [Y_ToolOfOthers shareLinkUrlWithStr:urlStr withNowVc:self];
            [Y_ToolOfOthers shareActionWithArr:@[showAllText] withNowVc:self];
            
        });
    }
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
//        NSLog(@"activityItems --- 分享 %@",activityItems);
//        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
//        [self presentViewController:activityVC animated:YES completion:^{
//            NSLog(@"分享ok");
//        }];
//    });

}
#pragma mark ============================================
//倒计时相关
- (void)upDataTimerrrInfo{
    [self timerPpause];//每次重新更新处理数据
    
    WEAKSELF
    //创建GCD定时器
    gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0)); //    //将定时器写成属性，是因为内存管理的原因，使用了dispatch_source_create方法，这种方法GCD是不会帮你管理内存的。
    //设置定时器
    dispatch_source_set_timer(gcdTimer, dispatch_walltime(NULL, 0), 1ull * NSEC_PER_SEC, 0);
    /*
     第二个参数：dispatch_time_t start, 定时器开始时间，类型为 dispatch_time_t，其API的abstract标明可参照dispatch_time()和dispatch_walltime()，同为设置时间，但是后者为“钟表”时间，相对比较准确，所以选择使用后者。dispatch_walltime(const struct timespec *_Nullable when, int64_t delta),参数when可以为Null，默认为获取当前时间，参数delta为增量，即获取当前时间的基础上，增加X秒的时间为开始计时时间，此处传0即可。
     第三个参数：uint64_t interval，定时器间隔时长，由业务需求而定。
     第四个参数：uint64_t leeway， 允许误差，此处传0即可。
    */
    //定时器需要执行的操作
    dispatch_source_set_event_handler(gcdTimer, ^{
        //设置对应的时间差
        ZhiBoShowInfoModel * model = weakSelf.showMode;
        model.daoJiShiUseTimeIv = [weakSelf dateTimeIntervalWithEndTimeStr:model.startDatetime withCellRomIndexNum:999];

    });
    // 启动任务，GCD计时器创建后需要手动启动
    dispatch_resume(gcdTimer);
    
}
- (void)timerPpause{
    if (gcdTimer) {
        dispatch_cancel(gcdTimer);
        gcdTimer = nil;
    }
    NSLog(@"pause gcdTimer --- %@",gcdTimer);
    /**
     停止 Dispatch Timer 有两种方法，一种是使用 dispatch_suspend，另外一种是使用 dispatch_source_cancel。
     dispatch_suspend 严格上只是把 Timer 暂时挂起   dispatch_suspend 之后的 Timer，是不能被释放的 会引起崩溃。
     用 dispatch_source_cancel 则没有这个限制
     */
}

- (NSString *)dateTimeIntervalWithEndTimeStr:(NSString *)startDatetime withCellRomIndexNum:(NSInteger)cellRomIndex{
    WEAKSELF
    if(startDatetime.length <= 0){
        //不符合要求 处理成空串
        return @"";
    }else{
        //有数据
        /**
         //1转型
         //2判断显示文本还是做倒计时 (之前更新 直到时间OK无需倒计时的 直接给展示文本)
         //3倒计时放到 返回到mode 调cell处理 文本更新
         
         */

        NSInteger timeIv = [[YTimeStamp getTimeIvWithTimeStr_YMDHMS:startDatetime] integerValue];
        NSInteger nowTimeIV = [[YTimeStamp getNowTimeTimestamp_haoMiao] integerValue];
        if(nowTimeIV > timeIv){
            dispatch_async(dispatch_get_main_queue(), ^{//主线更新
                NSString *kaishiShijian = Y_LocaleTypeFile_NSLocalString(@"开始时间");
                weakSelf.timeShowL.text  = [NSString stringWithFormat:@"%@：%@",kaishiShijian,[YTimeStamp getTimeMDHMSUseTimeYMDHMSstr:startDatetime]];
            });
            //展示时间比现在小 已经结束状态 == 展示旧的时间嘛 处理成空串
            return @"";
        }else if(nowTimeIV == timeIv){//更新到相同时间 做cell更新 直接更新MDhms文本
            dispatch_async(dispatch_get_main_queue(), ^{//主线更新
                NSString *kaishiShijian = Y_LocaleTypeFile_NSLocalString(@"开始时间");
                weakSelf.timeShowL.text  = [NSString stringWithFormat:@"%@：%@",kaishiShijian,[YTimeStamp getTimeMDHMSUseTimeYMDHMSstr:startDatetime]];

            });
            return @"";
        }else{
            //返回给Model的数据  做过减法的未来时间 //时间戳 转MDHms
            NSInteger useShowDaoJishiTimeIv = ([YTimeStamp timeIvZhuan10w:timeIv] - [YTimeStamp timeIvZhuan10w:nowTimeIV] );
            //有数据 ---- 处理倒计时文本
            NSString *showStr = [YTimeStamp getDHMSTimeStrUseDaoJiShiTimeIv:useShowDaoJishiTimeIv];
            dispatch_async(dispatch_get_main_queue(), ^{
                // @"距离开播还剩下：";
                NSString *julikaibo = Y_LocaleTypeFile_NSLocalString(@"距离开播还剩下");
                weakSelf.timeShowL.text  = [NSString stringWithFormat: @"%@：%@",julikaibo,showStr];
                
            });
            return @"";
        }
    }
    
    
}

//界面切换时也要做timer的
 //包括will
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self timerPpause];
}

- (void)dealloc{
    [self timerPpause];
    
}

@end



#pragma mark ========================================

@implementation  WaitForKaiBoSubView
 
 
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bakView];
        [self.bakView addSubview:self.imgView];
        [self.bakView addSubview:self.titleL];
        [self.bakView addSubview:self.typeL];
        [self.bakView addSubview:self.timeL];
        [self.bakView addSubview:self.shareBtn];
        [self allUIs];
    }
    return self;
}
- (void)allUIs{
    [_bakView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bakView.superview).offset(10);
        make.width.equalTo(_bakView.superview).offset(-20.0);
        make.height.offset(80.0);
        make.top.equalTo(_bakView.superview);
    }];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_imgView.superview);
        make.width.equalTo(_imgView.mas_height);
    }];
    
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(55);
        make.height.offset(24);
        make.right.equalTo(_shareBtn.superview).offset(-15);
        make.centerY.equalTo(_shareBtn.superview);
    }];
    
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgView.mas_right).offset(10);
        make.right.equalTo(_shareBtn.mas_left);
        make.top.equalTo(_titleL.superview).offset(15);
        make.height.offset(20);
    }];
    [_typeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(42);
        make.height.offset(20);
        make.left.equalTo(_titleL);
        make.top.equalTo(_titleL.mas_bottom).offset(10);
    }];
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_typeL.mas_right).offset(10);
        make.right.equalTo(_shareBtn.mas_left);
        make.centerY.equalTo(_typeL);
        
    }];
}
- (UIView *)bakView{
    if(!_bakView){
        _bakView = [[UIView alloc]init];
        _bakView.layer.cornerRadius = 6.0;
        _bakView.layer.masksToBounds = YES;
        _bakView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.3];
    }
    return _bakView;
}

- (UIImageView *)imgView{
    if(!_imgView){
        _imgView = [[UIImageView alloc]init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.cornerRadius = 6.0;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}

- (UIButton *)shareBtn{//128 238 238
    if(!_shareBtn){
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn newAnBtnWithBackColor:MainGreenColpr];
        [_shareBtn newAnBtnWithTextColor:[UIColor blackColor]];
        [_shareBtn newAnBtnWithFont:[UIFont systemFontOfSize:15.0]];
        [_shareBtn newAnBtnWithLayerCorNerNum:12.0 withLayerLineWidth:0.0 withLayerLineColor:MainGreenColpr];
        [_shareBtn newAnBtnWithTextStr: Y_LocaleTypeFile_NSLocalString(@"分享")];
        [_shareBtn newAnBtnWithFont:[UIFont systemFontOfSize:15.0]];
    }
    return _shareBtn;
}
- (UILabel *)titleL{
    if(!_titleL){
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [UIColor whiteColor];
        _titleL.font = [UIFont boldSystemFontOfSize:16.0];
    }
    return _titleL;
}

- (UILabel *)typeL{
    if(!_typeL){
        _typeL = [[UILabel alloc]init];
        _typeL.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _typeL.font = [UIFont boldSystemFontOfSize:14.0];
        _typeL.layer.cornerRadius = 10.0;
        _typeL.layer.borderWidth = 1.0;
        _typeL.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor;
        _typeL.textAlignment = NSTextAlignmentCenter;
    }
    return _typeL;
}
- (UILabel *)timeL{
    if(!_timeL){
        _timeL = [[UILabel alloc]init];
        _timeL.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _timeL.font = [UIFont boldSystemFontOfSize:11.0];
    }
    return _timeL;
}
@end
