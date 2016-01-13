//
//  SQL.h
//  chaoxi
//
//  Created by fizz on 15/12/29.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const createPoeSQL = @"CREATE TABLE IF NOT EXISTS poem (poemIndex text PRIMARY KEY , title text NOT NULL)";
static NSString *const insertPoeSQL = @"INSERT INTO poem (poemIndex, title) VALUES (?, ?)";
static NSString * const deletePoeSQL = @"DELETE FROM poem";  // 删除table
static NSString * const selectPoeSQL = @"SELECT * FROM poem";

