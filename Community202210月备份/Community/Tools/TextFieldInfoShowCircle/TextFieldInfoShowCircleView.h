//
//  TextFieldInfoShowCircleView.h
//  Community
//
//  Created by 余莹 on 2021/10/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TextCircleOkBlock)(NSString *);

@interface TextFieldInfoShowCircleView : UIView 
@property (nonatomic,strong) UITextField *textF;
@property (nonatomic,strong) UIView *showBackView;
@property (nonatomic,strong) UICollectionView *showCollectionView;

@property (nonatomic,copy)TextCircleOkBlock textCircleOkBlock;

- (void)changeItemNumWithInt:(NSInteger)ItemNum;
@end

NS_ASSUME_NONNULL_END
