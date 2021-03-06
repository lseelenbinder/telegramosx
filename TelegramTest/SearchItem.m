//
//  SearchItem.m
//  Telegram P-Edition
//
//  Created by Dmitry Kondratyev on 1/2/14.
//  Copyright (c) 2014 keepcoder. All rights reserved.
//

#import "SearchItem.h"
#import "MessagesUtils.h"
#import "TMAttributedString.h"
#import "TGDateUtils.h"


#define SelectColorNormal NSColorFromRGB(0x57a4e2)
#define SelectColorSelected NSColorFromRGB(0x000000)

@implementation SearchItem

- (void)initialize {
    self.title = [[NSMutableAttributedString alloc] init];
    [self.title setSelectionColor:NSColorFromRGB(0xffffff) forColor:DARK_BLACK];
    [self.title setSelectionColor:NSColorFromRGB(0xfffffe) forColor:LINK_COLOR];
    [self.title setSelectionColor:NSColorFromRGB(0xfffffa) forColor:BLUE_UI_COLOR];

    
    self.status = [[NSMutableAttributedString alloc] init];
    [self.status setSelectionColor:NSColorFromRGB(0xffffff) forColor:BLUE_UI_COLOR];
    [self.status setSelectionColor:NSColorFromRGB(0xfffffd) forColor:NSColorFromRGB(0x333333)];
    [self.status setSelectionColor:NSColorFromRGB(0xfffffe) forColor:NSColorFromRGB(0x9b9b9b)];
}

- (id)initWithUserItem:(TGUser*)user searchString:(NSString*)searchString {
    self = [super init];
    if(self) {
        [self initialize];
        
        self.type = SearchItemUser;
        self.dialog = [[DialogsManager sharedManager] findByUserId:user.n_id];
        if(!self.dialog) {
            self.dialog = [[DialogsManager sharedManager] createDialogForUser:user];
        }
        
        self.user = [[UsersManager sharedManager] find:user.n_id];
        
        [self.title appendString:user.fullName withColor:DARK_BLACK];
        [NSMutableAttributedString selectText:searchString fromAttributedString:(NSMutableAttributedString *)self.title selectionColor:BLUE_UI_COLOR];
    
    }
    return self;
}

- (id)initWithChatItem:(TGChat *)chat searchString:(NSString *)searchString {
    self = [super init];
    if(self) {
        [self initialize];

        self.type = SearchItemChat;
        self.chat = [[ChatsManager sharedManager] find:chat.n_id];
        self.dialog = [[DialogsManager sharedManager] findByChatId:chat.n_id];
   
        if(!self.dialog) {
            self.dialog = [[DialogsManager sharedManager] createDialogForChat:chat];
        }
        
        [self.title appendString:chat.title withColor:DARK_BLACK];
        [NSMutableAttributedString selectText:searchString fromAttributedString:(NSMutableAttributedString *)self.title selectionColor:BLUE_UI_COLOR];
        
    }
    return self;
}

- (id)initWithDialogItem:(TL_conversation *)dialog searchString:(NSString*)searchString {
    self = [super init];
    if(self) {
        [self initialize];
        
        self.type = SearchItemChat;
        
        self.dialog = dialog;
        
        
        
        self.user = self.dialog.user;
        
        [self.title appendString:dialog.user.fullName withColor:DARK_BLACK];
        
        [NSMutableAttributedString selectText:searchString fromAttributedString:(NSMutableAttributedString*)self.title selectionColor:BLUE_UI_COLOR];
        
    }
    return self;
}

- (id)initWithMessageItem:(TGMessage *)message searchString:(NSString *)searchString {
    self = [super init];
    if(self) {
        [self initialize];

        self.type = SearchItemMessage;
        self.message = message;
        
        self.dialog = message.dialog;
        
        
        
        
        self.user = [[UsersManager sharedManager] find:self.message.from_id == [UsersManager currentUserId] ? self.message.to_id.user_id : self.message.from_id];
        
        if(self.dialog.type == DialogTypeSecretChat) {
            self.user =  self.dialog.encryptedChat.peerUser;
        }

        if(self.dialog.type == DialogTypeChat) {
            self.chat = self.dialog.chat;
            [self.title appendString:self.chat.title withColor:DARK_BLACK];
        } else {
            [self.title appendString:self.user.fullName withColor:DARK_BLACK];
        }
        
        
        [self.status appendString:message.message withColor:NSColorFromRGB(0x9b9b9b)];
        
        NSRange range = [NSMutableAttributedString selectText:searchString fromAttributedString:(NSMutableAttributedString *)self.status selectionColor:BLUE_UI_COLOR];
        
        
        if(range.location > 8 && range.location != NSNotFound) {
            NSString *string = [[[self.status mutableString] substringFromIndex:range.location - 8] substringToIndex:8];
            NSRange searchRange = [string rangeOfString:@" "];
            
            int offset = 0;
            if(searchRange.location != NSNotFound) {
                offset = (int)searchRange.location;
            }
            
            [[self.status mutableString] replaceCharactersInRange:NSMakeRange(0, range.location - 8 + offset) withString:@"..."];
        }
        
        if(self.dialog.type == DialogTypeChat || self.user.n_id != self.message.from_id) {
            
            TGUser *user = [[UsersManager sharedManager] find:self.message.from_id];
            
            NSString *name = user.n_id == [UsersManager currentUserId] ? NSLocalizedString(@"Profile.You", nil) : user.dialogFullName;
            
            NSString *string = [NSString stringWithFormat:@"%@: ", name];
            [[self.status mutableString] insertString:string atIndex:0];
            [self.status addAttribute:NSForegroundColorAttributeName value:NSColorFromRGB(0x333333) range:NSMakeRange(0, string.length)];
        }
        
        //generate date
        self.dateSize = NSZeroSize;
        self.date = [[NSMutableAttributedString alloc] init];
        [self.date setSelectionColor:NSColorFromRGB(0xcbe1f0) forColor:NSColorFromRGB(0xaeaeae)];
        [self.date setSelectionColor:NSColorFromRGB(0xcbe1f1) forColor:NSColorFromRGB(0x333333)];
        [self.date setSelectionColor:NSColorFromRGB(0xcbe1f2) forColor:DARK_BLUE];
        

            NSString *dateStr = [TGDateUtils stringForMessageListDate:message.date];
            [self.date appendString:dateStr withColor:NSColorFromRGB(0xaeaeae)];
      
        
        
    }
    return self;
}

- (NSObject *)itemForHash {
    return self;
}

+ (NSUInteger)hash:(SearchItem *)item {
    NSString *hashStr;
    
    NSObject *object = item.dialog;
    
//    if(object == nil) {
//        DLog(@"log");
//    }
    
    if(item.type == SearchItemMessage) {
        hashStr = [NSString stringWithFormat:@"message_%d", item.message.n_id];
    } else {
        if([object isKindOfClass:[TL_conversation class]]) {
            hashStr = [Notification notificationNameByDialog:(TL_conversation *)object action:@"hash"];
        } else if([object isKindOfClass:[TGUser class]]) {
            hashStr = [NSString stringWithFormat:@"user_%d", ((TGUser *)object).n_id];
        } else if([object isKindOfClass:[TGChat class]]) {
            hashStr = [NSString stringWithFormat:@"chat_%d", ((TGChat *)object).n_id];
        }
    }
 
//    DLog(@"hashStr %@", hashStr);

    return [hashStr hash];
}

@end
