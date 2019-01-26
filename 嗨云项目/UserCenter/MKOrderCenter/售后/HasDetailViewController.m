//
//  HasDetailViewController.m
//  YangDongXi
//
//  Created by 杨鑫 on 15/10/16.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "HasDetailViewController.h"
#import "MKBaseItemObject.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
#import "RefundObject.h"
#import "UIImage+MKExtension.h"
#import "MKServiceTableViewController.h"
#import <PureLayout.h>


@interface HasDetailViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *topBrackView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

@property (weak, nonatomic) IBOutlet UITextView *instructionsTextField;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic, strong)UIView *backView;

@property (weak, nonatomic) IBOutlet UIButton *refundButton;
@property (weak, nonatomic) IBOutlet UILabel *onlyRefund;
@property (nonatomic, strong)UIPickerView *picker;
@property (nonatomic, strong)NSMutableArray *pickerData;
@property (nonatomic, strong)NSMutableArray *pickerDataId;

@property (nonatomic, strong) IBOutletCollection(UIButton) NSMutableArray *getPhoto;
@property (nonatomic,strong)UIActionSheet *sheet;

@property (nonatomic, strong) IBOutletCollection(UIImageView)NSMutableArray *  blackImageView;

@property (nonatomic, strong) IBOutletCollection(UIImageView)NSMutableArray *  addImageView;
@property (nonatomic,strong)NSMutableArray *imageDataArray;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSMutableArray *deleButtonArray;
@property (nonatomic, strong) IBOutletCollection(UIView) NSMutableArray *balkView;
@property (nonatomic,strong)UIButton *upImageButton;
@property (nonatomic,strong)RefundObject *refun;
@property (nonatomic,assign)NSInteger state;
@property (weak, nonatomic) IBOutlet UILabel *maxPrice;
@property (weak, nonatomic) IBOutlet UILabel *returnLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *returnHight;
@property (weak, nonatomic) IBOutlet UIView *serviceView;
@property (weak, nonatomic) IBOutlet UIView *yuanyinView;
@property (weak, nonatomic) IBOutlet UIView *seView;

@property (weak, nonatomic) IBOutlet UIButton *reButton;

@property (nonatomic,strong)NSMutableArray *dataSouce;


@property (nonatomic,assign)BOOL isXuanze;
@end

@implementation HasDetailViewController
- (UIView *)backView{
    if (!_backView) {
        self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 216-45, [UIScreen mainScreen].bounds.size.height, 45)];
        _backView.backgroundColor = [UIColor colorWithHexString:@"f0f1f3"];
//        _backView.alpha = .8;
        UIButton *but = [UIButton buttonWithType:(UIButtonTypeSystem)];
        but.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 40-10, (45-20)/2, 40, 20);
        but.titleLabel.font = [UIFont systemFontOfSize:14];
        [but setTitle:@"完成" forState:(UIControlStateNormal)];
        [but setTitleColor:[UIColor colorWithHex:0xff4b55] forState:(UIControlStateNormal)];
        [but addTarget:self action:@selector(handleWanCheng:) forControlEvents:(UIControlEventTouchUpInside)];
        [_backView addSubview:but];
        UIImage *ima = [UIImage imageNamed:@"arrow_left_hover"];
        ima = [ima imageWithColor:[UIColor lightGrayColor]];
        UIButton *upBut = [UIButton buttonWithType:(UIButtonTypeCustom)];
        upBut.frame = CGRectMake(15, (45 - 19)/2, 11, 19);
        [upBut setImage:ima forState:(UIControlStateNormal)];
        [upBut addTarget:self action:@selector(upButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        upBut.tag = 200;
        [_backView addSubview:upBut];
        UIButton *dowmBut = [UIButton buttonWithType:(UIButtonTypeCustom)];
        dowmBut.frame = CGRectMake(60, (45 - 19)/2, 11, 19);
        [dowmBut setImage:[UIImage imageNamed:@"arrow_right_hover"] forState:(UIControlStateNormal)];
        [dowmBut addTarget:self action:@selector(downButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        dowmBut.tag = 201;
        [_backView addSubview:dowmBut];
    }
    return _backView;
}
- (void)upButtonAction:(UIButton *)sender{
    self.state -- ;
    if (self.state < 0) {
        self.state = 0;
    }
    UIButton *bu = (UIButton *)[self.view viewWithTag:201];
    UIImage *imag = [UIImage imageNamed:@"arrow_right_hover"];
    [bu setImage:imag forState:(UIControlStateNormal)];
    
    if (self.state == 0) {
        UIImage *ima = [UIImage imageNamed:@"arrow_left_hover"];
        ima = [ima imageWithColor:[UIColor lightGrayColor]];
        [sender setImage:ima forState:(UIControlStateNormal)];
    }
    
    [self.picker selectRow:self.state  inComponent:0  animated:YES];
    [self.refundButton setTitle:self.pickerData[self.state] forState:(UIControlStateNormal)];
}
- (void)downButtonAction:(UIButton *)sender{
    self.state ++;
    if (self.state >= self.pickerData.count) {
        self.state = self.pickerData.count - 1;
    }
    
    UIButton *bu = (UIButton *)[self.view viewWithTag:200];
    UIImage *imag = [UIImage imageNamed:@"arrow_left_hover"];
    [bu setImage:imag forState:(UIControlStateNormal)];
    if (self.state == self.pickerData.count - 1) {
        UIImage *ima = [UIImage imageNamed:@"arrow_right_hover"];
        ima = [ima imageWithColor:[UIColor lightGrayColor]];
        [sender setImage:ima forState:(UIControlStateNormal)];
        
    }
    [self.picker selectRow:self.state  inComponent:0  animated:YES];
    [self.refundButton setTitle:self.pickerData[self.state] forState:(UIControlStateNormal)];
}
- (UIPickerView *)picker{
    if (!_picker) {
        self.picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height + 216, [UIScreen mainScreen].bounds.size.width, 216)];
        _picker.showsSelectionIndicator=YES;
        _picker.delegate=self;
        _picker.backgroundColor = [UIColor whiteColor];
    }
    return _picker;
}
- (IBAction)StatestateSgoods:(id)sender {
    self.isXuanze = YES;
    [self.instructionsTextField resignFirstResponder];
    [self.picker selectRow:0  inComponent:0  animated:YES];
    self.state = 0;
    UIButton *laftBut = (UIButton *)[self.view viewWithTag:200];
    UIButton *rightBut = (UIButton *)[self.view viewWithTag:201];
    
    UIImage *ima = [UIImage imageNamed:@"arrow_left_hover"];
    ima = [ima imageWithColor:[UIColor lightGrayColor]];
    [laftBut setImage:ima forState:(UIControlStateNormal)];
    [rightBut setImage:[UIImage imageNamed:@"arrow_right_hover"] forState:(UIControlStateNormal)];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.picker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 216, [UIScreen mainScreen].bounds.size.width, 216);
    } completion:^(BOOL finished) {
        self.backView.hidden = NO;
    }];
    [self.reButton setTitle:self.dataSouce.firstObject forState:(UIControlStateNormal)];
    [self.picker reloadAllComponents];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.state = 0 ;
    self.dataSouce = [NSMutableArray arrayWithArray:@[@"选择货物状态",@"没收到货",@"已收到货"]];
    self.pickerData = [NSMutableArray array];
    self.pickerDataId = [NSMutableArray array];
    self.priceTextField.delegate = self;
    self.instructionsTextField.delegate = self;
    self.refun = [[RefundObject alloc]init];
    self.priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.submitButton setTitleColor:[UIColor colorWithHex:0xff4b55] forState:(UIControlStateNormal)];
    self.submitButton.layer.borderColor = [UIColor colorWithHex:0xff4b55].CGColor;
    [self.submitButton addTarget:self action:@selector(handleSubmit:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.submitButton.layer setBorderWidth:1.0];
    self.onlyRefund.text = self.tString;
    if (!self.isReturn) {

        [self.yuanyinView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.serviceView withOffset:10];
        [self.seView autoSetDimension:(ALDimensionHeight) toSize:0];
        self.seView.hidden = YES;
        self.reButton.hidden = YES;
        self.returnLabel.hidden = YES;
        
    }else{
        [self.yuanyinView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.returnLabel withOffset:10];
        [self.seView autoSetDimension:(ALDimensionHeight) toSize:40];
        self.seView.hidden = NO;
        self.reButton.hidden = NO;
        self.returnLabel.hidden = NO;
    }
    [self networkLoad];
    
    self.refundButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.refundButton.layer.shadowOffset = CGSizeMake(0, 0);
    self.refundButton.layer.shadowOpacity = 0;
    self.refundButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.refundButton addTarget:self action:@selector(handleRefundButton:) forControlEvents:(UIControlEventTouchUpInside)];
    self.maxPrice.text =[NSString stringWithFormat:@"最多退款%@元",[MKBaseItemObject priceString: self.itemObject.paymentAmount]];
//    self.pickerData = [[NSMutableArray alloc]initWithObjects:@"买/卖双方协商一致",@"买错/多买/不想要",@"商品质量问题",@"未收到货品",@"其他", nil];
//    self.pickerDataId = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
//     [self.view addSubview:self.picker];
    [self.view addSubview:self.backView];
    self.backView.hidden = YES;
    self.imageDataArray = [NSMutableArray array];
    if ([self.tString isEqualToString: @"仅退款"]) {
        self.title = @"申请退款";
        self.priceTextField.userInteractionEnabled = NO;
        self.priceTextField.textColor = [UIColor colorWithHexString:@"b8b8b8"];
        if (self.itemObject) {
            self.priceTextField.text =[NSString stringWithFormat:@"%@",[MKBaseItemObject priceString: self.itemObject.paymentAmount]];
        }
    }else{
        self.title = @"申请退货";
        self.priceTextField.userInteractionEnabled = YES;
        self.priceTextField.textColor = [UIColor colorWithHexString:@"ff4d55"];
    }
    for (UIButton *but in self.getPhoto) {
        [but addTarget:self action:@selector(openMenu:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    for (UIButton *but in self.deleButtonArray) {
        
        but.hidden = YES;
        [but addTarget:self action:@selector(deleImage:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    for (int i = 0; i < self.balkView.count; i++) {
        UIView *view = self.balkView[i];
        if (i == 0) {
            continue;
        }
        view.hidden = YES;
    }

    
}
- (void)handleSubmit:(UIButton *)sender{
    if (![self.pickerData containsObject:[self.refundButton titleForState:(UIControlStateNormal)]]) {
        [MBProgressHUD showMessageIsWait:@"请选择退款原因" wait:YES];
        return;
    }
    NSUInteger inter =[self.pickerData indexOfObject:[self.refundButton titleForState:(UIControlStateNormal)]];
    _refun.order = self.order;
    _refun.orderUid = self.orderUid;
    _refun.item = self.itemObject;
    _refun.refund_desc = self.instructionsTextField.text;
    _refun.refund_amount = self.priceTextField.text;
    _refun.imageData = self.imageDataArray;
    _refun.refund_reason_id = [self.pickerDataId objectAtIndex:inter];
    __weak typeof(self) weakself = self;
    self.refun.tmpe = ^(){
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakself.refun.pickView removeFromSuperview];
//            [[NSNotificationCenter defaultCenter] postNotificationName:MKOrderStatusChangedNotification object:nil];
            NSMutableArray *arr = [NSMutableArray array];
            for (UIViewController *obj in weakself.navigationController.viewControllers) {
                if (![obj isKindOfClass:[MKServiceTableViewController class]]) {
                    [arr addObject:obj];
                }
            }
           weakself.navigationController.viewControllers = arr;
        [weakself.navigationController popViewControllerAnimated:YES];
        });
    };
    [_refun uploadData];
}

- (void)openMenu:(UIButton *)sender{
    self.upImageButton = sender;
    _sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消"
                           destructiveButtonTitle:@"拍照"
                                otherButtonTitles:@"从相册处选择",nil];
    [_sheet showInView:[UIApplication sharedApplication].keyWindow];
}
- (void)deleImage:(UIButton *)sender{
    NSUInteger inte =  [self.deleButtonArray indexOfObject:sender];
    [self.imageDataArray removeObjectAtIndex:inte];
    for (int i = 0; i < self.imageDataArray.count; i ++) {
        UIImageView *ima =self.blackImageView[i];
        ima.image = [UIImage imageWithData:self.imageDataArray[i]];
    }
    for (NSInteger i = self.imageDataArray.count ; i < self.balkView.count; i++) {
        UIImageView *ima = (UIImageView *)self.blackImageView[i];
        UIImageView *addImage = (UIImageView *)self.addImageView[i];
        addImage.hidden = NO;
        [(UIButton *)self.deleButtonArray[i] setHidden:YES];
        [(UIButton *)self.getPhoto[i] setHidden:NO];
        ima.image = [UIImage imageNamed:@"block_176x176"];
    }
    NSUInteger a = self.imageDataArray.count;
    if (a == 0) {
        UIView *vie =(UIView *) self.balkView[2];
        vie.hidden = YES;
        UIView *view =(UIView *) self.balkView[1];
        view.hidden = YES;
    }
    if (a == 1) {
        UIView *vie =(UIView *) self.balkView[2];
        vie.hidden = YES;
    }
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self takePhoto];
            break;
        case 1:  //打开本地相册
            [self LocalPhoto];
            break;
    }
}

- (void)takePhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}
- (void)LocalPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        [self.imageDataArray addObject:data];
        if (self.imageDataArray.count == 0) {
            [self.addImageView[1] setHidden:NO];
        }
        if (self.imageDataArray.count == 1) {
            [(UIButton *)self.deleButtonArray[0] setHidden:NO];
            [(UIButton *)self.getPhoto[0] setHidden:YES];
            UIImageView *image = (UIImageView *)self.blackImageView[0];
            image.image = [UIImage imageWithData:self.imageDataArray.firstObject];
            UIImageView *addview =(UIImageView *)self.addImageView[0];
            addview.hidden = YES;
            [(UIView *)self.balkView[1] setHidden:NO];
        }
        if (self.imageDataArray.count == 2) {
            [(UIButton *)self.deleButtonArray[1] setHidden:NO];
            [(UIButton *)self.getPhoto[1] setHidden:YES];
            UIImageView *image = (UIImageView *)self.blackImageView[1];
            image.image = [UIImage imageWithData:self.imageDataArray[1]];
            UIImageView *addview =(UIImageView *)self.addImageView[1];
            addview.hidden = YES;
            [(UIView *)self.balkView[2] setHidden:NO];
        }
        if (self.imageDataArray.count == 3) {
            [(UIButton *)self.deleButtonArray[2] setHidden:NO];
            [(UIButton *)self.getPhoto[2] setHidden:YES];
            UIImageView *image = (UIImageView *)self.blackImageView[2];
            image.image = [UIImage imageWithData:self.imageDataArray[2]];
            UIImageView *addview =(UIImageView *)self.addImageView[2];
            addview.hidden = YES;
        }
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)networkLoad{
    [MKNetworking MKSeniorGetApi:@"trade/refund/reason/list" paramters:nil completion:^(MKHttpResponse *response) {
        NSArray *array = [response responseDictionary][@"data"][@"refund_reason_list"];
        for (NSDictionary *dic in array) {
            [self.pickerData addObject:dic[@"refund_reason"]];
            [self.pickerDataId addObject:dic[@"refund_reason_id"]];
        }
          [self.view addSubview:self.picker];
    }];
}
- (IBAction)tapGesture:(id)sender {
    [self.priceTextField resignFirstResponder];
    [self.instructionsTextField resignFirstResponder];
    [UIView animateWithDuration:0.3f animations:^{
        self.picker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height + 216, [UIScreen mainScreen].bounds.size.width, 216);
    }];
    self.backView.hidden = YES;
}
- (void)handleWanCheng:(UIButton *)sender{
    [UIView animateWithDuration:0.3f animations:^{
        self.picker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height + 216, [UIScreen mainScreen].bounds.size.width, 216);
    }];
    [self.instructionsTextField resignFirstResponder];
    self.backView.hidden = YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.instructionsLabel.hidden = YES;
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        self.instructionsLabel.hidden = NO;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    int i = 0;
    for (NSInteger j = 0;j<textField.text.length; j++) {
        unichar c = [textField.text characterAtIndex:j];
        if (c == '.') {
            i++;
        }
    }
    if (textField.text.floatValue*100 > self.itemObject.paymentAmount) {
        [MBProgressHUD showMessageIsWait:@"退款金额不能大于原价" wait:YES];
        textField.text = @"";
        return;
    }
    if (i > 1 ) {
       [MBProgressHUD showMessageIsWait:@"输入金额有误" wait:YES];
        textField.text = @"";
        return;
    }
}
- (void)handleRefundButton:(UIButton *)sender{
    self.isXuanze = NO;
    [self.instructionsTextField resignFirstResponder];
    [self.picker selectRow:0  inComponent:0  animated:YES];
    self.state = 0;
    UIButton *laftBut = (UIButton *)[self.view viewWithTag:200];
    UIButton *rightBut = (UIButton *)[self.view viewWithTag:201];
    
    UIImage *ima = [UIImage imageNamed:@"arrow_left_hover"];
    ima = [ima imageWithColor:[UIColor lightGrayColor]];
    [laftBut setImage:ima forState:(UIControlStateNormal)];
    [rightBut setImage:[UIImage imageNamed:@"arrow_right_hover"] forState:(UIControlStateNormal)];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.picker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 216, [UIScreen mainScreen].bounds.size.width, 216);
    } completion:^(BOOL finished) {
        self.backView.hidden = NO;
    }];
    [self.refundButton setTitle:self.pickerData.firstObject forState:(UIControlStateNormal)];
    [self.picker reloadAllComponents];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.isXuanze) {
        return [self.dataSouce count];
    }
    return [self.pickerData count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.isXuanze) {
        return [self.dataSouce objectAtIndex:row];
    }
    return [self.pickerData objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.isXuanze) {
        [self.reButton setTitle:self.dataSouce[row] forState:(UIControlStateNormal)];
        if (row == 1) {
            self.priceTextField.userInteractionEnabled = NO;
            self.priceTextField.textColor = [UIColor colorWithHexString:@"b8b8b8"];
            if (self.itemObject) {
                self.priceTextField.text =[NSString stringWithFormat:@"%@",[MKBaseItemObject priceString: self.itemObject.paymentAmount ]];
            }
        }else if(row == 2){
            self.priceTextField.userInteractionEnabled = YES;
            self.priceTextField.textColor = [UIColor colorWithHexString:@"ff4d55"];
        }
    }else{
    [self.refundButton setTitle:self.pickerData[row] forState:(UIControlStateNormal)];
    }
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
