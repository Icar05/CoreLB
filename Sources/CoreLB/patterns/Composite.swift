//
//  File.swift
//  
//
//  Created by Галяткин Александр on 28.02.2023.
// https://refactoring.guru/ru/design-patterns/composite/swift/example#lang-features - base from here

import Foundation


protocol BaseComponent{
    var parent: CompositeComponent? { get set }
    func isComposite() -> Bool
    func operation() -> String
    func getStep() -> Int
}

extension BaseComponent{
    
    func isComposite() -> Bool{
        return false
    }
    
    func getStep() -> Int{
        return ( parent?.getStep() ?? 0 ) + 1
    }
    
    func getTabPrefix() -> String{
        return String.init(repeating: "\t", count: getStep() - 1)
    }

}

protocol CompositeComponent: BaseComponent {
    var children: [BaseComponent] { get }
    func add(component: BaseComponent) -> BaseComponent
    func remove(component: BaseComponent) -> BaseComponent
    func add(components: [BaseComponent]) -> BaseComponent
    func getStep() -> Int
}

extension CompositeComponent {

    func add(component: CompositeComponent) {}
    func remove(component: CompositeComponent) {}
    
    func isComposite() -> Bool {
        return true
    }
}


// component without composition inside
class NonCompositeComponent: BaseComponent {
    
    private let name: String
    
    init(_ name: String){
        self.name = name
    }
    
    var parent: CompositeComponent?

    func operation() -> String {
        return "\(getTabPrefix())    [\(name) : \(getStep())]"
    }
}


class ConcreteComposite: CompositeComponent {
   
    
    private let name: String
    
    var children: [BaseComponent] = []
    
    var parent: CompositeComponent?
    
    
    init(_ name: String){
        self.name = name
    }

    //remove child from self
    @discardableResult
    func add(component: BaseComponent) -> BaseComponent{
        var item = component
        item.parent = self
        children.append(item)
        
        return self as BaseComponent
    }
    
    @discardableResult
    func add(components: [BaseComponent]) -> BaseComponent {
        components.forEach{add(component: $0)}
        
        return self as BaseComponent
    }

    // add child
    func remove(component: BaseComponent)  -> BaseComponent{
        children.indices.forEach{
            if(children[$0].operation() == component.operation()){
                children[$0].parent = nil
                children.remove(at: $0)
            }
        }
        
        return self as BaseComponent
    }
    
    func operation() -> String {
        let childrenResult: String = children.map{ "\n\($0.operation())" }.joined()
        return "\(getTabPrefix())    [\(name) : \(getStep())] " + childrenResult 
    }
}

class Client {

    static func testSimpleThree(){
     
       let three =  ConcreteComposite("Root").add(components: [
                        ConcreteComposite("branchA").add(components: [
                            ConcreteComposite("subBranchA").add(components: [
                                ConcreteComposite("deepBranchA"),
                                ConcreteComposite("deepBranchB"),
                            ])
                        ]),
            
                        ConcreteComposite("branchB").add(component:
                            ConcreteComposite("subBranchB").add(component:
                                NonCompositeComponent("leafA"))
                        ),
            
                        ConcreteComposite("branchC").add(component:
                            ConcreteComposite("subBranchC").add(component:
                                NonCompositeComponent("leafB"))
                        ),

                        ConcreteComposite("subBranchD").add(components: [
                            NonCompositeComponent("leafC"),
                            NonCompositeComponent("leafD")
                        ])
        ])
        
        print("\(three.operation())")
        
    }
    
}
