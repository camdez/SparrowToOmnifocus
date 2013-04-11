//
//  DropView.m
//  SparrowToOmnifocus
//
//  Created by Cameron Desautels on 7/23/11.
//  Copyright 2011 Too Much Tea, LLC. All rights reserved.
//

#import "DropView.h"

@implementation DropView

- (id)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self registerForDraggedTypes:[NSArray arrayWithObject:@"public.url"]];
    }

    return self;
}

- (void)createOmnifocusTaskWithName:(NSString*)name andNote:(NSString*)note {
    name = (name ? [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] : @"");
    note = (note ? [note stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] : @"");

    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"omnifocus:///add?name=%@&note=%@", name, note]]];
}

#pragma mark - NSDraggingDestination

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    return NSDragOperationLink;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSPasteboard*  pasteboard  = [NSPasteboard generalPasteboard];
    NSString* str = [pasteboard  stringForType:NSPasteboardTypeString];
    if (str == nil) str = @"";
    
    for (NSPasteboardItem* item in [[sender draggingPasteboard] pasteboardItems]) {
        if ([item stringForType:@"public.url-name"]) {
        
            NSString *note = [NSString stringWithFormat:@"%@\n\n%@", [item stringForType:@"public.url"], str];
            [self createOmnifocusTaskWithName:[item stringForType:@"public.url-name"]
                                  andNote:note];
        }
    }
    
    return YES;
}

@end
