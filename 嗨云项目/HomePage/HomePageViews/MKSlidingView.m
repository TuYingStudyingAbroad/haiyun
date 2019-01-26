//
//  MKSlidingView.m
//  嗨云项目
//
//  Created by 杨鑫 on 16/6/1.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKSlidingView.h"
#import "HYCollectionLeftViewCell.h"

@interface MKSlidingView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong)UIScrollView *scrollview;
@property (nonatomic,strong)NSLayoutConstraint *layout;
@property (nonatomic,strong)NSMutableArray *labArr;


@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UICollectionViewFlowLayout *collectionViewLayout;

@property (nonatomic,strong)NSMutableArray *dataSouce;

@end
@implementation MKSlidingView

- (UICollectionViewFlowLayout *)collectionViewLayout{
    if (!_collectionViewLayout) {
        self.collectionViewLayout = [[UICollectionViewFlowLayout alloc]init];
        _collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionViewLayout.minimumLineSpacing = 5;
        _collectionViewLayout.minimumInteritemSpacing = 0;
    }
    return _collectionViewLayout;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
        self.collectionView.dataSource=self;
        self.collectionView.delegate=self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerNib:[UINib nibWithNibName:@"HYCollectionLeftViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"HYCollectionLeftViewCell"];
        self.collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}


- (void)slidingViewWith:(NSArray *)itemArray{
    self.dataSouce = [NSMutableArray arrayWithArray:itemArray];
    [self addSubview: self.collectionView];
   
    [self.collectionView autoPinEdgesToSuperviewEdgesWithInsets:(UIEdgeInsetsZero)];
 }

#pragma mark -- UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSouce.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HYCollectionLeftViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HYCollectionLeftViewCell" forIndexPath:indexPath];
   
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:[self.dataSouce[indexPath.row] imageUrl]] placeholderImage:[UIImage imageNamed:@"placeholder_160x180"]];
    
    cell.itemName.text =[self.dataSouce[indexPath.row] text];
    
   // cell.priceLabel.text = [NSString stringWithFormat:@"%@",[MKItemObject priceString:[self.dataSouce[indexPath.row] wirelessPrice]]];
    cell.priceLabel.text=[NSString stringWithFormat:@"%@",[MKItemObject pricdStringNOZero:[self.dataSouce[indexPath.row] wirelessPrice]]];
    cell.originalPrice.text = [NSString stringWithFormat:@"¥%@",[MKItemObject pricdStringNOZero:[self.dataSouce[indexPath.row] marketPrice]]];
//    CGFloat a =[self.dataSouce[indexPath.row] wirelessPrice];
//    CGFloat b =[self.dataSouce[indexPath.row] marketPrice];
    //cell.discountLabel.text = [NSString stringWithFormat:@"%.1lf折",(a/b)*10];
  //  cell.discountLabel.hidden=YES;
    return cell;
}


#pragma mark --UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(105, 160);
    //return CGSizeMake((self.frame.size.width - 30 )/3 , 160);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 5, 0, 5);
}


#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr =[self.entryObject.values[0] productList];
    MKMarketingListItem *object = arr[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(slidingCellWithListItem:)]) {
        [self.delegate slidingCellWithListItem:object];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == 0) {
        scrollView.contentOffset = CGPointMake(1, 0);
    }
    if (scrollView.contentOffset.x + scrollView.bounds.size.width == scrollView.contentSize.width) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x-1, 0);
    }
}
@end
