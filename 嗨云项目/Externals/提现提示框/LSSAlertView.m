//
//  LSSAlertView.m
//  LSSAlertView
//
//  Created by MS on 16/5/11.
//  Copyright © 2016年 LSS. All rights reserved.
//

#import "LSSAlertView.h"
#define LAVSCREEN [UIScreen mainScreen].bounds
#define LAVSCREENW [UIScreen mainScreen].bounds.size.width
#define LAVSCREENH [UIScreen mainScreen].bounds.size.height
//默认宽度
#define LAVWIDTH LAVSCREENW-60
///各个栏目之间的距离
#define LAVSPACE 10.0
@interface LSSAlertView()
//根window
@property (nonatomic) UIWindow *rootWindow;
//弹窗
@property (nonatomic) UIView *alertView;
//title,默认为一行，多行还未做
@property (nonatomic) UILabel *titleLabel;
//内容
@property (nonatomic) UILabel *mesLabel;
//确认按钮
@property (nonatomic) UIButton *sureBtn;
//取消按钮
@property (nonatomic) UIButton *cancleBtn;
///闲的记录一下高度吧
@property (nonatomic) CGFloat alertHeight;
@end
@implementation LSSAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureBtn cancleBtn:(NSString *)cancleBtn{
    if (self == [super init]) {
        self.frame = LAVSCREEN;
        self.backgroundColor = [UIColor colorWithWhite:.5 alpha:.3];
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius = 10.0;
        if (title) {
            self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, LAVSPACE, LAVWIDTH, 20)];
            self.titleLabel.text = title;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:self.titleLabel];
        }
        if (message) {
            //首先计算当前字体的高度,默认信息用15号
            CGFloat mesHeight = [self getTextHeightWithText:message AndFont:[UIFont systemFontOfSize:15]];
            self.mesLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame)+LAVSPACE, LAVWIDTH-40, mesHeight)];
            self.mesLabel.text = message;
            self.mesLabel.textColor=[UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0 alpha:1.0];
            self.mesLabel.font = [UIFont systemFontOfSize:15];
            self.mesLabel.numberOfLines = 0;
            ///以下两个方法不能用
            ///设置字间距
            // self.mesLabel.characterSpace = 2;
            ///设置行间距
            // self.mesLabel.lineSpace = 5;
            [self.alertView addSubview:self.mesLabel];
        }
    
        
        if (sureBtn) {
            self.sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.sureBtn.frame = CGRectMake(20, CGRectGetMaxY(self.mesLabel.frame)+LAVSPACE, (LAVWIDTH-40), 35);
            self.sureBtn.backgroundColor = [UIColor redColor];
            [self.sureBtn setTitle:sureBtn forState:UIControlStateNormal];
            [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.sureBtn.tag = 0;
            [self.sureBtn addTarget:self action:@selector(buttonBeClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:self.sureBtn];
        }

        
        self.alertHeight = 10+CGRectGetHeight(self.titleLabel.frame)+10+CGRectGetHeight(self.mesLabel.frame)+10+CGRectGetHeight(self.sureBtn.frame)+10;
        self.alertView.frame = CGRectMake(0, 0, LAVWIDTH, self.alertHeight);
        [self addSubview:self.alertView];
    }
    return self;
}
#pragma mark - 弹出 -
- (void)showAlertView{
    self.rootWindow = [UIApplication sharedApplication].keyWindow;
    [self.rootWindow addSubview:self];
    ///创建动画
    [self creatShowAnimation];
}
- (void)creatShowAnimation{
   // CGPoint startPoint = CGPointMake(self.frame.size.height, -self.alertHeight);
//    //damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
//    //velocity:弹性复位的速度
//    self.alertView.layer.position = startPoint;
//    [UIView animateWithDuration:2.0 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
//        self.alertView.layer.position = self.center;
//    } completion:^(BOOL finished) {
//        
//    }];
    self.alertView.layer.position = self.center;
}
#pragma mark - 点击按钮的回调 -
- (void)buttonBeClicked:(UIButton *)button{
    if (self.returnIndex) {
        self.returnIndex(button.tag);
    }
    [self removeFromSuperview];
}
#pragma mark - 得到高度 -
-(CGFloat)getTextHeightWithText:(NSString *)text AndFont:(UIFont *)font
{
    return [text boundingRectWithSize:CGSizeMake(LAVWIDTH-40, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blackColor]} context:nil].size.height;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
