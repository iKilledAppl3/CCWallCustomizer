#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>

#define customImgPath @"/var/mobile/Documents/ccwall.png"
#define plist @"/var/mobile/Library/Preferences/com.ikilledappl3.ccwallcustomizer.plist"

static NSString *path = @"/var/mobile/Documents/ccwall.png";

static BOOL kEnabled;
static BOOL darkenWallEnabled;
static BOOL whiteGlyphs;
static int kButtonBorders;
static BOOL kLegacy;

@interface CCUIControlCenterPagePlatterView : UIView {
	UIImageView* _whiteLayerView;

}

@end

//CCWallCustomizer is a tweak for iOS 10+ that customizes the background of the control center.
//Created by iKilledAppl3 :P

%hook NCMaterialSettings

-(void)setCcWhiteOverlayAlpha:(CGFloat)arg1 {

if (darkenWallEnabled == YES && kEnabled == YES) {
		%orig(1.0f);

     }
	 else {
		 %orig;
		 
	 }
}

- (void)setCutOutOverlayAlpha:(CGFloat)arg1 {

         //Stock
	if (kButtonBorders == 0 && kEnabled == YES) {
		%orig;
		

     }
	 //Solid Black Method
	 else if (kButtonBorders == 1 && kEnabled == YES) {
		 %orig(1.0f);

	} 
	
	//Dark Method
	else if (kButtonBorders == 2  && kEnabled == YES) {
		%orig(0.6f);
	} 

    //No Borders
     else if (kButtonBorders == 3 && kEnabled == YES) {
       //call nothing to show empty borders 

	} 


//Tweak disabled  so we use Stock
     else {
    
    %orig;
}
	
 }
 
 - (void)setCutOutOverlayWhite:(CGFloat)arg1 {

        //Stock 
	if (kButtonBorders == 0  && kEnabled == YES) {
		%orig;

     }
	  //Solid Black Method
	 else if (kButtonBorders == 1 && kEnabled == YES) {
		 %orig(0);

	} 
	
	 //Dark Method
	else if (kButtonBorders == 2  && kEnabled == YES) {
		 %orig(0);

	 } 

  //No Borders
else if (kButtonBorders == 3  && kEnabled == YES) {

//call nothing to show empty borders 

	} 

   //Tweak disabled  so we use Stock
     else {
    
    %orig;
}
	

 }


%end
	
%hook MPAVRoutingTableViewCell

-(void)setIconStyle:(unsigned long long)arg1 {
	
	if (kButtonBorders == 1 && kEnabled == YES) {
		 %orig(1);

	 } 
	 
	 else if (kButtonBorders == 2 && kEnabled == YES) {
		 %orig(1);

	 } 
	 
	 else {
	
	%orig;	 
		 
	 }
}	 
-(void)setTintColor:(id)arg1 {

if (kButtonBorders == 1  && kEnabled == YES) {
	
	%orig([UIColor whiteColor]);
	 } 
	 
	 else if (kButtonBorders == 2  && kEnabled == YES) {
		%orig([UIColor whiteColor]);

	 } 
	 
	 else {
	
	%orig;	 
		 
}
	
}	 

 %end

//Thanks skittyblock!
%hook CCUIControlCenterVisualEffect

 -(id)initWithPrivateStyle:(long long)arg1 {
	if (whiteGlyphs == YES  && kEnabled == YES) {
		return %orig(1);

     }
     
     //Solid Black Method
	 else if (kButtonBorders == 1) {
		return %orig(1);

	} 
	 else {
		 return %orig;
		 
	 }
}
%end

%hook CCUIControlCenterPagePlatterView

-(void)layoutSubviews {
	if (kEnabled == YES && kLegacy == NO) {
	%orig;

UIImageView *imgView =  [self valueForKey:@"_whiteLayerView"];

UIImageView *imageView = [[UIImageView alloc] init];

imageView.image = [UIImage imageWithContentsOfFile:customImgPath];

 //fit to the view
imageView.contentMode = UIViewContentModeScaleAspectFill;
 //set the image bounds to the view
imageView.bounds = imgView.bounds;
 //set image frame to one in the view
imageView.frame = imgView.frame;
 //make the image clips to bounds
imageView.clipsToBounds = YES;
 //fix landscape bug 
imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

//add the image view as a sub view of the background view 
[imgView addSubview:imageView];

	}
   else if (kLegacy == YES && kEnabled == YES) {
                %orig;

UIImageView *imgView = [self valueForKey:@"_whiteLayerView"];

imgView.image = [UIImage imageWithContentsOfFile:customImgPath];

}
      
  else if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {

     %orig;

}
	
	else  {
		%orig;
		
	}
	
}
 
%end
	
	//Prefs new 
HBPreferences *preferences;
extern NSString *const HBPreferencesDidChangeNotification;

static void loadPrefs()
{	
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:plist];
    if(prefs)
    {	
		kButtonBorders = [[prefs objectForKey:@"kButtonBorders"] integerValue];
		
	 }
}

%ctor {
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.ikilledappl3.ccwallcustomizer"];

	[preferences registerBool:&darkenWallEnabled default:NO forKey:@"darkenWallEnabled"];

	[preferences registerBool:&kEnabled default:NO forKey:@"kEnabled"];

	[preferences registerBool:&whiteGlyphs default:NO forKey:@"whiteGlyphs"];
	
	[preferences registerBool:&kLegacy default:NO forKey:@"kLegacy"];
	
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.ikilledappl3.ccwallcustomizer-prefsreload"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	loadPrefs();
}