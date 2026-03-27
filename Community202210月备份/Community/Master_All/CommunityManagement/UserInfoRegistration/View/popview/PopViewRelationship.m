//
//  PopViewRelationship.m
//  Community
//
//  Created by 余莹 on 2020/12/9.
//

#import "PopViewRelationship.h"
#import "RelationshipModel.h"
#import "CarTypeChooseBtn.h"//btn 相同的样式

#define W_RelationshipSubBtn 80
#define H_RelationshipSubBtn 30
#define Relationship_SubBtn_ViewMaxW (Screen_W-32)/4
#define Relationship_SubBtn_ViewMaxH (H_RelationshipSubBtn + 10)

#define Car_SubBtn_Tag 260

@interface PopViewRelationship ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *relationshipItemBackView;
@property (nonatomic,strong) NSMutableArray <RelationshipModel *>*realtionshipArr;
@property (nonatomic,strong) RelationshipModel *model;
@end
@implementation PopViewRelationship

#pragma mark == 重写
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubAllView];
        [self setUI];
    }
    return self;
}
- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr{
    _realtionshipArr = [NSMutableArray arrayWithArray:[RelationshipModel mj_objectArrayWithKeyValuesArray:dataSourceArr]];
    [self setRelationItem];
}

#pragma mark == btn action
- (void)subBtnAction:(CarTypeChooseBtn *)sender{
    NSLog(@"subBtnAction");
    if (sender.selected==YES) {
        return;
    }
    [self changSubBtnUI:sender];
    
    self.model = _realtionshipArr[sender.tag-Car_SubBtn_Tag];
    if (_delegate && [_delegate respondsToSelector:@selector(relationshipPopViewChooseModel:)]) {
        [_delegate relationshipPopViewChooseModel:self.model];
    }
    [self dismissThePopView];
}
- (void)changSubBtnUI:(CarTypeChooseBtn *)sender{
    sender.selected = !sender.selected;
    for (int i = 0 ; i < self.relationshipItemBackView.subviews.count; i++) {
        if ([self.relationshipItemBackView.subviews[i] isKindOfClass:[CarTypeChooseBtn class]]) {
            CarTypeChooseBtn *btn = (CarTypeChooseBtn*)self.relationshipItemBackView.subviews[i];
            if (btn.selected==YES && btn.tag != sender.tag) {
                btn.selected = NO;
            }
        }
    }
}

#pragma mark ==  btn item UI
- (void)setRelationItem{
    for (int i = 0; i<_realtionshipArr.count; i++) {
       RelationshipModel *model = _realtionshipArr[i];
   
       CGRect fram = CGRectMake(Relationship_SubBtn_ViewMaxW*((i)%4) +5 , Relationship_SubBtn_ViewMaxH*floor((i)/4.0), W_RelationshipSubBtn, H_RelationshipSubBtn);
       CarTypeChooseBtn *btn = [[CarTypeChooseBtn alloc]initWithFrame:fram];
       btn.tag = i+Car_SubBtn_Tag;
       [btn setTitle:model.name forState:UIControlStateNormal];
       [btn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
       [self.relationshipItemBackView addSubview:btn];
   }
}

#pragma mark == UI
- (void)addSubAllView{
    [self.subMainBackView addSubview:self.titleLabel];
    [self.subMainBackView addSubview:self.relationshipItemBackView];
}
- (void)setUI{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.superview.mas_top).offset(10);
        make.left.equalTo(_titleLabel.superview.mas_left).offset(16);
        make.width.offset(80);
        make.height.offset(30);
    }];
    [_relationshipItemBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_relationshipItemBackView.superview).insets(UIEdgeInsetsMake(50, 16, 30, 16));//t == 10+30+10
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"选择关系";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}
- (UIView *)relationshipItemBackView{
    if (!_relationshipItemBackView) {
        _relationshipItemBackView = [[UIView alloc]init];
    }
    return _relationshipItemBackView;
}
#pragma mark == 内容高度 重写
- (void)initSubMainHeight{
    self.subMainViewHeight  = 200;
}

@end
