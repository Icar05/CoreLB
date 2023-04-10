//
//  File.swift
//  
//
//  Created by Галяткин Александр on 28.02.2023.
//

import Foundation


public final class Tests{
    
    
    
    /** example of command  using **/
    public static func testCommand(){
        TestCommand.test()
    }
    
    /** example of builder  using **/
    public static func testBuilder(){
        TestBuilder.generalTest()
        TestBuilder.chainTest()
    }
    
    /** example of memento  using **/
    public static func testMemento(){
        TestMemento.test()
    }
    
    /** example of async collector  using **/
    public static func testAsyncCollector(){
        TestAsyncCollector.test()
    }
    
    
    /** example of composite  using **/
    public static func testComposite(){
        TestComposite.test()
    }
    

    /** example of decorator using **/
    public static func testDecorator(){
        TestDecorator.test()
    }
    
    
    /** example of chain of responsibility using **/
    public static func testChainOfResponsibility(){
        TestChainResponsibility.test()
    
    }
    
    /** example of distpatcher using **/
    public static func testDispatcher(){
        TestDispatchUtil.test()
    }
    
    public static func requesterTroubleTest() {
        let url =  "https://pikabu.ru/@SPINE.CONFESSION".replacingOccurrences(of: "@", with: "%2F%40")
        
        if let url = URL(string: url) {
            print("url: \(url)")
            
            do {
                 let result = try String(contentsOf: url, encoding: .windowsCP1251)
                print("success! -> \(result.count)")
            } catch {
                print("NewsSource: error while read url: \(error)")
            }
        } else {
            print("NewsSource: bad url")
        }
    }
    
}
