//
//  File.swift
//  
//
//  Created by Галяткин Александр on 11.03.2023.
//

import Foundation


open class SimpleStorage{
    
    
    
    private let encoder = JSONEncoder()
    
    private let decoder = JSONDecoder()
    
    
    public init() {}
    
    @discardableResult
    public func updateInt(_ value: Int, _ key: String) -> Bool{
        UserDefaults.standard.set(value, forKey: key)
        return true
    }
    
    public func readInt(_ key: String) -> Int{
        return UserDefaults.standard.integer(forKey: key)
    }    
    
    public func getObject<T: Codable>(key: String) -> T?{
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                print("Unable to Decode \(String(describing: T.self)) (\(error))")
                return nil
            }
        }
        return nil
    }
    
    
    @discardableResult
    public func saveObject<T: Codable>(_ model: T, key: String) -> Bool{
        do {
            let data = try encoder.encode(model)
            UserDefaults.standard.set(data, forKey: key)
            return true
        } catch {
            print("Unable to Encode \(String(describing: T.self)) (\(error))")
            return false
        }
    }
    
}

