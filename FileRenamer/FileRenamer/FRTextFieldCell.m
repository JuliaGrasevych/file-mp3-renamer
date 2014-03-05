//
//  FRTextFieldCell.m
//  FileRenamer
//
//  Created by Yuliya Grasevych on 05.03.14.
//  Copyright (c) 2014 Yuliya Grasevych. All rights reserved.
//

#import "FRTextFieldCell.h"
#import "FRTextView.h"
#import <objc/objc-runtime.h>

static NSString const* kFieldEditorKey = @"kFieldEditorKey";

@implementation FRTextFieldCell

-(NSTextView *)fieldEditorForView:(NSView *)aControlView
{
    FRTextView *frFieldEditor = objc_getAssociatedObject(aControlView.window, (__bridge const void *)(kFieldEditorKey));
    
    if (!frFieldEditor) {
        
        frFieldEditor = [FRTextView new];
        [frFieldEditor setFieldEditor:YES];
        objc_setAssociatedObject(aControlView.window, (__bridge const void *)(kFieldEditorKey), frFieldEditor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return frFieldEditor;
}


@end
