//
//  ZYCommunityFairEditInputCell.h
//  Community
//
//  Created by ZY on 2021/8/7.
//

#import <UIKit/UIKit.h>
#import "ZYCommunityFairMarkModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYCommunityFairEditInputCell : UITableViewCell

@property (nonatomic, strong) TTGTextTagCollectionView *textTagCollectionView;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UITextField *priceTF;

@property (weak, nonatomic) IBOutlet UIButton *discussButton;

@property (weak, nonatomic) IBOutlet UITextField *telTF;

@property (nonatomic, strong) ZYCommunityFairMarketModel *model;

@end

NS_ASSUME_NONNULL_END
