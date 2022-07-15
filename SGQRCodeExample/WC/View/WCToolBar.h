//
//  WCToolBar.h
//  SGQRCodeExample
//
//  Created by kingsic on 2022/7/9.
//  Copyright © 2022 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCToolBar : UIView
- (void)addQRCodeTarget:(id)aTarget action:(SEL)aAction;
- (void)addAlbumTarget:(id)aTarget action:(SEL)aAction;

- (void)showTorch;
- (void)dismissTorch;
@end

NS_ASSUME_NONNULL_END
