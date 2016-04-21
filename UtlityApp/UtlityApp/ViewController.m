//
//  ViewController.m
//  UtlityApp
//
//  Created by Narendra Verma on 4/15/16.
//  Copyright © 2016 Punchh. All rights reserved.
//

#import "ViewController.h"
#define properyName @"propertyName"
static NSString const * mapperKeys = @"mapperKeys";
static NSString const * propertyNumber = @"NSNumber";
static NSString const * propertyString = @"NSString";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_lblinvalidJson setHidden:YES];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (IBAction)btnClearTapped:(id)sender {
    [_txtView setString:@""];
}

- (IBAction)btnJsonTapped:(id)sender {
    if (!_txtClassName.stringValue.length) {
        [_lblinvalidJson setStringValue:@"Invalid Class Name"];
        [_lblinvalidJson setHidden:NO];
    } else {
        [_lblinvalidJson setStringValue:@"InvalidJson"];
        [_lblinvalidJson setHidden:YES];
        NSString * pastedString = _txtView.string;
        NSData* data = [pastedString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
        if ([jsonArray isKindOfClass:[NSArray class]]) {
            [self generateFileWithDict:[jsonArray firstObject]];
        } else if ([jsonArray isKindOfClass:[NSDictionary class]]) {
            [self generateFileWithDict:(NSDictionary *)jsonArray];
        } else {
            [_lblinvalidJson setHidden:NO];
        }
    }
}

- (NSString *) capatlizeString:(NSString *)string {
    if ([[string lowercaseString] isEqualToString:@"id"]) {
        return [_txtClassName.stringValue stringByAppendingString:[string capitalizedString]];
    }
    NSString * subString = @"";
    for (int i = 0; i < [string componentsSeparatedByString:@"_"].count; i++) {
        if (i == 0) {
            subString = [string componentsSeparatedByString:@"_"][0];
        } else {
            subString = [subString stringByAppendingFormat:@"%@",[([string componentsSeparatedByString:@"_"][i]) capitalizedString]];
        }
    }
    return subString;
}

- (void) generateFileWithDict:(NSDictionary *)dict {
    self.marrProperties = [NSMutableArray array];
    for (NSString * keys in dict.allKeys) {
        NSString * value = [dict valueForKey:keys];
        @try {
            NSMutableDictionary * dictValues = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                               properyName:[self capatlizeString:keys],
                                                                                               mapperKeys:keys}];
            if ([value isKindOfClass:[NSNumber class]]) {
                [dictValues setValue:propertyNumber
                              forKey:@"classtype"];
            } else {
                [dictValues setValue:propertyString
                              forKey:@"classtype"];
            }
            [_marrProperties addObject:dictValues];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
    }
    [self sortedArray];
    [self printData];
}

- (void) sortedArray {
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:properyName
                                                            ascending:YES];
    [_marrProperties sortUsingDescriptors:[NSArray arrayWithObject:sort]];
}

/*
 +(JSONKeyMapper*)keyMapper {
 return [[JSONKeyMapper alloc] initWithDictionary:@{@"name":@"title",@"ios_key":@"bundle_identifier",@"hockeyAppKey":@"public_identifier"}];
 }
 */
- (void) printData {
    NSString * properties = @"\n";
    NSString * strMapper = @"";
    for (NSDictionary * dict in _marrProperties) {
        properties = [properties stringByAppendingFormat:@"@property (strong, nonatomic) %@<Optional> *%@;\n",dict[@"classtype"],dict[properyName]];
        if (![dict[mapperKeys] isEqualToString:dict[properyName]]) {
            strMapper = [strMapper stringByAppendingFormat:@"\n@\"%@\":@\"%@\",",dict[mapperKeys],dict[properyName]];
        }
    }
    strMapper = [strMapper substringToIndex:(strMapper.length - 1)];
    NSLog(@"%@",strMapper);
    NSString * mapperMethod = [NSString stringWithFormat:@"+(JSONKeyMapper*)keyMapper {\nreturn [[JSONKeyMapper alloc] initWithDictionary:@{%@}];\n}",strMapper];
    
    [_txtView setString:[properties stringByAppendingFormat:@"\n\n\n%@",mapperMethod]];
}
@end
