//
//  HYContactView.m
//  嗨云项目
//
//  Created by haiyun on 16/7/13.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYContactView.h"
#import "HYContactsObject.h"
#import <UIImageView+WebCache.h>

@interface HYContactView ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView         *_pTableView;
    NSMutableArray *_rowArr;//row arr
    NSMutableArray *_sectionArr;//section arr
}

@end

@implementation HYContactView

-(void)dealloc
{
    _rowArr = nil;
    _sectionArr = nil;
    _pTableView = nil;
}

#pragma mark - dataArr(模拟从服务器获取到的数据)
- (NSArray *)serverDataArr
{
    if (!_serverDataArr) {
        _serverDataArr=@[@{@"portrait":@"1",@"name":@"BellKate"},@{@"portrait":@"2",@"name":@"花无缺"},@{@"portrait":@"3",@"name":@"东方不败"},@{@"portrait":@"4",@"name":@"任我行"},@{@"portrait":@"5",@"name":@"逍遥王"},@{@"portrait":@"6",@"name":@"阿离"},@{@"portrait":@"13",@"name":@"百草堂"},@{@"portrait":@"8",@"name":@"三味书屋"},@{@"portrait":@"9",@"name":@"彩彩"},@{@"portrait":@"10",@"name":@"陈晨"},@{@"portrait":@"11",@"name":@"多多"},@{@"portrait":@"12",@"name":@"峨嵋山"},@{@"portrait":@"7",@"name":@"哥哥"},@{@"portrait":@"14",@"name":@"林俊杰"},@{@"portrait":@"15",@"name":@"足球"},@{@"portrait":@"16",@"name":@"58赶集"},@{@"portrait":@"17",@"name":@"搜房网"},@{@"portrait":@"18",@"name":@"欧弟"}];
    }
    return _serverDataArr;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        self.backgroundColor = kHEXCOLOR(0xf5f5f5);
        if ( _rowArr == nil )
        {
            _rowArr = [[NSMutableArray alloc] init];
        }
        if ( _sectionArr == nil )
        {
            _sectionArr = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsNull(frame)||CGRectIsEmpty(frame))
        return;
    
    if (_pTableView == nil)
    {
        _pTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, Main_Screen_Height-64.0f) style:UITableViewStylePlain];
        _pTableView.backgroundColor = [UIColor clearColor];
        _pTableView.dataSource = self;
        _pTableView.delegate = self;
        _pTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_pTableView];
        
    }else
    {
        _pTableView.frame = CGRectMake(0, 0, frame.size.width, Main_Screen_Height-64.0f);
    }
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _rowArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section < _rowArr.count )
    {
        return [_rowArr[section] count];
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //viewforHeader
    id label = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    if ( !label )
    {
        label = NewObject(UILabel);
        [label setFont:[UIFont systemFontOfSize:12.0f]];
        [label setTextColor:kHEXCOLOR(0xa1a1a1)];
        [label setBackgroundColor:kHEXCOLOR(0xf5f5f5)];
    }
    [label setText:[NSString stringWithFormat:@"    %@",_sectionArr[section+1]]];
    return label;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 19.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strOderCellIdentifier  = @"HYContactTableViewCell";
    HYContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strOderCellIdentifier];
    if (cell == nil)
    {
        cell = [[HYContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strOderCellIdentifier];
    }
    HYContactsObject *model;
    if ( indexPath.section < _rowArr.count )
    {
        if ( indexPath.row < [_rowArr[indexPath.section] count] )
        {
            model=_rowArr[indexPath.section][indexPath.row];
        }
    }
    [(HYContactTableViewCell *)cell setMenuMsgDict:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark -刷新数据
-(void)updateContactView:(NSMutableArray *)nsDataArr
{
    NSMutableArray *dataArr=[NSMutableArray array];
    for (NSDictionary *subDic in nsDataArr)
    {
        HYContactsObject *model=[HYContactsObject objectWithDictionary:subDic];
//        NSLog(@"%@==%@==%@==%@",model.imageUrl,model.name,model.initial,model.mobile);
        [dataArr addObject:model];
    }
    if ( _rowArr == nil )
    {
        _rowArr = [[NSMutableArray alloc] init];
    }else
    {
        [_rowArr removeAllObjects];
    }
    [_rowArr addObjectsFromArray:[HYContactDataHelper getFriendListDataBy:dataArr]];
    if ( _sectionArr == nil )
    {
        _sectionArr = [[NSMutableArray alloc] init];
    }else
    {
        [_sectionArr removeAllObjects];
    }
    [_sectionArr addObjectsFromArray:[HYContactDataHelper getFriendListSectionBy:[_rowArr mutableCopy]]];
    [_pTableView reloadData];
}
@end

/**************baseCell*********************/
@interface HYContactTableViewCell ()
{
    UIImageView         *_headImageView;//头像
    UILabel             *_nameLabel;//姓名
    UILabel             *_phoneLabel;
    UIButton            *_rightBtn;
}
@end
@implementation HYContactTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        
    }
    return self;
}

-(void)setMenuMsgDict:(HYContactsObject *)contacts
{
    if ( contacts )
    {
        if ( _headImageView )
        {
             [_headImageView sd_setImageWithURL:[NSURL URLWithString:contacts.imageUrl] placeholderImage:[UIImage imageNamed:@"head_pic"]];
        }
        if ( _nameLabel )
        {
            _nameLabel.text = contacts.name;
        }
        if ( _phoneLabel )
        {
            _phoneLabel.text = contacts.mobile;
        }
    }
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    self.backgroundColor = [UIColor whiteColor];
    CGRect rect = CGRectMake(10.0f, 0, 32.0f, 32.0f);
    rect.origin.y = (frame.size.height-rect.size.height)/2.0f;
    if ( _headImageView == nil )
    {
        _headImageView = NewObject(UIImageView);
        _headImageView.backgroundColor = [UIColor clearColor];
        _headImageView.frame = rect;
        _headImageView.image = [UIImage imageNamed:@"head_pic"];
        [self addSubview:_headImageView];
    }
    else
    {
        _headImageView.frame = rect;
    }
    
    rect.origin.x += rect.size.width +10.0f;
    rect.size.height = 18.0f;
    rect.size.width = frame.size.width - 2*rect.origin.x;
    if ( _nameLabel == nil )
    {
        _nameLabel = NewObject(UILabel);
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
        _nameLabel.textColor = kHEXCOLOR(0x070707);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.frame = rect;
        [self addSubview:_nameLabel];
    }else
    {
        _nameLabel.frame = rect;
    }
    
    rect.origin.y += rect.size.height;
    if ( _phoneLabel == nil )
    {
        _phoneLabel = NewObject(UILabel);
        _phoneLabel.backgroundColor = [UIColor clearColor];
        _phoneLabel.font = [UIFont systemFontOfSize:12.0f];
        _phoneLabel.textColor = kHEXCOLOR(0x929292);
        _phoneLabel.textAlignment = NSTextAlignmentLeft;
        _phoneLabel.frame = rect;
        [self addSubview:_phoneLabel];
    }else
    {
        _phoneLabel.frame = rect;
    }
    
    rect.size.width = 44.0f;
    rect.size.height = 25.0f;
    rect.origin.y = (frame.size.height - rect.size.height)/2.0f;
    rect.origin.x = frame.size.width - rect.size.width - 12.0f;
    if ( _rightBtn == nil)
    {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"获取" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _rightBtn.frame = rect;
        _rightBtn.userInteractionEnabled = YES;
        _rightBtn.layer.cornerRadius = 5.0;
        _rightBtn.layer.masksToBounds = YES;
        _rightBtn.backgroundColor = kHEXCOLOR(kRedColor);
        [_rightBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBtn];
    }
    else
    {
        _rightBtn.frame = rect;
    }
}

-(void)onButton:(id)sender
{
    if ( sender == _rightBtn )
    {

    }
}
@end


