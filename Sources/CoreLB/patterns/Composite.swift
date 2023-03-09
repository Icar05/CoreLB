//
//  File.swift
//  
//
//  Created by Галяткин Александр on 28.02.2023.
// https://refactoring.guru/ru/design-patterns/composite/swift/example#lang-features - base from here

import Foundation


protocol BaseComponent{
    var identifier: String { get  }
    var parent: (CompositeComponent)? { get set }
    func isComposite() -> Bool
    func getStep() -> Int
    func operation(_ callback: @escaping (Bool) -> Void )
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
    
    
    
    var identifier: String
    
    private let name: String
    
    init(_ name: String){
        self.name = name
        self.identifier = UUID().uuidString
    }
    
    var parent: (any CompositeComponent)?

    func prepareName() -> String {
        return "\(getTabPrefix())    [Level: \(getStep()) : \(name)]"
    }
    
    func operation(_ callback: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
            print(self.prepareName())
            
            callback(true)
        }
    }
}


class ConcreteComposite: CompositeComponent {
   
    
    
    private var currentChildIndex = 0
    
    private let name: String
    
    var identifier: String
    
    var children: [BaseComponent] = []
    
    var parent: (CompositeComponent)?
    
    var callback: ((Bool) -> Void )? = nil
    
    
    init(_ name: String){
        self.name = name
        self.identifier = UUID().uuidString
    }

    //remove child from self
    @discardableResult
    func add(component: BaseComponent) -> BaseComponent{
        var item = component
        item.parent = self
        children.append(item)
        
        return self
    }
    
    @discardableResult
    func add(components: [BaseComponent]) -> BaseComponent {
        components.forEach{add(component: $0)}
        
        return self
    }

    @discardableResult
    func remove(component:BaseComponent)  -> BaseComponent{
        children.indices.forEach{
            if(children[$0].identifier == component.identifier){
                children[$0].parent = nil
                children.remove(at: $0)
            }
        }

        return self
    }
    
    private func prepareName() -> String {
        return "\(getTabPrefix())    [Level: \(getStep()) : \(name)] "
    }
    
    private func handleAction(){
        
        if(children.isEmpty){
            self.callback?(true)
            return
        }
        
        self.children[currentChildIndex].operation{ data in
            
            if(self.currentChildIndex < self.children.count - 1){
                self.currentChildIndex += 1
                self.handleAction()
            }else{
                self.callback?(true)
                return
            }

        }
        
    }
    
    func operation(_ callback: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            
            print(self.prepareName())
            
            self.callback = callback
            self.handleAction()
        }

    }
    
}

class Client {

    static func testSimpleThree(){
     
       let three =  ConcreteComposite("Root").add(components: [
                        ConcreteComposite("Branch 2").add(components: [
                            ConcreteComposite("Branch 3").add(components: [
                                ConcreteComposite("Branch 4").add(component:
                                    ConcreteComposite("Branch 4").add(component:
                                        ConcreteComposite("Branch 6").add(components: [
                                                NonCompositeComponent("Leaf 1"),
                                                NonCompositeComponent("Leaf 2"),
                                                NonCompositeComponent("Leaf 3")
                                            ]))
                                ),
                                ConcreteComposite("Branch 4.1"),
                            ])
                        ]),

                        ConcreteComposite("Branch 2.2").add(component:
                            ConcreteComposite("Branch 3.2").add(component:
                                NonCompositeComponent("Leaf 4"))
                        ),

                        ConcreteComposite("Branch 2.4").add(component:
                            ConcreteComposite("Branch 3.3").add(component:
                                NonCompositeComponent("Leaf 5"))
                        ),

                        ConcreteComposite("subBranchD").add(components: [
                            NonCompositeComponent("Leaf 6"),
                            NonCompositeComponent("Leaf 7")
                        ])
        ])
        
        three.operation{ _ in
            print("\n ____________________ \n Done!")
        }
        
    }
    
}
