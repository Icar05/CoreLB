//
//  File.swift
//  
//
//  Created by Галяткин Александр on 07.03.2023.
// https://refactoring.guru/ru/design-patterns/composite/swift/example#lang-features - base from here
//

import Foundation


/// Интерфейс Строителя объявляет создающие методы для различных частей объектов
/// Продуктов.
protocol Builder<T> {
    
    associatedtype T
    
    var product: T { get  }
    
    @discardableResult
    func buildMainDependency() -> Self
    
    @discardableResult
    func builtExtraDependency() -> Self
    
    @discardableResult
    func buildExpenciveDependency() -> Self
    
    func retrieveProduct() -> T
    
    func reset()
}

/// Классы Конкретного Строителя следуют интерфейсу Строителя и предоставляют
/// конкретные реализации шагов построения. Ваша программа может иметь несколько
/// вариантов Строителей, реализованных по-разному.
class SimpleBuilder: Builder {
    
    internal var product = SimpleProduct()
    

    func buildMainDependency() -> Self {
        product.add(part: "Main part")
        return self
    }
    
    func builtExtraDependency() -> Self {
        product.add(part: "Extra part")
        return self
    }
    
    func buildExpenciveDependency() -> Self {
        product.add(part: "Expensive part")
        return self
    }

 
    func retrieveProduct() -> SimpleProduct {
        let result = self.product
        reset()
        return result
    }
    
    func reset() {
        product = SimpleProduct()
    }
}


class Director {

    private var builder: (any Builder)?

    
    func update(builder: any Builder) {
        self.builder = builder
    }

   
    func buildMinimalViableProduct() {
        builder?.buildMainDependency()
    }

    func buildFullFeaturedProduct() {
        builder?.buildMainDependency()
        builder?.builtExtraDependency()
        builder?.buildExpenciveDependency()
    }
    
    func buildCustom(){
        builder?.buildMainDependency()
        builder?.buildExpenciveDependency()
    }
    
}

class SimpleProduct {

    private var parts = [String]()
    
    public init(){}

    func add(part: String) {
        self.parts.append(part)
    }

    func listParts() -> String {
        return " \n - " + parts.joined(separator: " \n - ") + "\n"
    }
}


class TestBuilder {
 
    static func generalTest() {
        
        let director = Director()
        let builder = SimpleBuilder()
        director.update(builder: builder)
        
        print("# MVP product: ")
        director.buildMinimalViableProduct()
        print(builder.retrieveProduct().listParts())

        print("# Standard full featured product: ")
        director.buildFullFeaturedProduct()
        print(builder.retrieveProduct().listParts())

        print("# Custom product: ")
        director.buildCustom()
        print(builder.retrieveProduct().listParts())
    }
    
    static func chainTest(){
        
        let product = SimpleBuilder()
                        .buildMainDependency()
                        .builtExtraDependency()
                        .buildExpenciveDependency()
                        .retrieveProduct()
        
        print("# Chain product: ")
        print(product.listParts())
                        
        
    }

}

