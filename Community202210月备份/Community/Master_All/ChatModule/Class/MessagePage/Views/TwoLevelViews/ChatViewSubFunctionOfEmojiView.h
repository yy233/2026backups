//
//  ChatViewSubFunctionOfEmojiView.h
//  Community
//
//  Created by 余莹 on 2022/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *EmojoCollectionViewCell_I = @"EmojoCollectionViewCell";
@interface EmojoCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *imgV;
@end


typedef void(^ChatViewSubFunctionOfEmojiViewTouchBlock)(NSInteger touchIndex,NSString *touchEmjImgName);

@interface ChatViewSubFunctionOfEmojiView : UIView <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
@property (nonatomic,strong) UICollectionView *emjCollectionView;
@property (nonatomic,copy) ChatViewSubFunctionOfEmojiViewTouchBlock chatViewSubFunctionOfEmojiViewTouchBlock;

@end

NS_ASSUME_NONNULL_END
