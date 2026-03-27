//
//  ZYIssueActivityVoiceCell.h
//  Community
//
//  Created by ZY on 2021/11/15.
//

#import <UIKit/UIKit.h>
#import "ZYPensionMainActivityModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^VoicePlayCompleteBlock)(ZYPensionMainActivityDataModel *model);

@protocol ZYIssueActivityVoiceCellDelegate <NSObject>

- (void)playButtonEvent;

- (void)closeButtonEvent;

@end

@interface ZYIssueActivityVoiceCell : UITableViewCell

@property (nonatomic, strong) ZYPensionMainActivityDataModel *model;

@property (nonatomic, weak) id<ZYIssueActivityVoiceCellDelegate> delegate;

@property (nonatomic, copy) VoicePlayCompleteBlock voicePlayCompleteBlock;

@end

NS_ASSUME_NONNULL_END
