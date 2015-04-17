//
//  SocketIOConnection.h
//  Media Controller
//
//  Created by Jordan Buschman on 11/11/14.
//  Copyright (c) 2014 Jordan Buschman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIOSocket.h"
#import "AppDelegate.h"
#import "User.h"

@interface SocketIOConnection : NSObject

@property (strong) SIOSocket *socket;
@property BOOL socketIsConnected;
@property User* thisUser;

- (instancetype) init;

- (void) connectToServerWithId: (NSString *) iD;

- (BOOL) connectionEstablished;

- (void) closeConnection;

//- (void) playMusic;

+ (SocketIOConnection *) globalSocketIOConnection;

@end