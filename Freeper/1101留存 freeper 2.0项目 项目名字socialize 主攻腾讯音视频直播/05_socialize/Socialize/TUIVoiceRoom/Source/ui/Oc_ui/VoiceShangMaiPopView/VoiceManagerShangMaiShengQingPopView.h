//
//  VoiceManagerShangMaiShengQingPopView.h
//  AFNetworking
//
//  Created by 余莹 on 2023/6/1.
//

#import <UIKit/UIKit.h>
#import "VoiceMemberPopListView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol VoiceManagerShangMaiShengQingPopViewDelegate <NSObject>
- (void)shangMaiTongYiWithIdstr:(NSString *)idstr;
- (void)shangMaiJuJueWithIdstr:(NSString *)idstr;

@end


@interface VoiceManagerShangMaiShengQingPopView : VoiceMemberPopListView
@property (nonatomic,weak) id<VoiceManagerShangMaiShengQingPopViewDelegate>shangMaiSheZhiDelegate;
@end

NS_ASSUME_NONNULL_END
