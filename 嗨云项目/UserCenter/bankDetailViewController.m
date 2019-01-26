//
//  bankDetailViewController.m
//  嗨云项目
//
//  Created by kans on 16/5/10.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "bankDetailViewController.h"
#import <PureLayout.h>
#import "MKProgessTableViewCell1.h"
#import "MKProgressTableViewCell.h"
#import "MKProgressRefusalTableViewCell.h"
#import "MKNetworking+BusinessExtension.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MKExtension.h"
#import "WXHBankDetailCellObject.h"
#import "WXHBankStatusListObject.h"
#import "WXHBankDetailCellObject.h"
#import "getMoneyTableViewController.h"
#import "WXHDownRefreshHeader.h"
@interface bankDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    WXHBankStatusListObject * statusListOBj;
    BOOL  isOld;
    
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong)WXHBankDetailCellObject* bankDetailCellOBJ;
@property (nonatomic,strong)WXHBankStatusListObject* bankStatuesListOBJ;
@property (nonatomic,strong)NSMutableArray * bankStatuesListArr;

@end

@implementation bankDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    ////////////////////通过删除中间的vc来定义左边的返回到指定页///////
//    //得到当前视图控制器中的所有控制器
//    NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
//    //把B从里面删除
//    [array removeObjectAtIndex:2];
//    //把删除后的控制器数组再次赋值
//    [self.navigationController setViewControllers:[array copy] animated:YES];
    
    
//////////////////////////////右边的完成按钮回到指定页////////
    
    if (self.showComplete) {
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain
                                                                           target:self action:@selector(saveBtnClick:)];
        self.navigationItem.rightBarButtonItem = rightButtonItem;
        

    }
    
    self.title=@"提现详情";
    self.bankStatuesListArr=[NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)
                                                  style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MKProgressTableViewCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"MKProgressTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MKProgessTableViewCell1" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"MKProgessTableViewCell1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MKProgressRefusalTableViewCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"MKProgressRefusalTableViewCell"];
    WXHDownRefreshHeader * header=[WXHDownRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.header=header;
    header.lastUpdatedTimeLabel.hidden=YES;
    header.stateLabel.hidden=YES;
    
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
}

-(void)saveBtnClick:(UIButton *)sender{
    UIViewController *viewCtl = self.navigationController.viewControllers[1];
    [self.navigationController popToViewController:viewCtl animated:YES];
}
- (void)loadNewData
{
    [self loadDataIsNew:YES];
}




- (void)loadDataIsNew:(BOOL)isNew
{
    
    NSMutableDictionary *param =
    [NSMutableDictionary dictionaryWithDictionary:@{@"withdrawals_number" :self.withdrawalsNumber}];
  
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    [MKNetworking MKSeniorGetApi:@"/virtualwealth/withdrawals/detail" paramters:param completion:^(MKHttpResponse *response)
     {
         [ hud hide:YES];
         // 拿到当前的下拉刷新控件，结束刷新状态
         [self.tableView.header endRefreshing];
         
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
         
       
         NSDictionary* detailDic = [response mkResponseData][@"withdrawals_item"];
         self.bankDetailCellOBJ=[WXHBankDetailCellObject objectWithDictionary:detailDic];
         [self.bankStatuesListArr removeAllObjects];
         for (WXHBankStatusListObject * oneStatusListOBJ in self.bankDetailCellOBJ.statusList) {
             [self.bankStatuesListArr addObject:oneStatusListOBJ];
         }
         if (self.bankStatuesListArr .count) {
             statusListOBj=[self.bankStatuesListArr objectAtIndex:0];
            
         }
         
        [self.tableView reloadData];
     }];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        
            return 2;
        
    }
    
};
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 187;
    }else{
        
        NSString * reasonStr=self.bankDetailCellOBJ.refusalReason;
        NSInteger a = [self heightForString:[UIScreen mainScreen].bounds.size.width - 17 -12 withConten:reasonStr withFont:13];
        if (indexPath.row==1) {
            return 70;
        }else{
        return 70+a;
        }
}
}
- (float) heightForString:(float)width withConten:(NSString *)conten withFont:(float)font{
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(37, 0, width, 0)];
    
    textView.text = conten;
    textView.font = [UIFont systemFontOfSize:font];
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    if (!conten.length) {
        return 0;
    }
    return sizeToFit.height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 10;
    }else{
        return 0;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    view.backgroundColor=[UIColor colorWithHexString:@"Oxf5f5f5"];
    return view;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        MKProgessTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"MKProgessTableViewCell1"];
        cell.bankDetailCellObj=self.bankDetailCellOBJ;
        [cell setData];
        
        return cell;
    }else{
        if (!isOld) {
            MKProgressRefusalTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"MKProgressRefusalTableViewCell" ];
            if (self.bankDetailCellOBJ.refusalReason&&indexPath.row==0) {
                NSString * reasonStr=self.bankDetailCellOBJ.refusalReason;
                NSInteger a = [self heightForString:[UIScreen mainScreen].bounds.size.width - 17 -12 withConten:reasonStr withFont:13];
                //减42和10效果最好
                cell.middle.constant =(a+70)/2-a-42;
            }else{
                cell.middle.constant=-10;
            }
            
            if (indexPath.row==0) {
                UIView * upView=(UIView *)[cell.contentView viewWithTag:1];
                upView.hidden=YES;
                cell.bankDetailCellOBJ=self.bankDetailCellOBJ;
                [cell getDataWithIndex:indexPath];
                
            }
            if (indexPath.row==1) {
                UIView * downView=(UIView *)[cell.contentView viewWithTag:2];
                downView.hidden=YES;
                cell.timeLab.text=statusListOBj.time;
                cell.reasonLab.text=@"";
                cell.statuLab.text=@"申请已成功提交";
            }
            return cell;
        }
      

        return nil ;
        }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
