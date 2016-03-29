//
//  ViewController.h
//  歌词
//
//  Created by myApple on 16/3/15.
//  Copyright © 2016年 myApple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ViewController : UIViewController<UITableViewDataSource>

@property (nonatomic,strong) AVAudioPlayer *player;
@end

