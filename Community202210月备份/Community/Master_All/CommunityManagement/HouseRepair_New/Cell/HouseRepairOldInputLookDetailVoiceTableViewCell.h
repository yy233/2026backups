//
//  HouseRepairOldInputLookDetailVoiceTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/3/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *HouseRepairOldInputLookDetailVoiceTableViewCell_I = @"HouseRepairOldInputLookDetailVoiceTableViewCell";

typedef void(^TouchVoiceBlock)(void);

@interface HouseRepairOldInputLookDetailVoiceTableViewCell : UITableViewCell
@property (nonatomic,copy) TouchVoiceBlock touchVoiceBlock;

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIButton *topBtn;

- (void)fillVoiceLengthWithInt:(NSInteger)voiceLength;

@end

NS_ASSUME_NONNULL_END
