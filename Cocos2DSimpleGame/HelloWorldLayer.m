//
//  HelloWorldLayer.m
//  Cocos2DSimpleGame
//
//  Created by Pham Van Hai on 4/10/13.
//  Copyright Pham Van Hai 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "GameOverScene.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

//use sound
#import "SimpleAudioEngine.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
    
    _targets = [[NSMutableArray alloc] init];
    _projectiles = [[NSMutableArray alloc] init];
    
    if((self=[super initWithColor:ccc4(255, 255, 255, 255)]))
    {
        CGSize winSize = [[CCDirector sharedDirector]winSize];
        _player = [CCSprite spriteWithFile:@"cannon.jpeg"
                            rect:CGRectMake(0, 0, 87, 55)];
        
        _player.position = ccp(_player.contentSize.width/2, winSize.height/2);
        
        [self addChild:_player];
        
    }
    
   
    
    self.touchEnabled = YES;
    [self schedule:@selector(gameLogic:) interval:1.0];
    [self schedule:@selector(update:)];
    
    //init and play background sound
    //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf"];
    
    return self;
    
	//@hai.phamvan rem
    /*
    if( (self=[super init]) ) {
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
		
		
		
		//
		// Leaderboards and Achievements
		//
		
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
		// to avoid a retain-cycle with the menuitem and blocks
		__block id copy_self = self;
		
		// Achievement Menu Item using blocks
		CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
			
			
			GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
			achivementViewController.achievementDelegate = copy_self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:achivementViewController animated:YES];
			
			[achivementViewController release];
		}];
		
		// Leaderboard Menu Item using blocks
		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
			
			
			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
			leaderboardViewController.leaderboardDelegate = copy_self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
			
			[leaderboardViewController release];
		}];

		
		CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		[self addChild:menu];

	}
	return self;
     */
     //@hai.phamvan end
}

-(void)update:(ccTime)dt
{
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    
    for (CCSprite *projectile in _projectiles)
    {
        CGRect projectileRect = CGRectMake(projectile.position.x - (projectile.contentSize.width/2),
                                           projectile.position.y - (projectile.contentSize.height/2),
                                           projectile.contentSize.width,
                                           projectile.contentSize.height);
        
        NSMutableArray *targetsToDelete = [[NSMutableArray alloc] init];
        for(CCSprite *target in _targets)
        {
            CGRect targetRect = CGRectMake(target.position.x - (target.contentSize.width/2),
                                           target.position.y - (target.contentSize.height/2),
                                           target.contentSize.width,
                                           target.contentSize.height);
            
            //check collision
            
            if(CGRectIntersectsRect(projectileRect, targetRect))
            {
                [targetsToDelete addObject:target];
            }
        }
        
        for(CCSprite *target in targetsToDelete)
        {
            [_targets removeObject:target];
            [self removeChild:target cleanup:YES];
            
            _projectilesDestroyed ++;
            
            if(_projectilesDestroyed > 10)
            {
                GameOverScene *gameOverScene = [GameOverScene node];
                _projectilesDestroyed = 0;
                
                [gameOverScene.layer.label setString:@"You Win!"];
                
                [[CCDirector sharedDirector] replaceScene:gameOverScene];
            }
        }
        
        if(targetsToDelete.count > 0)
        {
            [projectilesToDelete addObject:projectile];
        }
        
        [targetsToDelete release];
    }
    
    for(CCSprite *projectile in projectilesToDelete)
    {
        [_projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
    
[projectilesToDelete release];
}

-(void)gameLogic:(ccTime)dt
{
    [self addTarget];
}

//@hai.phamvan add function addTarget
- (void) addTarget
{
    CCSprite *target = [CCSprite spriteWithFile:@"Target.png"
                                               rect:CGRectMake(0, 0, 27, 40)];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int minY = target.contentSize.height/2;
    int maxY = winSize.height - target.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    
    target.position = ccp(winSize.width + target.contentSize.width/2, actualY/2);
    [self addChild:target];
    
    
    int minDuration = 2.0f;
    int maxDuration = 4.0f;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random()%rangeDuration) + minDuration;
    
    id actionMove = [CCMoveTo actionWithDuration:actualDuration
                                        position:ccp(-target.contentSize.width/2, actualY)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self
                                             selector:@selector(spriteMoveFinished:)];
    
    [target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    target.tag = 1;
    [_targets addObject:target];    
    
}


//function spriteMoveFinished
- (void) spriteMoveFinished:(id)sender
{
    CCSprite *sprite = (CCSprite *)sender;
    [self removeChild:sprite cleanup:YES];
    
    if(sprite.tag == 1)//targets
    {
        [_targets removeObject:sprite];
        GameOverScene *gameOverScene = [GameOverScene node];
        [gameOverScene.layer.label setString:@"You Lose!"];
        
        [[CCDirector sharedDirector] replaceScene:gameOverScene];
        
    }
    else if(sprite.tag == 2)//projectiles
    {
        [_projectiles removeObject:sprite];
    }
}


-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *projectile = [CCSprite spriteWithFile:@"Projectile.png"
                                               rect:CGRectMake(0, 0, 20, 20)];
    projectile.position = ccp(90, (winSize.height/2) + 8);
    
    int offX = location.x - projectile.position.x;
    int offY = location.y - projectile.position.y;
    
    float rotate =90 * (1 + tanf((float)offY / (float)offX));
    [_player setRotation:rotate];
        
    if(offX <= 0)
        return;
    
    [self addChild:projectile];
   

    
    int realX = winSize.width + (projectile.contentSize.width/2);
    float ratio = (float)offY / (float)offX;
    int realY = (realX * ratio) + projectile.position.y;
    CGPoint realDest = ccp(realX, realY);
     
    
    
    int offRealX = realX - projectile.position.x;
    int offRealY = realY - projectile.position.y;
    float length = sqrtf((offRealX * offRealX) + (offRealY * offRealY));
    float velocity = 480/1; //480pixels/1sec
    float realMoveDuration = length / velocity;
    
    [projectile runAction:[CCSequence actions:
                           [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
                           [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)],
                           nil]];    
    
    projectile.tag = 2;
    [_projectiles addObject:projectile];
    
    //play sound effect
    [[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
    
}

//@hai.phamvan end

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    //[_player release];
    //_player = nil;
    
    [_targets release];
    _targets = nil;
    
    [_projectiles release];
    _projectiles = nil;
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
