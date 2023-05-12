//
//  File.swift
//  
//
//  Created by Галяткин Александр on 12.05.2023.
//

import Foundation

public final class TestService{
    
    public init(){}
    
    public func doSomething(interval: Double, name: String, callback: @escaping (String) -> Void){
        DispatchQueue.global().asyncAfter(deadline: .now() + interval) {
            callback("⚡️ doTest ⚡️ Name: \(name), interval -> \(interval)")
        }
    }
    
    // emulate call from service
    public func onFinish(interval: Double, callback: @escaping (String) -> Void){
        DispatchQueue.global().asyncAfter(deadline: .now() + interval) {
            callback("On Finish! interval -> \(interval)")
        }
    }
    
}
