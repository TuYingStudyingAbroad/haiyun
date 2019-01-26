
//
//  fansSortView.m
//  嗨云项目
//
//  Created by 小辉 on 16/8/30.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "fansSortView.h"


@interface fansSortView()

@property (nonatomic,assign)BOOL timeBtnUp;
@property(nonatomic,assign)BOOL  icomeBtnUp;



@end

@implementation fansSortView





-(void)awakeFromNib{
    self.timeBtn.status = FLAlignmentStatusCenter;
   
    [self.timeBtn setImage:[UIImage imageNamed:@"qhs"] forState:UIControlStateNormal];
    [self.timeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    self.incomeBtn.status = FLAlignmentStatusCenter;
     self.incomeBtn.userInteractionEnabled=NO;
    
//    [self.incomeBtn setImage:[UIImage imageNamed:@"qhy"] forState:UIControlStateNormal];
    _timeBtnUp=YES;
    _icomeBtnUp=NO;
}
- (IBAction)sortBtnClick:(id)sender {
   
    if (sender == self.timeBtn)
    {   _btnTag=1;
         _icomeBtnUp=NO;
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        if (_timeBtnUp) {
             [self.timeBtn setImage:[UIImage imageNamed:@"qhe"] forState:UIControlStateNormal];
            _timeBtnUp=NO;
        }else{
            [self.timeBtn setImage:[UIImage imageNamed:@"qhs"] forState:UIControlStateNormal];
            _timeBtnUp=YES;
        }
//         [self.incomeBtn setImage:[UIImage imageNamed:@"qhy"] forState:UIControlStateNormal];
        [self.incomeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    }
    if (sender == self.incomeBtn)
    {
        _btnTag=2;
        _timeBtnUp=NO;
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        if (!_icomeBtnUp) {
//            [self.incomeBtn setImage:[UIImage imageNamed:@"qhs"] forState:UIControlStateNormal];
            _icomeBtnUp=YES;
           
        }else{
//            [self.incomeBtn setImage:[UIImage imageNamed:@"qhe"] forState:UIControlStateNormal];
            _icomeBtnUp=NO;
        }
        [self.timeBtn setImage:[UIImage imageNamed:@"qhy"] forState:UIControlStateNormal];
         [self.timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didPressBtnTag:withUPDown:)]) {
        [self.delegate didPressBtnTag:_btnTag withUPDown:sender == self.timeBtn?_timeBtnUp:_icomeBtnUp] ;
    }

    
}




@end
