//
//  NUIManager.h
//  阿里语音demo
//
//  Created by 余莹 on 2021/12/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^NUIGetInfoBlock)(NSString *getStr);

@interface NUIManager : NSObject
@property (nonatomic,copy) NUIGetInfoBlock getInfoBlock;

- (void)beginNui;

- (void)endNui;
@end

NS_ASSUME_NONNULL_END
