//
//  HYAcountSafeView.m
//  嗨云项目
//
//  Created by YanLu on 16/5/11.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYAcountSafeView.h"
#import "YLSafeUserInfo.h"

/**************baseCell*********************/
@interface HYUIBaseCellView ()
{
    
}
@end
@implementation HYUIBaseCellView
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
}
-(void)setMenuMsgDict:(NSMutableDictionary *)MenuMsgDict
          bHiddenLine:(BOOL)bhidden
{}
@end

//****************Cell***************************

@interface HYAccountUITableViewCell()
{
    UIImageView                 *_leftImageView;
    UIImageView                 *_rightImageView;
    UILabel                     *_leftLabel;
    UILabel                     *_rightLabel;
    UIView                      *_bottomLineView;
}

@end

@implementation HYAccountUITableViewCell


-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    self.backgroundColor = [UIColor whiteColor];
    CGRect rect = CGRectMake(12, 0, 20.0f, 20.0f);
    rect.origin.y = (frame.size.height - rect.size.height)/2.0f;
    if ( _leftImageView == nil)
    {
        _leftImageView = NewObject(UIImageView);
        _leftImageView.frame = rect;
        [self addSubview:_leftImageView];
    }else
    {
        _leftImageView.frame = rect;
    }
    
    rect.origin.x += rect.size.width + 12.0f;
    rect.size.width = 120.0f;
    if ( _leftLabel == nil )
    {
        _leftLabel = NewObject(UILabel);
        _leftLabel.backgroundColor = [UIColor clearColor];
        _leftLabel.font = [UIFont systemFontOfSize:14.0f];
        _leftLabel.textColor = kHEXCOLOR(0x252525);
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_leftLabel];
    }else
    {
        _leftLabel.frame = rect;
    }
    
    rect.size.height = 18.0f;
    rect.size.width = 18.0f;
    rect.origin.x = frame.size.width - rect.size.width - 12.0f;
    rect.origin.y = (frame.size.height - rect.size.height)/2.0f;
    if (_rightImageView  == nil)
    {
        _rightImageView = NewObject(UIImageView);
        _rightImageView.image = [UIImage imageNamed:@"qiehuan"];
        _rightImageView.frame = rect;
        [self addSubview:_rightImageView];
    }else
    {
        _rightImageView.frame = rect;
    }
    
    rect.size.width = 80.0f;
    rect.origin.x -= (rect.size.width+10.0f);
    if ( _rightLabel == nil )
    {
        _rightLabel = NewObject(UILabel);
        _rightLabel.backgroundColor = [UIColor clearColor];
        _rightLabel.font = [UIFont systemFontOfSize:12.0f];
        _rightLabel.textColor = kHEXCOLOR(0x999999);
        _rightLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_rightLabel];
    }else
    {
        _rightLabel.frame = rect;
    }
    
    rect.size.height = 0.5f;
    rect.origin.y = frame.size.height - rect.size.height;
    rect.origin.x = _leftLabel.frame.origin.x;
    rect.size.width = frame.size.width - rect.origin.x - 12.0f;
    if ( _bottomLineView == nil )
    {
        _bottomLineView = NewObject(UIView);
        _bottomLineView.backgroundColor = kHEXCOLOR(0xe5e5e5);
        _bottomLineView.frame = rect;
        [self addSubview:_bottomLineView];
    }else
    {
        _bottomLineView.frame = rect;
    }
    
}

-(void)setMenuMsgDict:(NSMutableDictionary *)MenuMsgDict bHiddenLine:(BOOL)bhidden
{
    if ( _bottomLineView )
    {
        _bottomLineView.hidden = bhidden;
    }
    if ( _leftLabel )
    {
        _leftLabel.text = [MenuMsgDict objectForKey:@"lN"];
    }
    if ( _leftImageView )
    {
        _leftImageView.image = [UIImage imageNamed:[MenuMsgDict objectForKey:@"img"]];
    }
    if ( _rightLabel )
    {
        _rightLabel.text = [MenuMsgDict objectForKey:@"rN"];
        _rightLabel.textColor = [MenuMsgDict objectForKey:@"color"];
    }

}
@end

/******************************************/
@interface HYAcountSafeView()<HYUIBaseCellViewDelegate>
{
    
}

@end

@implementation HYAcountSafeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (_ArrayGrid == nil)
        {
            _ArrayGrid = NewObject(NSMutableArray);
           
        }
    }
    return self;
}

-(void)dealloc
{
    _ArrayGrid = nil;
}


-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    
    if (_pTableView == nil)
    {
        _pTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _pTableView.backgroundColor = [UIColor clearColor];
        _pTableView.dataSource = self;
        _pTableView.delegate = self;
        _pTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_pTableView];
        
        [_pTableView registerClass:[HYAccountUITableViewCell class] forCellReuseIdentifier:@"HMJUIBaseCell"];
        
    }else
    {
        _pTableView.frame = self.bounds;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    return  [_ArrayGrid count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYUIBaseCellView *itemCell = [tableView dequeueReusableCellWithIdentifier:@"HMJUIBaseCell" forIndexPath:indexPath];
    
    itemCell.selectionStyle = UITableViewCellSelectionStyleNone;
    itemCell.delegate = self;
    
    if (indexPath.row < [_ArrayGrid count] && itemCell)
    {
        [(HYUIBaseCellView *)itemCell setMenuMsgDict: [_ArrayGrid objectAtIndex:indexPath.row]bHiddenLine:(indexPath.row == [_ArrayGrid count] - 1)];
    }
    return itemCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row < [_ArrayGrid count] )
    {
        if ( _delegate && [_delegate respondsToSelector:@selector(showSafeView:InfoType:)])
        {
            [_delegate showSafeView:self InfoType:indexPath.row];
        }
    }
}

-(void)sentSafeView:(YLSafeUserInfo *)userInfo
{
    [_ArrayGrid removeAllObjects];
    if ( userInfo && ISNSStringValid(userInfo.mobile) )
    {
        NSDictionary *dic = @{@"img":@"HYSafeshouji",@"lN":@"绑定手机",@"rN":@"修改",@"color":kHEXCOLOR(0x999999)};
        [_ArrayGrid addObject:dic];
    }else
    {
        NSDictionary *dic = @{@"img":@"HYSafeshouji",@"lN":@"绑定手机",@"rN":@"设置",@"color":kHEXCOLOR(0x999999)};
        [_ArrayGrid addObject:dic];
    }
    if ( userInfo &&  ISNSStringValid(userInfo.password) )
    {
         NSDictionary *dic1 = @{@"img":@"HYSafemima",@"lN":@"登录密码",@"rN":@"修改",@"color":kHEXCOLOR(0x999999)};
        [_ArrayGrid addObject:dic1];
    }else
    {
        NSDictionary *dic1 = @{@"img":@"HYSafemima",@"lN":@"登录密码",@"rN":@"设置",@"color":kHEXCOLOR(0x999999)};
        [_ArrayGrid addObject:dic1];
    }
    if ( userInfo &&  ISNSStringValid(userInfo.payPassword) )
    {
         NSDictionary *dic2 = @{@"img":@"HYSafezhifumima",@"lN":@"支付密码",@"rN":@"修改",@"color":kHEXCOLOR(0x999999)};
        [_ArrayGrid addObject:dic2];
    }else
    {
        NSDictionary *dic2 = @{@"img":@"HYSafezhifumima",@"lN":@"支付密码",@"rN":@"设置",@"color":kHEXCOLOR(0x999999)};
        [_ArrayGrid addObject:dic2];
    }
    if ( userInfo &&  ISNSStringValid(userInfo.authIdCard) )
    {
        NSDictionary *dic3 = @{@"img":@"HYSafeshimingrenzheng",@"lN":@"实名认证",@"rN":@"已认证",@"color":kHEXCOLOR(0x05be03)};
        [_ArrayGrid addObject:dic3];
       
    }else
    {
        NSDictionary *dic3 = @{@"img":@"HYSafeshimingrenzheng",@"lN":@"实名认证",@"rN":@"未认证",@"color":kHEXCOLOR(kRedColor)};
        [_ArrayGrid addObject:dic3];
    }
    if ( _pTableView )
    {
        [_pTableView reloadData];
    }
}
@end
