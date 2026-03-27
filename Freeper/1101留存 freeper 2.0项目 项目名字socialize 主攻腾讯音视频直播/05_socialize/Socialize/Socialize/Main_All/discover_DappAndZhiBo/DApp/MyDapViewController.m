//
//  MyDapViewController.m
//  Socialize
//
//  Created by 余莹 on 2023/5/22.
//

#import "MyDapViewController.h"
#import "Mylayout.h"
#import "ZiXunInfoTableViewCell.h"
#import "DapsView.h"
#import "ZhiBoAllMianListAndCanCreatNewZhiBoViewController.h"
#import "ZhiBoMainVc.h"
#import "Socialize-Swift.h"

@interface MyDapViewController () <UITableViewDelegate,UITableViewDataSource,DapsViewDelegate>

@property (nonatomic,strong) UIView *bkClearnV;
@property (nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic, strong) MyLinearLayout *contentLayout;

@property (nonatomic,strong) UIView *topV;
@property (nonatomic,strong) UIView *ceneterV;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *infoArr;
@end

@implementation MyDapViewController
- (NSArray *)infoArr{
    if(!_infoArr){
        _infoArr  = @[@"如果你最低支持到iOS8那么请用这个方法来初始化一个UITableviewCell,用这个方法要记得调用registerClassregisterClassregisterClassregisterClassregisterClass来注册UITableviewCe0000001",
                      @"如果你最低支持到来注册UITableviewCe0000001",
                      @"如果你最低支持到iOS8那么请用这个方法来初始化一个UITableviewCell,用这个方法要记得调用registerClass来注册UITableviewCe0000002",
                      @"如果你最低支持到iOS8那么请用这个方法来初始化一个UITableviewCell,用这个方法要记得调用registerClass来注册UITableviewCe0000003",
                      @"如果你最低支持到iOS8那么请用这个方法来初始化一个UITableviewCell,用这个方法要记得调用registerClass来注册UITableviewCe0000004"];
    }
    return _infoArr;
}
-(UIView *)bkClearnV{
    if(!_bkClearnV){
        _bkClearnV = [[UIView alloc] initWithFrame:self.view.frame];
        _bkClearnV.backgroundColor = [UIColor clearColor];
    }
    return _bkClearnV;
}
- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    }
    return _scrollView;
}
- (UIView *)topV{
    if(!_topV){
        _topV = [UIView new];
    }
    return _topV;
}
- (UIView *)ceneterV{
    if(!_ceneterV){
        
    }
    return _ceneterV;
}
 


#pragma mark ===
- (void)initRightItems{
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"搜索"] style:UIBarButtonItemStylePlain target:self action:@selector(setItemAction)];
    [self.navigationItem setRightBarButtonItems:@[searchItem]    animated:YES];
    
   
}
- (void)setItemAction{
    DLog()
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Y_LocaleTypeFile_NSLocalString(@"发现");
    [self initRightItems];
    [self initSelfViews];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarTransparentStyle];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithDefaultBackground];
        appearance.shadowColor = nil;
        appearance.backgroundEffect = nil;
        appearance.backgroundColor =  [self navBackColor];
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        navigationBar.backgroundColor = [self navBackColor];
        navigationBar.barTintColor = [self navBackColor];
        navigationBar.shadowImage = Y_gray_img;
        navigationBar.standardAppearance = appearance;
        navigationBar.scrollEdgeAppearance= appearance;
    }
    else {
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        navigationBar.backgroundColor = [self navBackColor];
        navigationBar.barTintColor = [self navBackColor];
        navigationBar.shadowImage = Y_gray_img;
        [[UINavigationBar appearance] setTranslucent:NO];
    }

}
- (UIColor *)navBackColor {
    return [UIColor clearColor];;
}

#pragma mark ===================================
//DapsViewDelegate
- (void)touchDapsItem:(UIButton *)sender{
    DLog(@"dapp %ld",(long)sender.tag);
}


#pragma mark ===================================
- (void)initSelfViews{
    //渐变色
    //主v
    GreenAndJianBianBkView *bgColorView = [[GreenAndJianBianBkView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:bgColorView];
 
    CGFloat all_H = self.view.frame.size.height;
    //渐变色
    UIColor * beginColor =  rgba(255, 255, 255, 1);
    UIColor * bottom_endColor =rgba(228, 228, 228, 1);
    //位置
    CGRect grayRect = CGRectMake(0, all_H/2, Screen_W, all_H/2);
    //view
    UIView *c_238g = [[UIView alloc]initWithFrame:grayRect];
    c_238g.backgroundColor = [UIColor y_colorGradientChangeWithSize:grayRect.size direction:IHGradientChangeDirectionVertical startColor:beginColor endColor:bottom_endColor];
    [self.view addSubview:c_238g];
    [self.view addSubview:self.bkClearnV];
    [self.view addSubview:self.bkClearnV];
    [self.bkClearnV addSubview:self.scrollView];
    
    //布局相关
    //活动布局相关
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    contentLayout.padding = UIEdgeInsetsMake(10, 16, 10, 16); //设置布局内的子视图离自己的边距.
    contentLayout.myHorzMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
    contentLayout.heightSize.lBound(_scrollView.heightSize, 300, 1); //高度虽然是自适应的。但是最小的高度不能低于父视图的高度 +x

    [self.scrollView addSubview:contentLayout];
    self.contentLayout = contentLayout;
    //垂直线性布局直接添加子视图
    [self topBtnsViews:contentLayout];
    [self createTitleL:contentLayout withText:@"DApps"];
    [self dappViews:contentLayout];
    [self createTitleL:contentLayout withText:@"资讯信息"];
    [self bottomInfoListWithLayout:contentLayout];
    

}

- (void)topBtnsViews:(MyLinearLayout*)contentLayout{
    MyLinearLayout *subsContentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    subsContentLayout.gravity = MyGravity_Horz_Trailing;
    subsContentLayout.myHorzMargin = 0;
    subsContentLayout.myHeight = 80;
    subsContentLayout.myTop = 10;
    [contentLayout addSubview:subsContentLayout];
    
    UIView *one = [UIView new];
    one.myHeight = 80;
    one.myWidth =  (Screen_W-32)/2;
    [subsContentLayout addSubview:one];
    
    UIButton *oneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    oneBtn.frame = CGRectMake(0, 0,(Screen_W-32)/2-10 , 80);
    [oneBtn setBackgroundImage:[UIImage imageNamed:@"直播"] forState:UIControlStateNormal];
    [oneBtn newAnBtnWithTextStr:@"直播"];
    [oneBtn newAnBtnWithFont:[UIFont systemFontOfSize:16.0]];
    [oneBtn newAnBtnWithTextColor:rgba(51, 51, 51, 1)];
    [oneBtn addTarget:self action:@selector(goZhiBo) forControlEvents:UIControlEventTouchUpInside];
    [one addSubview:oneBtn];

    
    UIView *two = [UIView new];
    two.myHeight = 80;
    two.myWidth =  (Screen_W-32)/2;
    [subsContentLayout addSubview:two];
    UIButton *twoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    twoBtn.frame = CGRectMake(10, 0,(Screen_W-32)/2-10 , 80);
    [twoBtn setBackgroundImage:[UIImage imageNamed:@"合成"] forState:UIControlStateNormal];
    [twoBtn newAnBtnWithTextStr:@"合成"];
    [twoBtn newAnBtnWithFont:[UIFont systemFontOfSize:16.0]];
    [twoBtn newAnBtnWithTextColor:rgba(51, 51, 51, 1)];
    [twoBtn addTarget:self action:@selector(goHeCheng) forControlEvents:UIControlEventTouchUpInside];
    [two addSubview:twoBtn];

    
    //go DiscoverViewController
}

- (void)goZhiBo{
    ZhiBoAllMianListAndCanCreatNewZhiBoViewController_Sw *vc = [[ZhiBoAllMianListAndCanCreatNewZhiBoViewController_Sw alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
    //#import "ZhiBoMainVc.h"
//    ZhiBoMainVc*vc = [[ZhiBoMainVc alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self pushVc:vc];
}
- (void)goHeCheng{
    DLog(@"");
}


//titlesLLL
- (void)createTitleL:(MyLinearLayout*)contentLayout withText:(NSString *)textStr{
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = textStr;
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    titleLabel.textColor = rgba(22, 22, 22, 1);
    [titleLabel sizeToFit];
    titleLabel.myLeading = 5;
    titleLabel.myHeight = 50;
    [contentLayout addSubview:titleLabel];
    
}
//dapps
- (void)dappViews:(MyLinearLayout*)contentLayout{
    CGFloat lieShu = 4;
    CGFloat itemH = 105;
    CGFloat itemW = (Screen_W-32)/lieShu;
    CGFloat dappBk_H = itemH;
    NSMutableArray *itemArr  = @[@1,@2,@3,@4,@5,@6,@7,@8].mutableCopy;
    if(itemArr.count<=4){
        //1行
    }else if (itemArr.count <= 8){
        //2行
        dappBk_H = 2*itemH;
    }else{//3行
        dappBk_H = 3*itemH;
    }
 
    MyLinearLayout *subsContentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    subsContentLayout.gravity = MyGravity_Horz_Trailing;
    subsContentLayout.myHorzMargin = 0;
    subsContentLayout.myHeight = dappBk_H;
    subsContentLayout.myTop = 10;
    [contentLayout addSubview:subsContentLayout];
    //背景图
    UIView *dappBkV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, dappBk_H)];
    dappBkV.layer.cornerRadius = 10;
    dappBkV.backgroundColor = [UIColor whiteColor];
    [subsContentLayout addSubview:dappBkV];
    
    [self subItemsWithBkv:dappBkV withItems:itemArr];
}
- (void)subItemsWithBkv:(UIView *)dappBkV withItems:(NSMutableArray *)itemArr {
    CGFloat lieShu = 4;
    CGFloat itemH = 105;
    CGFloat itemW = (Screen_W-32)/lieShu;
    
    for ( int i = 0; i<itemArr.count; i++) {
        CGRect fram;
        if(i<4){
            fram =  CGRectMake( i*itemW, 0, itemW, itemH);
        }else if (i<8){
            fram =  CGRectMake( (i-lieShu)*itemW, itemH*1, itemW, itemH);
        }else{
            fram =  CGRectMake( (i-lieShu*2)*itemW, itemH*2, itemW, itemH);
        }
 
        
        DapsView *dappView = [[DapsView alloc]initWithFrame:fram];
        dappView.delegate = self;
        dappView.centerBottomTitle.text = [NSString stringWithFormat:@"%@",itemArr[i]];
        dappView.dapAllCellBtn.tag = 300+i;
        //dappView.backgroundColor = Y_randomColor;
        dappView.centerTopImgView.image = [UIImage imageNamed:@"我的"];
        [dappBkV addSubview:dappView];
    }
    
}
 
 
//评论
- (void)bottomInfoListWithLayout:(MyLinearLayout*)contentLayout{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-KNavBarHeight-kTabBar_Height) style:UITableViewStylePlain];
    _tableView.estimatedRowHeight = 45;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    

    self.tableView.separatorInset = UIEdgeInsetsMake(0, 65, 0, 20);
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ZiXunInfoTableViewCell class] forCellReuseIdentifier:ZiXunInfoTableViewCell_I];
    self.tableView.myCenterX = 0;
//    self.tableView.myMargin = 10;
    self.tableView.myHorzMargin = 0;//左右
    self.tableView.myTop = 10;
    self.tableView.myBottom = -2;//线
    [contentLayout addSubview:self.tableView];

}





#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infoArr.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // return [[UITableViewCell alloc]init];
  //MyLayout中的布局视图可以支持UITableViewCell的高度自适应的能力。这里注册两个cell，一个是不和AutoLayout结合的实现，一个是和AutoLayout结合的实现。至于使用哪种方式您可以二选一。
//    NSString *identifiers[2] = {@"alltest1_cell", @"alltest1_cell_forautolayout"};
        
  //如果你最低支持到iOS8那么请用这个方法来初始化一个UITableviewCell,用这个方法要记得调用registerClass来注册UITableviewCell，否则可能会返回nil
    //这里因为AllTest1TableViewCell和AllTest1TableViewCellForAutoLayout的方法名相同，所以这里虽然是两个不同的类，但是我们还是可以使用，你可以将下面的代码改为identifiers[1]试试AllTest1TableViewCellForAutoLayout这个cell类。
    ZiXunInfoTableViewCell*cell = (ZiXunInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:ZiXunInfoTableViewCell_I forIndexPath:indexPath];

    cell.textMessageLabel.text = self.infoArr[indexPath.row];
   // RecommendDetailPinLunModel *model = [self.datas objectAtIndex:indexPath.row];
//    BOOL isImageMessageHidden = [[self.imageHiddenFlags objectAtIndex:indexPath.row] boolValue];
    //[cell setModellll:model];

//    //这里设置其他位置有间隔线而最后一行没有下划线。我们可以借助布局视图本身所提供的边界线来代替掉系统默认的cell之间的间隔线，因为布局视图的边界线所提供的能力要大于默认的间隔线。
//    if (indexPath.row  == self.datas.count - 1)
//    {
//        cell.rootLayout.bottomBorderline = nil;
//    }
//    else
//    {
//        MyBorderline  *bld = [[MyBorderline alloc] initWithColor:[UIColor brownColor]];
//        cell.rootLayout.bottomBorderline = bld;
//    }

    return cell;
}


#pragma mark -- UITableVewDelegate
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 10)];
//    return [UIView new];;
//}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    AllTest1TableViewHeaderFooterView *headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerfooterview"];
//    if (headerFooterView == nil)
//        headerFooterView = [[AllTest1TableViewHeaderFooterView alloc] initWithReuseIdentifier:@"headerfooterview"];
//
//
//    [headerFooterView setItemChangedAction:^(NSInteger index){
//
//        NSString *message = [NSString stringWithFormat:@"You have select index:%ld",(long)index];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//
//        [alertView show];
//
//    }];
//
//    return headerFooterView;
//
//}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  44;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"didSelectRowAtIndexPath %ld",indexPath.row);
    
//    self.imageHiddenFlags[indexPath.row] = @(![self.imageHiddenFlags[indexPath.row] boolValue]);
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
