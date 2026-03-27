//
//  DiscoverTopCollectionView.m
//  Socialize
//
//  Created by 余莹 on 2023/5/13.
//

#import "DiscoverTopCollectionView.h"
static CGFloat selfHeight =  80.0;
static NSString *subCollectionCell_I = @"subCollectionCell";
#define Items_all_w  (Screen_W*3/4)
#define Item_w       (Screen_W/4-15)
#define Item_h       40

@interface DiscoverTopCollectionView () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSArray *titilArr;
@end


@implementation DiscoverTopCollectionView
- (NSArray *)titilArr{
    if(!_titilArr){
        _titilArr = @[Y_LocaleTypeFile_NSLocalString(@"推荐_直播"),Y_LocaleTypeFile_NSLocalString(@"语音直播"),Y_LocaleTypeFile_NSLocalString(@"视频直播")];
    }
    return _titilArr;
}

//- (instancetype)initWithFrame:(CGRect)frame{
//    frame = CGRectMake(0, 0, Screen_W, selfHeight);
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.nowZhiBoListTopSelectedType = ZhiBoListTopType_tuijian;
//        [self addSubview:self.searchBtn];
//        [self addSubview:self.collectionV];
//        [_collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_collectionV.superview).offset(10);
//            make.right.equalTo(_collectionV.superview).offset(50);
//            make.height.offset(Item_h);
//            make.bottom.equalTo(_collectionV.superview).offset(-10);
//        }];
//        [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_collectionV);
//            make.right.equalTo(_searchBtn.superview.mas_right).offset(-20);
//            make.width.height.offset(30);
//        }];
//        _searchBtn.hidden = YES;
//
//    }
//    return self;
//}
//- (UIButton *)searchBtn{
//    if(!_searchBtn){
//        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_searchBtn newAnBtnWithFont: [UIFont systemFontOfSize:15.0]];
//    }
//    return _searchBtn;
//}
//- (UICollectionView *)collectionV{
//    if(!_collectionV){
//        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
//        flowLayout.itemSize = CGSizeMake(Item_w,Item_h);
//        flowLayout.minimumInteritemSpacing = 0;
//        flowLayout.minimumLineSpacing = 0;
//        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//
////        _collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(10,selfHeight/2-Item_h/2, Items_all_w,Item_h) collectionViewLayout:flowLayout];
//        _collectionV = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
//        _collectionV.backgroundColor = [UIColor clearColor];
//        _collectionV.showsHorizontalScrollIndicator = NO;
//        _collectionV.delegate = self;
//        _collectionV.dataSource = self;
//        [_collectionV registerClass:[subCollectionCell class] forCellWithReuseIdentifier:subCollectionCell_I];
//        _collectionV.scrollEnabled = YES;
//    }
//    return _collectionV;
//}
//
//
//#pragma mark ==
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return 1;
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return self.titilArr.count;
//
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    subCollectionCell*cell = (subCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:subCollectionCell_I  forIndexPath:indexPath];
//    if (!cell) {
//         cell = [[subCollectionCell alloc]initWithFrame:CGRectMake(0, 0, Item_w, Item_h)];
//    }
//
//    [cell.showBtn setTitle:self.titilArr[indexPath.row]  forState:UIControlStateNormal];
//    if(indexPath.row ==  self.nowZhiBoListTopSelectedType){
//        cell.showBtn.selected = YES;
//        cell.showBtn.backgroundColor = Y_RGB(102, 208, 209);
//        if(isIPhoneXSeries){
//            cell.showBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
//        }else{
//            cell.showBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];//w小的 不能17font
//
//        }
//
//    }else{
//        cell.showBtn.selected = NO;
//        cell.showBtn.backgroundColor = [UIColor clearColor];
//        if(isIPhoneXSeries){
//            cell.showBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        }else{
//            cell.showBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//
//        }
//
//
//    }
//
//    return cell;
//}
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    self.nowZhiBoListTopSelectedType = indexPath.row;
//    [collectionView reloadData];
//    if (_delegate && [_delegate respondsToSelector:@selector(nowSelectedType: )]) {
//        [_delegate nowSelectedType:indexPath.row];
//    }
//
//}

@end



#pragma mark ===

@implementation subCollectionCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.showBtn];
        [self setsubUI];
    }
    return self;
}
- (void)setsubUI{
    
    [self.showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_showBtn.superview);
        make.bottom.equalTo(_showBtn.superview);
        make.height.offset(30.0);
        make.width.offset(Item_w-4);
    }];
    self.showBtn.titleLabel.numberOfLines = 2;//多语言显示不完
    
}
//- (UIView *)bkView{
//    if(!_bkView){
//        _bkView = [[UIView alloc]init];
//    }
//    return _bkView;
//}
//- (UILabel *)centLabel{
//    if(!_centLabel){
//        _centLabel = [[UILabel alloc]init];
//        _centLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _centLabel;
//}

- (UIButton *)showBtn{
    if(!_showBtn){
        _showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showBtn setTitleColor:rgba(51, 51, 51,1) forState:UIControlStateNormal];
        [_showBtn setTitleColor:rgba(51, 51, 51,1) forState:UIControlStateSelected];
      
        _showBtn.userInteractionEnabled = NO;
        _showBtn.layer.cornerRadius = 15;
    }
    return _showBtn;
}


@end
