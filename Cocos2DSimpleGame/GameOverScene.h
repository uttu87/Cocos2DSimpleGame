//
//  GameOverScene.h
//  Cocos2DSimpleGame
//
//  Created by Pham Van Hai on 4/11/13.
//  Copyright (c) 2013 Pham Van Hai. All rights reserved.
//

#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor{
    CCLabelTTF *_label;
}
@property (nonatomic, retain) CCLabelTTF *label;
@end

@interface GameOverScene : CCScene{
    GameOverLayer *_layer;
}
@property (nonatomic, retain) GameOverLayer *layer;

@end