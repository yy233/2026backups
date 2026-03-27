//
//  ChatViewEmojiTool.h
//  Community
//
//  Created by 余莹 on 2022/6/14.
//表情

#import <Foundation/Foundation.h>

#import "ChatViewEmojoNameShare.h" //表情名字

NS_ASSUME_NONNULL_BEGIN
//文件地址
//展示宽高
static CGFloat kBottomEmjImg_HW = 25.0;
static CGFloat kTextViewUseEmjImg_HW = 15.0;
//数据结构标识
static NSString *k_emj_tip_start = @"[";
static NSString *k_emj_tip_end = @"]";

typedef void(^ChatSubUseTextViewOfEmjAttributedStringBlock)(NSMutableAttributedString * okAttributedString);

@interface ChatViewEmojiTool : NSObject

+ (void)getEmjIndexArrWithStr:(NSString *)string withBlock:(ChatSubUseTextViewOfEmjAttributedStringBlock)block;
@end

NS_ASSUME_NONNULL_END
