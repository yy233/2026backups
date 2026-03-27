//
//  ChatReportComplaintsVc.m
//  Community
//
//  Created by 余莹 on 2021/5/18.
//

#import "ChatReportComplaintsVc.h"
#import "ChatReportComplaintsCollectionViewCell.h"
#define  ChatReportComplaintsCollectionViewCell_Identifier               @"ChatReportComplaintsCollectionViewCell"

@interface ChatReportComplaintsVc () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UILabel *topTipLabel;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) NSMutableArray *titleArr;
@property (nonatomic,strong) NSMutableArray *imgNameArr;
@end

@implementation ChatReportComplaintsVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupsetupNavigationBarWithChatVcStyle];
    
}
#pragma mark ==
#pragma mark==
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"");
}
#pragma mark==
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titleArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ChatReportComplaintsCollectionViewCell *cell = (ChatReportComplaintsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ChatReportComplaintsCollectionViewCell_Identifier  forIndexPath:indexPath];
    [cell fillSubCellWithTitleStr:self.titleArr[indexPath.item] withImgNameStr:self.imgNameArr[indexPath.item]];
     return cell;
}
#pragma mark ==
- (void)initView{
    [self.view addSubview:self.topTipLabel];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.footerView];
    [_topTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_topTipLabel.superview).offset(16);
        make.right.equalTo(_topTipLabel.superview).offset(-16);
        make.height.offset(20);
    }];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topTipLabel.mas_bottom).offset(30);
        make.left.equalTo(_collectionView.superview).offset(16);
        make.right.equalTo(_collectionView.superview).offset(-16);
        make.height.offset(220);
    }];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_footerView.superview).offset(-20);
        make.left.right.equalTo(_footerView.superview);
        make.height.offset(90);
    }];
}
#pragma mark ==
- (UILabel *)topTipLabel{
    if (!_topTipLabel) {
        _topTipLabel = [[UILabel alloc]init];
        _topTipLabel.textColor = [Y_ColorWith16FromRGB(0x333333) colorWithAlphaComponent:0.7];
        _topTipLabel.font = [UIFont systemFontOfSize:12];
        _topTipLabel.text = @"请选择投诉原因 :";
    }
    return _topTipLabel;
}
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 90)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"立即提交"];
        [_footerView.footerBtn newAnBtnWithLayerCorNerNum:22 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
    }
    return _footerView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake((Screen_W-32-50)/3, 110);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);//top0
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 110*2) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
            [_collectionView registerClass:[ChatReportComplaintsCollectionViewCell class] forCellWithReuseIdentifier: ChatReportComplaintsCollectionViewCell_Identifier];
    }
    return _collectionView;
}
#pragma mark ==
- (NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [[NSMutableArray alloc]initWithObjects:@"造成骚扰",@"欺诈骗钱",@"账号盗用",@"侵权行为",@"虚假信息",@"内容不适",nil];
    }
    return _titleArr;
}
- (NSMutableArray *)imgNameArr{
    if (!_imgNameArr) {
        _imgNameArr = [[NSMutableArray alloc]initWithObjects:@"report_ico1",@"report_ico2",@"report_ico3",@"report_ico4",@"report_ico5",@"report_ico6", nil];
    }
    return _imgNameArr;
}

@end
