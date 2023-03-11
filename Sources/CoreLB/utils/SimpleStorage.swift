//
//  File.swift
//  
//
//  Created by Галяткин Александр on 11.03.2023.
//

import Foundation


public final class SimpleStorage{
    
    
    public init() {}
    
    @discardableResult
    public func updateInt(_ value: Int, _ key: String) -> Bool{
        UserDefaults.standard.set(value, forKey: key)
        return true
    }
    
    public func readInt(_ key: String) -> Int{
        return UserDefaults.standard.integer(forKey: key)
    }
    
}

