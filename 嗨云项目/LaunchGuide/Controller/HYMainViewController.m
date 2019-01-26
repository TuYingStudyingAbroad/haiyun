//
//  HYMainViewController.m
//  嗨云项目
//
//  Created by YanLu on 16/5/9.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYMainViewController.h"
#import "HYSystemInit.h"

@implementation HYMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    [self initsubview];
    // Do any additional setup after loading the view.

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initsubview
{
    UIImageView * imageBg = (UIImageView *)[self.view viewWithTag:0x10000];
    if (imageBg == NULL)
    {
        imageBg = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        if (IS_Iphone5)
        {
            imageBg.image = [UIImage imageNamed:@"LaunchImage-700-568h"];
        }
        else if (IS_Iphone6)
        {
            imageBg.image = [UIImage imageNamed:@"LaunchImage-800-667h"];
        }
        else if (IS_Iphone6Plus)
        {
            imageBg.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h"];
        }
        else if( IS_Iphone4 )
        {
            imageBg.image = [UIImage imageNamed:@"LaunchImage-700"];
        }
        else
        {
            imageBg.image = [UIImage imageNamed:@"LaunchImage-700-Portrait@2x~ipad"];
        }
        [self.view addSubview:imageBg];
    }else
    { 
        imageBg.frame = [[UIScreen mainScreen] bounds];
    }
    
    [[HYSystemInit sharedInstance]  GetServerNetworking];
    
//    [[HYSystemInit sharedInstance] sellerMessageBaseUrl];
    
#ifdef __IPHONE_7_0
    if (IS_IOS(7))
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
#endif
}

@end
