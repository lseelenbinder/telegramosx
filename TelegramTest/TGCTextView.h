//
//  TGCTextView.h
//  Telegram
//
//  Created by keepcoder on 01.10.14.
//  Copyright (c) 2014 keepcoder. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TGCTextMark.h"


@interface TGCTextView : NSView  {
    CTFrameRef CTFrame;
    
    
    @public
    NSPoint startSelectPosition;
    NSPoint currentSelectPosition;
    
}

@property (nonatomic,strong) NSAttributedString *attributedString;
//@property (nonatomic,assign) NSRange selectionRange;
@property (nonatomic,assign,setter=setEditable:) BOOL isEditable;

@property (nonatomic,assign,readonly) NSRange selectRange;


@property (nonatomic,strong) NSColor *selectColor;
@property (nonatomic,strong) NSColor *backgroundColor;



-(void)setSelectionRange:(NSRange)selectionRange;

-(void)addMark:(TGCTextMark *)mark;
-(void)addMarks:(NSArray *)marks;

-(int)currentIndexInLocation:(NSPoint)location;
-(BOOL)indexIsSelected:(int)index;

// its private not for use
-(BOOL)_checkClickCount:(NSEvent *)theEvent;

@end
