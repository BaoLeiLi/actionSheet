//
//  BLActionSheet.m
//  wannasg
//
//  Created by Mervyn on 16/12/19.
//  Copyright © 2016年 mervyn_lbl@163.com. All rights reserved.
//

#import "BLActionSheet.h"
#import "BLAction.h"
#import <objc/runtime.h>

#define actionHeight 50

@interface BLActionSheet ()<UIGestureRecognizerDelegate>

{
    NSString *_title;
    NSString *_message;
    CGFloat _actionMinY;
    BLActionSheetStyle _style;
    NSInteger _count;
}

@property (nonatomic,weak) BLAction *currentAction;

@property (nonatomic,weak) UIView *actionView;
@property (nonatomic,weak) UIButton *cancel;
@property (nonatomic,strong) UIFont *sheetTitleFont;
@property (nonatomic,strong) UIColor *sheetTitleColor;
@property (nonatomic,strong) UIFont *sheetMessageFont;
@property (nonatomic,strong) UIColor *sheetMessageColor;
@property (nonatomic,strong) UIFont *sheetCancelFont;
@property (nonatomic,strong) UIColor *sheetCancelColor;

@end

@implementation BLActionSheet

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message actionSheetStyle:(BLActionSheetStyle)style{
    
    if ([super init]) {
        
        _title = title;
        _message = message;
        _count = 0;
        
        self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        
        self.backgroundColor = SheetColor(0, 0, 0, 0);
        
        _style = style;
        
        _actionMinY = (style == BLActionSheetStyleFlat)?55:60;
        
        [self initArguments];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(0, 5, KScreenWidth, actionHeight);
        cancel.backgroundColor = [UIColor whiteColor];
        cancel.titleLabel.font = _sheetCancelFont;
        [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancel setTitleColor:_sheetCancelColor forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(removeActionSheet) forControlEvents:UIControlEventTouchUpInside];
        self.cancel = cancel;
        
        [self.actionView addSubview:cancel];
        
        objc_setAssociatedObject([UIApplication sharedApplication], customActionSheetKey, self, OBJC_ASSOCIATION_ASSIGN);
        
    }
    
    return self;
}

- (void)initArguments{
    
    _sheetTitleFont = [UIFont systemFontOfSize:16];
    _sheetTitleColor = SheetColor(102, 102, 102, 1.0);
    _sheetMessageFont = [UIFont systemFontOfSize:13];
    _sheetMessageColor = SheetColor(200, 200, 200, 1.0);
    _sheetCancelFont = [UIFont systemFontOfSize:16];
    _sheetCancelColor = SheetColor(34, 34, 34, 1.0);
}

- (void)addAction:(BLAction *)action{
    
    _count++;
    
    self.currentAction = action;
    
    if (_actionMinY == (_style == BLActionSheetStyleFlat?55:60)) {
        
        _actionMinY += 50;
        
    }else{
        
        _actionMinY += 51;
    }
    
    self.actionView.frame = CGRectMake(0, KScreenHeight, KScreenWidth, _actionMinY);
    
    if (_style == BLActionSheetStyleRound) {
        
        self.cancel.frame = CGRectMake(15, _actionMinY - 55, KScreenWidth - 30, actionHeight);
        
        self.cancel.layer.cornerRadius = 10;
        
        self.cancel.layer.masksToBounds = YES;
        
        action.frame = CGRectMake(15, 0, KScreenWidth - 30, actionHeight);
        
        [action layoutIfNeeded];
        
    }else{
        
        self.cancel.frame = CGRectMake(0, _actionMinY - 50, KScreenWidth, actionHeight);
        
        action.frame = CGRectMake(0, 0, KScreenWidth, actionHeight);
    }
    
    for (UIView *otherAction in self.actionView.subviews) {
        
        if ([otherAction isKindOfClass:[BLAction class]]) {
            
            CGRect originalRect = otherAction.frame;
            
            otherAction.frame = CGRectMake(originalRect.origin.x, originalRect.origin.y + 51, originalRect.size.width, actionHeight);
        }
    }
    
    if (_style == BLActionSheetStyleRound && _count == 1) {
            
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:action.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = action.bounds;
        shapeLayer.path = bezierPath.CGPath;
        action.layer.mask = shapeLayer;
        
    }
    
    [self.actionView addSubview:action];
}

- (void)addActions:(NSArray<BLAction *> *)actions{
    
    for (BLAction *subAction in actions) {
        
        [self addAction:subAction];
    }
    
//    [self addSheetTitle];
}

- (void)addSheetTitle{
    
    if (_title.length > 0 && _message.length > 0) {
        
        BLAction *sheetTitle = [[BLAction alloc] initWithActionTitle:_title subTitle:_message image:nil action:nil];
        sheetTitle.userInteractionEnabled = NO;
        [sheetTitle setValue:_sheetTitleFont forKey:@"actionTitleFont"];
        [sheetTitle setValue:_sheetTitleColor forKey:@"actionTitleColor"];
        [sheetTitle setValue:_sheetMessageFont forKey:@"actionMessageFont"];
        [sheetTitle setValue:_sheetMessageColor forKey:@"actionMessageColor"];
        [self addAction:sheetTitle];
        
        self.currentAction = sheetTitle;
    }
    
}

- (void)setSheetCancelFont:(UIFont *)sheetCancelFont{
    
    _sheetCancelFont = sheetCancelFont;
    
    self.cancel.titleLabel.font = sheetCancelFont;
}
- (void)setSheetCancelColor:(UIColor *)sheetCancelColor{
    
    _sheetCancelColor = sheetCancelColor;
    
    [self.cancel setTitleColor:sheetCancelColor forState:UIControlStateNormal];
}

- (void)presentActionSheet{
        
    [self addSheetTitle];
    
    if (_style == BLActionSheetStyleRound) {
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.currentAction.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = self.currentAction.bounds;
        shapeLayer.path = bezierPath.CGPath;
        self.currentAction.layer.mask = shapeLayer;
    }
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.15 animations:^{
        
        weakSelf.backgroundColor = SheetColor(0, 0, 0, 0.5);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.actionView.frame = CGRectMake(0, KScreenHeight-_actionMinY, KScreenWidth, _actionMinY);
            
        }completion:^(BOOL finished) {
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeActionSheet)];
            tap.delegate = self;
            [weakSelf addGestureRecognizer:tap];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeActionSheet) name:@"BLActionClickNotification" object:nil];
        }];
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    CGPoint point = [touch locationInView:self];
    
    if (_title.length > 0 || _message.length > 0) {
        
        CGRect titleRect = CGRectMake(0, self.actionView.frame.origin.y, KScreenWidth, actionHeight);
        
        if (CGRectContainsPoint(titleRect, point)) {
            
            return NO;
        }
    }
    
    return YES;
}

- (void)removeActionSheet{
    
    __weak typeof(self)weakSelf = self;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.actionView.transform = CGAffineTransformTranslate(self.actionView.transform, 0, KScreenHeight);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            weakSelf.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLActionClickNotification" object:nil];
            
            objc_setAssociatedObject([UIApplication sharedApplication], customActionSheetKey, nil, OBJC_ASSOCIATION_ASSIGN);
            
            [weakSelf removeFromSuperview];
        }];
    }];
}

- (UIView *)actionView{
    
    if (!_actionView) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, _actionMinY)];
        if (_style == BLActionSheetStyleFlat) {
            
            view.backgroundColor = SheetColor(240, 240, 240, 1.0);
            
        }else{
            
            view.backgroundColor = [UIColor clearColor];
        }
        self.actionView = view;
        [self addSubview:view];
    }
    return _actionView;
}


@end
