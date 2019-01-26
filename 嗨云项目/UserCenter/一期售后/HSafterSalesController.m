//
//  HSafterSalesController.m
//  嗨云项目
//
//  Created by 杨鑫 on 16/6/3.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HSafterSalesController.h"
#import "IQKeyboardManager.h"
#import "MKNetworking+BusinessExtension.h"
#import "HSRefundCell.h"
#import "HSRefundValueCell.h"



//选择服务
typedef NS_ENUM(NSInteger, HSAfterSalesService) {
    HSOnlyARefund   =   1,/** @仅退款 **/
    HSALLrefunds    =   2,/** @退货退款 **/
};
//货物状态
typedef NS_ENUM(NSInteger, HSStateOfTheGoods) {
    HSHaveReceivedTheGoods      =   1,/** @已收到货 **/
    HSNotYetReceivedTheGoods    =   2,/** @未收到货 **/
};



@interface HSafterSalesController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,assign)HSAfterSalesService currentService;

@property (nonatomic,assign)HSStateOfTheGoods currentGoods;


@property (nonatomic,strong)UITableView *tableView;


@property (nonatomic,strong)UITextField *textField;

//选择退货原因
@property (nonatomic,strong)UIPickerView *picker;
@property (nonatomic, strong)NSMutableArray *pickerData;
@property (nonatomic, strong)NSMutableArray *pickerDataId;

@property (nonatomic,strong)NSString *fuWu;


@end

@implementation HSafterSalesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.textField = [[UITextField alloc]init];
    self.pickerData = [NSMutableArray array];
    self.pickerDataId = [NSMutableArray array];;
    self.picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.textField.inputAccessoryView = self.picker;
    [self updataView];
    [self updateData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}
- (void)updateData{
    [MKNetworking MKSeniorGetApi:@"trade/refund/reason/list" paramters:nil completion:^(MKHttpResponse *response) {
        NSArray *array = [response responseDictionary][@"data"][@"refund_reason_list"];
        for (NSDictionary *dic in array) {
            [self.pickerData addObject:dic[@"refund_reason"]];
            [self.pickerDataId addObject:dic[@"refund_reason_id"]];
        }
        [self.picker reloadAllComponents];
    }];
}
- (void)updataView{
    NSArray *cs = @[@"HSRefundCell", @"HSRefundValueCell"];
    for (NSString *c in cs)
    {
        UINib *nib = [UINib nibWithNibName:c bundle:[NSBundle mainBundle]];
        [self.tableView registerNib:nib forCellReuseIdentifier:c];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row %2 == 0) {
       HSRefundCell *c = [tableView dequeueReusableCellWithIdentifier:@"HSRefundCell" forIndexPath:indexPath];
         [c setSelectionStyle:UITableViewCellSelectionStyleNone];
        c.xingHao.hidden = NO;
        switch (indexPath.row) {
            case 0:
                c.refundTExt.text = @"申请服务";
                break;
            case 2:
                c.refundTExt.text = @"货物状态";
                break;
            case 4:
                c.refundTExt.text = @"退款原因";
                break;
            case 6:
                c.refundTExt.text = @"退款金额";
                break;
            case 8:
                c.refundTExt.text = @"退款说明";
                c.xingHao.hidden = YES;
                break;
            default:
                break;
        }
        c.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        return c;
    }
    if (indexPath.row %2 != 0) {
        HSRefundValueCell *c = [tableView dequeueReusableCellWithIdentifier:@"HSRefundValueCell" forIndexPath:indexPath];
        [c setSelectionStyle:UITableViewCellSelectionStyleNone];
        c.JianTou.hidden = NO;
        c.TF.userInteractionEnabled = NO;
        switch (indexPath.row) {
            case 1:
                c.JianTou.hidden = YES;
                c.TF.text = [NSString stringWithFormat:@" %@",self.tString];
                break;
            case 3:
                c.TF.placeholder = @"  请选择货物状态";
                c.TF.userInteractionEnabled = YES;
                break;
            case 5:
                c.TF.text = @"  请选择退款原因";
                c.TF.userInteractionEnabled = YES;
                break;
            case 7:
                c.JianTou.hidden = YES;
                c.TF.text = @"  请输入退款金额";
                break;
            case 9:
                c.TF.text = @"  请输入退款说明";
                c.JianTou.hidden = YES;
                c.TF.userInteractionEnabled = YES;
                break;
            default:
                break;
        }
        [c.TF addTarget:self action:@selector(handleActionRefund:withEven:) forControlEvents:(UIControlEventEditingChanged)];
        c.backgroundColor =[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        return c;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)handleActionRefund:(UITextField *)sender withEven:(UIEvent *)even{
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}
@end
