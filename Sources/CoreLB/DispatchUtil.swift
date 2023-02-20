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
    
    
    
    
    
    private static let shared = DispatchUtil()
        
    private let group = DispatchGroup()
    
    private var callbacks: [DispatchUtilCompletion?] = []
    
    private var onFinishCallback: DispatchUtilCompletion? = nil
    
    private var onFinishCallbackQueue: DispatchQueue = .main
    
    
    
    
    private init() { }

    public static func getInstance() -> DispatchUtil{
        return shared
    }
    
    
    
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
        

        DispatchQueue.global(qos: qos).async { [weak self] in
            
            guard let self = self else { return }
            
            self.callbacks.forEach{ callback in
                self.group.enter()
                callback!({
                    self.onLeave()
                })
                self.group.wait()                
            }
            
            
            self.group.notify(queue: self.onFinishCallbackQueue) {[weak self] in
                
                guard let self = self else { return }
                
                if(self.onFinishCallback != nil){
                    self.onFinishCallback!({

                    })
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

