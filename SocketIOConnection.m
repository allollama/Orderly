//
//  SocketIOConnection.m
//  Media Controller
//
//  Created by Jordan Buschman on 11/11/14.
//  Copyright (c) 2014 Jordan Buschman. All rights reserved.
//

#import "SocketIOConnection.h"
#import "MusicQueue.h"

@implementation SocketIOConnection

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

- (void) connectToServerWithAddress: (NSString *) ip
                            andPort: (NSInteger) port {
    NSString * host = [NSString stringWithFormat: @"http://%@:%ld/controller", ip, port];
    
    if (!self.socketIsConnected) {
        [SIOSocket socketWithHost: host response: ^(SIOSocket *socket) {
            self.socket = socket;
        
            __weak typeof(self) weakSelf = self;
        
            self.socket.onConnect = ^() {
                weakSelf.socketIsConnected = YES;
                
                MusicQueue * musicQueue = [MusicQueue globalMusicQueue];
                [musicQueue reset];
                
                NSLog(@"Connected to server.");
            };
            
            [self.socket on: @"player info" callback: ^(SIOParameterArray *args) {
                NSLog(@"Received player info message.");
                
                NSDictionary * response = [args firstObject]; //Contains various information about the server
                
                NSMutableArray * library = [response objectForKey: @"library"];
                NSMutableArray * queue = [response objectForKey: @"queue"];
                NSMutableArray * last = [response objectForKey: @"last"];
                NSMutableArray * next = [response objectForKey: @"next"];
                NSNumber * nowPlaying = [response objectForKey:@"nowPlaying"];
                float volume = [[response objectForKey: @"volume"] floatValue];
                float isPaused = [[response objectForKey: @"isPaused"] floatValue];
                
                [MusicQueue globalMusicQueueWithLibrary: library
                                               andQueue: queue
                                                andLast: last
                                                andNext: next
                                          andNowPlaying: nowPlaying
                                              andVolume: volume
                                              andPaused: isPaused];
            }];
            [self.socket on: @"pause music" callback: ^(SIOParameterArray *args) {
                NSLog(@"Received pause music message.");
                MusicQueue * mq = [MusicQueue globalMusicQueue];
                [mq setPaused: YES];
            }];
            
            [self.socket on: @"play music" callback: ^(SIOParameterArray *args) {
                NSLog(@"Received play music message.");
                MusicQueue * mq = [MusicQueue globalMusicQueue];
                [mq setPaused: NO];
            }];
            
            [self.socket on: @"set volume" callback: ^(SIOParameterArray *args) {
                NSString * volume = [args firstObject];
                NSLog(@"Received message to set volume to %@.", volume);
                
                MusicQueue * musicQueue = [MusicQueue globalMusicQueue];
                [musicQueue setVolume: [volume floatValue]];
            }];
            
            [self.socket on: @"queue song" callback: ^(SIOParameterArray *args) {
                NSString * libraryID = [args firstObject]; //Contains various information about the server
                NSLog(@"Received message to queue up library[%@].", libraryID);
                
                MusicQueue * mq = [MusicQueue globalMusicQueue];
                [mq add: [libraryID integerValue]];
            }];
            
            [self.socket on: @"unqueue song" callback: ^(SIOParameterArray *args) {
                NSString * index = [args firstObject];
                NSLog(@"Received message to remove queue[%@].", index);
                
                MusicQueue * mq = [MusicQueue globalMusicQueue];
                [mq remove: [index integerValue]];
            }];
            
            [self.socket on: @"change song" callback: ^(SIOParameterArray *args) {
                NSString * libraryID = [args firstObject];
                NSLog(@"Received message to change song to library[%@].", libraryID);
                
                MusicQueue * mq = [MusicQueue globalMusicQueue];
                [mq changeSongTo: [libraryID integerValue]];
            }];
            
            [self.socket on: @"song ended" callback: ^(SIOParameterArray *args) {
                NSLog(@"Received song ended message.");
                
                MusicQueue * mq = [MusicQueue globalMusicQueue];
                [mq songFinishedPlaying];
                [mq loadSong];
                
                if (![mq nowPlaying])
                    [mq setPaused:YES];
                else
                    [mq setPaused:NO];
            }];
            
            [self.socket on: @"play previous" callback: ^(SIOParameterArray *args) {
                NSLog(@"Received play previous message.");
                
                MusicQueue * mq = [MusicQueue globalMusicQueue];
                
                [mq playPrevious];
            }];
            
            [self.socket on: @"play next" callback: ^(SIOParameterArray *args) {
                NSLog(@"Received play next message.");
                
                MusicQueue * mq = [MusicQueue globalMusicQueue];
                
                [mq playNext];
            }];
            [self.socket on: @"reorder queue" callback: ^(SIOParameterArray *args) {
                NSDictionary * argumentString = [args firstObject];
                //NSLog(@"%@", argumentString);
                NSString * from = [argumentString objectForKey:@"from"];
                NSString * to = [argumentString objectForKey:@"to"];
                
                NSLog(@"Received reorder queue message.");
                
                MusicQueue * mq = [MusicQueue globalMusicQueue];
                
                [mq moveFrom:[from integerValue] to:[to integerValue]];
            }];

            
        }];
    } else {
        [self closeConnection]; //Close connection
        [self connectToServerWithAddress:ip andPort:port]; //Try again
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
        [self.socket emit:@"disconnect app"]; //On recieving this message, server will kick the client
        self.socket = nil;
        
        MusicQueue * musicQueue = [MusicQueue globalMusicQueue];
        [musicQueue reset];
        
        NSLog(@"Disconnected from server.");
    }
}

-(void) changeSongTo: (NSInteger) libraryID {
    if (self.socketIsConnected) {
        [self.socket emit:@"change song" args: @[[NSString stringWithFormat:@"%ld",libraryID]]];
        MusicQueue * musicQueue = [MusicQueue globalMusicQueue];
        [musicQueue setPaused:NO];
    }
}

- (void) changeVolumeTo: (float) volume {
    if (self.socketIsConnected) {
        [self.socket emit:@"set volume" args: @[[NSString stringWithFormat:@"%f",volume]]];
    }
}

- (void) pauseMusic {
    if (self.socketIsConnected) {
        MusicQueue * musicQueue = [MusicQueue globalMusicQueue];
        if (![musicQueue paused]) {
            [self.socket emit:@"pause music"];
        }
    }
}

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

- (void) add: (NSInteger) libraryID {
    if (self.socketIsConnected) {
        [self.socket emit:@"queue song" args: @[[NSString stringWithFormat:@"%ld",libraryID]]];
    }
}

- (void) remove: (NSInteger) index {
    if (self.socketIsConnected) {
        [self.socket emit:@"unqueue song" args: @[[NSString stringWithFormat:@"%ld",index]]];
    }
    
}

- (void) rewind {
    if (self.socketIsConnected) {
        MusicQueue * mq = [MusicQueue globalMusicQueue];
        
        if ([[mq last] count] > 0) { //There is a song to go back to, play that song
            [self.socket emit:@"play previous"];
        }
        else if ([mq nowPlaying] != nil) { //There is no song to go back to, but there is a song currently playing, so start that song over
            [self.socket emit:@"change song" args: @[[NSString stringWithFormat:@"%@",[mq nowPlaying]]]];
        }
    }
}

- (void) fastForward {
    if (self.socketIsConnected) {
        MusicQueue * mq = [MusicQueue globalMusicQueue];
        
        if (([[mq next] count] > 0 || [[mq queue] count] > 0) && [mq nowPlaying] != nil) { //There is a song to go forward to, play that song
            [self.socket emit:@"play next"];
        }
        else if ([mq nowPlaying] == nil){ //Try to queue up and play the next song
            [self.socket emit:@"song ended"];
            [self.socket emit:@"play music"];
        }
    }
}

- (void) moveFrom: (NSInteger) from
               to: (NSInteger) to {
    if (self.socketIsConnected) {
        [self.socket emit:@"reorder queue"
                     args: @[[NSString stringWithFormat:@"%lu", from], [NSString stringWithFormat:@"%lu", to]]];
    }
}

+ (SocketIOConnection *) globalSocketIOConnection {
    if (!socketIOConnection) {
        socketIOConnection = [[SocketIOConnection alloc] init];
    }
    
    return socketIOConnection;
}

@end