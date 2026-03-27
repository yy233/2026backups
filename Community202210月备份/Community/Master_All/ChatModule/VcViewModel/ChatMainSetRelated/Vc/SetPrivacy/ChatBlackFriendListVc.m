//
//  ChatBackFriendListVc.m
//  Community
//
//  Created by 余莹 on 2021/5/18.
//

#import "ChatBlackFriendListVc.h"
#import "BlackFriendCollectionViewCell.h"
#define  BlackFriendCollectionViewCell_Identifier            @"BlackFriendCollectionViewCell"
@interface ChatBlackFriendListVc () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSMutableArray *titleArr;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIButton *addBtn;

@end

@implementation ChatBlackFriendListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupsetupNavigationBarWithChatVcStyle];
    
}
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
    BlackFriendCollectionViewCell *cell = (BlackFriendCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:BlackFriendCollectionViewCell_Identifier  forIndexPath:indexPath];
    [cell fillSubCellWithTitleStr:self.titleArr[indexPath.item] withImgNameStr:@"no_avatar"];
     return cell;
}
#pragma mark ==
- (void)initView{
    [self.view addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_collectionView.superview);
        make.bottom.equalTo(_collectionView.superview).offset(-20);
    }];
}
#pragma mark ==
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake((Screen_W-32-50)/3, 110);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);//top0
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-KNavBarHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
            [_collectionView registerClass:[BlackFriendCollectionViewCell class] forCellWithReuseIdentifier: BlackFriendCollectionViewCell_Identifier];
    }
    return _collectionView;
}
- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [[UIButton alloc]init];//
    }
    return _addBtn;
}
#pragma mark ==
- (NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [[NSMutableArray alloc]initWithObjects:@"用户昵称",@"用户昵称",@"用户昵称",@"用户昵称",@"用户昵称",@"用户昵称",@"用户昵称",nil];
    }
    return _titleArr;
}

@end
