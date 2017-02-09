//
//  BLAction.m
//  wannasg
//
//  Created by Mervyn on 16/12/19.
//  Copyright © 2016年 mervyn_lbl@163.com. All rights reserved.
//

#import "BLAction.h"
#import "BLActionSheet.h"
#import <objc/runtime.h>



@interface BLAction ()

{
    NSString *_titleString;
    NSString *_messageString;
    NSString *_actionImageName;
}

@property (nonatomic,copy) actionBlock executBlock;

@property (nonatomic,strong) UIFont *actionTitleFont;
@property (nonatomic,strong) UIColor *actionTitleColor;
@property (nonatomic,strong) UIFont *actionMessageFont;
@property (nonatomic,strong) UIColor *actionMessageColor;

@property (nonatomic,weak) UILabel *actionTitle;

@property (nonatomic,weak) UILabel *actionMessage;

@property (nonatomic,weak) UIImageView *actionImage;


@end

@implementation BLAction

- (instancetype)initWithActionTitle:(NSString *)title subTitle:(NSString *)subTitle image:(NSString *)imageName action:(actionBlock)handle{
    
    if ([super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        _executBlock = handle;
        
        _actionTitleFont = [UIFont systemFontOfSize:16];
        _actionTitleColor = SheetColor(34, 34, 34, 1.0);
        _actionMessageFont = [UIFont systemFontOfSize:13];
        _actionMessageColor = SheetColor(180, 180, 180, 1.0);
        
        UILabel *mainTitle = [[UILabel alloc] init];
        mainTitle.frame = CGRectMake(0, 15, self.frame.size.width, 20);
        mainTitle.font = [UIFont systemFontOfSize:16];
        mainTitle.text = title;
        mainTitle.textAlignment = NSTextAlignmentCenter;
        mainTitle.textColor = SheetColor(34, 34, 34, 1.0);
        self.actionTitle = mainTitle;
        [self addSubview:mainTitle];
        
        if(subTitle && subTitle.length > 0){
            
            mainTitle.frame = CGRectMake(0, 7, self.frame.size.width, 20);
            
            UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, self.frame.size.width, 15)];
            message.text = subTitle;
            message.textAlignment = NSTextAlignmentCenter;
            message.font = [UIFont systemFontOfSize:13];
            message.textColor = SheetColor(180, 180, 180, 1.0);
            self.actionMessage = message;
            [self addSubview:message];
        }
        
        if (imageName.length > 0) {
            
            UIImageView *actionImg = [[UIImageView alloc] init];
            actionImg.image = [UIImage imageNamed:imageName];
            self.actionImage = actionImg;
            [self addSubview:actionImg];
        }
        
        _titleString = title;
        _messageString = subTitle;
        _actionImageName = imageName;
        
        UITapGestureRecognizer *actionTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionBlock)];
        [self addGestureRecognizer:actionTap];
        
    }
    return self;
}

- (BLStruct)getMaxLengthToAdjustImageFrame{
    
    CGRect titleRect = [_titleString boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.actionTitleFont} context:nil];
    
    CGRect messageRect = [_messageString boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.actionMessageFont} context:nil];
    
    CGFloat maxLength = ((titleRect.size.width > messageRect.size.width) ? titleRect.size.width:messageRect.size.width);
    
    CGFloat imgWH = 30;
    CGFloat imgX = (KScreenWidth - maxLength - imgWH - 15)*0.5;
    
    self.actionImage.frame = CGRectMake(imgX, 10, imgWH, imgWH);
    
    BLStruct newStruct = {imgX + imgWH + 15,maxLength};
    
    return newStruct;
}


- (void)setActionTitleFont:(UIFont *)actionTitleFont{
    
    _actionTitleFont = actionTitleFont;
    
    self.actionTitle.font = actionTitleFont;
}
- (void)setActionTitleColor:(UIColor *)actionTitleColor{
    
    _actionTitleColor = actionTitleColor;
    
    self.actionTitle.textColor = actionTitleColor;
}
- (void)setActionMessageFont:(UIFont *)actionMessageFont{
    
    _actionMessageFont = actionMessageFont;
    
    self.actionMessage.font = actionMessageFont;
}
- (void)setActionMessageColor:(UIColor *)actionMessageColor{
    
    _actionMessageColor = actionMessageColor;
    
    self.actionMessage.textColor = actionMessageColor;
}

- (void)actionBlock{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BLActionClickNotification" object:nil];
    
    if (_executBlock) {
        
        id sheet = objc_getAssociatedObject([UIApplication sharedApplication], customActionSheetKey);
        
        if ([sheet isKindOfClass:[BLActionSheet class]]) {
            
            sheet = objc_getAssociatedObject([UIApplication sharedApplication], customActionSheetKey);
            
        }else{
            
            sheet = nil;
        }
        
        self.executBlock(sheet);
    }
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    BLStruct newStruct = {0,self.frame.size.width};
    
    if (_actionImageName.length > 0) {
        
        newStruct = [self getMaxLengthToAdjustImageFrame];
        
    }
    
    CGRect titleRect = self.actionTitle.frame;
    
    self.actionTitle.frame = CGRectMake(newStruct.x, titleRect.origin.y, newStruct.width, 20);
    
    if (_actionMessage) {
        
        self.actionMessage.frame = CGRectMake(newStruct.x, 27, newStruct.width, 15);
    }
}



@end
