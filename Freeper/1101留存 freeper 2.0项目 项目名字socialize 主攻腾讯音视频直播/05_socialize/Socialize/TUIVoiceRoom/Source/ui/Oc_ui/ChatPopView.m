//
//  ChatPopView.m
//  TUIVoiceRoom
//
//  Created by 余莹 on 2023/6/14.
//

#import "ChatPopView.h"
#import <Masonry/Masonry.h>


@interface ChatPopViewSubBottomView ()
 

@end


@implementation ChatPopViewSubBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubViewAndUI];
    }
    return self;
}

- (void)addSubViewAndUI{
    [self addSubview:self.inputBkView];
    [self.inputBkView addSubview:self.inputTextView];
    [self addSubview:self.rightBtn];
    //
    [_inputBkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_inputBkView.superview).offset(10);
        make.right.equalTo(_inputBkView.superview).offset(-45);
        make.height.offset(40.0);
        make.top.equalTo(_inputBkView.superview.mas_top).offset(10);
        
    }];
    //
    [_inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.equalTo(_inputTextView.superview).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    //
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(28.0);
        make.right.equalTo(_rightBtn.superview.mas_right).offset(-6);
        make.centerY.equalTo(_inputBkView).offset(0);
    }];
    
   
   
}

- (UIButton *)rightBtn{
    if(!_rightBtn){
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[VoiceOcTool getVoiceUseImgWithImgIconNameStr:@"表情_yuan"] forState:UIControlStateNormal];
    }
    return _rightBtn;
}

- (UIView *)inputBkView{
    if(!_inputBkView){
        _inputBkView = [[UIView alloc]init];
        _inputBkView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
        _inputBkView.layer.cornerRadius = 18;
        _inputBkView.layer.masksToBounds = YES;
        
    }
    return _inputBkView;
}

- (UITextView *)inputTextView{
    if(!_inputTextView){
        _inputTextView = [[UITextView alloc]init];
        _inputTextView.textColor = [UIColor whiteColor];
        _inputTextView.backgroundColor = [UIColor clearColor];
        _inputTextView.font = [UIFont systemFontOfSize:15.0];
    }
    return _inputTextView;
}




@end


@interface ChatPopView () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@end

@implementation ChatPopView

#pragma mark == 重写
- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr{
    [_tableView reloadData];
    
}
- (void)changMainBackViewBackColor{
    self.subMainBackView.backgroundColor = [UIColor blackColor];// [UIColor whiteColor]; //Color_238GrayColor;//半截背景颜色配置
}
- (void)initSubMainHeight{
    self.subMainViewHeight  = Screen_H*0.8;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubAllView];
 
    }
    return self;
}
- (void)addSubAllView{
    [self.subMainBackView addSubview:self.titL];
    [self.subMainBackView addSubview:self.tableView];
    [self.subMainBackView addSubview:self.bottomView];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
    
    [_titL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_titL.superview);
        make.height.offset(40.0);
    }];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomView.superview);
        make.height.offset(88+kBottom_SafeHeight);
        make.left.right.equalTo(_bottomView.superview);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_tableView.superview);
        make.top.equalTo(_titL.mas_bottom);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
    
    [_bottomView.rightBtn addTarget:self action:@selector(biaoQingAction:) forControlEvents:UIControlEventTouchUpInside];

    
    //点击事件
    
    UITapGestureRecognizer *sigleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBackView)];
      sigleTapRecognizer.delegate=self;
      sigleTapRecognizer.numberOfTapsRequired = 1;

      [_tableView addGestureRecognizer:sigleTapRecognizer];
}
- (void)clickBackView{
    NSLog(@"clickBackView");
    [self endEditing:YES];
}
 

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
   
    // 若为ScrollView的点击事件才响应，scrollview上的UIButton、UILabel啥的点了也不会进哦
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIScrollView"]) {
        return YES;
    }
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableView"]) {
        return YES;
    }
    return  NO;

}

#pragma mark ==

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.layer.cornerRadius = 10;
        _tableView.layer.masksToBounds = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = YES;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (UILabel *)titL{
    if(!_titL){
        _titL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 50)];
        _titL.textColor = [UIColor whiteColor];
        _titL.font = [UIFont systemFontOfSize:16.0];
        _titL.text = voiceRoomLocalize(@"聊天");
        _titL.textAlignment = NSTextAlignmentCenter;
    }
    return _titL;
}

- (ChatPopViewSubBottomView *)bottomView{
    if(!_bottomView){
        CGRect ff = CGRectMake(0, 0, Screen_W, 88+kBottom_SafeHeight);
        _bottomView = [[ChatPopViewSubBottomView alloc]initWithFrame:ff];
    }
    return _bottomView;
}

#pragma mark == 重写


#pragma mark ===
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{//chatvccess
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //    cell.contentView.backgroundColor = ra
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self endEditing:YES];
}




#pragma mark ==
//表情
- (void)biaoQingAction:(UIButton *)sender{
    NSLog(@" 表情  暂时当发送按钮 ");
    if(_chatDelegate && [_chatDelegate respondsToSelector:@selector(touchChatPopSubBiaoQingBtn:)]){
        NSString *strOfSend = _bottomView.inputTextView.text;
        [_chatDelegate touchChatPopSubBiaoQingBtn:strOfSend]; 
    }
    //发送后 刷新列表
    [_tableView reloadData];
    
}
@end
 
