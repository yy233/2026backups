//
//  ShareBottomPopView.m
//  TUIVoiceRoom
//
//  Created by 余莹 on 2023/6/13.
//

#import "ShareBottomPopView.h"
#import <Masonry/Masonry.h>
#import "VoiceOcTool.h"
#import <SDWebImage/SDWebImage.h>
#define  itemW  ((Screen_W-55)/4)
#define  itemH  (80)

@implementation TopImgBottomTextCollectionCell
 
 

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.topImg];
        [self.contentView addSubview:self.bottomL];
        [self setsubUI];
    }
    return self;
}


- (void)setsubUI{
    [_topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(44);
        make.centerX.equalTo(_topImg.superview);
        make.centerY.equalTo(_topImg.superview).offset(-10);
    }];
    [_bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(_bottomL.superview);
        make.top.equalTo(_topImg.mas_bottom).offset(10);
    }];
}


- (UIImageView *)topImg{
    if(!_topImg){
        _topImg = [[UIImageView alloc]init];
        _topImg.layer.cornerRadius = 21.0;
        _topImg.layer.masksToBounds = YES;
        _topImg.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    }
    return _topImg;
}
- (UILabel *)bottomL{
    if(!_bottomL){
        _bottomL = [[UILabel alloc]init];
        _bottomL.textColor = [UIColor whiteColor];
        _bottomL.font = [UIFont systemFontOfSize:12.0];
        _bottomL.textAlignment = NSTextAlignmentCenter;
        _bottomL.numberOfLines = 2;
    }
    return _bottomL;
}

@end



@interface ShareBottomPopView () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) NSArray *imgNameArr;
@end

@implementation ShareBottomPopView


#pragma mark == 重写
- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr{
}
- (void)changMainBackViewBackColor{
    self.subMainBackView.backgroundColor = [UIColor blackColor]; //Color_238GrayColor;//半截背景颜色配置
}
- (void)initSubMainHeight{
    self.subMainViewHeight  = Screen_H*0.3;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubAllView];
        [self setUI];
    }
    return self;
}
- (void)addSubAllView{
    [self.subMainBackView  addSubview:self.titleL];
    [self.subMainBackView  addSubview:self.collectionView];
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleL.superview).offset(20);
        make.top.equalTo(_titleL.superview).offset(20);
        make.height.offset(40);
    }];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_collectionView.superview);
        make.bottom.equalTo(_collectionView.superview);
        make.top.equalTo(_titleL.mas_bottom).offset(10);
    }];
    
}



- (NSArray *)dataArr{
    if(!_dataArr){
        _dataArr = @[voiceRoomLocalize(@"Web端"),
                     voiceRoomLocalize(@"Freeper APP"),
                     voiceRoomLocalize(@"Freeper群"),
        ];
    }
    return _dataArr;
}
- (NSArray *)imgNameArr{
    if(!_imgNameArr){
        _imgNameArr = @[@"连线",
                        @"freeperIcon",
                        @"连线",
        ];
    }
    return _imgNameArr;
}
 
- (UILabel *)titleL{
    if(!_titleL){
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [UIColor whiteColor];
        _titleL.font = [UIFont systemFontOfSize:16.0];
        _titleL.text = voiceRoomLocalize(@"分享给");
    }
    return _titleL;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W,80) collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[TopImgBottomTextCollectionCell class] forCellWithReuseIdentifier:@"TopImgBottomTextCollectionCell"];
        _collectionView.scrollEnabled = YES;
         
    }
    return _collectionView;
}



#pragma mark ===

#pragma mark - UICollectionViewDelegateFlowLayout
//动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(itemW, itemH);
   
}

//动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 0, 10);//某Section总的上下左右
}

//动态设置每列的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}
//动态设置每行的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 1;
}

//动态设置某个分区头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(Screen_W, 1);
}
//动态设置某个分区尾视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(Screen_W, 1);
}
#pragma mark ==

//代理相应方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TopImgBottomTextCollectionCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"TopImgBottomTextCollectionCell" forIndexPath:indexPath];
    cell.bottomL.text = self.dataArr[indexPath.row];
    cell.topImg.image = [VoiceOcTool getVoiceUseImgWithImgIconNameStr:self.imgNameArr[indexPath.row]];
    
    if(indexPath.row == self.dataArr.count-1  && self.groupFaceUrlStr.length>0){//群头像
        [cell.topImg sd_setImageWithURL:[NSURL URLWithString:self.groupFaceUrlStr] placeholderImage:[VoiceOcTool getVoiceUseImgWithImgIconNameStr:self.imgNameArr[indexPath.row]]];
    }
    
    if(indexPath.row == 0){
        cell.topImg.contentMode = UIViewContentModeCenter;
    }else{
        cell.topImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return cell;
    
}
 


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%s %ld",__func__,(long)indexPath.row);
    if(_shareBottomPopViewDelegate && [_shareBottomPopViewDelegate respondsToSelector:@selector(touchShareType:)]){
        [_shareBottomPopViewDelegate touchShareType:indexPath.row];
    }
    [self dismissThePopView];
}
 

 

@end



