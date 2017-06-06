//
//  CCWallCustomizerBridgingHeader.h
//
//
//  Created by iKilledAppl3 on 2/11/17.
//
//

#import <UIKit/UIKit.h>

@interface CCUIControlCenterPageContainerViewController : UIViewController {
    UIImageView* _whiteLayerView;
    UIView * _contentView;
    
}
@property (nonatomic,retain) UIView *viewCC;
@property (nonatomic,retain) UIView *contentView;
@property (nonatomic,retain) UIImageView *customCCImageOverlay;
@property (nonatomic,retain) UIImageView *_whiteLayerView;
@end



