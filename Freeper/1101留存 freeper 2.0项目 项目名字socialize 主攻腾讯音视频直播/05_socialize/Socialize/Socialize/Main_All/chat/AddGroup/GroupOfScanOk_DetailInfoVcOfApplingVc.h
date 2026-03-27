//
//  GroupOfScanOkReqBecomGMember.h
//  Socialize
//
//  Created by 余莹 on 2023/8/18.
//
//扫码后 跳转到申请加入某群的申请页面展示当前群详情
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//加群申请发送页
@interface GroupSendApplyInfoVc : Y_BaseViewController

@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UIButton *sendBtn;
@property (nonatomic,strong) V2TIMGroupInfoResult *groupInfoRes;


@end

//headerv
@interface GroupOfScanOk_DetailInfoVcOfApplingVc_SubHeaderView : UIView

@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *titleLBittomL;
@property (nonatomic,strong) UIButton *groupQRTocuhBtn;
@property (nonatomic,strong) UIImageView *groupImg;

@end

//扫码后跳转的群资料页
@interface GroupOfScanOk_DetailInfoVcOfApplingVc : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSString *groupId;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) GroupOfScanOk_DetailInfoVcOfApplingVc_SubHeaderView *headerView;
@property (nonatomic,strong) UIButton *applyForBecomeGroupMemberBtn;
//
@property (nonatomic,strong) V2TIMGroupInfoResult *groupInfoRes;

@end

NS_ASSUME_NONNULL_END
