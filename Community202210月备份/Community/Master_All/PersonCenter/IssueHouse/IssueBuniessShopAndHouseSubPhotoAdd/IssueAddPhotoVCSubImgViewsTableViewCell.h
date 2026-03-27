//
//  IssueAddPhotoVCSubImgViewsTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/1/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    Cell_SubImgViews_Type_mainImg,//头图
    Cell_SubImgViews_Type_shiNeiImg,//室内图
    Cell_SubImgViews_Type_otherImg,//其他图
    Cell_SubImgViews_Type_HouseTypeMainImg,//此类是房屋租赁的图片cell计算所用类型
} Cell_SubImgViews_Type;

@protocol IssueAddPhotoVCSubImgViewsTableViewCellDelegate <NSObject>
- (void)subImgViewsCellAddPhotoActionWithCellType:(Cell_SubImgViews_Type)type;
- (void)subImgViewsCellEditPhotoActionWithCellType:(Cell_SubImgViews_Type)type withIndex:(NSInteger)index;
- (void)subImgViewsCellDeletPhotoActionWithCellType:(Cell_SubImgViews_Type)type withIndex:(NSInteger)index;
@end

@interface IssueAddPhotoVCSubImgViewsTableViewCell : UITableViewCell
- (void)dataSourceWithImgviewsArr:(NSMutableArray *)dataSourceImgArr andType:(Cell_SubImgViews_Type)type;
@property (nonatomic,weak) id <IssueAddPhotoVCSubImgViewsTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
