//
//  ChatVcMsgViewModel.h
//  Community
//
//  Created by 余莹 on 2022/3/23.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface ChatVcMsgViewModel : BaseDataViewModel

@property (nonatomic,assign) ChatVc_Seesion_type chatVc_Seesion_type;//群类型 非群类型
@property (nonatomic,copy) NSString *fID;//好友
@property (nonatomic,copy) NSString *gID;//群

@end

NS_ASSUME_NONNULL_END
