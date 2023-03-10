//
//  Command.swift
//  
//
//  Created by Галяткин Александр on 09.03.2023.
//// https://refactoring.guru/ru/design-patterns/composite/swift/example#lang-features - base from here

import Foundation



/// Интерфейс Команды объявляет метод для выполнения команд.
protocol Command {
    func execute()
}

/// Некоторые команды способны выполнять простые операции самостоятельно.
class SimpleCommand: Command {

    private var payload: String

    init(_ payload: String) {
        self.payload = payload
    }

    func execute() {
        print("- Simple command Executed:  (" + payload + ")")
    }
}

/// Но есть и команды, которые делегируют более сложные операции другим
/// объектам, называемым «получателями».
class ComplexCommand: Command {

    private var receiver: Receiver

    /// Данные о контексте, необходимые для запуска методов получателя.
    private var a: String
    private var b: String

    /// Сложные команды могут принимать один или несколько объектов-получателей
    /// вместе с любыми данными о контексте через конструктор.
    init(_ receiver: Receiver, _ a: String, _ b: String) {
        self.receiver = receiver
        self.a = a
        self.b = b
    }

    /// Команды могут делегировать выполнение любым методам получателя.
    func execute() {
        print("- Complex Command Executed: Call receiver ...")
        receiver.doSomething(a)
        receiver.doSomethingElse(b)
    }
}

/// Классы Получателей содержат некую важную бизнес-логику. Они умеют выполнять
/// все виды операций, связанных с выполнением запроса. Фактически, любой класс
/// может выступать Получателем.
class Receiver {

    func doSomething(_ a: String) {
        print(" - Receiver:  (" + a + ")")
    }

    func doSomethingElse(_ b: String) {
        print(" - Receiver:  (" + b + ")")
    }
}

/// Отпрвитель связан с одной или несколькими командами. Он отправляет запрос
/// команде.
class Invoker {

    
    private var usedCommands: [Command] = []
    
    private var onStart: Command?

    private var onFinish: Command?

    /// Инициализация команд.
    func setOnStart(_ command: Command) {
        onStart = command
    }

    func setOnFinish(_ command: Command) {
        onFinish = command
    }

    /// we can call each command togheter if we want
    func invoke() {
        print("Invoker: execute start and finish commands:")
        
        invokeStart()
        invokeFinish()
    }
    
    func invokeStart() {
        if(onStart != nil){
            print("\nInvoker: Start command:")
            onStart?.execute()
            usedCommands.append(onStart!)
        }
    }
    
    ////we can call specifical commands
    func invokeFinish(){
        if(onFinish != nil){
            print("\nInvoker: Finish command:")
            onFinish?.execute()
            usedCommands.append(onFinish!)
        }
    }
    
    
    //// we can mamage last commands
    func repeatLast(){
        
        if(usedCommands.isEmpty){
            print("\nInvoker: commands list clear.")
            return
        }
        
        print("\nInvoker: repeat last...")
        usedCommands.removeLast().execute()
    }
}

/// Давайте посмотрим как всё это будет работать.
class TestCommand {
    
    static func test() {
        /// Клиентский код может параметризовать отправителя любыми командами.
        
        
    
        let invoker = Invoker()
        let receiver = Receiver()
        let simpleCommand = SimpleCommand("Say Hi!")
        let complexCommand = ComplexCommand(receiver, "Send email", "Save report")
        
        
        
        invoker.setOnStart(simpleCommand)
        invoker.setOnFinish(complexCommand)
        
        invoker.invoke()
        invoker.invokeFinish()
        
        invoker.repeatLast()
        invoker.repeatLast()
        invoker.repeatLast()
        invoker.repeatLast()
    }
}
