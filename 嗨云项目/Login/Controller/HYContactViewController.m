//
//  HYContactViewController.m
//  嗨云项目
//
//  Created by haiyun on 16/7/13.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYContactViewController.h"
#import "HYContactView.h"
#import <AddressBook/AddressBook.h>
#import "HYSystemLoginMsg.h"
#import "HYDeliveryNoView.h"

@interface HYContactViewController ()
{
    HYContactView           *_pView;
    HYDeliveryNoView        *_noView;
}

@end

@implementation HYContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kHEXCOLOR(0xf5f5f5);
    self.title = @"手机联系人";
    [self initsubview];
    //获取手机联系人
    [self userAuthorizationAddressBook];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
-(void)initsubview
{
    CGRect rect = CGRectMake(0,0, self.view.bounds.size.width, Main_Screen_Height-64.0f);
    rect.size.height -= rect.origin.x;
    if (_pView == nil)
    {
        _pView = [[HYContactView alloc] init];
        _pView.frame = rect;
        [self.view addSubview:_pView];
    }else
    {
        _pView.frame = rect;
    }
    if ( _noView == nil )
    {
        _noView = NewObject(HYDeliveryNoView);
        _noView.frame = rect;
        _noView.backgroundColor = [UIColor clearColor];
        [_noView updateDeliverView:@"你的手机通讯录中没有找到嗨云店主～" imageName:@"LoginContacts"];
        _noView.hidden = YES;
        [self.view addSubview:_noView];
    }
    else
    {
        _noView.frame = rect;
    }
    [self.view bringSubviewToFront:_noView];

    
}

#pragma mark -获取手机联系人
-(void)userAuthorizationAddressBook
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
    {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            
            CFErrorRef *error1 = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
            [self copyAddressBook:addressBook];
        });
    }
    else if ( ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized )
    {
        
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        [self copyAddressBook:addressBook];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            _noView.hidden = NO;
        });
    }
}

- (void)copyAddressBook:(ABAddressBookRef)addressBook
{
    NSMutableArray  *peopleArr = [NSMutableArray array];
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    for ( int i = 0; i < numberOfPeople; i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        NSString *firstName = (NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *middlename = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonMiddleNameProperty));
        NSString *lastName = (NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSString *phoneName = [NSString stringWithFormat:@"%@%@%@",(ISNSStringValid(lastName)?lastName:@""),(ISNSStringValid(middlename)?middlename:@""),(ISNSStringValid(firstName)?firstName:@"")];
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
            [dict1 setObject:phoneName forKey:@"name"];
            NSString * personPhone = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phone, k));
            [dict1 setObject:[self changePhoneNum:personPhone] forKey:@"mobile"];
            [peopleArr addObject:dict1];
            
        }
        CFRelease(phone);
        
    }
    CFRelease(people);
    if ( peopleArr && peopleArr.count > 0 )
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            _noView.hidden = YES;
            if ( _pView )
            {
                [_pView updateContactView:peopleArr];
            }
        });

//        [HYSystemLoginMsg sendqueryUserMobileDirectory:@{@"user_mobile_list":peopleArr}
//                                               success:^{
//            
//        }];
        NSLog(@"self.peopleArr====%@",peopleArr);
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            _noView.hidden = NO;
        });
    }
    
}

-(NSString *)changePhoneNum:(NSString *)phoneNum
{
    NSCharacterSet *setToRemove = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]
                                   invertedSet];
    NSString *phoneStr = [[phoneNum componentsSeparatedByCharactersInSet:setToRemove] componentsJoinedByString:@""];
    if ( phoneStr.length > 11 && [phoneStr hasPrefix:@"86"] )
    {
        return [phoneStr substringFromIndex:2];
    }
    return phoneStr;
}

@end
