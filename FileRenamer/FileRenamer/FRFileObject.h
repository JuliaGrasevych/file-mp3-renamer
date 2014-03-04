//
//  FRFileObject.h
//  FileRenamer
//
//  Created by Yuliya Grasevych on 27.02.14.
//  Copyright (c) 2014 Yuliya Grasevych. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FRMP3Info;

static NSString *const kFRTagFormatKeyTitle = @"<title>";
static NSString *const kFRTagFormatKeyArtist = @"<artist>";
static NSString *const kFRTagFormatKeyAlbum = @"<album>";
static NSString *const kFRTagFormatKeyTrack = @"<track>";
static NSString *const kFRTagFormatKeyYear = @"<year>";

typedef enum
{
    FRFileObjectNew = 0,
    FRFileObjectPreviewed,
    FRFileObjectRenamed
}FRFileObjectState;

@interface FRFileObject : NSObject

@property (nonatomic) NSString *filename;
@property (nonatomic) NSString *fileExtension;
@property (nonatomic) FRMP3Info *fileMp3Info;
@property (nonatomic) NSURL *fileURL;
@property (nonatomic) NSString *previewFilename;
@property (nonatomic) FRFileObjectState state;

+(id)fileWithURL:(NSURL *)url;
-(void)renamingPreviewWithFormat:(NSString *)format;
-(BOOL)renameWithError:(NSError __autoreleasing **)error;
-(void)updateFileInfo;
@end
