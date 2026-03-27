//
//  VoiceSetManagerPearsonsPopView.h
//  AFNetworking
//
//  Created by 余莹 on 2023/6/1.
//

#import <UIKit/UIKit.h>
#import "VoiceMemberPopListView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VoiceSetManagerPearsonsPopViewDelegate <NSObject>

- (void)setMamagerPopViewAddPersonWithInfoIDStr:(NSString *)idstr;
- (void)setMamagerPopViewDeletPersonWithInfoIDStr:(NSString *)idstr;

@end

@interface VoiceSetManagerPearsonsPopView : VoiceMemberPopListView
@property (nonatomic,weak) id <VoiceSetManagerPearsonsPopViewDelegate> setManagerPopDelegate;
@end

NS_ASSUME_NONNULL_END
