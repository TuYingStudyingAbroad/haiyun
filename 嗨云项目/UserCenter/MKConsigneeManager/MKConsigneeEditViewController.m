//
//  MKConsigneeEditViewController.m
//  YangDongXi
//
//  Created by cocoa on 15/4/7.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKConsigneeEditViewController.h"
#import "MKBaseLib.h"
#import "UIColor+MKExtension.h"
#import <PureLayout.h>
#import "MBProgressHUD+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
#import "NSDictionary+MKExtension.h"
#import <UIAlertView+Blocks.h>
#import "NSArray+MKExtension.h"
#import "MKRealNameObject.h"
#import "MKConfirmOrderViewController.h"
#import "MKRegionItem.h"

#define STRING_OR_EMPTY(A)  ({ __typeof__(A) __a = (A); __a ? __a : @""; })

@interface MKConsigneeEditViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>


@property (weak, nonatomic) IBOutlet UITextField *detailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *identityCardTextField;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
@property (weak, nonatomic) IBOutlet UIButton *noBtn;

@property (weak, nonatomic) IBOutlet UIView *idCardView;

@property (assign ,nonatomic) BOOL isIdCard;

@property (weak, nonatomic) IBOutlet UIView *defaultView;

@property (strong, nonatomic) UIPickerView *locatePicker;
@property (weak, nonatomic) IBOutlet UILabel *isIdMustLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textTipsViewTop;

@property (strong, nonatomic) NSString *selectedProvinceCode;

@property (strong, nonatomic) NSString *selectedCityCode;

@property (strong, nonatomic) NSString *selectedAreaCode;

@property (strong, nonatomic) NSString *selectedStreetCode;


//@property (nonatomic, assign) BOOL ignoreCity;

@property (nonatomic, strong) NSMutableArray *showComponents;

@property (strong, nonatomic) NSMutableArray *indexsOfPicker;
@property (weak, nonatomic) IBOutlet UIView *tipsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idViewHeight;
@property (weak, nonatomic) IBOutlet UIView *line1;

@end


@implementation MKConsigneeEditViewController

- (IBAction)addAction:(id)sender {
    UISwitch *sw = (UISwitch *)sender;
    if (sw.on) {
        
    }else {
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTips];
    
    self.deleteBtn.layer.borderColor = [UIColor colorWithHex:0xff4b55].CGColor;
    self.deleteBtn.layer.cornerRadius = 3;
    self.deleteBtn.layer.borderWidth = 0.5;
    self.deleteBtn.hidden = YES;
    
    self.tipsView.layer.cornerRadius = 6;
    
    self.phoneTextField.delegate = self;
    self.identityCardTextField.delegate = self;
    
    self.showComponents = [NSMutableArray arrayWithArray:@[[NSArray array], [NSArray array], [NSArray array],  [NSArray array], [NSArray array]]];
    
    if (self.isEdit)
    {
        [self updateData];
        
        self.deleteBtn.hidden = NO;
    }
    else
    {
        self.deleteBtn.hidden = YES;
        
        [self getAddressAtIndex:0 withCode:@"CN" isReloadAll:YES completion:^{
            
        }];

        /*
        NSArray *provinces = [self.regionModel provinces];
        self.selectedProvinceCode = [(MKRegionItem *)provinces[0] code];
        
        NSArray *cities = [self.regionModel citiesWithProvinceCode:self.selectedProvinceCode];
        self.selectedCityCode = [(MKRegionItem *)cities[0] code];
        
        NSArray *areas = [self.regionModel areasWithCityCode:self.selectedCityCode];
        self.selectedAreaCode = [(MKRegionItem *)areas[0] code];
        
        NSArray *streets = [self getStreetsWithPcode:self.selectedAreaCode];
        self.selectedStreetCode = [(MKRegionItem *)streets[0] code];
        
        self.showComponents = [NSMutableArray arrayWithArray:@[provinces, cities, areas,  streets, [NSArray array]]];
         */
    }
    [self setupPickerView];
    
    [self setupSubViews];
    [self.nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.scrollView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(completeBtnClick:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AllBack"] style:UIBarButtonItemStylePlain target:self action:@selector(gobackWithNoEdit)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    self.nameTextField.placeholder = @"请输入收货人";
    
    self.phoneTextField.placeholder =  @"请输入手机号";
    
    self.detailAddressTextField.placeholder = @"请输入详细地址";
    
    if (self.isTax) {
//        self.line1.hidden = YES;
//        self.idViewHeight.constant = 0;
//        self.tipsView.hidden = YES;
        
        self.isIdMustLabel.hidden = NO;
    }else {
//        self.idViewHeight.constant = 40;
//        self.line1.hidden = NO;
//        self.tipsView.hidden = NO;
        
        self.isIdMustLabel.hidden = YES;
    }
}

//温馨提示
- (void)setTips {
    NSString *tipStr1 = @"1.购买跨境进口商品时需填写收件人身份号，收货人姓名须与身份证信息一致，否则将无法通过海关检查！";
    NSString *tipStr2 = @"2.身份证信息只会用于办理海关清关手续，您的个人信息绝对不会用于他用，请放心验证。";
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:tipStr1];
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:tipStr2];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];//调整行间距
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tipStr1 length])];
    [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tipStr2 length])];
    
    _tipLabel1.attributedText = attributedString1;
    _tipLabel2.attributedText = attributedString2;
}

#pragma mark -- get address data

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
        }
    }
    if (textField == self.phoneTextField) {
        if (textField.text.length > 13) {
            textField.text = [textField.text substringToIndex:20];
        }
    }
}

-(void)getAddressAtIndex:(NSInteger)index withCode:(NSString *)code isReloadAll:(BOOL)isReloadAll completion:(void(^)(void))completion;
{
    NSArray *dataArray = [self readArrayWithCustomObjFromUserDefaults:code];
    if(dataArray && dataArray.count > 0)
    {
        [self getAddressList:dataArray isReloadAll:isReloadAll withIndex:index code:code forcedReload:YES];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"region_code": code}];
        
        [MKNetworking MKSeniorGetApi:@"/delivery/sub_region/list" paramters:param completion:^(MKHttpResponse *response)
         {
             NSArray *db = [response mkResponseData][@"region_list"];
             NSMutableArray *tempArray = [[NSMutableArray alloc]init];
             for (NSDictionary *d in db)
             {
                 MKRegionItem *item = [[MKRegionItem alloc]init];
                 
                 item.code = [d objectForKey:@"code"];
                 
                 item.name = [d objectForKey:@"name"];
                 
                 item.pcode = [d objectForKey:@"id"];
                 
                 [tempArray addObject:item];
              }
             if(tempArray.count > 0)
             {
                 [self writeArrayWithCustomObjToUserDefaults:code withArray:tempArray];
             }
            
             if(completion)
             {
                 completion();
             }
             
         }];
    }
    else
    {
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"region_code": code}];
        
        [MKNetworking MKSeniorGetApi:@"/delivery/sub_region/list" paramters:param completion:^(MKHttpResponse *response)
         {
             NSArray *db = [response mkResponseData][@"region_list"];
             
             NSMutableArray *tempArray = [[NSMutableArray alloc]init];
             
             for (NSDictionary *d in db)
             {
                 MKRegionItem *item = [[MKRegionItem alloc]init];
                 
                 item.code = [d objectForKey:@"code"];
                 
                 item.name = [d objectForKey:@"name"];
                 
                 item.pcode = [d objectForKey:@"id"];
                 
                 [tempArray addObject:item];
             }
            
             if(tempArray.count > 0)
             {
                 [self writeArrayWithCustomObjToUserDefaults:code withArray:tempArray];
             }
             else
             {
                 MKRegionItem *item = [[MKRegionItem alloc]init];
                 
                 item.code = @"NOCODE";
                 
                 item.name = @"我不清楚";
                 
                 [tempArray addObject:item];
             }
            
             BOOL flag = YES;
             
             [self getAddressList:tempArray isReloadAll:isReloadAll withIndex:index code:code forcedReload:flag];
             
             if(isReloadAll && index == 3)
             {
                 [self shouldUpdateInitData];
             }
             else if(!isReloadAll && index == 3)
             {
                 self.firstAddressTextField.text = [self pickedRegions];
             }
             if(completion)
             {
                 completion();
             }
         }];
    }
}

#pragma mark --
#pragma mark --  parser data

-(void)getAddressList:(NSArray *)addressList isReloadAll:(BOOL)isReloadAll withIndex:(NSInteger)index code:(NSString *)code forcedReload:(BOOL)isForced
{
    if(self.showComponents.count > index)
    {
        [self.showComponents replaceObjectAtIndex:index withObject:addressList];
    }
    
    if(index < 3 && isForced)
    {
        [self.locatePicker reloadComponent:index];
    }
    
    if(!isReloadAll && isForced)
    {
        if (addressList.count != 0)
        {
            //放队列防止第一列先停，第二列后停错位的问题
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(index < 3)
                {
                    [self.locatePicker selectRow:0 inComponent:index animated:NO];
                }});
        }
    }

    if (index < 3 && addressList.count > 0)
    {
        if(isReloadAll && self.consigneeItem)
        {
            NSString *nextCode = nil;
            
            if(index == 0)
            {
                nextCode = self.consigneeItem.provinceCode;
            }
            else if (index == 1)
            {
                nextCode = self.consigneeItem.cityCode;
            }
            else
            {
                nextCode = self.consigneeItem.areaCode;
            }
            
            [self getAddressAtIndex:index + 1 withCode:nextCode isReloadAll:isReloadAll completion:nil];
        }
        else
        {
             [self getAddressAtIndex:index + 1 withCode:[(MKRegionItem *)addressList[0] code] isReloadAll:isReloadAll completion:nil];
        }
       
    }
    else
    {
        NSInteger cIndex = index;

        while (cIndex < 3)
        {
            [self.showComponents replaceObjectAtIndex:cIndex + 1 withObject:[NSArray array]];
            
            [self.locatePicker reloadComponent:cIndex + 1];
            
            cIndex = cIndex + 1;
        }
    }
}

- (void)getAuthInfo
{
//    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    
//    [MKNetworking MKSeniorGetApi:@"/user/auth/get" paramters:nil completion:^(MKHttpResponse *response)
//    {
//        [ hud hide:YES];
//        if (response.errorMsg != nil)
//        {
//            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
//            return ;
//        }
////        if ([response mkResponseData][@"auth_info"]) {
////            [self.idCardView removeFromSuperview];
////            self.isIdCard = YES;
////        }
//    }];
}

- (void)setupSubViews
{
    self.firstAddressTextField.inputView = self.locatePicker;
    self.firstAddressTextField.delegate = self;
    //self.firstAddressTextField.text = [self pickedRegions];

    if(!self.isEdit)
    {
        self.firstAddressTextField.text = @"请选择";
    }
    
    if (self.isEdit)
    {
        self.title = @"修改地址";
    }
    else
    {
        self.title = @"新建地址";
//        [self getAuthInfo];
    }
    
    if (self.consigneeItem.isDefault)
    {
        self.addr.on = YES;
        self.defaultView.hidden = YES;
        self.textTipsViewTop.constant = -40;
    }
    else
    {
        self.addr.on = NO;
        self.defaultView.hidden = NO;
        self.textTipsViewTop.constant = 10;
    }
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    v.backgroundColor = [UIColor colorWithHex:0xd1d5da];
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setTitleColor:[UIColor colorWithHex:0x0076ff] forState:UIControlStateNormal];
    bt.titleLabel.font = [UIFont systemFontOfSize:14];
    [bt setTitle:@"完成" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(textFieldComplete) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:bt];
    [bt autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:12];
    [bt autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [bt autoSetDimension:ALDimensionWidth toSize:50];
    self.firstAddressTextField.inputAccessoryView = v;
}

- (void)textFieldComplete
{
    [self.firstAddressTextField resignFirstResponder];
}

- (void)setupPickerView
{
    self.locatePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216)];
    self.locatePicker.delegate = self;
    self.locatePicker.dataSource = self;
    self.locatePicker.showsSelectionIndicator = YES;
    [self.locatePicker reloadAllComponents];
    
    //[self reloadPickerView];
}

- (void)reloadPickerView
{
    NSArray *ids = @[STRING_OR_EMPTY(self.selectedProvinceCode), STRING_OR_EMPTY(self.selectedCityCode),
                     STRING_OR_EMPTY(self.selectedAreaCode)];
    for (int i = 0; i < self.showComponents.count - 2; ++ i)
    {
        NSArray *r = self.showComponents[i];
        NSString *code = ids[i];
        int row = 0;
        for (MKRegionItem *item in r)
        {
            if ([item.code isEqualToString:code])
            {
                [self.locatePicker selectRow:row inComponent:i animated:NO];
                break;
            }
            row ++ ;
        }
    }
    self.firstAddressTextField.text = [self pickedRegions];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.firstAddressTextField)
    {
        [self reloadPickerView];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    
    if (self.phoneTextField == textField)
    {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        
        if (existedLength - selectedLength + replaceLength > 13) {
            return NO;
        }
        
        NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"0123456789-"];
        string = [string stringByTrimmingCharactersInSet:s];
        if (string.length > 0)
        {
            return NO;
        }
    }
    if (self.identityCardTextField == textField)
    {
        NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"0123456789Xx"];
        string = [string stringByTrimmingCharactersInSet:s];
        if (string.length > 0)
        {
            return NO;
        }
    }
    if (textField == self.nameTextField) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 20) {
            return NO;
        }
    }
    return YES;
}


#pragma mark - Private Method

- (MKRegionItem *)checkCode:(NSString *)itemCode inItems:(NSArray *)items
{
    for (MKRegionItem *item in items)
    {
        if ([itemCode isEqualToString:item.code])
        {
            return item;
        }
    }
    return items[0];
}

- (NSString *)selectedProvinceString
{
    NSInteger row = [self.locatePicker selectedRowInComponent:0];
    NSArray *items = self.showComponents[0];
    return [self selectedItemStringWithRow:row inItems:items];
}

- (NSString *)selectedCityString
{
    NSInteger row = [self.locatePicker selectedRowInComponent:1];
    NSArray *items = self.showComponents[1];
    return [self selectedItemStringWithRow:row inItems:items];
}

- (NSString *)selectedAreaString
{
    NSInteger row = [self.locatePicker selectedRowInComponent:2];
    NSArray *items = self.showComponents[2];
    return [self selectedItemStringWithRow:row inItems:items];
}

//- (NSString *)selectedStreetString
//{
//    NSInteger row = [self.locatePicker selectedRowInComponent:3];
//    NSArray *items = self.showComponents[3];
//    return [self selectedItemStringWithRow:row inItems:items];
//}

- (NSString *)selectedItemStringWithRow:(NSInteger)row inItems:(NSArray *)items
{
    if (row >= items.count)
    {
        return @"";
    }
    return [items[row] name];
}

//- (NSArray *)getStreetsWithPcode:(NSString *)pcode
//{
//    NSArray *ar = [self.regionModel streetWithAreaCode:pcode];
//    MKRegionItem *item = [[MKRegionItem alloc] init];
//    item.code = nil;
//    item.name = @"我不清楚";
//    return [@[item] arrayByAddingObjectsFromArray:ar];
//}

#pragma mark - 业务逻辑

//新增  x修改完成
- (void)completeBtnClick:(id)sender
{
    if (![self checkInput])
    {
        return;
    }
    
    MKConsigneeObject *consigneeItem = [[MKConsigneeObject alloc] init];
    consigneeItem.countryCode = @"CN";
    consigneeItem.provinceCode = self.selectedProvinceCode;
    consigneeItem.cityCode = self.selectedCityCode;
    consigneeItem.areaCode = self.selectedAreaCode;
    consigneeItem.streetCode = self.selectedStreetCode;
    consigneeItem.address = self.detailAddressTextField.text;
    consigneeItem.mobile = self.phoneTextField.text;
    consigneeItem.consignee = self.nameTextField.text;
    consigneeItem.consigneeUid = self.consigneeItem.consigneeUid;
    consigneeItem.idNo = self.identityCardTextField.text;
    if (!self.isEdit)
    {
        if (!self.isIdCard)
        {
            [self newConsignee:consigneeItem];
        }
        else
        {
            [self newConsignee:consigneeItem];
        }
        return;
    }
    [self modifyConsignee:consigneeItem];
}

//修改未完成
- (void) gobackWithNoEdit {
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"是否取消编辑并退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    if (!self.isEdit) {
        view.message = @"是否取消新增并退出";
    }
    view.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return;
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    [view show];
    
}

- (void)newConsignee:(MKConsigneeObject *)consigneeItem
{
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    
    NSString *str = [[consigneeItem dictionarySerializer] jsonString];
    [MKNetworking MKSeniorPostApi:@"/user/consignee/add" paramters:@{@"consignee" : str}
                       completion:^(MKHttpResponse *response)
    {
        [ hud hide:YES];
        if (response.errorMsg != nil)
        {
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
            return ;
        }
        NSString *consigneeUid = [response mkResponseData][@"consignee_uid"];
        consigneeItem.consigneeUid = consigneeUid;
        if (self.addr.on)
        {
            [self setDefault:consigneeItem];
        }
        
        if (self.canSelected) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSuccessFullAddAddress:)])
            {
                NSMutableArray *arr =[NSMutableArray arrayWithArray: self.navigationController.viewControllers] ;
                [self.delegate didSuccessFullAddAddress:consigneeItem];
                for (NSInteger i = arr.count -1;i >= 0 ;i -- ) {
                    UIViewController *con =(UIViewController *) arr[i];
                    if ([con isKindOfClass:[MKConfirmOrderViewController class]]) {
                        [self.navigationController popToViewController:con animated:YES];
                        break;
                    }
                }
                return;
            }
        }else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSuccessFullAddAddress:)])
            {
                [self.delegate didSuccessFullAddAddress:consigneeItem];
            }
        }
        
        [MBProgressHUD showMessageIsWait:@"添加成功" wait:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)modifyConsignee:(MKConsigneeObject *)consigneeItem
{
    NSString *str = [[consigneeItem dictionarySerializer] jsonString];
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    
    [MKNetworking MKSeniorPostApi:@"/user/consignee/update" paramters:@{@"consignee" : str}
                       completion:^(MKHttpResponse *response)
    {
        [ hud hide:YES];
        if (response.errorMsg != nil)
        {
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
            return ;
        }
        if (self.addr.on)
        {
            [self setDefault:consigneeItem];
        }
        if (self.canSelected) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSuccessModifyAddress:)])
            {
                NSMutableArray *arr =[NSMutableArray arrayWithArray: self.navigationController.viewControllers] ;
                [self.delegate didSuccessModifyAddress:consigneeItem];
                for (NSInteger i = arr.count -1;i >= 0 ;i -- ) {
                    UIViewController *con =(UIViewController *) arr[i];
                    if ([con isKindOfClass:[MKConfirmOrderViewController class]]) {
                        [self.navigationController popToViewController:con animated:YES];
                        break;
                    }
                }
                return;
            }
        }else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSuccessModifyAddress:)])
            {
                [self.delegate didSuccessModifyAddress:consigneeItem];
            }
        }
        [MBProgressHUD showMessageIsWait:@"编辑成功" wait:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (BOOL)checkInput
{
    NSString *name = self.nameTextField.text;
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (name.length == 0)
    {
        [MBProgressHUD showMessageIsWait:@"请输入收货人姓名" wait:YES];
        return NO;
    }
    if (name.length > 20)
    {
        [MBProgressHUD showMessageIsWait:@"收货人姓名长度不能大于20" wait:YES];
        return NO;
    }
    NSString *phone = self.phoneTextField.text;
    phone = [phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (phone.length == 0)
    {
        [MBProgressHUD showMessageIsWait:@"请输入收货人手机号码" wait:YES];
        return NO;
    }
    if (self.phoneTextField.text.length != 11)
    {
        [MBProgressHUD showMessageIsWait:@"请输入正确的手机号码" wait:YES];
        return NO;
    }
    
    NSString *firstAddress = self.firstAddressTextField.text;
    firstAddress = [firstAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (firstAddress.length == 0)
    {
        [MBProgressHUD showMessageIsWait:@"请选择省市区" wait:YES];
        return NO;
    }
    
    NSString *detailAddress = self.detailAddressTextField.text;
    detailAddress = [detailAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (detailAddress.length == 0)
    {
        [MBProgressHUD showMessageIsWait:@"请输入收货人详细地址" wait:YES];
        return NO;
    }else if (detailAddress.length < 5) {
        [MBProgressHUD showMessageIsWait:@"详细地址不能小于5个字符" wait:YES];
        return NO;
    }else if (detailAddress.length > 70) {
        [MBProgressHUD showMessageIsWait:@"详细地址不能大于70个字符" wait:YES];
        return NO;
    }
    
    NSString *idStr = self.identityCardTextField.text;
    idStr = [idStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (self.isTax) {
        if (idStr.length == 0) {
            [MBProgressHUD showMessageIsWait:@"请填写身份证号码" wait:YES];
            return NO;
        }
    }
    if (![self isValidateIdentityCard:idStr]) {
        [MBProgressHUD showMessageIsWait:@"请填写正确的身份证号码" wait:YES];
        return NO;
    }
    
//    if (!self.isEdit)
//    {
    
//    }
    return YES;
}

- (IBAction)clickSelectedBtn:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if (btn.tag == 1)
    {
        self.yesBtn.selected = YES;
        self.noBtn.selected = NO;
    }
    else
    {
        self.yesBtn.selected = NO;
        self.noBtn.selected = YES;
    }
}

- (void)setDefault:(MKConsigneeObject*)consigneeObject
{
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    [MKNetworking MKSeniorPostApi:@"/user/consignee/default/set"
                        paramters:@{@"consignee_uid" : consigneeObject.consigneeUid} completion:^(MKHttpResponse *response)
    {
        [ hud hide:YES];
        if (response.errorMsg != nil)
        {
            [MBProgressHUD showMessageIsWait:[NSString stringWithFormat:@"设置默认地址时发生错误了!\n%@", response.errorMsg] wait:YES];
            self.isEdit = YES;
            self.consigneeItem = consigneeObject;
            return ;
        }
        if (self.isEdit && !self.canSelected)
        {
            [MBProgressHUD showMessageIsWait:@"编辑成功" wait:YES];
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSuccessModifyAddress:)]) {
                [self.delegate didSuccessModifyAddress:consigneeObject];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }
        else if(!self.canSelected)
        {
            [MBProgressHUD showMessageIsWait:@"添加成功" wait:YES];
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSuccessFullAddAddress:)]) {
                [self.delegate didSuccessFullAddAddress:consigneeObject];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }
    }];
}

/**
 *  验证身份证号
 */
- (BOOL)isValidateIdentityCard:(NSString *)identityCard
{
    if (identityCard.length == 0) {
        return YES;
    }
    NSString *regex = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|[x,X])$)";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

#pragma mark -
#pragma mark -------------------- UIPickerViewDelegate,UIPickerViewDataSource --------------------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat width = 0;
    CGFloat screenWidth = self.view.frame.size.width;
    CGFloat averageWidth = screenWidth / 4.0f;
    if (component == 0) {
        width = 60;
    } else if (component == 1) {
        width = averageWidth - 5;
    } else if (component == 2) {
        width = averageWidth - 5;
    }
//    else if (component == 3) {
//        width = screenWidth - 60 - averageWidth * 2 + 10;
//    }
    return width;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(self.showComponents.count > component)
    {
        NSArray *items = self.showComponents[component];
        return items.count;
    }
    else
    {
        return 0;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSArray *items = self.showComponents[component];
    NSString *title = [[items objectAtIndex:row] name];
    
    CGFloat fontSize = 17.0f;
    NSInteger maxLength = 3;
    if (title.length > maxLength)
    {
        fontSize = fontSize - 1 - (title.length - maxLength);
    }
    
    UILabel *titleLabel = (UILabel *)view;
    if (!titleLabel)
    {
        titleLabel = [[UILabel alloc] init];
    }
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:fontSize];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = title;
    
    return titleLabel;
}

- (void)reloadRegionFromIndex:(NSInteger)index withComponentIndex:(NSInteger)cIndex withPcode:(NSString *)pcode
{
    [self getAddressAtIndex:index withCode:pcode isReloadAll:NO completion:^{
        
        //放队列防止第一列先停，第二列后停错位的问题
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
        {
            self.firstAddressTextField.text = [self pickedRegions];
        });
        
    }];
    /*
    for (NSInteger i = index; i < 4; ++ i)
    {
        NSArray *items;

        if (i == 1)
     
        {
            items = [self.regionModel citiesWithProvinceCode:pcode];
        }
        else if (i == 2)
        {
            items = [self.regionModel areasWithCityCode:pcode];
        }
        else
        {
            items = [self getStreetsWithPcode:pcode];
        }
        
        [self.showComponents replaceObjectAtIndex:i withObject:items];
        
        [self.locatePicker reloadComponent:cIndex];
        
        if (items.count != 0)
        {
            //放队列防止第一列先停，第二列后停错位的问题
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
            {
                [self.locatePicker selectRow:0 inComponent:cIndex animated:NO];
            });
        }
        
        if (items.count != 0)
        {
            pcode = [(MKRegionItem *)items[0] code];
        }
        else
        {
            pcode = nil;
        }
        
        cIndex ++ ;
    }
    
    while (cIndex < 4)
    {
        [self.locatePicker reloadComponent:cIndex ++ ];
    }
     */
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *items = self.showComponents[component];
    
    if (row >= items.count)
    {
        return;
    }
    
    MKRegionItem *item = items[row];
    
    [self reloadRegionFromIndex:component + 1 withComponentIndex:component + 1 withPcode:item.code];
    
    /*
    //放队列防止第一列先停，第二列后停错位的问题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        self.firstAddressTextField.text = [self pickedRegions];
    });
    */
}

- (NSString *)pickedRegions
{
    self.selectedProvinceCode = [(MKRegionItem *)self.showComponents[0][[self.locatePicker selectedRowInComponent:0]] code];
    
    int ind = 1;
    NSArray *cities = self.showComponents[1];
    NSInteger s = [self.locatePicker selectedRowInComponent:ind ++];
    self.selectedCityCode = s < cities.count ? [(MKRegionItem *)cities[s] code] : nil;
    
    NSArray *areas = self.showComponents[2];
    s = [self.locatePicker selectedRowInComponent:ind ++ ];
    self.selectedAreaCode = s < areas.count ? [(MKRegionItem *)areas[s] code] : nil;
    
//    NSArray *streets = self.showComponents[3];
//    s = [self.locatePicker selectedRowInComponent:ind];
//    self.selectedStreetCode = s < streets.count ? [(MKRegionItem *)streets[s] code] : nil;
    
    return [NSString stringWithFormat:@"%@-%@-%@", [self selectedProvinceString], [self selectedCityString],
            [self selectedAreaString]];
}

#pragma mark --
#pragma mark -- upate edit data

-(void)shouldUpdateInitData
{
    NSArray *provinces = [self readArrayWithCustomObjFromUserDefaults:@"CN"];
    
    MKRegionItem *item = [self checkCode:self.consigneeItem.provinceCode inItems:provinces];
    self.selectedProvinceCode = item.code;
    
    NSArray *cities = [self readArrayWithCustomObjFromUserDefaults:item.code];
    item = [self checkCode:self.consigneeItem.cityCode inItems:cities];
    self.selectedCityCode = item.code;
    
    NSArray *areas = [self readArrayWithCustomObjFromUserDefaults:item.code];
    item = [self checkCode:self.consigneeItem.areaCode inItems:areas];
    self.selectedAreaCode = item.code;
    
//    NSArray *streets = [self readArrayWithCustomObjFromUserDefaults:item.code];
//    item = [self checkCode:self.consigneeItem.streetCode inItems:streets];
//    self.selectedStreetCode = item.code;
    
    [self reloadPickerView];
    
    self.firstAddressTextField.text = [self pickedRegions];

}
- (void)updateData
{
    [self getAddressAtIndex:0 withCode:@"CN" isReloadAll:YES completion:^{
        
        [self shouldUpdateInitData];
        
    }];

    /*
    NSArray *provinces = [self.regionModel provinces];
    MKRegionItem *item = [self checkCode:self.consigneeItem.provinceCode inItems:provinces];
    self.selectedProvinceCode = item.code;
    
    NSArray *cities = [self.regionModel citiesWithProvinceCode:item.code];
    item = [self checkCode:self.consigneeItem.cityCode inItems:cities];
    self.selectedCityCode = item.code;
    
    NSArray *areas = [self.regionModel areasWithCityCode:item.code];
    item = [self checkCode:self.consigneeItem.areaCode inItems:areas];
    self.selectedAreaCode = item.code;
    
    NSArray *streets = [self getStreetsWithPcode:item.code];
    item = [self checkCode:self.consigneeItem.streetCode inItems:streets];
    self.selectedStreetCode = item.code;
    
    self.showComponents = [NSMutableArray arrayWithArray:@[provinces, cities, areas, streets, [NSArray array]]];
    */
    
    self.detailAddressTextField.text = self.consigneeItem.address;
    self.nameTextField.text = self.consigneeItem.consignee;
    self.phoneTextField.text = self.consigneeItem.mobile;
    self.identityCardTextField.text = self.consigneeItem.idNo;

}



#pragma mark -- save data

-(void)writeArrayWithCustomObjToUserDefaults:(NSString *)keyName withArray:(NSMutableArray *)myArray
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:myArray];
    
    [defaults setObject:data forKey:keyName];
    [defaults synchronize];
}

#pragma mark -- get data

-(NSArray *)readArrayWithCustomObjFromUserDefaults:(NSString*)keyName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(!keyName || keyName.length  == 0)
    {
        return nil;
    }

    NSData *data = [defaults objectForKey:keyName];

    if(data)
    {
        NSArray *myArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        return myArray;
    }
    else
    {
        return nil;
    }
}




@end
