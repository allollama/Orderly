//
//  SocketIOConnection.h
//  Media Controller
//
//  Created by Jordan Buschman on 11/11/14.
//  Copyright (c) 2014 Jordan Buschman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIOSocket.h"

@interface SocketIOConnection : NSObject

@property (strong) SIOSocket *socket;
@property BOOL socketIsConnected;

- (instancetype) init;

- (void) connectToServerWithAddress: (NSString *) ip
                            andPort: (NSInteger) port;

- (BOOL) connectionEstablished;

- (void) closeConnection;

- (void) changeSongTo: (NSInteger) libraryID;
- (void) changeVolumeTo: (float) volume;

- (void) pauseMusic;
- (void) playMusic;

- (void) add: (NSInteger) libraryID;
- (void) remove: (NSInteger) index;

- (void) rewind;
- (void) fastForward;

- (void) moveFrom: (NSInteger) from
               to: (NSInteger) to;

+ (SocketIOConnection *) globalSocketIOConnection;

@end