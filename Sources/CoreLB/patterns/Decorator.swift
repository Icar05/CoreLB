//
//  File.swift
//  
//
//  Created by Галяткин Александр on 24.02.2023.
//

import Foundation


/// Базовый интерфейс Компонента определяет поведение, которое изменяется
/// декораторами.
public protocol Component {
    func operation()
}


/// Конкретные Компоненты предоставляют реализации поведения по умолчанию. Может
/// быть несколько вариаций этих классов.
public class ConcreteComponent: Component {
    
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

    private var component: Component

    public init(_ component: Component) {
        self.component = component
    }
    
    public final override func operation() {
        self.extraOperation()
        self.component.operation()
    }
    
    public func extraOperation(){
        print("Decorator")
    }
}


/// Конкретные Декораторы вызывают обёрнутый объект и изменяют его результат
/// некоторым образом.
public class ConcreteDecoratorA: Decorator {
    
    override public func extraOperation() {
        print("ConcreteDecoratorA")
    }
}

/// Декораторы могут выполнять своё поведение до или после вызова обёрнутого
/// объекта.
public class ConcreteDecoratorB: Decorator {

    override public func extraOperation() {
        print("ConcreteDecoratorB")
    }
}


public class ConcreteDecoratorC: Decorator {

    override public func extraOperation() {
        print("ConcreteDecoratorC")
    }
}
