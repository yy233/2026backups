//
//  LiveRoomOCInfo.m
//  AFNetworking
//
//  Created by 余莹 on 2023/7/8.
//

#import "LiveRoomOCInfo.h"
#import "LiveRoomLocalized.h"


#define  Item_W  ( (Screen_W-100)/5 )
#define  Item_H  (75.0)

@implementation LiveRoomOCInfo

@end

#pragma mark ===

@interface BottomUsePopView ()  <UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation BottomUsePopView


- (NSArray *)titleArr{
   if(!_titleArr){
       if(!_isAudienceType){//主播
//           _titleArr = @[
//               liveRoomLocalize(@"管理成员"),
//               liveRoomLocalize(@"清除弹幕"),
//               liveRoomLocalize(@"分享"),
//               liveRoomLocalize(@"关播")];
           _titleArr = @[
               liveRoomLocalize(@"清除弹幕"),
               liveRoomLocalize(@"分享"),
               liveRoomLocalize(@"关播")];
       }else{//观众
           _titleArr = @[
               liveRoomLocalize(@"清除弹幕"),
               liveRoomLocalize(@"分享"),
               liveRoomLocalize(@"关播")];
       }
     
   }
   return _titleArr;
}
- (NSArray *)imgArr{
   if(!_imgArr){
       if(!_isAudienceType){//主播
//           _imgArr = @[@"管理",@"清除",@"分享",@"退出"];
           _imgArr = @[@"清除",@"分享",@"退出"];
           
       }else{//观众
           _imgArr = @[@"清除",@"分享",@"退出"];
       }
   
   }
   return _imgArr;
}
- (NSArray *)touchDelegaTypeNumArr{
   if(!_touchDelegaTypeNumArr){
       
       
       if(!_isAudienceType){//主播
          // @[@"管理",@"清除",@"分享",@"退出"];
//           _touchDelegaTypeNumArr = @[
//                                      @(Botom_Tool_Type_GuanLiChengYuan),
//                                      @(Botom_Tool_Type_DanMuQingKong),
//                                      @(Botom_Tool_Type_FenXiang),
//                                      @(Botom_Tool_Type_GuanBi),
//           ];
           _touchDelegaTypeNumArr = @[
                                      @(Botom_Tool_Type_DanMuQingKong),
                                      @(Botom_Tool_Type_FenXiang),
                                      @(Botom_Tool_Type_GuanBi),
           ];
           
       }else{//观众
           _touchDelegaTypeNumArr = @[
                                      @(Botom_Tool_Type_DanMuQingKong),
                                      @(Botom_Tool_Type_FenXiang),
                                      @(Botom_Tool_Type_GuanBi),
           ];
       }
   }
   return _touchDelegaTypeNumArr;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    frame =  CGRectMake(0,0, Screen_W, Screen_H);
    self = [super initWithFrame:frame];
    if (self) {
        self.bounds = frame;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.01];
        [self addSubview:self.blackBackView];
        [self addSubview:self.hidenPopViewBtn];
        [self.blackBackView addSubview:self.collectionView];
        [self setAllUI];
        
        //self.hidenPopViewBtn.backgroundColor = [[UIColor ]colorWithAlphaComponent:0.3];
    }
    return self;
}
- (void)setAllUI{
    [self.blackBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_blackBackView.superview);
        make.height.offset(180);
        make.bottom.equalTo(_blackBackView.superview).offset(30);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_collectionView.superview).offset(-40);
        make.centerX.equalTo(_collectionView.superview);
        make.top.equalTo(_collectionView.superview).offset(20);
        make.bottom.equalTo(_collectionView.superview).offset(-20);
    }];
    [_hidenPopViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_hidenPopViewBtn.superview);
        make.bottom.equalTo(_collectionView.mas_top);
    }];
    
}
- (UIView *)blackBackView{
    if(!_blackBackView){
        _blackBackView = [[UIView alloc]init];
        _blackBackView.layer.cornerRadius = 30;
        _blackBackView.backgroundColor = podUse_rgba(27, 26, 39, 1);
    }
    return _blackBackView;
}
#pragma mark ==

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[BottomToolPopViewSubCell class] forCellWithReuseIdentifier:kBottomToolPopViewSubCell_I];
        _collectionView.scrollEnabled = YES;
    }
    _collectionView.userInteractionEnabled = YES;
    return _collectionView;
 
}
- (UIButton *)hidenPopViewBtn{
    if(!_hidenPopViewBtn){
        _hidenPopViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hidenPopViewBtn addTarget:self action:@selector(touchHidenBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hidenPopViewBtn;
}
- (void)touchHidenBtn{
    NSLog(@" touchHidenBtn   ---  touchHidenBtn");
    if(_delegate && [_delegate respondsToSelector:@selector(touchCellWithBotomToolType:)]){
        Botom_Tool_Type touchType = Botom_Tool_Type_HidenSelfPopView;
        [_delegate touchCellWithBotomToolType:touchType];
    }
}

#pragma mark ==
//动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(Item_W, Item_H);
}

//动态设置每个分区的EdgeInsets｜view轮廓距离v边
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);//cv内的左右
}

//动态设置每列的间距大小|每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 5;
}
//动态设置每行的间距|每个item之间的间距|数列之间
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

//动态设置某个分区头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(Screen_W, 1);
}
//动态设置某个分区尾视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(Screen_W, 1);
}


#pragma mark ==
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.titleArr.count>self.imgArr.count){
        return self.imgArr.count;
    }else{
        return self.titleArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BottomToolPopViewSubCell *cell = (BottomToolPopViewSubCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kBottomToolPopViewSubCell_I  forIndexPath:indexPath];
    if (!cell) {
        cell = [[BottomToolPopViewSubCell alloc]initWithFrame:CGRectZero];
    }
    cell.bottomL.text = [NSString stringWithFormat:@"%@",self.titleArr[indexPath.row]];
    NSString *imgStr = [NSString stringWithFormat:@"%@",self.imgArr[indexPath.row]];
    UIImage *cellImg = [UIImage imageNamed:imgStr
                                  inBundle:liveRoomBundle_UseNoTexType()
             compatibleWithTraitCollection:nil];
    
    cell.iconImgv.image = cellImg;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@" didSelectItemAtIndexPath  %ld %ld",(long)indexPath.row,(long)indexPath.section);

    
    if(_delegate && [_delegate respondsToSelector:@selector(touchCellWithBotomToolType:)]){
        Botom_Tool_Type touchType = [ self.touchDelegaTypeNumArr[indexPath.row] intValue];
        [_delegate touchCellWithBotomToolType:touchType];
    }
    
    
 
}

@end

#pragma mark ====

@implementation BottomToolPopViewSubCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = 1234;//用于区分点击事件
        self.contentView.tag = 1234;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.iconImgv];
        [self.contentView addSubview:self.bottomL];
        [self setsubUI];
    }
    return self;
}
- (void)setsubUI{
    NSString *nowLg = [[NSUserDefaults standardUserDefaults] objectForKey:@"Locale_Type"];
    if([nowLg isEqualToString: @"zh-Hans"]){
        [_iconImgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(44.0);
            make.centerX.equalTo(_iconImgv.superview);
            make.top.equalTo(_iconImgv.superview).offset(5);
        }];
        [_bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.equalTo(_bottomL.superview);
            make.bottom.equalTo(_bottomL.superview);
            make.top.equalTo(_iconImgv.mas_bottom);
        }];

    }else{//缩小图片
        [_iconImgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(36.0);
            make.centerX.equalTo(_iconImgv.superview);
            make.top.equalTo(_iconImgv.superview).offset(5);
        }];
        _iconImgv.layer.cornerRadius = 18.0;
        [_bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.equalTo(_bottomL.superview);
            make.bottom.equalTo(_bottomL.superview);
            make.top.equalTo(_iconImgv.mas_bottom);
        }];
        
    }
   
    
}

- (UILabel *)bottomL{
    if(!_bottomL){
        _bottomL = [[UILabel alloc]init];
        _bottomL.textColor = podUse_rgba(153, 153, 153, 1);
        _bottomL.font = [UIFont systemFontOfSize:11.0];
        _bottomL.textAlignment = NSTextAlignmentCenter;
        _bottomL.numberOfLines = 2;
    }
    return _bottomL;
}
- (UIImageView *)iconImgv{
    if(!_iconImgv){
        _iconImgv = [[UIImageView alloc]init];
        _iconImgv.contentMode = UIViewContentModeCenter;
        _iconImgv.layer.cornerRadius = 22.0;
        _iconImgv.layer.masksToBounds = YES;
        _iconImgv.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.25];

    }
    return _iconImgv;
}
 
@end

 

#pragma mark === 管理员popview

@interface AdmainManagerPopView () <UITableViewDelegate,UITableViewDataSource>
@end
@implementation AdmainManagerPopView



- (instancetype)initWithFrame:(CGRect)frame{
    frame =  CGRectMake(0,0, Screen_W, Screen_H);
    self = [super initWithFrame:frame];
    if (self) {
        self.bounds = frame;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.01];
        [self addSubview:self.blackBackView];
        [self addSubview:self.hidenPopViewBtn];
        [self.blackBackView addSubview:self.tableView];
        [self setAllUIs];
    }
    return self;
}
- (void)setAllUIs{
    [self.blackBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_blackBackView.superview);
        make.height.equalTo(_blackBackView.superview).multipliedBy(0.6);
        make.bottom.equalTo(_blackBackView.superview).offset(30);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_tableView.superview).offset(-40);
        make.centerX.equalTo(_tableView.superview);
        make.top.equalTo(_tableView.superview).offset(20);
        make.bottom.equalTo(_tableView.superview).offset(-20);
    }];
    [self.hidenPopViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_hidenPopViewBtn.superview);
        make.bottom.equalTo(_tableView.mas_top);
    }];
    self.tableView.tableHeaderView = self.headerView;
    UIView *foov = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 50)];
    foov.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = foov;
    __block UITableView* blockSelfTableView = self.tableView;
    self.headerView.showListTypeChangeBlock = ^{
        [blockSelfTableView reloadData];
    };
    
}
- (UIView *)blackBackView{
    if(!_blackBackView){
        _blackBackView = [[UIView alloc]init];
        _blackBackView.layer.cornerRadius = 30;
        _blackBackView.backgroundColor = podUse_rgba(27, 26, 39, 1);
    }
    return _blackBackView;
}
#pragma mark ==
- (AdmainManagerPopViewSubHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[AdmainManagerPopViewSubHeaderView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 100)];
    }
    return _headerView;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, Screen_W-40, Screen_H*0.6) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (UIButton *)hidenPopViewBtn{
    if(!_hidenPopViewBtn){
        _hidenPopViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hidenPopViewBtn addTarget:self action:@selector(touchHidenBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hidenPopViewBtn;
}
- (void)touchHidenBtn{
    NSLog(@" touchHidenBtn   ---  touchHidenBtn");
    if(_delegate && [_delegate respondsToSelector:@selector(touchCellWithHidenAdmangerPopView)]){
        [_delegate touchCellWithHidenAdmangerPopView];
    }
}



#pragma mark ========
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AdmainManagerPopViewSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAdmainManagerPopViewSubTableViewCelll_I];
    if(!cell){
        cell = [[AdmainManagerPopViewSubTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kAdmainManagerPopViewSubTableViewCelll_I];
    }
    cell.nameStrLabel.text = @"AdmainManagerPopViewSubTableViewCellAdmainManagerPopViewSubTableViewCell11";
    return cell;
}


@end

#pragma mark== cell

@implementation AdmainManagerPopViewSubTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview: self.nameStrLabel];
        [self.contentView addSubview: self.headerImgv];
        [self setallUIs];
        
    }
    return self;
}
 
- (void)setallUIs{
    [_headerImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(44.0);
        make.centerY.equalTo(_headerImgv.superview);
        make.left.equalTo(_headerImgv.superview).offset(20);
    }];
    [_nameStrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headerImgv.mas_right).offset(15);
        make.top.bottom.equalTo(_nameStrLabel.superview);
        make.right.equalTo(_nameStrLabel.superview).offset(-20);
    }];
}

- (UILabel *)nameStrLabel{
    if(!_nameStrLabel){
        _nameStrLabel = [[UILabel alloc]init];
        _nameStrLabel.textColor = podUse_rgba(238, 238, 238, 1);
        _nameStrLabel.font = [UIFont systemFontOfSize:12.0];
        _nameStrLabel.textAlignment = NSTextAlignmentLeft;
        _nameStrLabel.numberOfLines = 2;
    }
    return _nameStrLabel;
}
- (UIImageView *)headerImgv{
    if(!_headerImgv){
        _headerImgv = [[UIImageView alloc]init];
        _headerImgv.contentMode = UIViewContentModeCenter;
        _headerImgv.layer.cornerRadius = 22.0;
        _headerImgv.layer.masksToBounds = YES;
        _headerImgv.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.25];

    }
    return _headerImgv;
}
@end

#pragma mark== headerv


@implementation AdmainManagerPopViewSubHeaderView
//100h
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.popViewTitleL];
        [self addSubview:self.onLineTypeBtn];
        [self addSubview:self.nomalTypeBtn];
        [self setheaderUi];
        //
        self.onLineTypeBtn.selected = YES;
        self.nomalTypeBtn.selected = NO;
        self.isNomalTypeListShow = NO;
    }
    return self;
}
- (void)setheaderUi{
    [_popViewTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_popViewTitleL.superview).offset(10);
        make.height.offset(36);
        make.left.right.equalTo(_popViewTitleL.superview);
    }];
    [_onLineTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_popViewTitleL.mas_bottom);
        make.height.offset(44);
        make.width.equalTo(_onLineTypeBtn.superview).multipliedBy(0.4);
        make.left.equalTo(_onLineTypeBtn.superview).offset(10);
    }];
    [_nomalTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.width.equalTo(_onLineTypeBtn);
        make.right.equalTo(_nomalTypeBtn.superview).offset(-10);
    }];

    
}
- (UILabel *)popViewTitleL{
    if(!_popViewTitleL){
        _popViewTitleL = [[UILabel alloc]init];
        _popViewTitleL.textColor = podUse_rgba(238, 238, 238, 1);
        _popViewTitleL.font = [UIFont systemFontOfSize:15.0];
        _popViewTitleL.textAlignment = NSTextAlignmentCenter;
        _popViewTitleL.numberOfLines = 2;
        
    }
    return _popViewTitleL;
}

- (UIButton *)onLineTypeBtn{
    if(!_onLineTypeBtn){
        _onLineTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_onLineTypeBtn setTitle:@"在线" forState:UIControlStateNormal];
        [_onLineTypeBtn setTitleColor:podUse_rgba(138, 138, 138, 1) forState:UIControlStateNormal];
        [_onLineTypeBtn setTitleColor:podUse_rgba(238, 238, 238, 1) forState:UIControlStateSelected];
        [_onLineTypeBtn addTarget:self action:@selector(onLineTypeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _onLineTypeBtn.titleLabel.numberOfLines = 2;
    }
    return _onLineTypeBtn;
}
- (UIButton *)nomalTypeBtn{
    if(!_nomalTypeBtn){
        _nomalTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nomalTypeBtn setTitle:@"普通" forState:UIControlStateNormal];
        [_nomalTypeBtn setTitleColor:podUse_rgba(138, 138, 138, 1) forState:UIControlStateNormal];
        [_nomalTypeBtn setTitleColor:podUse_rgba(238, 238, 238, 1) forState:UIControlStateSelected];
        [_nomalTypeBtn addTarget:self action:@selector(nomalTypeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _nomalTypeBtn.titleLabel.numberOfLines = 2;
    }
    return _nomalTypeBtn;
}


- (void)onLineTypeBtnAction{
    if(self.onLineTypeBtn.selected == YES){
        return;
    }
    self.onLineTypeBtn.selected = YES;
    self.nomalTypeBtn.selected = NO;
    self.isNomalTypeListShow = NO;
    if(self.showListTypeChangeBlock){
        self.showListTypeChangeBlock();
    }
}
- (void)nomalTypeBtnAction{
    if(self.nomalTypeBtn.selected == YES){
        return;
    }
    self.onLineTypeBtn.selected = NO;
    self.nomalTypeBtn.selected = YES;
    self.isNomalTypeListShow = YES;
    if(self.showListTypeChangeBlock){
        self.showListTypeChangeBlock();
    }
}
@end
