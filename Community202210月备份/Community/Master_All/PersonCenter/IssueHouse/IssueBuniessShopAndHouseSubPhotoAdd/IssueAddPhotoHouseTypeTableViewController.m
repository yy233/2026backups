//
//  IssueAddPhotoHouseTypeTableViewController.m
//  Community
//
//  Created by 余莹 on 2021/2/27.
//

#import "IssueAddPhotoHouseTypeTableViewController.h"
#import "IssueAddPhotoVCSubImgViewsTableViewCell.h"
#define  IssueAddPhotoVCSubImgViewsTableViewCell_Identifier           @"IssueAddPhotoVCSubImgViewsTableViewCell"
#define  Height_cell_oneHang             100
//
#import "IssueAddPhotoViewModel.h"
@interface IssueAddPhotoHouseTypeTableViewController ()<IssueAddPhotoVCSubImgViewsTableViewCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation IssueAddPhotoHouseTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectionTitleArr = [[NSArray alloc]initWithObjects:@"房屋图片",nil];
    self.sectionDetailTitleArr = [[NSArray alloc]initWithObjects:@"至少上传1张 1/8",nil];
     
}

#pragma mark ==
- (void)footerBtnFinishAction{
    if (self.sectionOneImgArr.count == 0) {//必须>1
        Y_SVP_SHOW_INFO_MES(@"缺少图片数据");
        return;
    }
    
    Y_SVP_SHOW_MES_IsDealing_15Delay;
    [IssueAddPhotoViewModel issueAddHousePhotosWithAllImgs:self.sectionOneImgArr block:^(NSArray * arr, BOOL success) {
        if (success){
            NSString *msg = [NSString stringWithFormat:@"成功提交\n%@%ld张",self.sectionTitleArr.firstObject,arr.count];
            // @"URL" @"IMG"
            NSMutableDictionary *noticeHouseDic = [[NSMutableDictionary alloc]init];
            [noticeHouseDic setValue:arr forKey:@"URL"];
            [noticeHouseDic setValue:self.sectionOneImgArr forKey:@"IMG"];
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_SUCCESS_MES(msg);
                Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(HousePhotoAddEnd_Notice_Name, noticeHouseDic);//图片url+img数据。房屋的数据
                [self popVC];
            });
        }
    }];
}
#pragma mark == delet
- (void)subImgViewsCellDeletPhotoActionWithCellType:(Cell_SubImgViews_Type)type withIndex:(NSInteger)index{
    [self.sectionOneImgArr removeObjectAtIndex:index];
    [self.tableView reloadData];
}
#pragma mark == edit
- (void)subImgViewsCellEditPhotoActionWithCellType:(Cell_SubImgViews_Type)type withIndex:(NSInteger)index{
    DLog(@"编辑 %ld",(long)index);
}
#pragma mark == add 省略
//
#pragma mark - Table view data source //重写

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section>0) {
        return 0;
    }
    if (indexPath.row==0) {
        return 40;
    }else{
        if (indexPath.section==0) {
            if (self.sectionOneImgArr.count>=4) {
                return Height_cell_oneHang*2;
            }else{
                return Height_cell_oneHang;
            }
        }else if (indexPath.section==1){
            if (self.sectionTwoImgArr.count>=4) {
                return Height_cell_oneHang*2;
            }else{
                return Height_cell_oneHang;
            }
         }else{
             if (self.sectionThrImgArr.count>=4) {
                 return Height_cell_oneHang*2;
             }else{
                 return Height_cell_oneHang;
             }
            
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont systemFontOfSize:17];
            cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5];
        }
        cell.textLabel.text = self.sectionTitleArr[indexPath.section];
        cell.detailTextLabel.text = self.sectionDetailTitleArr[indexPath.section];
        return cell;
    }else{
        IssueAddPhotoVCSubImgViewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueAddPhotoVCSubImgViewsTableViewCell_Identifier];
        if (!cell) {
            cell = [[IssueAddPhotoVCSubImgViewsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueAddPhotoVCSubImgViewsTableViewCell_Identifier];
        }
        cell.delegate = self;
        [cell dataSourceWithImgviewsArr:self.sectionOneImgArr andType:Cell_SubImgViews_Type_HouseTypeMainImg];
        return cell;
    }
}

@end
