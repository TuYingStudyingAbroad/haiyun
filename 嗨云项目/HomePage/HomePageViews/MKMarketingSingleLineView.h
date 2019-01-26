//
//  MKMarketingSingleLineView.h
//  YangDongXi
//
//  Created by cocoa on 15/5/5.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KNumberOfIconsInLine 4

@interface MKMarketingSingleLineView : UIView

- (void)updateViews:(NSArray *)views;

- (void)updateViews:(NSArray *)views withSeperator:(BOOL)sp;

/**
 * This method is used to layout icons based on the input provided
 */
- (void)updatHorizationaleViews:(NSArray *)views withSeperator:(BOOL)sp isLeft:(BOOL)isLeft;

- (void)updateVerticalViews:(NSArray *)views withSeperator:(BOOL)sp isLeft:(BOOL)isLeft;

-(void)updateStyle3Views:(NSArray *)views withSeperator:(BOOL)sp isLeft:(BOOL)isLeft;

-(void)updateStyle4Views:(NSArray *)views withSeperator:(BOOL)sp;

@end
