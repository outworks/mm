//
//  TrackHttpResponse.h
//  cmm
//
//  Created by Hcat on 15/4/11.
//
//

#import "LK_HttpResponse.h"

@interface TrackQueryHttpResponse : LK_HttpBasePageResponse

@end

@interface TrackListHttpResponse : LK_HttpBaseResponse

@property(nonatomic,strong)NSArray *track;
@property(nonatomic,strong)NSArray *unit;

@end