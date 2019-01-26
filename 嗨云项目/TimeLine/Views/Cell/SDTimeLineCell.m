//
//  SDTimeLineCell.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//



#import "SDTimeLineCell.h"

#import "SDTimeLineCellModel.h"
#import "UIView+SDAutoLayout.h"

#import "SDTimeLineCellCommentView.h"

#import "SDWeiXinPhotoContainerView.h"

#import "SDTimeLineCellOperationMenu.h"
#import "wxhTitleButton.h"

const CGFloat contentLabelFontSize = 13;
CGFloat maxContentLabelHeight = 0; // 根据具体font而定

NSString *const kSDTimeLineCellOperationButtonClickedNotification = @"SDTimeLineCellOperationButtonClickedNotification";

@implementation SDTimeLineCell

{
    UIImageView *_iconView;
    UILabel *_nameLable;
    UILabel *_contentLabel;
    SDWeiXinPhotoContainerView *_picContainerView;
    UILabel *_timeLabel;
    UIButton *_moreButton;
    UIButton *_operationButton;
    SDTimeLineCellCommentView *_commentView;
    BOOL _shouldOpenContentLabel;
    SDTimeLineCellOperationMenu *_operationMenu;
    UILabel * _sharNumLab;
    UIView * _graylineView;
    UIButton * _selectBtn;
    wxhTitleButton * _titleBtn;
    UIView * _bottomView;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)setup
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOperationButtonClickedNotification:) name:kSDTimeLineCellOperationButtonClickedNotification object:nil];
    
    _shouldOpenContentLabel = NO;
    
//    _iconView = [UIImageView new];
    
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:14];

    _nameLable.textColor=[UIColor colorWithHexString:@"252525"];
    _nameLable.numberOfLines = 0;
    
    _graylineView=[UIView new];
    _graylineView.backgroundColor=[UIColor colorWithHexString:@"e0e0e0"];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
   


    
    _sharNumLab=[UILabel new];
    _sharNumLab.font = [UIFont systemFontOfSize:12];
    _sharNumLab.textColor = [UIColor colorWithHexString:@"999999"];
    
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSize];
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor=[UIColor colorWithHexString:@"333333"];
    
    _selectBtn = [UIButton new];
    [_selectBtn addTarget:self action:@selector(selectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _titleBtn=[wxhTitleButton  titleButton];
      [_titleBtn setTitle:@"图文分享" forState:UIControlStateNormal];
    [_titleBtn setImage:[UIImage imageNamed:@"分享文案"] forState:UIControlStateNormal];
    [_titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    _picContainerView = [SDWeiXinPhotoContainerView new];
    
    _bottomView=[UIView new];
    _bottomView.backgroundColor=[UIColor colorWithHexString:@"e0e0e0"];
    

    
    NSArray *views = @[ _nameLable,_graylineView, _timeLabel,_sharNumLab, _titleBtn,_contentLabel,_selectBtn, _picContainerView,_bottomView];
    
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    

    
    _nameLable.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView,5 )
    .rightSpaceToView(contentView,margin)
   .autoHeightRatio(0);
    
    _graylineView.sd_layout.
    leftEqualToView(_nameLable)
    .topSpaceToView(_nameLable,margin)
    .rightEqualToView(_nameLable)
    .heightIs(0.5);
    
   

    _timeLabel.sd_layout
    .leftEqualToView(_graylineView)
    .topSpaceToView(_graylineView, margin)
    .heightIs(15).widthIs(40).
     autoHeightRatio(0);
    
   
    
     _sharNumLab.sd_layout
    .leftSpaceToView(_timeLabel,margin)
    .topEqualToView(_timeLabel)
    .heightIs(15).widthIs(40)
    .autoHeightRatio(0);
    
    _titleBtn.sd_layout
    .rightSpaceToView(contentView,margin)
    .topEqualToView(_timeLabel)
    .heightIs(28)
    .widthIs(90);
    
    _contentLabel.sd_layout
    .leftEqualToView(_timeLabel)
    .topSpaceToView(_titleBtn, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    
    _selectBtn.sd_layout
    .leftEqualToView(_contentLabel).rightEqualToView(_contentLabel)
    .topEqualToView(_contentLabel).bottomEqualToView(_contentLabel);
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
    _bottomView.sd_layout
    .topSpaceToView(_picContainerView,10)
    .leftSpaceToView(contentView,0)
    .rightSpaceToView(contentView,0)
    .heightIs(0.5);
   
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setModel:(SDTimeLineCellModel *)model
{
    _model = model;
    
    _timeLabel.text = @"10小时前";
   [_timeLabel sizeToFit];
    _sharNumLab.text=@"1000人分享";
   [_sharNumLab sizeToFit];
    
    _nameLable.text = model.name;
    
    // 防止单行文本label在重用时宽度计算不准的问题
    [_nameLable sizeToFit];
    
    
     NSString * allStr=[NSString stringWithFormat:@"%@查看详情",model.msgContent];
//    _contentLabel.text =allStr;
    
    
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:allStr];
    

    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor colorWithHexString:@"23baf0"]
     
                          range:NSMakeRange(model.msgContent.length, 4)];
    
    _contentLabel.attributedText = AttributedStr;
    

    _picContainerView.picPathStringsArray = model.picNamesArray;
    
    CGFloat picContainerTopMargin = 0;
    if (model.picNamesArray.count) {
        picContainerTopMargin = 10;
    }
    _picContainerView.sd_layout.topSpaceToView(_contentLabel, picContainerTopMargin);
    [self setupAutoHeightWithBottomView:_bottomView bottomMargin:5];
    
   
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}

#pragma mark - private actions

-(void)selectBtnClicked{
    NSLog(@"kkkkkk");
}

-(void)titleBtnClick:(UIButton *)sender{

    if (self.cellDelegate&&[self.cellDelegate respondsToSelector:@selector(share:)]) {
        [self.cellDelegate share:self.indexPath];
    }
}

- (void)moreButtonClicked
{
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}

- (void)operationButtonClicked
{
    [self postOperationButtonClickedNotification];
    _operationMenu.show = !_operationMenu.isShowing;
}

- (void)receiveOperationButtonClickedNotification:(NSNotification *)notification
{
    UIButton *btn = [notification object];
    
    if (btn != _operationButton && _operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self postOperationButtonClickedNotification];
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}

- (void)postOperationButtonClickedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSDTimeLineCellOperationButtonClickedNotification object:_operationButton];
}

@end
