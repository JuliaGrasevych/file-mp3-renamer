//
//  FRFileObject.m
//  FileRenamer
//
//  Created by Yuliya Grasevych on 27.02.14.
//  Copyright (c) 2014 Yuliya Grasevych. All rights reserved.
//

#import "FRFileObject.h"
#import "FRMP3Info.h"

@implementation FRFileObject

+(id)fileWithURL:(NSURL *)url
{
    FRFileObject *file = [[FRFileObject alloc] init];
    if (file) {
        
        file.fileURL = url;
        [file updateFileInfo];
        file.state = FRFileObjectNew;
        
    }
    return file;
}

-(void)renamingPreviewWithFormat:(NSString *)format
{
    NSString *newFilename = [self filenameWithFormat:format];
    self.previewFilename = newFilename;
    self.state = FRFileObjectPreviewed;
}

-(BOOL)renameWithError:(NSError * __autoreleasing *) error
{
    BOOL result = YES;
    if (!self.previewFilename) {
        result = NO;
        *error = [NSError errorWithDomain:@"Desired filename is not set" code:10 userInfo:nil];
    }
    NSString *newFilename = [self.previewFilename
                             stringByAppendingPathExtension:self.fileExtension];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *newFileURL = [[self.fileURL URLByDeletingLastPathComponent]
                         URLByAppendingPathComponent:newFilename];
    
    result = [fileManager moveItemAtURL:self.fileURL toURL:newFileURL error:error];
    if (result) {
        self.fileURL = newFileURL;
        self.state = FRFileObjectRenamed;
        [self updateFileInfo];
    }
    return result;
}

-(void)updateFileInfo
{
    self.filename = [[self.fileURL lastPathComponent] stringByDeletingPathExtension];
    self.fileExtension = [[self.fileURL lastPathComponent]pathExtension];
    self.fileMp3Info = [[FRMP3Info alloc] initWithURLPath:self.fileURL];
}

#pragma mark - Private

-(NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"Filename = %@; fileExtension = %@;\n %@", self.filename, self.fileExtension, self.fileMp3Info];
    return desc;
}

-(NSString *)filenameWithFormat:(NSString *)format
{
    __block NSMutableString *newFilename = [NSMutableString stringWithString:format];
    __block NSInteger nextLocationAdd = 0;
    NSError *regExpError = nil;
    
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:@"<(\\w+)>" options:NSRegularExpressionCaseInsensitive error:&regExpError];
    
    [regExp enumerateMatchesInString:format options:NSMatchingReportCompletion range:NSMakeRange(0, format.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (result) {
            
            
            NSString *mp3Pattern = [format substringWithRange:result.range];
            NSString *mp3InfoString = nil;
            if ([mp3Pattern isEqualToString:kFRTagFormatKeyAlbum]) {
                mp3InfoString = self.fileMp3Info.album;
            }
            else if ([mp3Pattern isEqualToString:kFRTagFormatKeyArtist]) {
                mp3InfoString = self.fileMp3Info.artist;
            }
            else if ([mp3Pattern isEqualToString:kFRTagFormatKeyTitle]) {
                mp3InfoString = self.fileMp3Info.title;
            }
            else if ([mp3Pattern isEqualToString:kFRTagFormatKeyTrack]) {
                mp3InfoString = self.fileMp3Info.track;
            }
            else if ([mp3Pattern isEqualToString:kFRTagFormatKeyYear]) {
                mp3InfoString = self.fileMp3Info.year;
            }
            NSRange correctedRange = NSMakeRange(result.range.location+nextLocationAdd, result.range.length);
            [newFilename replaceCharactersInRange:correctedRange withString:mp3InfoString];
            nextLocationAdd += mp3InfoString.length-result.range.length;
        }
    }];
    
    return newFilename;
}


@end
