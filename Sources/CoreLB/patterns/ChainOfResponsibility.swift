//
//  File.swift
//  
//
//  Created by Галяткин Александр on 23.02.2023.
// https://refactoring.guru/ru/design-patterns/composite/swift/example#lang-features - base from here

import Foundation

//private implementations of element
public protocol Handler{
    func handle(data: String)
    func canHandle(data: String) -> Bool
}
// in order to have equel behaviour of each elements of chaint
public protocol AbstractElement{
    func handleRequest(data: String)
    
    @discardableResult
    func setNext( _ element: AbstractElement) -> AbstractElement
}

private protocol ResponsibleElement: AbstractElement{
    var handler: Handler { get }
    var nextElement: AbstractElement? { get set }
}

// in order to have equel behaviour of each elements of chaint
extension ResponsibleElement {
    
  public func handleRequest(data: String){
        if(handler.canHandle(data: data)){
            handler.handle(data: data)
        }else{
            nextElement?.handleRequest(data: data)
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

public class Element: ResponsibleElement{
    
    
    fileprivate var handler: Handler
    
    public var nextElement: AbstractElement?

    public init( _ handler: Handler){
        self.handler = handler
    }
    
    @discardableResult
    public func setNext( _ element: AbstractElement) -> AbstractElement{
        self.nextElement = element
        
        return element
    }
}

public class ChainOfResponibilityHelper{
    
   
    private var firstElement: Element? = nil
    
    private var currentElement: Element? = nil
    
    
    public init(){}
    
    
    public func appendElement( _ manager: Element) -> ChainOfResponibilityHelper{
        
        if(firstElement == nil){
            self.firstElement = manager
        }else{
            self.currentElement?.nextElement = manager
        }
    
        self.currentElement = manager
        
        return self
    }
    
    public func handleRequest( _ request: String){
        self.firstElement?.handleRequest(data: request)
    }
    
    
    //prepare chain from different elements
    public static func prepareChainFromHandlers(hadlers: [Element]) -> Element? {
    
        let firstElement = hadlers.first
        var currentElement = hadlers.first
        var currenIndex = 0
        
        while currenIndex  < hadlers.count{
            currentElement?.nextElement = hadlers[currenIndex]
            currentElement = hadlers[currenIndex]
            currenIndex += 1
        }
                
        return firstElement
    }
    
}

