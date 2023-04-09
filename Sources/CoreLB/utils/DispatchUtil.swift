//
//  File.swift
//  
//
//  Created by Галяткин Александр on 17.01.2023.
//

import Foundation



public typealias Closure = () -> Void
public typealias Closure1<T> = (T) -> Void

public typealias DispatchUtilCompletion = (_ onLeave: Closure?) -> Void



public class DispatchUtil{
    
    
    private let group = DispatchGroup()
    
    private var callbacks: [DispatchUtilCompletion?] = []
    
    private var onFinishCallback: DispatchUtilCompletion? = nil
    
    private var onFinishCallbackQueue: DispatchQueue = .main
    
    
    public init() { }
    
    
    public func doAction(callback:  DispatchUtilCompletion?) -> DispatchUtil{
        self.callbacks.append(callback)
        return self
    }
    
    public func doOnFinish(queue: DispatchQueue, callback:  DispatchUtilCompletion? = nil) -> DispatchUtil{
        self.onFinishCallback = callback
        self.onFinishCallbackQueue = queue
        return self
    }
    
    
    private func onLeave(){
        self.group.leave()
    }
    
    public func execute(qos: DispatchQoS.QoSClass){
        DispatchQueue.global(qos: qos).async {
            
            self.callbacks.forEach{ callback in
                self.group.enter()
                callback!({
                    self.onLeave()
                })
                self.callbacks.removeFirst()
                self.group.wait()                
            }
            
            
            self.group.notify(queue: self.onFinishCallbackQueue) {
                if(self.onFinishCallback != nil){
                    self.onFinishCallback!({

                    })
                    self.onFinishCallback = nil
                }
                self.clear()
            }
            
        }
        
    }
    
    private func clear(){
        self.callbacks.removeAll()
        self.onFinishCallback = nil
    }
}


class TestDispatchUtil{
    
    static func test(){
        DispatchUtil()
            .doAction(callback: doTest)
            .doAction(callback: doTest2)
            .doOnFinish(queue: .main, callback: doOnFinish)
            .execute(qos: .userInitiated)
    }
    
    
    /** dispatcher methods **/
    private static func doTest(callback:  Closure?) -> Void{
        sleep(7)
        print("⚡️ doTest ⚡️ Name: \(OperationQueue.current?.underlyingQueue?.label ?? "None")\r")
        callback?()
    }
    
    private static func doTest2(callback:  Closure?) -> Void{
        sleep(3)
        print("⚡️ doTest2 ⚡️ Name: \(OperationQueue.current?.underlyingQueue?.label ?? "None")\r")
        callback?()
    }
    
    private static func doOnFinish(callback:  Closure?) -> Void{
        print("⚡️ doOnFinish ⚡️ Name: \(OperationQueue.current?.underlyingQueue?.label ?? "None")\r")
        callback?()
    }
    
}
