//
//  RecommendCollectionViewCell.h
//  Socialize
//
//  Created by 余莹 on 2023/5/15.
//

#import <UIKit/UIKit.h>

static NSString * _Nullable kRecommendCollectionViewCell_I = @"RecommendCollectionViewCell";
static NSString * _Nullable RecommendCollectionViewCell_TopCell_I = @"RecommendCollectionViewCell_TopCell";


NS_ASSUME_NONNULL_BEGIN

@interface RecommendCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titL;
@property (nonatomic,strong) UIView *typeBkView;
@end

@interface RecommendCollectionViewCell_TopCell : UICollectionViewCell
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIImageView *imgView;
@end

NS_ASSUME_NONNULL_END
