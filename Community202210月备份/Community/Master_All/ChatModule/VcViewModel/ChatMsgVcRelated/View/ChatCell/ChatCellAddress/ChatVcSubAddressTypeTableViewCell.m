//
//  ChatVcSubAddressTypeTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/3/24.
//

#import "ChatVcSubAddressTypeTableViewCell.h"
#import "ChatBaseMapView.h"

@interface ChatVcSubAddressTypeTableViewCell ()
@property (nonatomic,strong) NSString *addressStr;
@property (nonatomic,assign) CGFloat lati;
@property (nonatomic,assign) CGFloat longi;
@property (nonatomic,strong) ChatBaseMapView *mapV;
@end

@implementation ChatVcSubAddressTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
 

- (void)leftOtherUI{
    WEAKSELF
    self.contentView_New.hidden = YES;//图片类型的UI  不需要
    [self.backView addSubview:self.topLocateAddressLabel];
    [self.backView addSubview:self.bottomLocateAddressShowBackView];
    [self.backView addSubview:self.centerBtn];
    self.bottomLocateAddressShowBackView.backgroundColor = Color_245Gray;
    [self.bottomLocateAddressShowBackView addSubview:self.mapV];
    //给尖角留位置5 left -5 w-5
    [_topLocateAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bubbleImageView_New).offset(5);
        make.left.equalTo(weakSelf.bubbleImageView_New).offset(10);
        make.width.equalTo(weakSelf.bubbleImageView_New).offset(-15);
        make.height.equalTo(weakSelf.bubbleImageView_New).multipliedBy(0.4);//h  0.4 -
    }];
    [_bottomLocateAddressShowBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topLocateAddressLabel.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.bubbleImageView_New).offset(10);
        make.width.equalTo(weakSelf.bubbleImageView_New).offset(-15);
        make.bottom.equalTo(weakSelf.bubbleImageView_New).offset(-5);
    }];
    [_centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bottomLocateAddressShowBackView);
    }];
    [_mapV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_mapV.superview);
    }];
}
- (void)rightOtherUI{
    WEAKSELF
    self.contentView_New.hidden = YES;//图片类型的UI  不需要
    [self.backView addSubview:self.topLocateAddressLabel];
    [self.backView addSubview:self.bottomLocateAddressShowBackView];
    [self.backView addSubview:self.centerBtn];
    self.bottomLocateAddressShowBackView.backgroundColor = Color_245Gray;
    [self.bottomLocateAddressShowBackView addSubview:self.mapV];
    //给尖角留位置 5 right -5 w-5
    [_topLocateAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bubbleImageView_New).offset(5);
        make.right.equalTo(weakSelf.bubbleImageView_New).offset(-10);
        make.width.equalTo(weakSelf.bubbleImageView_New).offset(-15);
        make.height.equalTo(weakSelf.bubbleImageView_New).multipliedBy(0.4);//h  0.4 -
    }];
    [_bottomLocateAddressShowBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topLocateAddressLabel.mas_bottom).offset(0);
        make.right.equalTo(weakSelf.bubbleImageView_New).offset(-10);
        make.width.equalTo(weakSelf.bubbleImageView_New).offset(-15);
        make.bottom.equalTo(weakSelf.bubbleImageView_New).offset(-5);
    }];
    [_centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bottomLocateAddressShowBackView);
    }];
    [_mapV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_mapV.superview);
    }];
}

 

- (void)fillMsgCellContentInfoWithFriendGroupOtherType:(ChatVcSessionType_FriendGroupSystemOtehr)friendGroupSystemType withMsgModel:(id)msgModel{
    
    if (friendGroupSystemType == ChatVcSessionType_FriendGroupSystemOtehr_Friend || friendGroupSystemType ==ChatVcSessionType_FriendGroupSystemOtehr_Group) {
        ChatFriendMessageModel *model = ( ChatFriendMessageModel *)msgModel;
        
        //1025新版数据
        NSDictionary *dataDic = [Tool dictionaryWithJsonString:[TextShowWithModelStr textShowWithModelStr:model.data]];//新版
        NSString *addressStr = [[dataDic allKeys]containsObject:kAddStr] ? dataDic[kAddStr] :@"";
        NSString *latStr = [[dataDic allKeys]containsObject:kLat] ? dataDic[kLat] :@"";
        NSString *longStr = [[dataDic allKeys]containsObject:kLong] ? dataDic[kLong] :@"";
        self.topLocateAddressLabel.text = addressStr;
        [self shwoAddressMapViewWithAddressStr:addressStr withLat:[latStr floatValue] withLong:[longStr floatValue]];
    }
 

}



#pragma mark == 地图
- (void)shwoAddressMapViewWithAddressStr:(NSString *)addressStr withLat:(CGFloat)lat withLong:(CGFloat)longi{
    DLog(@"地图展示");
    self.lati = lat;
    self.longi = longi;
    self.addressStr = addressStr;
}

#pragma mark ===  otherUI

#pragma mark ==
 
- (UILabel *)topLocateAddressLabel{
    if (!_topLocateAddressLabel) {
        _topLocateAddressLabel = [[UILabel alloc]init];
        _topLocateAddressLabel.textColor = Color_51BlackColor;
        _topLocateAddressLabel.font = [UIFont systemFontOfSize:13.0];
        _topLocateAddressLabel.backgroundColor = [UIColor whiteColor];
        _topLocateAddressLabel.numberOfLines = 2;
    }
    return _topLocateAddressLabel;
}
- (UIView *)bottomLocateAddressShowBackView{
    if (!_bottomLocateAddressShowBackView) {
        _bottomLocateAddressShowBackView = [[UIView alloc]init];
    }
    return _bottomLocateAddressShowBackView;
}

- (UIButton *)centerBtn{
    if (!_centerBtn) {
        _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_centerBtn addTarget:self action:@selector(centerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerBtn;
}

- (ChatBaseMapView *)mapV{
    if (!_mapV) {
        _mapV = [[ChatBaseMapView alloc]initWithFrame:CGRectMake(0, 0,Screen_W*0.5 ,100)];//同_bubbleImageView气泡占位高度一样h
    }
    return _mapV;
}



//做地图大view展示
- (void)centerBtnAction{
    DLog(@"地图 %f %f",self.lati , self.longi );
    if (isNil(self.chatVcSubCellsDeletage)) {
        return;
    }
    if ( [self.chatVcSubCellsDeletage   respondsToSelector:@selector(cellDelegateWithTouchOpenLocateActionWithAddressStr:withLatFloat:withLongFloat:andWithFriendMsgWithMsgData:orGroupModel:)]) {
        [self.chatVcSubCellsDeletage  cellDelegateWithTouchOpenLocateActionWithAddressStr:self.addressStr withLatFloat:self.lati  withLongFloat:self.longi andWithFriendMsgWithMsgData:self.fmodel orGroupModel:self.gmodel];
    }
}
@end
