//
//  ChatViewEmojoNameShare.m
//  Community
//
//  Created by 余莹 on 2022/6/14.
//

#import "ChatViewEmojoNameShare.h"
@class ChatViewEmojiTool;
@implementation ChatViewEmojoNameShare

singleton_implementation(share);

- (NSMutableArray *)emjAllNameArr{
    if (!_emjAllNameArr) {
        _emjAllNameArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _emjAllNameArr;
}
- (void)initFileArr{
//    NSString  *bundlePath = [NSString stringWithFormat:@"%@%@",[NSBundle mainBundle ].resourcePath, kEmj_BuildleFileName ];
    NSString  *bundlePath = [[NSBundle mainBundle ].resourcePath   stringByAppendingPathComponent:  kEmj_BuildleFileName ];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray* arr=[fm contentsOfDirectoryAtPath:bundlePath error:nil];
    self.emjAllNameArr = [NSMutableArray arrayWithArray:[arr sortedArrayUsingSelector:@selector(compare:)]];//排序的
    NSLog(@"_emjAllNameArr == %@",_emjAllNameArr);
}
 

    
@end
