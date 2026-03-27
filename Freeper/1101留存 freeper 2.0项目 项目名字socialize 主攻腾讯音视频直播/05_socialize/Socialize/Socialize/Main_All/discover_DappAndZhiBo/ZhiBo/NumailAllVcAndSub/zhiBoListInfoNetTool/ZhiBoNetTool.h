//
//  ZhiBoNetTool.h
//  Socialize
//
//  Created by 余莹 on 2023/8/16.
//

#import <Foundation/Foundation.h>
#import "ZhiBoListViewModel.h" //直播数据mode
#import "VoiceRoomChuanZhiModel.h" //直播房间model
#import "VoiceRoomBase.h"
#import "LiveRoomBase.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZhiBoNetTool : NSObject

singleton_interface(share)

- (void)getOneZhiBoDetailInfoWithActivityID:(NSString *)actId withBlock:(BaseDicAndSuccessBoolBlock)block;

@end

NS_ASSUME_NONNULL_END
