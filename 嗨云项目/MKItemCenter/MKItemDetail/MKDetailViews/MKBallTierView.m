//
//  MKBallTierView.m
//  嗨云项目
//
//  Created by 杨鑫 on 16/7/13.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKBallTierView.h"
#import <PureLayout.h>
#import "UIColor+MKExtension.h"
#import "UIView+MKExtension.h"
#import "AppDelegate.h"
#import "MKBaseTableViewCell.h"
#import "MKFullTableViewCell.h"
#import "MKPrivilegeTableViewCell.h"
#import "MKNetworking+BusinessExtension.h"
#import "MBProgressHUD+MKExtension.h"

#define MKSelfHight Main_Screen_Height/2
@interface MKBallTierView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,assign)MKPopUpHierarchy popUpHierarchyType;

@property (nonatomic,strong)UIButton *backButton;

@property (nonatomic,strong)UITextField *textField;

@property (nonatomic,strong)UILabel *atTheTopOfTheLabel;

@property (nonatomic,strong)UIButton *dissButton;
/**
 *      @brief 活动单个数据的时候所展示的
 */
@property (nonatomic,strong)UILabel *fristLabel;

/**
 *      @brief 当前的高度
 */
@property (nonatomic,assign)CGFloat selfhight;

@property (nonatomic,strong)UIView *lineView;


/**
 *      @brief 不使用优惠劵
 */
@property (nonatomic,strong)UIButton *favorableButton;

@property (nonatomic,strong)UITableView *tableView;
@end

@implementation MKBallTierView

- (void)removeFromSuperview{
    [self.backButton removeFromSuperview];
    self.backButton = nil;
}

- (UIButton *)backButton{
    if (!_backButton) {
        self.backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _backButton.backgroundColor = [UIColor blackColor];
        _backButton.alpha = .3f;
        [UIAppWindowTopView addSubview:_backButton];
        [_backButton autoPinEdgesToSuperviewEdgesWithInsets:(UIEdgeInsetsZero)];
        __weak __typeof(self) weakSelf = self;
        [_backButton setTapActionWithBlock:^{
            [weakSelf dismiss:^{
              weakSelf.backButton.hidden = YES;
            }];
        }];
    }
    return _backButton;
}
- (UIButton *)dissButton{
    if (!_dissButton) {
        self.dissButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        __weak __typeof(self) weakSelf = self;
        [_dissButton setTapActionWithBlock:^{
            [weakSelf dismiss:^{
                weakSelf.backButton.hidden = YES;
            }];
        }];
    }
    return _dissButton;
}
- (UIButton *)favorableButton{
    if (!_favorableButton) {
        self.favorableButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _favorableButton.layer.borderColor = [[UIColor colorWithHex:0xFF2741] CGColor];
        _favorableButton.layer.borderWidth = 1.0f;
        _favorableButton.layer.cornerRadius = 3.f;
        _favorableButton.layer.masksToBounds = YES;
        [_favorableButton setTitleColor:[UIColor colorWithHex:0xFF2741] forState:(UIControlStateNormal)];
        _favorableButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_favorableButton setTitle:@"不使用优惠劵" forState:(UIControlStateNormal)];
        [_favorableButton addTarget:self action:@selector(handleCouponItemAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _favorableButton;
}
- (void)MKPopUpHierarchywithType:(MKPopUpHierarchy)type withDataArray:(NSMutableArray *)dataArray{
    self.dataArray = dataArray;
    self.popUpHierarchyType = type;
    self.backButton.hidden = YES;
    self.seleArray = [NSMutableArray array];
    self.backgroundColor = [UIColor whiteColor];
    if (self.popUpHierarchyType == MKPopUpHierarchyCoupon) {
        self.frame = CGRectMake(0, Main_Screen_Height, Main_Screen_Width, MKSelfHight);
    }
    if (self.popUpHierarchyType == MKPopUpHierarchyReduction) {
        if (self.dataArray.count != 1 ) {
            self.selfhight = 200;
        }else{
            self.selfhight = 160;
        }
        
        self.frame = CGRectMake(0, Main_Screen_Height, Main_Screen_Width, self.selfhight);
    }
    [UIAppWindowTopView addSubview:self];
    [self loadView];
}
- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}

- (void)loadView{
    //头部的文本
    self.atTheTopOfTheLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, Main_Screen_Width -24, 40)];
    [self addSubview:self.atTheTopOfTheLabel];
    if (self.popUpHierarchyType == MKPopUpHierarchyCoupon) {
        _atTheTopOfTheLabel.text = @"优惠劵";
        _atTheTopOfTheLabel.textAlignment = NSTextAlignmentCenter;
        _atTheTopOfTheLabel.font = [UIFont systemFontOfSize:17];
    }
    if (self.popUpHierarchyType == MKPopUpHierarchyReduction) {
        _atTheTopOfTheLabel.text = @"活动";
        _atTheTopOfTheLabel.textAlignment = NSTextAlignmentLeft;
         _atTheTopOfTheLabel.font = [UIFont systemFontOfSize:14];
    }
    //箭头 和X
    self.dissButton.frame = CGRectMake(Main_Screen_Width -36, 0, 24, 40);
    [self addSubview:self.dissButton];
    if (self.popUpHierarchyType == MKPopUpHierarchyCoupon) {
        [self.dissButton setImage:[UIImage imageNamed:@"X_19x19"] forState:(UIControlStateNormal)];
    }
    if (self.popUpHierarchyType == MKPopUpHierarchyReduction) {
        [self.dissButton setImage:[UIImage imageNamed:@"shuilu_qiehuan"] forState:(UIControlStateNormal)];
    }
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(12, 39, Main_Screen_Width -24, 0.8)];
    [self addSubview:self.lineView];
    self.lineView.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
    if (self.popUpHierarchyType == MKPopUpHierarchyCoupon) {
        [self.fristLabel removeFromSuperview];
        self.fristLabel = nil;
        [self.lineView removeFromSuperview];
        self.lineView = nil;
    }
    if (self.popUpHierarchyType == MKPopUpHierarchyReduction) {
//        if (self.dataArray.count ==1) {
//            self.fristLabel = [[UILabel alloc]init];
//            /**
//             *      @brief 单个优惠活动的时候设置文本内容;
//             */
//            self.fristLabel.text = self.dataArray.firstObject;
//            self.fristLabel.frame = CGRectMake(12, 40, Main_Screen_Width -24, self.selfhight - 40);
//            self.fristLabel.font = [UIFont systemFontOfSize:13];
//            self.fristLabel.textAlignment = NSTextAlignmentCenter;
//            self.fristLabel.numberOfLines = 0;
//            [self addSubview:self.fristLabel];
//        }else{
//            /**
//             *      @brief 多个的时候需要用tabView
//             */
            [self.fristLabel removeFromSuperview];
            self.fristLabel = nil;
            self.tableView.frame = CGRectMake(0, 40, Main_Screen_Width, self.selfhight - 40);
            [self addSubview:self.tableView];
            [self.tableView registerNib:[UINib nibWithNibName:@"MKFullTableViewCell" bundle:nil] forCellReuseIdentifier:@"MKFullTableViewCell"];
//        }
    }
    
    if (self.popUpHierarchyType == MKPopUpHierarchyCoupon) {
        self.tableView.frame = CGRectMake(0, 40, Main_Screen_Width, MKSelfHight - 40);
        [self addSubview:self.tableView];
        [self.tableView registerNib:[UINib nibWithNibName:@"MKPrivilegeTableViewCell" bundle:nil] forCellReuseIdentifier:@"MKPrivilegeTableViewCell"];
        if (self.type == 1) {
            self.tableView.frame = CGRectMake(0, 40, Main_Screen_Width, MKSelfHight - 40 - 55);
            self.favorableButton.frame = CGRectMake(12, MKSelfHight - ((55-40)/2)-40 , Main_Screen_Width - 24, 40);
            [self addSubview:self.favorableButton];
        }else{
            [self.favorableButton removeFromSuperview];
            self.favorableButton = nil;
        }
    }
}
- (void)handleCouponItemAction:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCouponObject:)]) {
        [self.delegate didSelectCouponObject:nil];
        [self dismiss:nil];
    }
}
- (void)show{
    self.hidden = NO;
    self.backButton.hidden = NO;
        [UIView animateWithDuration:.2f animations:^{
            if (self.popUpHierarchyType == MKPopUpHierarchyCoupon) {
                self.frame = CGRectMake(0, Main_Screen_Height-MKSelfHight, Main_Screen_Width, Main_Screen_Height/2);
            }
            if (self.popUpHierarchyType == MKPopUpHierarchyReduction) {
                
                self.frame = CGRectMake(0, Main_Screen_Height-self.selfhight, Main_Screen_Width, self.selfhight);
            }
            
        } completion:^(BOOL finished) {
            
        }];
    
}

- (void)dismiss:(void (^)(void))completion{
    [UIView animateWithDuration:.2f animations:^{
        if (self.popUpHierarchyType == MKPopUpHierarchyCoupon) {
            self.frame = CGRectMake(0, Main_Screen_Height, Main_Screen_Width, MKSelfHight);
        }
        if (self.popUpHierarchyType == MKPopUpHierarchyReduction) {
            self.frame = CGRectMake(0, Main_Screen_Height, Main_Screen_Width, self.selfhight);
        }
    }completion:^(BOOL finished) {
        self.backButton.hidden = YES;
        self.hidden = YES;
        if (completion) {
            completion();
        }
    }];
}

- (void)handleReceiveAction:(UIButton *)button withEven:(UIEvent *)even{
    NSSet *touchs = [even allTouches];
    UITouch *touch = [touchs anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    MKCouponObject *obj = self.dataArray[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCouponObject:)]) {
        self.objectItem = obj;
        [self.delegate didSelectCouponObject:obj];
        [self.tableView reloadData];
        [self dismiss:nil];
    }
    
    /**
     *      @brief 放在数据请求成功之后的操作
     */
    [self.seleArray addObject:obj];
    [self.tableView reloadData];
}
#pragma mark -领取优惠券
- (void) getCouponAction:(UIButton *)btn withEven:(UIEvent *) even {
    
    if (![getUserCenter isLogined])
    {
        [getUserCenter loginoutPullView];
        return;
    }
    NSSet *touchs = [even allTouches];
    UITouch *touch = [touchs anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    MKCouponObject *obj = self.dataArray[indexPath.row];
    [MKNetworking MKSeniorPostApi:@"/marketing/activity_coupon/grant" paramters:@{@"activity_uid" : obj.couponUid, @"receiver_id": [NSString stringWithFormat:@"%ld",(long)getUserCenter.userInfo.userId]}
                      completion:^(MKHttpResponse *response)
     {
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
         [MBProgressHUD showMessageIsWait:@"领取成功" wait:YES];
     }];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.popUpHierarchyType == MKPopUpHierarchyReduction) {
        MKFullTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKFullTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.baseLabel.text = self.dataArray[indexPath.row];
        return cell;
    }
    if (self.popUpHierarchyType == MKPopUpHierarchyCoupon){
         MKPrivilegeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKPrivilegeTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //优惠劵的内容赋值
        MKCouponObject *model = self.dataArray[indexPath.row];
        if (self.type == 1) {
            /**
             *      @brief 确认订单来的有优惠劵
             */
            [cell cellWithModel:model withType:1];
            if (self.objectItem) {
                if ([model isEqual: self.objectItem]) {
                    cell.getBut.layer.borderColor = [[UIColor colorWithHex:0xe5e5e5] CGColor];
                    cell.getBut.layer.borderWidth = 1.0f;
                    cell.getBut.layer.cornerRadius = 3.f;
                    cell.getBut.layer.masksToBounds = YES;
                    [cell.getBut setTitleColor:[UIColor colorWithHex:0xe5e5e5] forState:(UIControlStateNormal)];
                    cell.getBut.enabled = NO;
                    [cell.getBut setTitle:@"已选择" forState:(UIControlStateNormal)];
                }else{
                    cell.getBut.layer.borderColor = [[UIColor colorWithHex:0xFF2741] CGColor];
                    cell.getBut.layer.borderWidth = 1.0f;
                    cell.getBut.layer.cornerRadius = 3.f;
                    cell.getBut.layer.masksToBounds = YES;
                    [cell.getBut setTitleColor:[UIColor colorWithHex:0xFF2741] forState:(UIControlStateNormal)];
                    cell.getBut.enabled = YES;
                    [cell.getBut setTitle:@"使用" forState:(UIControlStateNormal)];
                }
            }else{
                cell.getBut.layer.borderColor = [[UIColor colorWithHex:0xFF2741] CGColor];
                cell.getBut.layer.borderWidth = 1.0f;
                cell.getBut.layer.cornerRadius = 3.f;
                cell.getBut.layer.masksToBounds = YES;
                [cell.getBut setTitleColor:[UIColor colorWithHex:0xFF2741] forState:(UIControlStateNormal)];
                cell.getBut.enabled = YES;
                [cell.getBut setTitle:@"使用" forState:(UIControlStateNormal)];
            }
            [cell.getBut addTarget:self action:@selector(handleReceiveAction:withEven:) forControlEvents:(UIControlEventTouchUpInside)];
        }else{
            [cell cellWithModel:model withType:2];
            cell.getBut.layer.borderColor = [[UIColor colorWithHex:0xFF2741] CGColor];
            cell.getBut.layer.borderWidth = 1.0f;
            cell.getBut.layer.cornerRadius = 3.f;
            cell.getBut.layer.masksToBounds = YES;
            [cell.getBut setTitleColor:[UIColor colorWithHex:0xFF2741] forState:(UIControlStateNormal)];
            cell.getBut.enabled = YES;
            [cell.getBut setTitle:@"领取" forState:(UIControlStateNormal)];
            
            [cell.getBut addTarget:self action:@selector(getCouponAction:withEven:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        
        return cell;
    }
    
    static NSString *ID = @"MKBallTierViewCell";
    MKBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MKBaseTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBottomSeperatorLineMarginLeft:12 rigth:24];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.popUpHierarchyType == MKPopUpHierarchyReduction) {
        return [self heightForString:Main_Screen_Width -24 withConten:self.dataArray[indexPath.row] withFont:13] + 13;
    }
    if (self.popUpHierarchyType == MKPopUpHierarchyCoupon) {
        return 75;
    }
    return 44.f;
}
- (float) heightForString:(float)width withConten:(NSString *)conten withFont:(float)font{
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(12, 0, width, 0)];
    textView.text = conten;
    textView.font = [UIFont systemFontOfSize:font];
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

@end
