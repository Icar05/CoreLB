//
//  File.swift
//  
//
//  Created by Галяткин Александр on 28.02.2023.
//

import Foundation


public final class Examples{
    
    
    public init(){}
    

    /** example of decorator using **/
    public func testDecorator(){
          ConcreteDecoratorC(
                ConcreteDecoratorB(
                    ConcreteDecoratorA(
                        ConcreteComponent()
                    )
                )
            )
            .operation()
    }
    
    
    /** example of chain of responsibility using **/
    public func testChainPattern(){

        let firstElement = Element(XHandler())
                .setNext(Element(XHandler()))
                .setNext(Element(YHandler()))
                .setNext(Element(XHandler()))
                .setNext(Element(YHandler()))
                .setNext(Element(XHandler()))
                .setNext(Element(YHandler()))
                .setNext(Element(ZHandler()))
        
        // be careful, you should start first element manually
        firstElement.handleRequest(data: "Example of manual chain")
        
        
        
        // helper will store first element for you
        ChainOfResponibilityHelper()
            .appendElement(Element(XHandler()))
            .appendElement(Element(YHandler()))
            .appendElement(Element(ZHandler()))
            .handleRequest("Example of stored chain")


        ChainOfResponibilityHelper.prepareChainFromHandlers(
            hadlers: [
                Element(XHandler()),
                Element(YHandler()),
                Element(ZHandler())
            ]
        )?.handleRequest(data: "Chain from array")
    
    }
    
    /** example of distpatcher using **/
    public func testDispatcher(){
        DispatchUtil.getInstance()
            .doAction(callback: doTest)
            .doAction(callback: doTest2)
            .doOnFinish(queue: .main, callback: doOnFinish)
            .execute(qos: .userInitiated)
    }
    
    /** dispatcher methods **/
    private func doTest(callback:  Closure?) -> Void{
        sleep(7)
        print("⚡️ doTest ⚡️ Name: \(OperationQueue.current?.underlyingQueue?.label ?? "None")\r")
        callback?()
    }
    
    private func doTest2(callback:  Closure?) -> Void{
        sleep(3)
        print("⚡️ doTest2 ⚡️ Name: \(OperationQueue.current?.underlyingQueue?.label ?? "None")\r")
        callback?()
    }
    
    private func doOnFinish(callback:  Closure?) -> Void{
        print("⚡️ doOnFinish ⚡️ Name: \(OperationQueue.current?.underlyingQueue?.label ?? "None")\r")
        callback?()
    }
    
}