//
//  MainViewController.m
//  FileRenamer
//
//  Created by Yuliya Grasevych on 27.02.14.
//  Copyright (c) 2014 Yuliya Grasevych. All rights reserved.
//

#import "MainViewController.h"
#import "FRFileObject.h"

static NSString * const kMP3FileExtension = @"mp3";

@interface MainViewController () <NSTextFieldDelegate>
@property (strong) IBOutlet NSArrayController *fileArrayController;
- (IBAction)addFile:(id)sender;
- (IBAction)previewFilename:(id)sender;
@property (weak) IBOutlet NSTextField *formatTextField;
@property (nonatomic) NSString *filenameFormat;
- (IBAction)formatItemAction:(NSButton *)sender;
- (IBAction)renameFiles:(NSButton *)sender;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (NSMutableArray *)filesArray
{
    if (!_filesArray) {
        _filesArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _filesArray;
}

-(NSArray *)selectedFiles
{
    return self.fileArrayController.selectedObjects;
}

-(NSArray *)fetchFilesAtURL:(NSURL *)url
{
    __block NSMutableArray *filesArray = [NSMutableArray arrayWithCapacity:1];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *fileError = nil;
    BOOL isDir = NO;
    BOOL fileExist = [fileManager fileExistsAtPath:url.relativePath isDirectory:&isDir];
    
    if (!fileExist) {
        return nil;
    }
    if (isDir) {
        NSArray *files = [fileManager contentsOfDirectoryAtURL:url includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&fileError];
        if (fileError) {
            
            return nil;
        }
        else
        {
            [files enumerateObjectsUsingBlock:^(NSURL *innerUrl, NSUInteger idx, BOOL *stop) {
                
                NSArray *innerFiles = [self fetchFilesAtURL:innerUrl];
                [filesArray addObjectsFromArray:innerFiles];
            }];
        }
    }
    
    else
    {
        if ([url.absoluteString.pathExtension isEqualToString:kMP3FileExtension]) {
            
            FRFileObject *file = [FRFileObject fileWithURL:url];
            [filesArray addObject:file];
        }
        else
        {
            return nil;
        }
    }
    
    return [NSArray arrayWithArray:filesArray];
}

- (IBAction)addFile:(id)sender {
    NSOpenPanel *filePicker = [NSOpenPanel openPanel];
    filePicker.canChooseFiles = YES;
    filePicker.canChooseDirectories = YES;
    filePicker.allowsMultipleSelection = YES;
    [filePicker setAllowedFileTypes:@[kMP3FileExtension]];
    if ([filePicker runModal] == NSFileHandlingPanelOKButton)
    {
        NSArray *urls = filePicker.URLs;
        [urls enumerateObjectsUsingBlock:^(NSURL *url, NSUInteger idx, BOOL *stop) {
            NSArray *fetchedFiles = [self fetchFilesAtURL:url];
            [self.fileArrayController addObjects:fetchedFiles];
        }];
    }

}

- (IBAction)previewFilename:(id)sender {
    NSString *previewFormat = self.formatTextField.stringValue;
    [[self selectedFiles] enumerateObjectsUsingBlock:^(FRFileObject *file, NSUInteger idx, BOOL *stop) {
        [file renamingPreviewWithFormat:previewFormat];
    }];
}
- (IBAction)formatItemAction:(NSButton *)sender {
    NSInteger itemTag = sender.tag;
    NSString *formatItemString = @"";
    switch (itemTag) {
        case 100:
            formatItemString = kFRTagFormatKeyArtist;
            break;
        case 101:
            formatItemString = kFRTagFormatKeyTitle;
            break;
        case 102:
            formatItemString = kFRTagFormatKeyAlbum;
            break;
        case 103:
            formatItemString = kFRTagFormatKeyTrack;
            break;
        case 104:
            formatItemString = kFRTagFormatKeyYear;
            break;
        default:
            break;
    }
    NSMutableString *formatString = [NSMutableString stringWithString: self.formatTextField.stringValue];
    NSText *currentTextEditor = [self.formatTextField currentEditor];
    if (currentTextEditor) {
        NSRange textRange = [currentTextEditor selectedRange];
        if (textRange.location != NSNotFound) {
            [formatString replaceCharactersInRange:textRange withString:formatItemString];
            NSRange newTextRange = NSMakeRange(textRange.location-textRange.length+formatItemString.length, 0);
            [currentTextEditor setSelectedRange:newTextRange];
        }
    }
    else {
        [formatString appendString:formatItemString];
    }
    
    self.filenameFormat = [NSString stringWithString:formatString];
}

- (IBAction)renameFiles:(NSButton *)sender {
    
    NSString *previewFormat = self.formatTextField.stringValue;
    __block NSError *renameError = nil;
    [[self selectedFiles] enumerateObjectsUsingBlock:^(FRFileObject *file, NSUInteger idx, BOOL *stop) {
        if (file.state != FRFileObjectPreviewed) {
            [file renamingPreviewWithFormat:previewFormat];
        }
        [file renameWithError:&renameError];
        if (renameError) {
            *stop = YES;
        }
    }];
    if (renameError) {
        NSAlert *alert = [NSAlert alertWithError:renameError];
        [alert runModal];
    }
}

#pragma mark - Text Field Delegate
-(BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor
{
    return NO;
}
@end
