//
//  MyNftBaseCollectionViewCell.h
//  Socialize
//
//  Created by 余莹 on 2023/5/30.
//

#import <UIKit/UIKit.h>
static NSString *kMyNftBaseCollectionViewCell_i = @"MyNftBaseCollectionViewCell";
NS_ASSUME_NONNULL_BEGIN

@interface MyNftBaseCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titL;
@property (nonatomic,strong) UIView *typeBkView;
@end

NS_ASSUME_NONNULL_END
