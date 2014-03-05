//
//  FRMP3Info.m
//  FileRenamer
//
//  Created by Yuliya Grasevych on 27.02.14.
//  Copyright (c) 2014 Yuliya Grasevych. All rights reserved.
//

#import "FRMP3Info.h"
#import "NSArray+Metadata.h"
#import <AVFoundation/AVFoundation.h>

@implementation FRMP3Info

-(id)initWithURLPath:(NSURL *)fileURL
{
    self = [self init];
    if (self) {
        AVAsset *fileAsset = [AVAsset assetWithURL:fileURL];
        NSArray *fileData = [fileAsset metadataForFormat:AVMetadataFormatID3Metadata];
        
        _artist = [fileData metadataValueForKey:AVMetadataID3MetadataKeyLeadPerformer];
        _title = [fileData metadataValueForKey:AVMetadataID3MetadataKeyTitleDescription];
        _album = [fileData metadataValueForKey:AVMetadataID3MetadataKeyAlbumTitle];
        _track = [fileData metadataValueForKey:AVMetadataID3MetadataKeyTrackNumber];
        _year = [fileData metadataValueForKey:AVMetadataID3MetadataKeyYear];
        
    }
    return self;
}

-(NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"Artist = %@; title = %@; album = %@; track = %@; year = %@", self.artist, self.title, self.album, self.track, self.year];
    return desc;
}

@end
