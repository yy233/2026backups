//
//  ZiXunInfoTableViewCell.m
//  Socialize
//
//  Created by 余莹 on 2023/5/22.
//

#import "ZiXunInfoTableViewCell.h"

@implementation ZiXunInfoTableViewCell

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
    if (self != nil)
    {
    
        /**
         * 您可以尝试用不同的布局来实现相同的功能。
         */
        [self bkViewInit];
          [self createLinearRootLayout];
       // [self createRelativeRootLayout];
       // [self createFloatRootLayout];
       
        //如果是代码实现autolayout的话必须要将translatesAutoresizingMaskIntoConstraints 设置为NO。
        _rootLayout.translatesAutoresizingMaskIntoConstraints = NO;
        
        //设置布局视图的autolayout约束，这里是用iOS9提供的约束设置方法，您也可以用低级版本设置，以及用masonry来进行设置。
        [_rootLayout.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = YES;
        [_rootLayout.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
        //目前MyLayout和AutoLayout相结合并且高度根据宽度自适应时只能通过明确设置宽度约束，暂时不支持同时设置左右约束来确定宽度的能力。
        [_rootLayout.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor].active = YES;
        
        //这句代码很关键，表明self.contentView的高度随着子视图_rootLayout的高度自适应。
        [self.contentView.bottomAnchor constraintEqualToAnchor:_rootLayout.bottomAnchor constant:0].active = YES;
        
 

        
    }
    
    return self;
}
//- (void)setModellll:(RecommendDetailPinLunModel *)plunModel{
//    self.headImageView.image = [UIImage imageNamed:plunModel.headImage];
//    [self.headImageView sizeToFit];
//
//
//
//    self.nickNameLabel.text = plunModel.nickName;
//    [self.nickNameLabel sizeToFit];
//
//    self.textMessageLabel.text = plunModel.textMessage;
//
//}

- (void)bkViewInit{
    
    _bkv = [[UIView alloc]init];
    _bkv.layer.cornerRadius = 16;
    [self.contentView addSubview:self.bkv];
    [_bkv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bkv.superview).insets(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.bkv.backgroundColor = Color_238GrayColor;
  
   
}
//用线性布局来实现UI界面
-(void)createLinearRootLayout{
    
        _rootLayout= [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
        _rootLayout.paddingTop = 5;
        _rootLayout.paddingBottom = 5;
        //这个属性只局限于在UITableViewCell中使用，用来优化tableviewcell的高度自适应的性能，其他地方请不要使用！！！
        _rootLayout.cacheEstimatedRect = YES;
        _rootLayout.heightSize.equalTo(@(MyLayoutSize.wrap));
        _rootLayout.widthSize.equalTo(nil);
 
        _rootLayout.layer.cornerRadius = 10;
        [self.contentView addSubview:_rootLayout];
    
    
    
        MyLinearLayout *messageLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
        messageLayout.weight = 1;
        messageLayout.myLeading = 15;  //前面2行代码描述的是垂直布局占用除头像外的所有宽度，并和头像保持5个点的间距。
        messageLayout.subviewVSpace = 5; //垂直布局里面所有子视图都保持5个点的间距。
        [_rootLayout addSubview:messageLayout];
    
    
    
        _textMessageLabel = [UILabel new];
    //    _textMessageLabel.font = [CFTool font:15];
    //    _textMessageLabel.textColor = [CFTool color:4];
        _textMessageLabel.myLeft = 0;
        _textMessageLabel.myRight = 15; //垂直线性布局里面如果同时设置了左右边距则能确定子视图的宽度，这里表示宽度和父视图相等。
        _textMessageLabel.myHeight = MyLayoutSize.wrap; //如果想让文本的高度是动态的，请在设置明确宽度的情况下将高度设置为自适应。
        _textMessageLabel.backgroundColor = [Color_Socialize_GreenColor colorWithAlphaComponent:0.2];
        [messageLayout addSubview:_textMessageLabel];
    //
    
}
//{
//    _rootLayout= [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
//    _rootLayout.paddingTop = 5;
//    _rootLayout.paddingBottom = 5;
//    //这个属性只局限于在UITableViewCell中使用，用来优化tableviewcell的高度自适应的性能，其他地方请不要使用！！！
//    _rootLayout.cacheEstimatedRect = YES;
//    _rootLayout.heightSize.equalTo(@(MyLayoutSize.wrap));
//    _rootLayout.widthSize.equalTo(nil);
//
////    _rootLayout.myTop = 5;
////    _rootLayout.myBottom = 5;
////    _rootLayout.myLeft = 5;
////    _rootLayout.myRight = 5;
//    _rootLayout.layer.cornerRadius = 10;
//
//    [self.contentView addSubview:_rootLayout];
//
//
//    /*
//       用线性布局实现时，整体用一个水平线性布局：左边是头像，右边是一个垂直的线性布局。垂直线性布局依次加入昵称、文本消息、图片消息。
//     */
//
//
//
//
//    _headImageView = [UIImageView new];
//    _headImageView.mySize = CGSizeMake(40, 40);
//    _headImageView.myLeft = 15;
//    _headImageView.myTop = 10;
//    _headImageView.backgroundColor = [UIColor cyanColor];
//    [_rootLayout addSubview:_headImageView];
////    [_headImageView zy_cornerRadiusRoundingRect];
//    self.headImageView.layer.mask =  [BezierPathTool bezierPathToolWithThisViewBounds:CGRectMake(0, 0, 40, 40) withCornerRadi:CGSizeMake(6, 6) withRoundingCorners:UIRectCornerAllCorners];//(UIRectCornerTopLeft | UIRectCornerTopRight)];
//
//
//    MyLinearLayout *messageLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
//    messageLayout.weight = 1;
//    messageLayout.myLeading = 15;  //前面2行代码描述的是垂直布局占用除头像外的所有宽度，并和头像保持5个点的间距。
//    messageLayout.subviewVSpace = 5; //垂直布局里面所有子视图都保持5个点的间距。
//    [_rootLayout addSubview:messageLayout];
//
//
//    _nickNameLabel = [UILabel new];
////    _nickNameLabel.textColor = [];
////    _nickNameLabel.font = [CFTool font:17];
//    _nickNameLabel.myHeight = 50;
//    _nickNameLabel.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
//    [messageLayout addSubview:_nickNameLabel];
//
//
//    _textMessageLabel = [UILabel new];
////    _textMessageLabel.font = [CFTool font:15];
////    _textMessageLabel.textColor = [CFTool color:4];
//    _textMessageLabel.myLeft = 0;
//    _textMessageLabel.myRight = 15; //垂直线性布局里面如果同时设置了左右边距则能确定子视图的宽度，这里表示宽度和父视图相等。
//    _textMessageLabel.myHeight = MyLayoutSize.wrap; //如果想让文本的高度是动态的，请在设置明确宽度的情况下将高度设置为自适应。
//    _textMessageLabel.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.2];
//    [messageLayout addSubview:_textMessageLabel];
//
//
////    _imageMessageImageView = [UIImageView new];
////    _imageMessageImageView.myCenterX = 0;  //图片视图在父布局视图中水平居中。
////    [messageLayout addSubview:_imageMessageImageView];
//}
@end
