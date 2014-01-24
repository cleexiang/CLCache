CLCache
==============

####How To Use?

#####Read Data:
* -(id)objectForKey:(NSString *)key;

* -(NSData *)dataForKey:(NSString *)key;

#####Write Data:
* -(NSString *)setObject:(id <NSCoding>)object forKey:(NSString *)key;
* -(NSString *)setData:(NSData *)data forKey:(NSString *)key;
