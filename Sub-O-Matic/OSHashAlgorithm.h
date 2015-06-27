#import <Cocoa/Cocoa.h>

typedef struct
{
    uint64_t fileHash;
    uint64_t fileSize;
} VideoHash;

@interface OSHashAlgorithm : NSObject {
    
}
+(VideoHash)hashForPath:(NSString*)path;
+(VideoHash)hashForURL:(NSURL*)url;
+(VideoHash)hashForFile:(NSFileHandle*)handle;
+(NSString*)stringForHash:(uint64_t)hash;

@end