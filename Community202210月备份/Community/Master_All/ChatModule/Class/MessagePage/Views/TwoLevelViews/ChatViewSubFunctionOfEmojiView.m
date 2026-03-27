//
//  ChatViewSubFunctionOfEmojiView.m
//  Community
//
//  Created by 余莹 on 2022/6/9.
// 聊天底部功能——表情

#import "ChatViewSubFunctionOfEmojiView.h"
#import "ChatViewEmojiTool.h"

//横向 每行 10个

@implementation ChatViewSubFunctionOfEmojiView

- (void)initEmjData{
   
    NSString  *bundlePath = [[NSBundle mainBundle ].resourcePath   stringByAppendingPathComponent:  kEmj_BuildleFileName ];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray* arr=[fm contentsOfDirectoryAtPath:bundlePath error:nil];
    self.dataSourceArr = [NSMutableArray arrayWithArray:[arr sortedArrayUsingSelector:@selector(compare:)]];
    NSLog(@"chatVcUseEmj arr == %@",self.dataSourceArr);
    [self.emjCollectionView reloadData];
    
}

- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataSourceArr;
}
 
- (UICollectionView *)emjCollectionView{
    if (!_emjCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(k_ChatViewBottomEmj_OneItem_W_H,k_ChatViewBottomEmj_OneItem_W_H);
        //line 跟滚动方向相同的间距
        //item 跟滚动方向垂直的间距
        //sectionInset 是每个section内缩进 每个区内的区头和区尾到本区的Item之间的距离
        flowLayout.minimumLineSpacing = 0.0;
        flowLayout.minimumInteritemSpacing = 0.0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);//t,b.l.r
        // Vertical   上下滑条 （数据先铺 第一横行）
        // Horizontal 横轴滚动 （数据先铺 第一竖行）
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        _emjCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, (self.dataSourceArr.count/(Screen_W/k_height_OneItem)+1)*k_height_OneItem) collectionViewLayout:flowLayout];
        _emjCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 200) collectionViewLayout:flowLayout];

        _emjCollectionView.backgroundColor = [UIColor clearColor];;
        _emjCollectionView.showsHorizontalScrollIndicator = NO;
        _emjCollectionView.delegate = self;
        _emjCollectionView.dataSource = self;
        [_emjCollectionView registerClass:[EmojoCollectionViewCell class] forCellWithReuseIdentifier:EmojoCollectionViewCell_I];
    }
    return _emjCollectionView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initEmjData];
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.emjCollectionView];
        [_emjCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_emjCollectionView.superview);
        }];
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EmojoCollectionViewCell *cell =  (EmojoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:EmojoCollectionViewCell_I forIndexPath:indexPath];

    NSString *imgNameStr = [NSString stringWithFormat:@"%@/%@",kEmj_BuildleFileName,[TextShowWithModelStr textShowWithModelStr:self.dataSourceArr[indexPath.row]]];
    cell.imgV.image = [UIImage imageNamed:imgNameStr];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *imgNameStr = [NSString stringWithFormat:@"%@/%@",kEmj_BuildleFileName,[TextShowWithModelStr textShowWithModelStr:self.dataSourceArr[indexPath.row]]];

    if (isNil(self.chatViewSubFunctionOfEmojiViewTouchBlock)) {
        return;
    }
    self.chatViewSubFunctionOfEmojiViewTouchBlock(indexPath.row,imgNameStr);
}

@end

#pragma  mark == cell 
@implementation EmojoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imgV];
        [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(_imgV.superview);
            make.centerX.centerX.equalTo(_imgV.superview);
            make.width.height.offset(kBottomEmjImg_HW);
        }];
    }
    return self;
}
 
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgV;
}

@end
