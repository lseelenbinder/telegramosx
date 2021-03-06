//
//  MessageTableItemContact.m
//  Telegram P-Edition
//
//  Created by Dmitry Kondratyev on 2/14/14.
//  Copyright (c) 2014 keepcoder. All rights reserved.
//

#import "MessageTableItemContact.h"
#import "NSString+Extended.h"
#import "ImageUtils.h"
#import "RMPhoneFormat.h"
#import "NS(Attributed)String+Geometrics.h"

@implementation MessageTableItemContact

- (id) initWithObject:(TGMessage *)object  {
    self = [super initWithObject:object];
    if(self) {
        
        TL_messageMediaContact *contact = (TL_messageMediaContact * )object.media;
        
        NSString *fullName = [[[[NSString stringWithFormat:@"%@ %@", contact.first_name, contact.last_name] trim] htmlentities] singleLine];
        
        self.firstName = contact.first_name;
        self.lastName = contact.last_name;
        
        if(contact.user_id) {
            self.contactUser = [[UsersManager sharedManager] find:contact.user_id];

        }

        self.contactName = fullName;

        if(self.contactUser) {
            self.user_id = contact.user_id;
        } else {
            self.contactText =  [NSString stringWithFormat:@"%C%C", (unichar)(self.firstName.length ? [self.firstName characterAtIndex:0] : 0), (unichar)(self.lastName.length ? [self.lastName characterAtIndex:0] : 0)];
        }
        
        NSString *phoneNumber = contact.phone_number.length ? [RMPhoneFormat formatPhoneNumber:contact.phone_number] : NSLocalizedString(@"User.Hidden", nil);
     
        self.contactNumberString = phoneNumber;
        self.contactNumber = [[NSAttributedString alloc] initWithString:phoneNumber attributes:@{NSFontAttributeName: [NSFont fontWithName:@"Helvetica" size:12]}];
        
        self.contactNumberSize = [self.contactNumber sizeForWidth:FLT_MAX height:FLT_MAX];
        
        self.blockSize = NSMakeSize(300, 36);
    }
    return self;
}

-(NSString *)contactName {
    if(self->_contactName == nil)
        return @"";
    return _contactName;
}

@end
