//
//  WXHBankCardViewController.m
//  嗨云项目
//
//  Created by kans on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "WXHBankCardViewController.h"

#import "WXHBankCardTableViewCell.h"
#import "AppDelegate.h"
#import <PureLayout.h>
#import "MJRefresh.h"
#import "bankEditViewController.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
#import "WXHBankListObject.h"
@interface WXHBankCardViewController ()<UITableViewDataSource, UITableViewDelegate,bankEditViewControllerDelegate>
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong)UIView *backView;

@property (nonatomic,assign)BOOL isNew;
@end

@implementation WXHBankCardViewController

- (void)viewDidLoad {
        [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.edgesForExtendedLayout= UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
//        self.tabBarController.tabBar.translucent = NO;
    }

    self.dataArray=[NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIButton * toolBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [toolBtn setTitle:@"+ 添加银行卡" forState:UIControlStateNormal];
    [toolBtn setTintColor:[UIColor redColor]];
    [toolBtn setBackgroundColor:[UIColor whiteColor]];
    toolBtn.frame = CGRectMake(0, 0, self.view.frame.size.width, self.navigationController.toolbar.frame.size.height);
    [toolBtn addTarget:self action:@selector(addBankCard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:toolBtn];
    [toolBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [toolBtn autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [toolBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [toolBtn autoSetDimension:ALDimensionHeight toSize:self.navigationController.toolbar.frame.size.height];
    if (self.changeTitle) {
        self.title=@"选择银行卡";
    }else{
        self.title=@"我的银行卡";
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [self.tableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:toolBtn];
    [self.tableView registerNib:[UINib nibWithNibName:@"WXHBankCardTableViewCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"WXHBankCardTableViewCell"];

    self.textField = [[UITextField alloc]init];
    [appDelegate.window addSubview:self.textField];
   
  //  [self showBackView];
    [self getData];
}
-(void)getData{
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    
    [MKNetworking MKSeniorGetApi:@"/myaccount/bank/list" paramters:nil completion:^(MKHttpResponse *response)
     {
         [ hud hide:YES];
         if (response.errorMsg != nil)
         {
             NSLog(@"%@",response.errorMsg);
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             // self.tableView.hidden = YES;
             return ;
         }
         [self.dataArray removeAllObjects];
//         NSLog(@"%@",response.responseDictionary);
         NSArray *db = [response responseDictionary][@"data"];
//         NSLog(@"GG%@",db);
        for (NSDictionary *couponDic in db)
         {
             WXHBankListObject *item = [WXHBankListObject objectWithDictionary:couponDic];
             if (couponDic[@"bank_lastno"]) {
                  [self.dataArray addObject:item];
             }
            
       }
             [self.tableView reloadData];

     }];
    
   
}
//标记一张的时候不能删除
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.isNew = YES;

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
 
    
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXHBankCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WXHBankCardTableViewCell" forIndexPath:indexPath ];
    WXHBankListObject * wxhBankListOBJ=[self.dataArray objectAtIndex:indexPath.section];
    cell.bankListOBJ=wxhBankListOBJ;
    [cell layoutCellSubviews];
    return cell;
}

//是否允许编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if (_dataArray.count>1) {
//
//          return YES;
//    }
//    else{
//        //标记剩余一张时不可删除
//        //if (self.isNew) {
//          //  [MBProgressHUD showMessageIsWait:@"无法删除，请至少保留一张银行卡~" wait:YES];
//       // }
//        return NO;
//    }
    
    return YES;
    
}

//编辑 风格
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}
//提交编辑
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (_dataArray.count) {
        
        WXHBankListObject * banlListOBJ=[_dataArray objectAtIndex:indexPath.section];
        NSString * bankId=[NSString stringWithFormat:@"%@",banlListOBJ.bankId];
        NSLog(@"%@",bankId);
        NSMutableDictionary *param =
        [NSMutableDictionary dictionaryWithDictionary:@{@"id" : bankId}];
        [MKNetworking MKSeniorPostApi:@"/myaccount/bank/del" paramters:param completion:^(MKHttpResponse *response)
         {
             if (response.errorMsg) {
                 [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
                 return ;
             }
             [self.dataArray removeObject:banlListOBJ];
             [_tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationTop];

         }];
        
    }
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WXHBankListObject * bankListObj=(WXHBankListObject *)[self.dataArray objectAtIndex:indexPath.section];
    
    if (self.canSelected) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectBank:)])
        {
            [self.delegate didSelectBank:bankListObj];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
    }
}

-(void)addBankCard{
    if (self.dataArray.count==10) {
         [MBProgressHUD showMessageIsWait:@"最多可添加10张提现银行卡" wait:YES];
        return;
    }
    bankEditViewController * bankEditVC=[bankEditViewController create];
    bankEditVC.hidesBottomBarWhenPushed=YES;
    bankEditVC.delegate=self;
    [self.navigationController pushViewController:bankEditVC animated:YES];
    
   // [self showBack];
}
- (void)showBack{
    self.backView = [[UIView alloc]initWithFrame:CGRectZero];
    self.backView.backgroundColor = [UIColor lightGrayColor];
    self.backView.alpha = .8f;
    [appDelegate.window addSubview:self.backView];
 
    [self.backView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [self.textField becomeFirstResponder];
}


//代理方法
-(void)didSuccessAddBank:(WXHBankListObject*)obj{
    if (obj) {
        [self.dataArray addObject:obj];
        [self getData];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.toolbarHidden=YES;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController hidesBottomBarWhenPushed];
}


@end
