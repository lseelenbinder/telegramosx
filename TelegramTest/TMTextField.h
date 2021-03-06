//
//  TMTextField.h
//  Telegram P-Edition
//
//  Created by Dmitry Kondratyev on 2/12/14.
//  Copyright (c) 2014 keepcoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceholderTextView : TMView
//@property (nonatomic) BOOL isDraw;
@property (nonatomic, strong) NSAttributedString *placeholderAttributedString;
@property (nonatomic) NSPoint placeholderPoint;
@end

@protocol TMTextFieldDelegate <NSObject>

-(void)textFieldDidChange:(id)field;

@end


@interface TMTextField : NSTextField

@property (nonatomic, strong) NSAttributedString *placeholderAttributedString;
@property (nonatomic) NSPoint placeholderPoint;

@property (nonatomic,assign) NSSize textOffset;

@property (nonatomic,assign) BOOL placeHolderOnSelf;

@property (nonatomic,strong) id <TMTextFieldDelegate> fieldDelegate;

+ (id)defaultTextField;
+ (id)loginPlaceholderTextField;
- (PlaceholderTextView *)placeholderView;
- (PlaceholderTextView *)placeholderView:(id)sender;

-(void)showEmoji;

@end
