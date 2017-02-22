//
//  MGMAdinline.m
//  Adinline
//
//  Created by Mr. Gecko on 2/4/11.
//  Copyright (c) 2011 Mr. Gecko's Media (James Coleman). All rights reserved. http://mrgeckosmedia.com/
//

#import "MGMAdinline.h"
#import <WebKit/Webkit.h>

NSString * const MGMAIAllowStrangers = @"MGMAIAllowStrangers";


@implementation MGMAdinline
+ (id<AIAdium>)adium {
	return adium;
}

- (void)installPlugin {
	allowsStrangers = [[NSUserDefaults standardUserDefaults] boolForKey:MGMAIAllowStrangers];
	[[adium contentController] registerHTMLContentFilter:self direction:AIFilterIncoming];
	[[adium contentController] registerHTMLContentFilter:self direction:AIFilterOutgoing];
}
- (void)uninstallPlugin {
	[[adium contentController] unregisterHTMLContentFilter:self];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)filterHTMLString:(NSString *)theHTMLString content:(AIContentObject *)theContent {
	AIListObject *source = [theContent source];
	if (allowsStrangers || ![source isStranger]) {
		NSMutableString *html = [[[theHTMLString stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"] mutableCopy] autorelease];
		NSRange range = NSMakeRange(0, [html length]);
		while (range.length>1) {
			NSAutoreleasePool *pool = [NSAutoreleasePool new];
			NSRange linkRange = [html rangeOfString:@"<a " options:NSCaseInsensitiveSearch range:range];
			if (linkRange.location!=NSNotFound) {
				range.location = linkRange.location+linkRange.length;
				range.length = [html length]-range.location;
				NSRange linkStartRange = [html rangeOfString:@">" options:NSCaseInsensitiveSearch range:range];
				if (linkStartRange.location==NSNotFound)
					continue;
				range.location = linkStartRange.location+linkStartRange.length;
				range.length = [html length]-range.location;
				NSRange linkReplaceEndRange = [html rangeOfString:@"<" options:NSCaseInsensitiveSearch range:range];
				NSRange linkEndRange = [html rangeOfString:@"</a" options:NSCaseInsensitiveSearch range:range];
				if (linkEndRange.location==NSNotFound)
					continue;
				range.location = linkEndRange.location+linkEndRange.length;
				range.length = [html length]-range.location;
				NSMutableString *link = [[html substringWithRange:NSMakeRange(linkStartRange.location+linkStartRange.length, linkEndRange.location-(linkStartRange.location+linkStartRange.length))] mutableCopy];
				NSRange tagRange = NSMakeRange(0, [link length]);
				while (YES) {
					NSRange tagStartRange = [link rangeOfString:@"<" options:NSCaseInsensitiveSearch range:tagRange];
					if (tagStartRange.location==NSNotFound)
						break;
					tagRange.location = tagStartRange.location;
					tagRange.length = [link length]-tagRange.location;
					NSRange tagEndRange = [link rangeOfString:@">" options:NSCaseInsensitiveSearch range:tagRange];
					if (tagEndRange.location==NSNotFound)
						break;
					[link replaceCharactersInRange:NSMakeRange(tagStartRange.location, (tagEndRange.location+tagEndRange.length)-tagStartRange.location) withString:@""];
					tagRange.location = tagStartRange.location;
					tagRange.length = [link length]-tagRange.location;
				}
                
                NSRange replaceRange = NSMakeRange(linkStartRange.location+linkStartRange.length, linkReplaceEndRange.location-(linkStartRange.location+linkStartRange.length));
				if ([[NSArray arrayWithObjects:@"/servicedesk/issue-type-icons", @"/secure/viewavatar", @"/images/icons/priorities/minor.svg", nil]
                     containsObject:[[[NSURL URLWithString:link] path] lowercaseString]]) {
					NSString *image = [NSString stringWithFormat:@"<img src=\"%@\" alt=\"%@\" style=\"width: 16px; max-width: 16px; max-height: 16px;\" onLoad=\"alignChat(nearBottom());\" onclick=\"(function(that) { var link = document.createTextNode(that.alt); var clickLink = function(e) { window.event.cancelBubble = true; that.hidden = false; e.target.removeChild(link); return false; }; window.event.cancelBubble = true; that.parentElement.onclick = clickLink; that.parentElement.appendChild(link); that.hidden = true; return false; })(this); return false;\" />", link, link];
					[html replaceCharactersInRange:replaceRange withString:image];
					range.location += [image length]-replaceRange.length;
					range.length = [html length]-range.location;
				} else if ([[NSArray arrayWithObjects:@"png", @"jpg", @"jpeg", @"tif", @"tiff", @"gif", @"bmp", nil]
                        containsObject:[[[[NSURL URLWithString:link] path] pathExtension] lowercaseString]]) {
					NSString *image = [NSString stringWithFormat:@"<img src=\"%@\" alt=\"%@\" style=\"max-width: 100%%; max-height: 100%%;\" onLoad=\"alignChat(nearBottom());\" onclick=\"(function(that) { var link = document.createTextNode(that.alt); var clickLink = function(e) { window.event.cancelBubble = true; that.hidden = false; e.target.removeChild(link); return false; }; window.event.cancelBubble = true; that.parentElement.onclick = clickLink; that.parentElement.appendChild(link); that.hidden = true; return false; })(this); return false;\" />", link, link];
					[html replaceCharactersInRange:replaceRange withString:image];
					range.location += [image length]-replaceRange.length;
					range.length = [html length]-range.location;
				}
            
				[link release];
			} else {
				break;
			}
			[pool drain];
		}
		return html;
	}
	return theHTMLString;
}
- (CGFloat)filterPriority {
	return (CGFloat)LOWEST_FILTER_PRIORITY;
}
@end