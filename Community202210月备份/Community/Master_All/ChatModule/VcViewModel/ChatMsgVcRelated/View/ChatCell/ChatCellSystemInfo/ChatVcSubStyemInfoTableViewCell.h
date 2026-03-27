//
//  ChatVcSubStyemInfoWithAddMemberTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/5/10.
//

#import <UIKit/UIKit.h>
#import "ChatVcSubBaseTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

#define ChatVcSubStyemInfoTableViewCell_Identifier                    @"ChatVcSubStyemInfoTableViewCell"
static NSString *ChatVcSubTipsCell_I                                  = @"ChatVcSubTipsCell";

@interface ChatVcSubStyemInfoTableViewCell : ChatVcSubBaseTableViewCell
@property (nonatomic,strong) UILabel *showSystemInfoLabel;
//- (void)fillSystemNoticeCellWithMsgTypeStr:(NSString *)msgTypeStr;
- (void)fillSystemNoticeCellWithDateStr:(NSString *)dateStr withGroupAddMemberWithWillShowStr:(NSString *)willShowStr;
@end

NS_ASSUME_NONNULL_END
