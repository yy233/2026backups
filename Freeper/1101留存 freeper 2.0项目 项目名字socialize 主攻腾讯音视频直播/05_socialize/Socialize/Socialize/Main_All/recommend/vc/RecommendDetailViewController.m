//
//  RecommendDetailViewController.m
//  Socialize
//
//  Created by 余莹 on 2023/5/15.
//

#import "RecommendDetailViewController.h"
#import "MyLayout.h"

#import "RecommendDetailPinLunModel.h"
#import "RecommendPinLunTableViewCell.h"

#import "HistoryHolderTableViewController.h"
#import "MoreNftViewController.h"

#define  topImgView_H   (280.0)
#define  headerV_H     (80)
#define  btnsV_H        (60)
#define  history_item_H   (60)


@interface RecommendDetailViewController () <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) MyLinearLayout *contentLayout;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *topImgv;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIView *btnsView;
@property (nonatomic,strong) UIView *historyView;
@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *datas;             //评论数据模型数组

@end

@implementation RecommendDetailViewController


#pragma  mark ===

- (NSMutableArray *)datas{
    if(!_datas){
        _datas = [NSMutableArray new];
        
        NSArray *headImages = @[@"head1",
                                @"head2",
                                @"minions1",
                                @"minions4",
                                @"head1"
                                ];
        
        NSArray *nickNames = @[@"欧阳大哥",
                               @"醉里挑灯看键",
                               @"张三",
                               @"李四",
                               @"欧阳大哥"
                               ];
        
        NSArray *textMessages = @[@"aaaa哈哈",
                                  @"This Demo is used to introduce the solution when use layout view to realize the UITableViewCell's dynamic height. We only need to use the layout view's sizeThatFits method to evaluate the size of the layout view. and you can touch the Cell to shrink the height when the Cell has a picture.",
                                  @"This section not only has texThis section not only has texThis section not only has texThis section not only has texThis section not only has texThis section not only has texThis section not only has texThis section not only has texThis section not only has texThis section not only has texThis section not only has texThis section not only has texThis section not only has texThis section not only has texThis section not only has texThis section not only has texThis section not only has texThis section not only has texThis section not only has texThis section not only has texThis section not only has texThis section not only has texThis section not only has texThis section not only has texThis section not only has texThis section not only has text",
                                  
                                  @"",
                                  @"哈"
                                  ];
        
        for (int i = 0; i < 30; i++)
        {
            RecommendDetailPinLunModel *model = [[RecommendDetailPinLunModel alloc]init];

            model.headImage    =  headImages[arc4random_uniform((uint32_t)headImages.count)];
            model.nickName     =  [NSString stringWithFormat:@"%d %@",i,nickNames[arc4random_uniform((uint32_t)nickNames.count)]];
            model.textMessage  =  textMessages[arc4random_uniform((uint32_t)textMessages.count)];
            [_datas addObject:model];
         } 

      
    }
    return _datas;
}
- (void)viewDidLoad {
    self.title = @"详情";
    [super viewDidLoad];
}
//透明色
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
    [self setup_NavigationBar_TransparentBk_whiteText];
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
        NSDictionary *attDic = @{
            NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
            NSForegroundColorAttributeName:[UIColor whiteColor]};
        navigationBar.titleTextAttributes =  attDic;
    }
    else {
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        navigationBar.backgroundColor = [self navBackColor];
        navigationBar.barTintColor = [self navBackColor];
        navigationBar.shadowImage = Y_gray_img;
        NSDictionary *attDic = @{
            NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
            NSForegroundColorAttributeName:[UIColor whiteColor]};
        navigationBar.titleTextAttributes =  attDic;
        [[UINavigationBar appearance] setTranslucent:NO];
    }
  

}
- (UIColor *)navBackColor {
    return [UIColor clearColor];;
}

- (void)loadView{
    [super loadView];
    [self initSv];
    [self initMainLinearLout];
}
- (void)initSv{
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
  
    
    UIImageView *topImgv = [UIImageView new];
    topImgv.backgroundColor = [UIColor cyanColor];
    topImgv.frame = CGRectMake(0, -KNavBarHeight, Screen_W, topImgView_H);
    
    [scrollView addSubview:topImgv];
    self.scrollView = scrollView;
    self.topImgv = topImgv;
    
    self.view = scrollView;
    
}

- (void)initMainLinearLout{
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    contentLayout.padding = UIEdgeInsetsMake(0, 16, 10, 16); //设置布局内的子视图离自己的边距.
    contentLayout.myHorzMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
//    contentLayout.heightSize.lBound(_scrollView.heightSize, Screen_H-KNavBarHeight-kTabBar_Height, 1); //高度虽然是自适应的。但是最小的高度不能低于父视图的高度 +x
    contentLayout.heightSize.lBound(_scrollView.heightSize, topImgView_H+btnsV_H+headerV_H+history_item_H*2+50, 1); //高度虽然是自适应的。但是最小的高度不能低于父视图的高度 +x
    [self.scrollView addSubview:contentLayout];
    self.contentLayout = contentLayout;
    //垂直线性布局直接添加子视图
    [self createzhanweiImg:contentLayout];
    [self headerUserInfoView:contentLayout];
    [self btnsView:contentLayout];
   
    [self createTitleL:contentLayout withText:@"更多编号"];
    [self moreNftView:contentLayout];
    [self historysView:contentLayout];
    [self createTitleL:contentLayout withText:@"NFT评论"];
    [self tableviewInit:contentLayout];

    
}

//同高度的占位img
-(void)createzhanweiImg:(MyLinearLayout*)contentLayout
{
    UIImageView *img = [[UIImageView alloc]init];
    img.backgroundColor = Y_randomColor;
    img.myHeight = topImgView_H-KNavBarHeight;
    img.myTop = 0;//给到headerview的top间距0
    img.myHorzMargin = 80;
    [contentLayout addSubview:img];
}

- (void)createTitleL:(MyLinearLayout*)contentLayout withText:(NSString *)textStr{
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = textStr;
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    [titleLabel sizeToFit];
    titleLabel.myLeading = 5;
    titleLabel.myHeight = 50;
    [contentLayout addSubview:titleLabel];
    
}
#pragma makr ==
- (void)headerUserInfoView:(MyLinearLayout*)contentLayout{
    
    MyLinearLayout *userlayout = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
    userlayout.gravity = MyGravity_Horz_Left;
    userlayout.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.3];
    //layout.topPos.equalTo(self.topLayoutGuide).offset(10);
    userlayout.myHorzMargin = 0;
    userlayout.myHeight = 60;
    userlayout.myTop = 10;
    [contentLayout addSubview:userlayout];
    
    UIView *red = [UIView new];
    red.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.9];
    red.myWidth = 60;
    red.myHeight = 60;
    red.myLeft = 10;
    [userlayout addSubview:red];
    //圆角
    red.layer.mask =  [BezierPathTool bezierPathToolWithThisViewBounds:CGRectMake(0, 0, 60, 60) withCornerRadi:CGSizeMake(6, 6) withRoundingCorners:UIRectCornerAllCorners];//(UIRectCornerTopLeft | UIRectCornerTopRight)];
    
    UILabel *blue = [UILabel new];
    blue.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.3];
    //blue.layer.mask =  [BezierPathTool bezierPathToolWithThisViewBounds:CGRectMake(5, 0, 120, 50) withCornerRadi:CGSizeMake(16, 6) withRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomRight)];//
 
    blue.myHeight = 60;
    blue.myLeft = 5;
    blue.myRight = 10;
    blue.myWidth = Screen_W/2;
    blue.text = @"blueblueblueblueblueblue11blueblueblueblueblueblue22";
    [userlayout addSubview:blue];
}

- (void)btnsView:(MyLinearLayout*)contentLayout{
    CGFloat btns_h = 60;
    CGFloat btns_w = (Screen_W-32)/5;
    MyLinearLayout *btnslayout = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
    btnslayout.gravity = MyGravity_Horz_Trailing;
    btnslayout.backgroundColor = Color_Socialize_GreenColor;
    btnslayout.myHorzMargin = 0;
    btnslayout.myHeight = btns_h;
    btnslayout.myTop = 10;
    [contentLayout addSubview:btnslayout];
    
    NSArray *btnTypeArr  = @[@1,@2,@3,@4,@5];//水平平分

    for (int i = 0; i <btnTypeArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = Y_randomColor;
        btn.myHeight = btns_h;
        btn.myWidth = btns_w;
        [btn setTitle:[NSString stringWithFormat:@"%@",btnTypeArr[i]] forState:UIControlStateNormal];
        [btnslayout addSubview:btn];
    }
}

//编号
- (void)moreNftView:(MyLinearLayout*)contentLayout{
    CGFloat mores_h = 130;
    CGFloat mores_w = (Screen_W-32)/3;
    MyLinearLayout *moreslayout = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
    moreslayout.gravity = MyGravity_Horz_Trailing;
    moreslayout.backgroundColor = Color_Socialize_GreenColor;
    moreslayout.myHorzMargin = 0;
    moreslayout.myHeight = mores_h;
 
    moreslayout.myTop = 10;
    [contentLayout addSubview:moreslayout];
    
    
    NSArray *btnTypeArr  = @[@1,@2,@3];//水平平分

    for (int i = 0; i <btnTypeArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = Y_randomColor;
        btn.myHeight = mores_w-10;
        btn.myWidth = mores_w;
        [btn setTitle:[NSString stringWithFormat:@"%@",btnTypeArr[i]] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(goToNftDetail) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(goToMoreList) forControlEvents:UIControlEventTouchUpInside];

        [moreslayout addSubview:btn];
        UIImageView *nftImg = [[UIImageView alloc]init];
        nftImg.layer.cornerRadius =  6;
        [moreslayout addSubview:nftImg];
    }
    
}

- (void)goToMoreList{
    
//    MoreNftViewController *vc = [[MoreNftViewController alloc]init];
//    [self pushVc:vc];
    
    //test
    [self goHistoryList];
}


- (void)topImgBottomText:(MyLinearLayout*)contentLayout{
    CGFloat mores_h = 130;
    CGFloat mores_w = (Screen_W-32)/3;
    MyLinearLayout *moreslayout = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
    moreslayout.gravity = MyGravity_Horz_Trailing;
    moreslayout.backgroundColor = Color_Socialize_GreenColor;
    moreslayout.myHorzMargin = 0;
    moreslayout.myHeight = mores_h;
    moreslayout.myTop = 10;
    [contentLayout addSubview:moreslayout];

}

//历史持有
- (void)historysView:(MyLinearLayout*)contentLayout{
    NSMutableArray *histArr = @[@1,@2,@3,@4].mutableCopy;
//    NSMutableArray *histArr = @[].mutableCopy;
    CGFloat h_History_oneitem = 80;
  
    MyLinearLayout *historyLayout = [[MyLinearLayout alloc]initWithOrientation:MyOrientation_Vert];
    historyLayout.gravity = MyGravity_Horz_Left;
    historyLayout.backgroundColor = [[UIColor cyanColor]colorWithAlphaComponent:0.3];;
    historyLayout.myHorzMargin = 0;
    historyLayout.myHeight =  histArr.count >=2 ? h_History_oneitem*3 :h_History_oneitem*(1+histArr.count);
    historyLayout.myTop = 1;
    [contentLayout addSubview:historyLayout];
 
    UILabel *historyTitleLabel = [UILabel new];
    historyTitleLabel.text = @"历史持有人";
    historyTitleLabel.font = [UIFont systemFontOfSize:15.0];
    [historyTitleLabel sizeToFit];
    historyTitleLabel.myLeading = 5;
    historyTitleLabel.myHeight = 50;
    [historyLayout addSubview:historyTitleLabel];
    
    if(histArr.count <=0 ){
        //不做加法 放置暂无view
        UILabel *zanwuL = [[UILabel alloc]init];
        zanwuL.backgroundColor = [UIColor lightGrayColor];
        zanwuL.text = @"暂无";
        [zanwuL sizeToFit];
        zanwuL.textAlignment = NSTextAlignmentCenter;
        zanwuL.myWidth = Screen_W-32-20;
        [historyLayout addSubview:zanwuL];
    }else if(histArr.count<=2){
        //直接加
        for (int i = 0; i <histArr.count; i++) {
            UIView *vss = [self hisSubVwithInfo:histArr[i]];
            [historyLayout addSubview:vss];
        }
      
    }else{
        //只加2个
        UIView *vss1 = [self hisSubVwithInfo:histArr.firstObject];
        [historyLayout addSubview:vss1];
        UIView *vss2 = [self hisSubVwithInfo:histArr[1]];
        [historyLayout addSubview:vss2];
        
         
    }
  
}
- (UIView *)hisSubVwithInfo:(id)info{
    CGFloat hisItem_w = Screen_W-32-20;
    
    UIView *hisItem = [[UIView alloc]init];
    hisItem.bounds = CGRectMake(0, 0, hisItem_w, 80);
    hisItem.backgroundColor = [[UIColor brownColor] colorWithAlphaComponent:0.3];
    hisItem.layer.cornerRadius = 6;
    hisItem.myLeft = 10;
    hisItem.myTop = 5;
    hisItem.myWidth = hisItem_w;
    UILabel *subL = [[UILabel alloc]init];
    subL.text = [NSString stringWithFormat:@"%@",info];
    [subL sizeToFit];
    subL.backgroundColor = Y_randomColor;
    [hisItem addSubview:subL];
    return hisItem;
}


- (UIView *)hisSubvieInit:(id)info{
    CGFloat hisItem_w = Screen_W-32-20;
    
    UIView *hisItem = [[UIView alloc]init];
    hisItem.bounds = CGRectMake(0, 0, hisItem_w, 80);
    hisItem.backgroundColor = [[UIColor brownColor] colorWithAlphaComponent:0.3];
    hisItem.layer.cornerRadius = 6;
    hisItem.myLeft = 10;
    hisItem.myTop = 5;
    hisItem.myWidth = hisItem_w;
    UILabel *subL = [[UILabel alloc]init];
    subL.text = [NSString stringWithFormat:@"%@",info];
    [subL sizeToFit];
    subL.backgroundColor = Y_randomColor;
    [hisItem addSubview:subL];
    
    
    return hisItem;
}

- (void)goHistoryList{
    HistoryHolderTableViewController *vc = [[HistoryHolderTableViewController alloc]init];
    [self pushVc:vc];
}

//评论
-(void)tableviewInit:(MyLinearLayout*)contentLayout{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-KNavBarHeight-kTabBar_Height) style:UITableViewStylePlain];
    _tableView.estimatedRowHeight = 45;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    

    self.tableView.separatorInset = UIEdgeInsetsMake(0, 65, 0, 20);
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[RecommendPinLunTableViewCell class] forCellReuseIdentifier:@"RecommendPinLunTableViewCell"];
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
    return self.datas.count;//return 1;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

  //MyLayout中的布局视图可以支持UITableViewCell的高度自适应的能力。这里注册两个cell，一个是不和AutoLayout结合的实现，一个是和AutoLayout结合的实现。至于使用哪种方式您可以二选一。
//    NSString *identifiers[2] = {@"alltest1_cell", @"alltest1_cell_forautolayout"};
        
  //如果你最低支持到iOS8那么请用这个方法来初始化一个UITableviewCell,用这个方法要记得调用registerClass来注册UITableviewCell，否则可能会返回nil
    //这里因为AllTest1TableViewCell和AllTest1TableViewCellForAutoLayout的方法名相同，所以这里虽然是两个不同的类，但是我们还是可以使用，你可以将下面的代码改为identifiers[1]试试AllTest1TableViewCellForAutoLayout这个cell类。
    RecommendPinLunTableViewCell*cell = (RecommendPinLunTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"RecommendPinLunTableViewCell" forIndexPath:indexPath];
    
        
    RecommendDetailPinLunModel *model = [self.datas objectAtIndex:indexPath.row];
//    BOOL isImageMessageHidden = [[self.imageHiddenFlags objectAtIndex:indexPath.row] boolValue];
    [cell setModellll:model];
    
    //这里设置其他位置有间隔线而最后一行没有下划线。我们可以借助布局视图本身所提供的边界线来代替掉系统默认的cell之间的间隔线，因为布局视图的边界线所提供的能力要大于默认的间隔线。
    if (indexPath.row  == self.datas.count - 1)
    {
        cell.rootLayout.bottomBorderline = nil;
    }
    else
    {
        MyBorderline  *bld = [[MyBorderline alloc] initWithColor:[UIColor brownColor]];
        cell.rootLayout.bottomBorderline = bld;
    }
    
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
 
