//
//  ChatVcMsgViewModel.m
//  Community
//
//  Created by 余莹 on 2022/3/23.
//

#import "ChatVcMsgViewModel.h"
#import "ChatManagerData.h"
//msg 消息 只能用order=2的默认顺序 最新的msg在first 要逆一边顺序再累积
@interface ChatVcMsgViewModel ()
@property (nonatomic,strong) NSMutableArray *saveOldArr;
@end

@implementation ChatVcMsgViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)getDataListOnePage{
    //第一页
    self.pageNum = 1;
    WEAKSELF
    if (self.chatVc_Seesion_type == ChatVc_Seesion_type_Group) {//群
        //历史消息
        [ChatManagerData getOneGroupChatHistoryMsgListWithGroupUUID:self.gID withBlock:^(NSDictionary * dic, BOOL success) {
            weakSelf.thisIsSuccessBool = success;
            if (success) {
                if ([[dic allKeys]containsObject:@"messages"]) {
                    NSArray *thisPageArr = [[NSArray alloc]initWithArray: [dic objectForKey: @"messages"]];
                    weakSelf.saveOldArr = [[NSMutableArray alloc]initWithArray: [weakSelf reversObjWithThisPageArr:thisPageArr]];
                    weakSelf.dataOfArr = [[NSArray alloc]initWithArray:weakSelf.saveOldArr];
                }
            }
        }];
        
    }else{
        
        [ChatManagerData  getOneFriendChatHistoryMsgListWithPageNum: self.pageNum  withPageSize:Y_PAGE_SIZE_10 WithFriendUUIDNewInfo:self.fID withBlock:^(NSArray * _Nonnull arr, BOOL success) {//好友
            weakSelf.thisIsSuccessBool = success;
            if(success){
                if (arr.count >= Y_PAGE_SIZE_10) {
                    weakSelf.pageNum += 1;
                }
                if(arr.count==0){
                    return;
                }
                weakSelf.saveOldArr = [[NSMutableArray alloc]initWithArray:  [weakSelf reversObjWithThisPageArr:arr] ]; // 得到作逆序 ，lastObj 则为最新msg
                weakSelf.dataOfArr = [[NSArray alloc]initWithArray:weakSelf.saveOldArr];
            }
        }];
    }
}
//逆序
- (NSMutableArray *)reversObjWithThisPageArr:(NSArray *)thisPageArr{
    NSMutableArray* tmpArr = (NSMutableArray *)[[thisPageArr reverseObjectEnumerator] allObjects];
    return tmpArr;
}
- (void)getDataListNextPage{
    
    
    //总页数-1 * size 小于当前arr.cout 则不做add 直接end (第一页不在这个限制内)
    if ((self.pageNum != 1)  &&  (self.pageNum-1)  * Y_PAGE_SIZE_10  < self.dataOfArr.count) {
        NSLog(@"聊天 历史消息  已经历史的最后一页了");
        self.thisIsSuccessBool = NO;
        return;
    }
    
    
    
    WEAKSELF
    if (self.chatVc_Seesion_type == ChatVc_Seesion_type_Group) {//群
    }else{
        //好友类型
        [ChatManagerData  getOneFriendChatHistoryMsgListWithPageNum:self.pageNum withPageSize:Y_PAGE_SIZE_10 WithFriendUUIDNewInfo:self.fID withBlock:^(NSArray * _Nonnull arr, BOOL success) {//好友
            weakSelf.thisIsSuccessBool = success;
            if(success){
                if (arr.count >= Y_PAGE_SIZE_10) {
                    weakSelf.pageNum += 1;
                }
                if(arr.count==0){
                    return;
                }
                
                weakSelf.saveOldArr = [NSMutableArray arrayWithArray: [weakSelf reversObjWithThisPageArr:arr]];//更长旧的历史记录 得到作逆序 再作为总arr的最前部分；
                [weakSelf.saveOldArr addObjectsFromArray:weakSelf.dataOfArr];
                weakSelf.dataOfArr = [[NSArray alloc]initWithArray:weakSelf.saveOldArr];
            }
        }];
    }
    
}

- (NSMutableArray *)saveOldArr{
    if (!_saveOldArr) {
        _saveOldArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _saveOldArr;
}

@end
