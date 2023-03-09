//
//  File.swift
//  
//
//  Created by Галяткин Александр on 24.02.2023.
//  https://refactoring.guru/ru/design-patterns/composite/swift/example#lang-features - base from here

import Foundation


/// Базовый интерфейс Компонента определяет поведение, которое изменяется
/// декораторами.
public protocol DecoratorComponent {
    func operation()
}


/// Конкретные Компоненты предоставляют реализации поведения по умолчанию. Может
/// быть несколько вариаций этих классов.
public class ConcreteComponent: DecoratorComponent {
    
    public init(){}
    

    public func operation(){
        print("ConcreteComponent")
    }
    
}


/// Базовый класс Декоратора следует тому же интерфейсу, что и другие
/// компоненты.   Основная цель этого класса - определить интерфейс обёртки для
/// всех конкретных декораторов. Реализация кода обёртки по умолчанию может
/// включать в себя  поле для хранения завёрнутого компонента и средства его
/// инициализации.
public class Decorator: ConcreteComponent {

    private var component: DecoratorComponent

    public init(_ component: DecoratorComponent) {
        self.component = component
    }
    // this moment similar to chain of responsibility. Only one difference -
    // previous component is setted from contructor
    public final override func operation() {
        
        if(needMainOperation()){
            self.mainOperation()
        }
        
        self.component.operation()
    }
    
    public func mainOperation(){
        print("Decorator")
    }
    
    internal func needMainOperation() -> Bool{
        return true
    }
}


/// Конкретные Декораторы вызывают обёрнутый объект и изменяют его результат
/// некоторым образом.
public class ConcreteDecoratorA: Decorator {
    
    override public func mainOperation() {
        print("ConcreteDecoratorA")
    }
}

/// Декораторы могут выполнять своё поведение до или после вызова обёрнутого
/// объекта.
public class ConcreteDecoratorB: Decorator {

    override public func mainOperation() {
        print("ConcreteDecoratorB")
    }
    
    internal override func needMainOperation() -> Bool {
        return false
    }
}


public class ConcreteDecoratorC: Decorator {

    override public func mainOperation() {
        print("ConcreteDecoratorC")
    }
}
