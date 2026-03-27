//
//  ZYChatInformationTopCell.m
//  Community
//
//  Created by ZY on 2021/4/23.
//

#import "ZYChatInformationTopCell.h"
#import "ZYChatInformationTopCollectionViewCell.h"

static NSString * const chatInformationTopCollectionViewCellID = @"ZYChatInformationTopCollectionViewCell";
static NSString * const chatInformationTopAddBtnCollectionViewCellID = @"chatInformationTopAddBtnCollectionViewCellID";

#define kChatInformationTopCollectionViewCellWidth 90
#define kChatInformationTopCollectionViewCellHeight 100

@interface ZYChatInformationTopCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *iconImageArray;

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic,strong) NSMutableArray *groupMemberIdSaveArray;

@end

@implementation ZYChatInformationTopCell
- (void)fillDataWithImgUrl:(NSString *)imgUrlStr withNickName:(NSString *)nickName{
    self.titleArray = [NSMutableArray arrayWithObjects:nickName, @"加入群聊", nil];
    self.iconImageArray = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,imgUrlStr], @"ic_join_dialing_norm", nil];
    [self.collectionView reloadData];
}
- (void)fillDataWithGroupMemberArr:(NSMutableArray *)groupMemberArr withNickName:(NSString *)nickName{
    //
//    nickName 群昵称
    //
    self.titleArray = [[NSMutableArray alloc]init];
    self.iconImageArray = [[NSMutableArray alloc]init];
    for ( NSDictionary *memberDic in groupMemberArr) {
        NSString *userUuid = [[memberDic allKeys]containsObject:@"userUuid"] ? memberDic[@"userUuid"] :@"";
        NSString *avatar = [[memberDic allKeys]containsObject:@"avatar"] ? memberDic[@"avatar"] :@"";
        NSString *remarks = [[memberDic allKeys]containsObject:@"remarks"] ? memberDic[@"remarks"] :@"";
        NSString *imgAllUrlStr = [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,avatar];
        [self.titleArray addObject:remarks];
        [self.iconImageArray addObject:imgAllUrlStr];
        [self.groupMemberIdSaveArray addObject:userUuid];
    }
    //最后一个圆
    [self.titleArray addObject:@"加入群聊"];
    [self.iconImageArray addObject:@"ic_join_dialing_norm"];
    [self.groupMemberIdSaveArray addObject:@""];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
 
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self customCollectionView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 懒加载
- (NSMutableArray *)iconImageArray {
    if (!_iconImageArray) {
        _iconImageArray = [NSMutableArray arrayWithObjects:@"user-avatar_s", @"ic_join_dialing_norm", nil];
    }
    
    return _iconImageArray;
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"", @"加入群聊", nil];
    }
    
    return _titleArray;
}

#pragma mark - 定制collectionView
- (void)customCollectionView {
    
    // 设置collection横向滑动
    self.collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 设置代理
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    // 注册单元格
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZYChatInformationTopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:chatInformationTopCollectionViewCellID];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZYChatInformationTopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:chatInformationTopAddBtnCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.iconImageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.row < ([collectionView numberOfItemsInSection:0]-1)) {
        
        ZYChatInformationTopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:chatInformationTopCollectionViewCellID forIndexPath:indexPath];
        [cell.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr:self.iconImageArray[indexPath.row]]];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressChoose:)];
        longPress.numberOfTouchesRequired = 1;
        longPress.minimumPressDuration = 0.5;
        longPress.allowableMovement = 10;//长按手指能移动的最大距离
        cell.iconImageView.userInteractionEnabled = YES;
        [cell.iconImageView addGestureRecognizer:longPress];
        cell.iconImageView.tag = indexPath.row+200;
        cell.titleLabel.text = self.titleArray[indexPath.row];
        return cell;
        
    }else{
        ZYChatInformationTopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:chatInformationTopAddBtnCollectionViewCellID forIndexPath:indexPath];
        cell.iconImageView.image = [UIImage imageNamed:self.iconImageArray[indexPath.row]];
        cell.iconImageView.userInteractionEnabled = NO;//移除群成员的不响应处理
        cell.titleLabel.text = self.titleArray[indexPath.row];
        return cell;
    }
}
#pragma mark === longPressChoose
- (void)longPressChoose:(UILongPressGestureRecognizer *)longPress{
    NSInteger index =  longPress.view.tag-200;
    if (longPress.state==UIGestureRecognizerStateBegan) {
        if ([_delegate respondsToSelector:@selector(chatInformationTopCollectionViewCellLongPressItemAtIndex:)]) {
            [_delegate chatInformationTopCollectionViewCellLongPressItemAtIndex:index];
        }
    }

    
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(chatInformationTopCollectionViewCellSelectItemAtIndexPath:)]) {
        [self.delegate chatInformationTopCollectionViewCellSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(90, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// item 列间距(纵)
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 16;
}

// item 行间距(横)
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

@end
