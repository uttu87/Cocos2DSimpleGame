//
//  HelloWorldLayer.h
//  Cocos2DSimpleGame
//
//  Created by Pham Van Hai on 4/10/13.
//  Copyright Pham Van Hai 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor
{
    NSMutableArray *_targets;
    NSMutableArray *_projectiles;
    CCSprite       *_player;
    
    int _projectilesDestroyed;
}




// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
