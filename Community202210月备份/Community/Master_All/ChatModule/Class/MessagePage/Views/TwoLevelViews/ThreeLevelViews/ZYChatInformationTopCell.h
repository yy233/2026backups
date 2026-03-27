//
//  ZYChatInformationTopCell.h
//  Community
//
//  Created by ZY on 2021/4/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYChatInformationTopCellDelegate <NSObject>
//点击
- (void)chatInformationTopCollectionViewCellSelectItemAtIndexPath:(NSIndexPath *)indexPath;
//长按 后踢出群聊
- (void)chatInformationTopCollectionViewCellLongPressItemAtIndex:(NSInteger)index;

@end

@interface ZYChatInformationTopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;

@property (nonatomic, weak) id<ZYChatInformationTopCellDelegate> delegate;
- (void)fillDataWithImgUrl:(NSString *)imgUrlStr withNickName:(NSString *)nickName;
- (void)fillDataWithGroupMemberArr:(NSMutableArray *)groupMemberArr withNickName:(NSString *)nickName;

@end

NS_ASSUME_NONNULL_END
