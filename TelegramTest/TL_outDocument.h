//
//  TL_outDocument.h
//  Messenger for Telegram
//
//  Created by keepcoder on 09.04.14.
//  Copyright (c) 2014 keepcoder. All rights reserved.
//

#import "TLRPC.h"

@interface TL_outDocument : TL_document

@property (nonatomic,strong) NSString *file_path;

+(TL_outDocument *)createWithN_id:(long)n_id access_hash:(long)access_hash user_id:(int)user_id date:(int)date file_name:(NSString *)file_name mime_type:(NSString *)mime_type size:(int)size thumb:(TGPhotoSize *)thumb dc_id:(int)dc_id file_path:(NSString *)file_path;
+(TL_outDocument *)outWithDocument:(TL_document *)document file_path:(NSString *)file_path;
@end
