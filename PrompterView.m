//
//  PrompterView.m
//  GreatTeleprompter
//
//  Created by Scott Means on 6/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PrompterView.h"


@implementation PrompterView

@synthesize theSpeech, paused;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    return self;
}

- (void)awakeFromNib
{
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef c = UIGraphicsGetCurrentContext();
	CGContextSetRGBFillColor(c, 1.0, 1.0, 1.0, 1.0);
	
	CGRect rc = CGRectMake(rect.origin.x, rect.origin.y - (speechOffset * (baseWidth/self.bounds.size.width)), rect.size.width, rect.size.height + speechOffset);
	
	[theSpeech drawInRect:rc withFont:[UIFont systemFontOfSize:36.0]];
}

- (void)setTheSpeech:(NSString *)newSpeech
{
	[theSpeech release];
	theSpeech = [newSpeech retain];
	
	tickTimer = [NSTimer scheduledTimerWithTimeInterval:TICK_INTERVAL target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
	
	speechOffset = 0.0;
	baseWidth = self.bounds.size.width;
	
	[self setNeedsDisplay];
}

- (void)layoutSubviews
{
	[self setNeedsDisplay];
}

- (void)timerTick:(NSTimer*)theTimer
{
	if (!paused) {
		speechOffset += 1.0;
		[self setNeedsDisplay];
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	
	UITouch *t = [touches anyObject];
	
	lastTouchPos = [t locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *t = [touches anyObject];
	
	CGPoint newTouchPos = [t locationInView:self];
	
	speechOffset += newTouchPos.y - lastTouchPos.y;
	
	lastTouchPos = newTouchPos;
	
	[self setNeedsLayout];
}

- (void)dealloc {
    [super dealloc];
}


@end
