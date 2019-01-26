//
//  MKCountDownButton.h
//  YangDongXi
//
//  Created by windy on 15/6/4.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKCountDownButton;
typedef NSString* (^DidChangeBlock)(MKCountDownButton *countDownButton,int second);
typedef NSString* (^DidFinishedBlock)(MKCountDownButton *countDownButton,int second);

typedef void (^TouchedDownBlock)(MKCountDownButton *countDownButton,NSInteger tag);

@interface MKCountDownButton : UIButton
{
    int _second;
    int _totalSecond;
    
    NSTimer *_timer;
    NSDate *_startDate;
    
    DidChangeBlock _didChangeBlock;
    DidFinishedBlock _didFinishedBlock;
    TouchedDownBlock _touchedDownBlock;
}

-(void)addToucheHandler:(TouchedDownBlock)touchHandler;

-(void)didChange:(DidChangeBlock)didChangeBlock;
-(void)didFinished:(DidFinishedBlock)didFinishedBlock;
-(void)startWithSecond:(int)second;
- (void)stop;
@end
