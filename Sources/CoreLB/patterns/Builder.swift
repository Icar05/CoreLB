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
protocol Builder {
    @discardableResult
    func buildMainDependency() -> Builder
    @discardableResult
    func builtExtraDependency() -> Builder
    @discardableResult
    func buildExpenciveDependency() -> Builder
    func retrieveProduct() -> SimpleProduct
}

/// Классы Конкретного Строителя следуют интерфейсу Строителя и предоставляют
/// конкретные реализации шагов построения. Ваша программа может иметь несколько
/// вариантов Строителей, реализованных по-разному.
class SimpleBuilder: Builder {
   
    
    private var product = SimpleProduct()

    func buildMainDependency() -> Builder {
        product.add(part: "Main part")
        return self
    }
    
    func builtExtraDependency() -> Builder {
        product.add(part: "Extra part")
        return self
    }
    
    func buildExpenciveDependency() -> Builder {
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

    private var builder: Builder?

    
    func update(builder: Builder) {
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

/// Имеет смысл использовать паттерн Строитель только тогда, когда ваши продукты
/// достаточно сложны и требуют обширной конфигурации.
///
/// В отличие от других порождающих паттернов, различные конкретные строители
/// могут производить несвязанные продукты. Другими словами, результаты
/// различных строителей могут не всегда следовать одному и тому же интерфейсу.
class SimpleProduct {

    private var parts = [String]()

    func add(part: String) {
        self.parts.append(part)
    }

    func listParts() -> String {
        return "Product parts: " + parts.joined(separator: ", ") + "\n"
    }
}


class TestBuilder {
 
    static func generalTest() {
        
        let director = Director()
        let builder = SimpleBuilder()
        director.update(builder: builder)
        
        print("MVP product")
        director.buildMinimalViableProduct()
        print(builder.retrieveProduct().listParts())

        print("Standard full featured product:")
        director.buildFullFeaturedProduct()
        print(builder.retrieveProduct().listParts())

        print("Custom product:")
        director.buildCustom()
        print(builder.retrieveProduct().listParts())
    }
    
    static func chainTest(){
        
        let product = SimpleBuilder()
                        .buildMainDependency()
                        .builtExtraDependency()
                        .buildExpenciveDependency()
                        .retrieveProduct()
        
        print(product.listParts())
                        
        
    }

}

