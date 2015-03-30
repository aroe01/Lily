//
//  NSCache+Ex.swift
//  SwifyCache
//
//  Created by kukushi on 3/24/15.
//  Copyright (c) 2015 Xing He. All rights reserved.
//

import Foundation

private var NSCacheKeysKey: UInt8 = 0

public extension NSCache {
    
    var allKeys: Set<String> {
        return _allKeys
    }
    
    private var _allKeys: Set<String>! {
        get {
            var keys = objc_getAssociatedObject(self, &NSCacheKeysKey) as? Set<String>
            if keys == nil {
                keys = Set<String>()
                self._allKeys = keys
            }
            return keys!
        }
        set(newValue) {
            objc_setAssociatedObject(self, &NSCacheKeysKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    public func removeAll() {
        removeAllObjects()
    }
    
    subscript(key: String) -> CacheProxy {
        return CacheProxy(key, self)
    }
    
    subscript(key: String) -> AnyObject? {
        get {
            return self[key]
        }
        set {
            if newValue != nil {
                _allKeys.insert(key)
                setObject(newValue!, forKey: key)
            }
        }
    }
}

public class CacheProxy {
    private let key: String
    private let cache: NSCache
    
    init (_ key: String, _ cache: NSCache) {
        self.key = key
        self.cache = cache
    }
    
    func remove() {
        cache._allKeys.remove(key)
        cache.removeObjectForKey(key)
    }
    
    var object: AnyObject? {
        return cache.objectForKey(key)
    }
    
    var string: String {
        return (object as? String) ?? ""
    }
    
    var data: NSData {
        return (object as? NSData) ?? NSData()
    }
    
    var number: NSNumber? {
        return object as? NSNumber
    }
    
    var value: NSValue? {
        return object as? NSValue
    }
    
    var bool: Bool {
        return (object as? Bool) ?? false
    }
    
    var double: Double {
        return number?.doubleValue ?? 0
    }
    
    var float: Float {
        return number?.floatValue ?? 0
    }
    
    var int: Int {
        return number?.integerValue ?? 0
    }
}