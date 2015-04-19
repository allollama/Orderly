//
//  SocketIOConnection.m
//  Media Controller
//
//  Created by Jordan Buschman on 11/11/14.
//  Copyright (c) 2014 Jordan Buschman. All rights reserved.
//

#import "SocketIOConnection.h"
#import "Group.h"

@implementation SocketIOConnection
@synthesize thisUser;

SocketIOConnection * socketIOConnection;

- (instancetype) init {
    self = [super init];
    if (self) {
        self.socketIsConnected = NO;
        self.socket = [[SIOSocket alloc] init];
        self.socket = nil;
    }
    return self;
}

- (void) connectToServerWithId: (NSString *) iD {
    NSString * host = @"https://omnisplit.com";
    
    if (!self.socketIsConnected) {
        [SIOSocket socketWithHost: host response: ^(SIOSocket *socket) {
            NSLog(@"WOWOWOW");
            self.socket = socket;
        
            __weak typeof(self) weakSelf = self;
        
            self.socket.onConnect = ^() {
                NSLog(@"Connected to server.");
                weakSelf.socketIsConnected = YES;
                [weakSelf.socket emit: @"create_or_join" args: @[iD]];
            };
            
            self.socket.onError = ^(NSDictionary* error) {
                NSLog(@"%@", error);
            };
            
            [self.socket on: @"update_people" callback: ^(SIOParameterArray *args) {
                NSLog(@"Updating list of people.");
                AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                thisUser = delegate.thisUser;
                
                NSError *jsonError;
                
                NSLog(@"%@", jsonError);

                NSString * newPeople = [args firstObject]; //Contains a new list of users in the chat
                NSDictionary *peopleDictionary = [NSJSONSerialization JSONObjectWithData:[newPeople dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
                
                thisUser.group.peopleDictionary = peopleDictionary;
                [thisUser.group updateGroupFromServer];
            }];
        }];
    } else {
        NSLog(@"Closing connection");
        [self closeConnection]; //Close connection
        [self connectToServerWithId:iD]; //Try again
    }
}

- (BOOL) connectionEstablished {
    if (!self.socketIsConnected)
        return NO;
    return YES;
}

- (void) closeConnection {
    if (self.socketIsConnected) {
        self.socketIsConnected = NO;
        [self.socket emit:@"disconnect"]; //On recieving this message, server will kick the client
        self.socket = nil;
        
        NSLog(@"Disconnected from server.");
    }
}
/*
- (void) playMusic {
    if (self.socketIsConnected) {
        MusicQueue * musicQueue = [MusicQueue globalMusicQueue];
        if ([musicQueue paused]) {
            if (![musicQueue nowPlaying] && [[musicQueue next] count] == 0 && [[musicQueue queue] count] != 0) {
                [self.socket emit:@"song ended"];
            }
            [self.socket emit:@"play music"];
        }
    }
}
*/
+ (SocketIOConnection *) globalSocketIOConnection {
    if (!socketIOConnection) {
        socketIOConnection = [[SocketIOConnection alloc] init];
    }
    
    return socketIOConnection;
}

@end