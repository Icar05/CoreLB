//
//  ChainOfResponsibility.swift
//  
//
//  Created by Галяткин Александр on 23.02.2023.
// https://refactoring.guru/ru/design-patterns/composite/swift/example#lang-features - base from here

import Foundation

//private implementations of element
public protocol Handler{
    func handle(data: String)
    func canHandle(data: String) -> Bool
    static func instantiate() -> Handler
}
// in order to have equel behaviour of each elements of chaint
public protocol AbstractElement{
    func handleRequest(data: String)
    
    @discardableResult
    func setNext( _ element: AbstractElement) -> AbstractElement
    var nextElement: AbstractElement? { get }
}

private protocol ResponsibleElement<T>: AbstractElement {
    
    associatedtype T : Handler
    
    var handler: T { get }
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
    
    public func handle(data: String) {
        print("\nZHandler handle: \(data)\n")
    }
    
    public func canHandle(data: String) -> Bool {
        print("\(data)  [ZHandler] -> \(canHandle)")
        return canHandle
    }
    
    public static func instantiate() -> Handler {
        return ZHandler()
    }
}


public class YHandler: Handler{
    

    private let canHandle = false
    
    public func handle(data: String) {
        print("\nYHandler handle: \(data)\n")
    }
    
    public func canHandle(data: String) -> Bool {
        print("\(data)  [YHandler] -> \(canHandle)")
        return canHandle
    }
    
    public static func instantiate() -> Handler {
        return YHandler()
    }
}

public class XHandler: Handler{
   
    
    
    private let canHandle = false
    
    public func handle(data: String) {
        print("\nXHandler handle: \(data)\n")
    }
    
    public func canHandle(data: String) -> Bool {
        print("\(data)  [XHandler] -> \(canHandle)")
        return canHandle
    }
    
    public static func instantiate() -> Handler {
        return XHandler()
    }
}

public class Element<T>: ResponsibleElement where T: Handler{
    
    
    fileprivate var handler: T
    
    public var nextElement: AbstractElement?

    public init(){
        self.handler = T.instantiate() as! T
    }
    
    @discardableResult
    public func setNext( _ element: AbstractElement) -> AbstractElement{
        self.nextElement = element
                
        return element
    }
}

public class ChainOfResponibilityHelper{

    private var firstElement: AbstractElement? = nil

    private var currentElement: AbstractElement? = nil


    public init(){}


    public func appendElement( _ element: AbstractElement) -> ChainOfResponibilityHelper{

        if(firstElement == nil){
            self.firstElement = element
        }else{
            self.currentElement?.setNext(element)
        }

        self.currentElement = element

        return self
    }

    public func handleRequest( _ request: String){
        self.firstElement?.handleRequest(data: request)
    }


    //prepare chain from different elements
    public static func prepareChainFromHandlers(hadlers: [AbstractElement]) -> AbstractElement? {

        let firstElement = hadlers.first
        var currentElement = hadlers.first
        var currenIndex = 0

        while currenIndex  < hadlers.count{
            currentElement?.setNext(hadlers[currenIndex])
            currentElement = hadlers[currenIndex]
            currenIndex += 1
        }

        return firstElement
    }
    
}

/// Давайте посмотрим как всё это будет работать.
class TestChainResponsibility {
    
    static func test() {
       
        
        //raw chain call, need start from first element
        let firstElement = Element<XHandler>()

            //append next elements
            firstElement
                  .setNext(Element<YHandler>())
                  .setNext(Element<XHandler>())
                  .setNext(Element<YHandler>())
                  .setNext(Element<XHandler>())
                  .setNext(Element<YHandler>())
                  .setNext(Element<XHandler>())
                  .setNext(Element<YHandler>())
                  .setNext(Element<ZHandler>())


            // start from top
            firstElement.handleRequest(data: "TestData")
        
        
        
        // helper will store first element for you
        ChainOfResponibilityHelper()
            .appendElement(Element<XHandler>())
            .appendElement(Element<YHandler>())
            .appendElement(Element<ZHandler>())
            .handleRequest("Example of stored chain")
        

        ChainOfResponibilityHelper.prepareChainFromHandlers(
            hadlers: [
                Element<XHandler>(),
                Element<YHandler>(),
                Element<ZHandler>()
            ]
        )?.handleRequest(data: "Chain from array")
    }
}
