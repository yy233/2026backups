//
//  ChatViewEmojoNameShare.h
//  Community
//
//  Created by 余莹 on 2022/6/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString const* kEmj_BuildleFileName = @"ChatBottomEmj.bundle";

@interface ChatViewEmojoNameShare : NSObject
@property (nonatomic,strong) NSMutableArray *emjAllNameArr;
- (void)initFileArr;

singleton_interface(share)

@end

NS_ASSUME_NONNULL_END
