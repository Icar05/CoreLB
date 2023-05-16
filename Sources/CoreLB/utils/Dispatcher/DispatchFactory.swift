//
//  File.swift
//  
//
//  Created by Галяткин Александр on 11.05.2023.
//

import Foundation

public final class  DispatchFactory{
    
    
    private let testService = TestService()
        
    public init(){}
    

    
    public func getAction(
        interval: Double,
        name: String,
        callback: @escaping (String) -> Void) -> DispatchUtilCompletion{
            return { onLeave in
                self.testService.doSomething(interval: interval, name: name, callback: { data in
                   callback(data)
                   onLeave?()
                })
            }
    }
    
    public func getFinishAction(interval: Double, callback: @escaping (String) -> Void) -> Closure{
        return {
            self.testService.onFinish(interval: interval, callback: callback)
        }
    }

    
    
}
