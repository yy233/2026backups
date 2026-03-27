//
//  ChatReportComplaintsCollectionViewCell.h
//  Community
//
//  Created by 余莹 on 2021/5/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatReportComplaintsCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UIView *backV;
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *titleL;

- (void)fillSubCellWithTitleStr:(NSString *)titleStr withImgNameStr:(NSString *)imgNameStr;
@end

NS_ASSUME_NONNULL_END
