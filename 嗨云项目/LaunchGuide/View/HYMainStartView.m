//
//  HYMainStartView.m
//  嗨云项目
//
//  Created by haiyun on 16/7/14.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYMainStartView.h"
#import "HYSystemInit.h"

@interface HYMainStartView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView            *_pCollectionView;//单张图片
    
    
//    UIPageControl               *_pagecontrol;
}


@end

@implementation HYMainStartView

-(void)dealloc
{
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    
    CGRect rect = self.bounds;
    
    if ( _pCollectionView == nil )
    {
        UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        [collectionViewLayout setScrollDirection:    UICollectionViewScrollDirectionHorizontal
];
        collectionViewLayout.minimumInteritemSpacing = 0.0f;
        collectionViewLayout.minimumLineSpacing = 0.0f;
        _pCollectionView=[[UICollectionView alloc] initWithFrame:rect collectionViewLayout:collectionViewLayout];
        _pCollectionView.backgroundColor = [UIColor clearColor];
        [_pCollectionView registerClass:[HYMainStartCollectionViewCell class] forCellWithReuseIdentifier:@"HYMainStartCollectionViewCell"];
        _pCollectionView.delegate = self;
        _pCollectionView.dataSource = self;
        _pCollectionView.alwaysBounceVertical = NO;
        _pCollectionView.showsVerticalScrollIndicator = NO;
        _pCollectionView.showsHorizontalScrollIndicator = NO;
        _pCollectionView.pagingEnabled = YES;
        _pCollectionView.bounces = NO;
        [self addSubview:_pCollectionView];
    }else
    {
        _pCollectionView.frame = rect;
    }
    
   
    
    
//    rect.size.height = 10.0f;
//    rect.origin.y -= ((70.0f/1342.0f)*Main_Screen_Height + rect.size.height/2.0f);
//    rect.size.width = frame.size.width;
//    rect.origin.x = 0.0f;
//    if (_pagecontrol == nil)
//    {
//        _pagecontrol=[[UIPageControl alloc]init];
//        _pagecontrol.currentPage = 0;//当前页数
//        _pagecontrol.numberOfPages = 4;
//        _pagecontrol.userInteractionEnabled = YES;
//        _pagecontrol.currentPageIndicatorTintColor = kHEXCOLOR(kRedColor);
//        _pagecontrol.pageIndicatorTintColor = kHEXCOLOR(0xdfdfdf);
//        [_pagecontrol addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventTouchUpInside];
//        _pagecontrol.center = CGPointMake(Main_Screen_Width/2.0f, rect.origin.y);
//        _pagecontrol.bounds = CGRectMake(0, 0, Main_Screen_Width, 10.0f);
//        [self addSubview:_pagecontrol];
//    }else
//    {
//        _pagecontrol.numberOfPages = 4;
//        _pagecontrol.center = CGPointMake(Main_Screen_Width/2.0f, rect.origin.y);
//        _pagecontrol.bounds = CGRectMake(0, 0, Main_Screen_Width, 10.0f);
//    }

    
}

#pragma mark --UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HYMainStartCollectionViewCell *itemCell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"HYMainStartCollectionViewCell" forIndexPath:indexPath];
    [itemCell updateImageName:[NSString stringWithFormat:@"Launch%ld",indexPath.row] row:indexPath.row];
    return itemCell;
    
}
#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(CGRectGetWidth(collectionView.bounds), CGRectGetHeight(collectionView.bounds));
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsZero;
}

//设置页眉尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}
//设置页脚尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}



-(void)pageTurn:(UIPageControl *)sender
{
    CGSize viewSize = self.frame.size;
    CGRect  rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [_pCollectionView scrollRectToVisible:rect animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
    
}

@end

@interface HYMainStartCollectionViewCell ()
{
    UIImageView                 *_bgImageView;
    UIButton                    *_registerBtn;//注册

}

@end

@implementation HYMainStartCollectionViewCell


-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
   
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    self.backgroundColor = [UIColor clearColor];
    CGRect rect = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height);
    if ( _bgImageView == nil )
    {
        _bgImageView = NewObject(UIImageView);
        _bgImageView.frame = rect;
        _bgImageView.image = [UIImage imageNamed:@"a"];
        [self addSubview:_bgImageView];
    }
    else
    {
        _bgImageView.frame = rect;
    }
    _bgImageView.userInteractionEnabled = YES;
    rect.size.height = (90.0f/1336.0f)*Main_Screen_Height;
    rect.origin.x = (145.0f/763.0f)*Main_Screen_Width;
    rect.size.width = Main_Screen_Width-2*rect.origin.x;
    rect.origin.y = Main_Screen_Height - ((88.0f/1336.0f)*Main_Screen_Height+rect.size.height);
    if ( _registerBtn == nil)
    {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerBtn setTitle:@"抢先一步" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:((36.0f/763.0f)*Main_Screen_Width)];
        _registerBtn.frame = rect;
        _registerBtn.userInteractionEnabled = YES;
        _registerBtn.layer.cornerRadius = rect.size.height/2.0f;
        _registerBtn.layer.masksToBounds = YES;
        _registerBtn.backgroundColor = kHEXCOLOR(kRedColor);
        [_registerBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        _registerBtn.hidden = YES;
        [self addSubview:_registerBtn];
    }
    else
    {
        _registerBtn.frame = rect;
    }
    
    [self bringSubviewToFront:_registerBtn];
}

-(void)updateImageName:(NSString *)imageName row:(NSInteger)index
{
    if ( _bgImageView )
    {
        _bgImageView.image = [UIImage imageNamed:imageName];
    }
    if ( index == 2 )
    {
        _registerBtn.hidden = NO;
    }else
    {
        _registerBtn.hidden = YES;
    }
    [self bringSubviewToFront:_registerBtn];

}

-(void)onButton:(id)sender
{
    
    if ( sender == _registerBtn )
    {
        SetObjectforNSUserDefaultsByKey(@"2", @"HYStart_Show1.2.3");
        [[HYSystemInit sharedInstance] OnMain];
    }
}
@end
