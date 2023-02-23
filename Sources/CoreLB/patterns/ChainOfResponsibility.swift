//
//  File.swift
//  
//
//  Created by Галяткин Александр on 23.02.2023.
//

import Foundation


public protocol Handler{
    func handle(data: String)
    func canHandle(data: String) -> Bool
}

public protocol AbstractManager{
    func handleRequest(data: String)
}

private protocol ManagerWithHandler: AbstractManager{
    var handler: Handler { get }
    var nextManager: AbstractManager? { get set }
}

extension ManagerWithHandler {
    
  public func handleRequest(data: String){
        if(handler.canHandle(data: data)){
            handler.handle(data: data)
        }else{
            nextManager?.handleRequest(data: data)
        }
    }
}

public class ZHandler: Handler{
    
    private let canHandle = true
    
    public init(){
        
    }
    
    public func handle(data: String) {
        print("Chain, ZHandler handle: \(data)")
    }
    
    public func canHandle(data: String) -> Bool {
        print("Chain, ZHandler canHandle: \(canHandle)")
        return canHandle
    }
}


public class YHandler: Handler{
    
    private let canHandle = false
    
    public init(){
        
    }
    
    public func handle(data: String) {
        print("Chain, YHandler handle: \(data)")
    }
    
    public func canHandle(data: String) -> Bool {
        print("Chain, YHandler canHandle: \(canHandle)")
        return canHandle
    }
}

public class XHandler: Handler{
    
    private let canHandle = false
    
    public init(){
        
    }
    
    public func handle(data: String) {
        print("Chain, XHandler handle: \(data)")
    }
    
    public func canHandle(data: String) -> Bool {
        print("Chain, XHandler canHandle: \(canHandle)")
        return canHandle
    }
}

public class Manager: ManagerWithHandler{
    
    
    fileprivate var handler: Handler
    
    public var nextManager: AbstractManager?

    public init( _ handler: Handler){
        self.handler = handler
    }
}

public class ChainOfResponibilityHelper{
    
   
    private var firstManager: Manager? = nil
    
    private var currentManager: Manager? = nil
    
    
    public init(){}
    
    
    public func appendElement( _ manager: Manager) -> ChainOfResponibilityHelper{
        
        if(firstManager == nil){
            self.firstManager = manager
        }else{
            self.currentManager?.nextManager = manager
        }
    
        self.currentManager = manager
        
        return self
    }
    
    public func handleRequest( _ request: String){
        self.firstManager?.handleRequest(data: request)
    }
    
    
    public static func prepareChainFromHandlers(hadlers: [Manager]) -> Manager? {

        var currentHandler = hadlers.last
        var currenIndex = hadlers.count
        
        
        while currenIndex  > 0{
            
            currenIndex -= 1
            currentHandler?.nextManager = hadlers[currenIndex]
            currentHandler = hadlers[currenIndex]
        }
        
        return currentHandler
    }
    
}

