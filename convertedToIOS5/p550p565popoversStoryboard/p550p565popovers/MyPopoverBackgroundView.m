
#import "MyPopoverBackgroundView.h"

// inherits:
// @property (nonatomic, readwrite) UIPopoverArrowDirection arrowDirection
// @property (nonatomic, readwrite) CGFloat arrowOffset

@implementation MyPopoverBackgroundView {
    CGFloat arrOff;
    UIPopoverArrowDirection arrDir;
}
@dynamic arrowDirection, arrowOffset;

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
    }
    return self;
}

#define ARBASE 20
#define ARHEIGHT 20

// dude, where's my shadow???? documentation claims I'll be given one, but it isn't happening
// looks like a bug to me...

- (void)drawRect:(CGRect)rect
{

    // WARNING: this code is sort of a cheat:
    // I should be checking self.arrowDirection and changing what I do depending on that...
    // but instead I am just *assuming* that the arrowDirection is UIPopoverArrowDirectionUp
    
    UIImage* linOrig = [UIImage imageNamed: @"linen.png"];
    CGFloat capw = linOrig.size.width / 2.0 - 1;
    CGFloat caph = linOrig.size.height / 2.0 - 1;
    UIImage* lin = [linOrig resizableImageWithCapInsets:UIEdgeInsetsMake(caph, capw, caph, capw)];
    
    // draw the arrow
    // I'm just going to make a triangle filled with our linen background...
    // ...extended by a rectangle so it joins to our "pinked" corner drawing
    CGContextRef con = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(con);
    CGContextTranslateCTM(con, self.arrowOffset - ARBASE + rect.size.width/2.0, 0);
    CGContextMoveToPoint(con, 0, ARHEIGHT);
    CGContextAddLineToPoint(con, ARBASE / 2.0, 0);
    CGContextAddLineToPoint(con, ARBASE, ARHEIGHT);
    CGContextClosePath(con);
    CGContextAddRect(con, CGRectMake(0,ARHEIGHT,ARBASE,15));
    CGContextClip(con);
    [lin drawAtPoint:CGPointMake(-40,-40)];
    CGContextRestoreGState(con);
    
    // draw the background, to go behind the view part of our rectangle (i.e. rect minus arrow)
    CGRect trash;
    CGRect real;
    CGRectDivide(rect, &trash, &real, ARHEIGHT, CGRectMinYEdge);
    [lin drawInRect:real];
    
}

+(UIEdgeInsets)contentViewInsets {
    return UIEdgeInsetsMake(20,20,20,20); // nice border given our linen edge
}

// we are required to implement all this even though it's obvious what it needs to do

+(CGFloat)arrowBase {
    return ARBASE;
}

+(CGFloat)arrowHeight {
    return ARHEIGHT;
}

- (UIPopoverArrowDirection) arrowDirection {
    return self->arrDir;
}

- (CGFloat) arrowOffset {
    return self->arrOff;
}

- (void) setArrowDirection: (UIPopoverArrowDirection) val {
    self->arrDir = val;
    [self setNeedsLayout];
}

- (void) setArrowOffset: (CGFloat) val {
    self->arrOff = val;
    [self setNeedsLayout];
}



@end