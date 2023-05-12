//
//  File.swift
//  
//
//  Created by Галяткин Александр on 12.05.2023.
//

import Foundation

public final class TestDispatcher{
    
    private let testService = TestService()
    
    private let factory = DispatchFactory()
    
    private let dispatchExtendedUtil = DispatchUtilExtended()
    
    public init(){}
    
    
    public func testRaw(){
        
        
        print("DispatchQueue.global ...")

        DispatchQueue.global(qos: .userInitiated).async {
            let initialGroup = DispatchGroup()

                initialGroup.enter()
                self.testService.doSomething(interval: 5, name: "#1", callback: {  data in
                    print("Data: \(data)")
                    initialGroup.leave()
                })
            
                initialGroup.enter()
                self.testService.doSomething(interval: 3, name: "#2", callback: {  data in
                    print("Data: \(data)")
                    initialGroup.leave()
                })
            
                initialGroup.wait()
                print("Wait")
            
                initialGroup.enter()
                self.testService.doSomething(interval: 9, name: "#3", callback: {  data in
                    print("Data: \(data)")
                    initialGroup.leave()
                })
            
                initialGroup.enter()
                self.testService.doSomething(interval: 2, name: "#4", callback: {  data in
                    print("Data: \(data)")
                    initialGroup.leave()
                })

                   
                initialGroup.notify(queue: DispatchQueue.main) {
                    self.testService.onFinish(interval: 2, callback: { data in
                        print("\nResult: \(data)")
                    })
                }
               
            }
        
    }
    
    public func testExtendedUtil(){
        
        print("Extended Util ...")
        
        self.dispatchExtendedUtil
            .doAction(factory.getAction(interval: 5, name: "#1", callback: {  data in
                print("Data: \(data)")
            }))
            .doAction(factory.getAction(interval: 3, name: "#2", callback: {  data in
                print("Data: \(data)")
            }))
            .wait()
            .doAction(factory.getAction(interval: 9, name: "#3", callback: {  data in
                print("Data: \(data)")
            }))
            .doAction(factory.getAction(interval: 2, name: "#4", callback: {  data in
                print("Data: \(data)")
            }))
            .doOnFinish(factory.getFinishAction(interval: 2, callback: { data in
                print("Result: \(data)")
            }))
            .execute(qos: .userInitiated)
    }
    
    
}
