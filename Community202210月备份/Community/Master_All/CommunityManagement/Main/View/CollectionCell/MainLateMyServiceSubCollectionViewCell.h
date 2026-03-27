//
//  MainLateMyServiceSubCollectionViewCell.h
//  Community
//
//  Created by 余莹 on 2021/8/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MyServiceSubCollectionViewCell_Type_Repair=0,
    MyServiceSubCollectionViewCell_Type_Visitor=1,
    MyServiceSubCollectionViewCell_Type_WuYe=2,
} MyServiceSubCollectionViewCell_Type;

@interface MainLateMyServiceSubCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)UIImageView *backImgView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *phoneImgBtn;

- (void)fillType:(MyServiceSubCollectionViewCell_Type)selfType;
@end

NS_ASSUME_NONNULL_END
