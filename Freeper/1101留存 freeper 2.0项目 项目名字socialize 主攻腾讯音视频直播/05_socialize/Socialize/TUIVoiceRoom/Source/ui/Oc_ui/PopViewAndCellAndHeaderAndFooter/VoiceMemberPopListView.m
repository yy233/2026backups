//
//  VoiceMemberPopListView.m
//  TUIVoiceRoom
//
//  Created by 余莹 on 2023/5/31.
//

#import "VoiceMemberPopListView.h"
#import "VoiceOcFileUse_Header.h"
#import <Masonry/Masonry.h>

#define  pop_GreenCyanlColor  podUse_rgba(61, 240, 240, 1)
#define  pop_RedColor         podUse_rgba(249, 81, 81, 1)
#define  pop_BlckColor        podUse_rgba(51, 51, 51, 1)

#define  pop_Font_16      [UIFont systemFontOfSize:16.0]
#define  pop_Font_15      [UIFont systemFontOfSize:15.0]
#define  pop_Font_14      [UIFont systemFontOfSize:14.0]
#define  pop_Font_13      [UIFont systemFontOfSize:13.0]
#define  pop_Font_12      [UIFont systemFontOfSize:12.0]
#define  pop_Font_11      [UIFont systemFontOfSize:11.0]

#define Btn_H_58  (58)
#define Btn_H_50  (50)
#define Btn_H_30  (30)
#define Btn_H_28  (28)
#define Btn_H_20  (20)
#define Btn_W_156  (156)
#define Btn_W_58  (58)
#define Btn_W_28  (28)
#define Btn_W_20  (20)
#define Btn_W_15  (15)


@implementation VoiceMemberPopListView

- (void)tableViewOtherSet{
    self.closeBtn.hidden = YES;
    self.tableView.backgroundColor = podUse_rgba(27, 26, 39, 1);
    self.tableView.layer.cornerRadius = 30;
    [self popViewAddOtherInfo];
    
    
}
//***重写高度时使用
- (void)setSubMainViewHeight{
    self.tableViewHeight =  Screen_H *0.7;//Screen_H *0.65;
}
 
#pragma mark == 重写
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //test
    VoiceMemberPopListViewCell_ShowOnLineCell *cell = [tableView dequeueReusableCellWithIdentifier:kVoiceMemberPopListViewCell_ShowOnLineCell_I];
    if (!cell) {
        cell = [[VoiceMemberPopListViewCell_ShowOnLineCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kVoiceMemberPopListViewCell_ShowOnLineCell_I];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.textColor =  [UIColor whiteColor];
    cell.textLabel.text =  [NSString stringWithFormat:@"%@",  self.dataSource[indexPath.row]];
    return cell;
}

#pragma mark == 点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(basePopViewTag:OfSubTableViewTouchWithIndexPath:)]) {
       //[self dismissThePopView];
        [self.delegate basePopViewTag:0 OfSubTableViewTouchWithIndexPath:indexPath];//base=tag=0
    }
}

//0601
- (void)popViewAddOtherInfo{
    
}


@end



#pragma mark ==   cell 显示在线与不在线||  主播端_成员cell

@implementation VoiceMemberPopListViewCell_ShowOnLineCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        [self.contentView addSubview:self.heaImg];
        [self.contentView addSubview:self.addressL];
        [self.contentView addSubview:self.typeL];
        [self.contentView addSubview:self.rightBtn];
        [self setUs];
    }
    return self;
}
- (void)setUs{
    [_heaImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_heaImg.superview);
        make.width.height.offset(36);
        make.left.equalTo(_heaImg.superview).offset(10);
    }];
    
    //addressL typeL
    [_addressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_addressL.superview).multipliedBy(0.4);
        make.left.equalTo(_heaImg.mas_right).offset(20);
        make.top.equalTo(_heaImg);
        make.height.offset(25);
       
    }];
    [_typeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.equalTo(_addressL);
        make.top.equalTo(_addressL.mas_bottom);
        make.height.offset(20);
    }];
    
    //
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rightBtn.superview);
        make.width.height.offset(24);
        make.right.equalTo(_rightBtn.superview).offset(-20);
    }];
}
- (void)changeLabelMasOnlyShwoAddress{
    _typeL.hidden = YES;
    [_addressL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_addressL.superview).multipliedBy(0.4);
        make.left.equalTo(_heaImg.mas_right).offset(20);
        make.top.equalTo(_heaImg);
        make.height.equalTo(_heaImg);
    }];
}


#pragma mark ==

- (UIImageView *)heaImg{
    if(!_heaImg){
        _heaImg = [[UIImageView alloc]init];
        _heaImg.layer.cornerRadius = 18;//36
        _heaImg.layer.masksToBounds = YES;
        _heaImg.backgroundColor = [UIColor blackColor];
    }
    return _heaImg;
}

- (UILabel *)addressL{
    if(!_addressL){
        _addressL = [[UILabel alloc]init];
        _addressL.textColor = [UIColor whiteColor];
        _addressL.font = [UIFont systemFontOfSize:16.0];
        _addressL.textAlignment = NSTextAlignmentLeft;
        _addressL.text = @"";
    }
    return _addressL;
}

- (UILabel *)typeL{
    if(!_typeL){
        _typeL = [[UILabel alloc]init];
        _typeL.textColor =  podUse_rgba(153, 153, 153, 1);
        _typeL.font = [UIFont systemFontOfSize:12.0];
        _typeL.textAlignment = NSTextAlignmentLeft;
        _typeL.text = @"";
    }
    return _typeL;
}


//本按钮的图片在子类中设置
- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_rightBtn setImage:[VoiceOcTool getVoiceUseImgWithImgIconNameStr:@"聊天_buJy"]  forState:UIControlStateNormal];
//        [_rightBtn setImage:[VoiceOcTool getVoiceUseImgWithImgIconNameStr:@"聊天_jy"]  forState:UIControlStateSelected];
//        [_rightBtn addTarget:self action:@selector(rightBtnJinYan:) forControlEvents:UIControlEventTouchUpInside];//当前listVIew做为baseview，rightbtn各自子类里做action
     }
    return _rightBtn;
}

//- (void)rightBtnJinYan:(UIButton *)sender{
//    sender.selected = !sender.selected;
//    if(sender.selected){//静音
//
//    }else{//正常
//
//    }
//}

@end
#pragma mark ==== cell 主播端看到的_观众上麦的同意拒绝 || 主播端_上麦管理cell |上麦cell 只有地址无type
@implementation VoiceManagerPopListViewCell_showGanZhongShangDealMaiCell
 
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.rightBtn.hidden = YES;
        [self.contentView addSubview:self.rightBtn_TongYi];
        [self.contentView addSubview:self.rightBtn_JuJue];
        [self showGanZhongShangDealMaiCell];
        [self changeLabelMasOnlyShwoAddress];
    }
    return self;
}
- (void)showGanZhongShangDealMaiCell{
//   pop_WEAKSELF
//    [_rightBtn_TongYi mas_makeConstraints:^(MASConstraintMaker *make) {//同意
//        make.left.equalTo(weakSelf.addressL.mas_right).offset(10);
//        make.centerY.equalTo(weakSelf.superview);
//        make.width.offset(Btn_W_58);
//        make.height.offset(Btn_H_20);
//    }];
//    [_rightBtn_JuJue mas_makeConstraints:^(MASConstraintMaker *make) {//拒绝
//        make.left.equalTo(_rightBtn_TongYi.mas_right).offset(10);
//        make.centerY.equalTo(weakSelf.rightBtn_JuJue.superview);
//        make.width.offset(Btn_W_58);
//        make.height.offset(Btn_H_20);
//    }];
    
    
    [_rightBtn_JuJue mas_makeConstraints:^(MASConstraintMaker *make) {//拒绝
        make.right.equalTo(_rightBtn_JuJue.superview).offset(-15);
        make.centerY.equalTo(_rightBtn_JuJue.superview);
        make.width.offset(Btn_W_58);
        make.height.offset(Btn_H_30);
    }];
    
    [_rightBtn_TongYi mas_makeConstraints:^(MASConstraintMaker *make) {//同意
        make.right.equalTo(_rightBtn_JuJue.mas_left).offset(-10);
        make.centerY.equalTo(_rightBtn_TongYi.superview);
        make.width.offset(Btn_W_58);
        make.height.offset(Btn_H_30);
    }];
    
    
}


- (UIButton *)rightBtn_TongYi{
    if(!_rightBtn_TongYi){//同意
        _rightBtn_TongYi = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn_TongYi.backgroundColor = pop_GreenCyanlColor;
        _rightBtn_TongYi.titleLabel.textColor = pop_BlckColor;
        _rightBtn_TongYi.titleLabel.font = pop_Font_14;
        _rightBtn_TongYi.layer.cornerRadius = 16.0;
        _rightBtn_TongYi.layer.masksToBounds = YES;
        [_rightBtn_TongYi setTitle: voiceRoomLocalize(@"同意")  forState:UIControlStateNormal];
        [_rightBtn_TongYi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       // [_rightBtn_TongYi addTarget:self action:@selector(rightBtnTOngYi:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _rightBtn_TongYi;
}

- (UIButton *)rightBtn_JuJue{//拒绝
    if(!_rightBtn_JuJue){
        _rightBtn_JuJue = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn_JuJue.backgroundColor = pop_RedColor;
        _rightBtn_JuJue.titleLabel.textColor = pop_BlckColor;
        _rightBtn_JuJue.titleLabel.font = pop_Font_14;
        _rightBtn_JuJue.layer.cornerRadius = 16.0;
        _rightBtn_JuJue.layer.masksToBounds = YES;
        [_rightBtn_JuJue setTitle:voiceRoomLocalize(@"拒绝") forState:UIControlStateNormal];
        [_rightBtn_JuJue setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[_rightBtn_JuJue addTarget:self action:@selector(rightBtnJuJue:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _rightBtn_JuJue;
}
#pragma mark ==

@end

//主播端_设置管理者cell
@implementation VoiceManagerPopListViewCell_SetManagerPersonCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
   if (self) {
       [self setManagerPersonCell];
       //增加宽度
       [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
           make.height.offset(24);
           make.width.offset(30);
       }];
   }
   return self;
}
- (void)setManagerPersonCell{//无需在此处做 协议相关方法
 
//    [self.rightBtn setImage:[VoiceOcTool getVoiceUseImgWithImgIconNameStr:@"管理员_w"]  forState:UIControlStateNormal];
//    [self.rightBtn setImage:[VoiceOcTool getVoiceUseImgWithImgIconNameStr:@"管理员"]  forState:UIControlStateSelected];
//    [self.rightBtn addTarget:self action:@selector(setGuanLiYuanAction:) forControlEvents:UIControlEventTouchUpInside];

}
- (void)setGuanLiYuanAction:(UIButton *)sender{
//    //设置管理人员 删除管理人员 . 子类有新做btn action 此处可舍弃
//    if( _managerPersonDelegate && [_managerPersonDelegate respondsToSelector:@selector(touchSetManagerOrDeleManagerBool:withUserId:)] ){
//        [_managerPersonDelegate touchSetManagerOrDeleManagerBool:<#(BOOL)#> withUserId:<#(nonnull NSString *)#>]
//    }
}
 
@end



#pragma mark ---- h f


#pragma mark == HeaderTitleAndSearchView


@implementation HeaderTitleAndSearchView

- (void)onlyShowTitleLabel{
    self.popViewListTopSearchBar.hidden = YES;
    self.frame = CGRectMake(0, 0, Screen_W, Header_H_Title);

}
- (instancetype)initWithFrame:(CGRect)frame
{
    
    frame = CGRectMake(0 , 0 , Screen_W, Header_H_TitleAndSearchBar);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.popViewListTopTitleL];
        [self addSubview:self.popViewListTopSearchBar];
        [self setTopAUIs];
        self.popViewListTopSearchBar.hidden = YES;
    }
    return self;
}
- (void)setTopAUIs{
    [_popViewListTopTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_popViewListTopTitleL.superview).offset(-20);
        make.centerX.top.width.equalTo(_popViewListTopTitleL.superview);
        make.height.offset(Header_H_Title);
    }];
    [_popViewListTopSearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(_popViewListTopTitleL);
        make.top.equalTo(_popViewListTopTitleL.mas_bottom);
        make.bottom.equalTo(_popViewListTopSearchBar.superview);//管理员 pop
        
    }];
    
}

- (UILabel *)popViewListTopTitleL{
    if(!_popViewListTopTitleL){
        _popViewListTopTitleL = [[UILabel alloc]init];
        _popViewListTopTitleL.textColor = [UIColor whiteColor];
        _popViewListTopTitleL.font = [UIFont systemFontOfSize:16.0];
        _popViewListTopTitleL.textAlignment = NSTextAlignmentCenter;
        _popViewListTopTitleL.text = @"";
    }
    return _popViewListTopTitleL;
}

- (UISearchBar *)popViewListTopSearchBar{
    if(!_popViewListTopSearchBar){
        _popViewListTopSearchBar = [[UISearchBar alloc]init];
        _popViewListTopSearchBar.backgroundColor = [UIColor clearColor];
        _popViewListTopSearchBar.searchBarStyle = UISearchBarStyleMinimal;
        _popViewListTopSearchBar.placeholder = @"Everyone is searching";
         if (@available(iOS 13.0, *)) {
            _popViewListTopSearchBar.searchTextField.textColor = [UIColor whiteColor];
            _popViewListTopSearchBar.searchTextField.font = [UIFont systemFontOfSize:14.0];
            if(_popViewListTopSearchBar.searchTextField.leftView){
                UIImageView *iconImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"搜索_w"]];
                _popViewListTopSearchBar.searchTextField.leftView = iconImgV;
            }
        } else {
        }
        
    }
    return _popViewListTopSearchBar;
}

@end

#pragma mark ==  HeaderTypeChangeView

@implementation HeaderTypeChangeView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, Header_H_TitleAndSearchBarAndTwoBtns);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        [self setTopBUIs];
    }
    return self;
}
- (void)setTopBUIs{
    pop_WEAKSELF
    [weakSelf.popViewListTopTitleL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.popViewListTopTitleL.superview).offset(-20);
        make.centerX.top.width.equalTo(weakSelf.popViewListTopTitleL.superview);
        make.height.offset(Header_H_Title);
    }];
    [weakSelf.popViewListTopSearchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(weakSelf.popViewListTopTitleL);
        make.top.equalTo(weakSelf.popViewListTopTitleL.mas_bottom);
//        make.bottom.equalTo(weakSelf.popViewListTopSearchBar.superview);
        make.height.offset(40);//显示的时候 用40h
        make.height.offset(0.1);
    }];
  
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(Btn_W_156);
        make.height.offset(Btn_H_50);
        make.left.equalTo(_leftBtn.superview).offset(20);
        make.top.equalTo(weakSelf.popViewListTopSearchBar.mas_bottom).offset(5);
    }];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(Btn_W_156);
        make.height.offset(Btn_H_50);
        make.right.equalTo(_rightBtn.superview).offset(-20);
        make.top.equalTo(weakSelf.popViewListTopSearchBar.mas_bottom).offset(5);

    }];
}

- (UIButton *)leftBtn{
    if(!_leftBtn){
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setTitleColor:podUse_rgba(153, 153, 153, 1)  forState:UIControlStateNormal];
        [_leftBtn setTitleColor:podUse_rgba(255, 255, 255, 1)  forState:UIControlStateSelected];
        _leftBtn.backgroundColor = [UIColor clearColor];
        _leftBtn.titleLabel.font = pop_Font_14;
        [_leftBtn setTitle:voiceRoomLocalize(@"已上麦成员")  forState:UIControlStateNormal];
        _leftBtn.titleLabel.numberOfLines = 2;
    }
    return _leftBtn;
}
- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitleColor:podUse_rgba(153, 153, 153, 1)  forState:UIControlStateNormal];
        [_rightBtn setTitleColor:podUse_rgba(255, 255, 255, 1)  forState:UIControlStateSelected];
        _rightBtn.backgroundColor = [UIColor clearColor];
        _rightBtn.titleLabel.font = pop_Font_14;
        [_rightBtn setTitle:voiceRoomLocalize(@"普通在线成员")  forState:UIControlStateNormal];
        _rightBtn.titleLabel.numberOfLines = 2;
        
    }
    return _rightBtn;
}

 
@end
 
#pragma mark ==  FooterJinYinView

@implementation FooterJinYinView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, Footer_H_TwoBtns);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.allJinYinBtn];
        [self addSubview:self.allJieChuJinYinBtn];//解除静音
        [self setFooterUIs];
    }
    return self;
}
- (void)setFooterUIs{
    [_allJinYinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(Btn_W_156);
        make.height.offset(Btn_H_50);
        make.left.equalTo(_allJinYinBtn.superview).offset(20);
        make.top.equalTo(_allJinYinBtn.superview).offset(5);
    }];
    [_allJieChuJinYinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(Btn_W_156);
        make.height.offset(Btn_H_50);
        make.right.equalTo(_allJieChuJinYinBtn.superview).offset(-20);
        make.top.equalTo(_allJieChuJinYinBtn.superview).offset(5);
    }];
    
    
}

- (UIButton *)allJinYinBtn{
    if(!_allJinYinBtn){
        _allJinYinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _allJinYinBtn.backgroundColor = [UIColor clearColor];
        _allJinYinBtn.titleLabel.textColor = pop_BlckColor;
        [_allJinYinBtn setTitleColor:pop_GreenCyanlColor forState:UIControlStateNormal];
        _allJinYinBtn.titleLabel.font = pop_Font_16;
        _allJinYinBtn.layer.cornerRadius = 6.0;
        _allJinYinBtn.layer.borderWidth = 1.0;
        _allJinYinBtn.layer.borderColor = pop_GreenCyanlColor.CGColor;
        _allJinYinBtn.layer.masksToBounds = YES;
        [_allJinYinBtn setTitle:voiceRoomLocalize(@"全体静音")  forState:UIControlStateNormal];
        [_allJinYinBtn addTarget:self action:@selector(allJYAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allJinYinBtn;
}
- (UIButton *)allJieChuJinYinBtn{
    if(!_allJieChuJinYinBtn){
        _allJieChuJinYinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _allJieChuJinYinBtn.backgroundColor = pop_GreenCyanlColor;
        _allJieChuJinYinBtn.titleLabel.textColor = pop_BlckColor;
        [_allJieChuJinYinBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _allJieChuJinYinBtn.titleLabel.font = pop_Font_16;
        _allJieChuJinYinBtn.layer.cornerRadius = 6.0;
        _allJieChuJinYinBtn.layer.masksToBounds = YES;
        [_allJieChuJinYinBtn setTitle:voiceRoomLocalize(@"解除全体静音")   forState:UIControlStateNormal];
        [_allJieChuJinYinBtn addTarget:self action:@selector(allNotJYAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allJieChuJinYinBtn;
}
- (void)allJYAction:(UIButton *)sender{
    NSLog(@"%s",__FUNCTION__);
}
- (void)allNotJYAction:(UIButton *)sender{
    NSLog(@"%s",__FUNCTION__);

}
@end
 

 
