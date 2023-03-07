//
//  File.swift
//  
//
//  Created by Галяткин Александр on 02.03.2023.
//https://refactoring.guru/ru/design-patterns/composite/swift/example#lang-features - base from here

import Foundation


/// Интерфейс Снимка предоставляет способ извлечения метаданных снимка, таких
/// как дата создания или название. Однако он не раскрывает состояние Создателя.
protocol Memento {

    var name: String { get }
    var date: Date { get }
}

/// Конкретный снимок содержит инфраструктуру для хранения состояния Создателя.
class ConcreteMemento: Memento {

    /// Создатель использует этот метод, когда восстанавливает своё состояние.
    private(set) var state: String
    private(set) var date: Date

    init(state: String) {
        self.state = state
        self.date = Date()
    }

    /// Остальные методы используются Опекуном для отображения метаданных.
    var name: String { return state + " " + date.description.suffix(14).prefix(8) }
}




/// Создатель содержит некоторое важное состояние, которое может со временем
/// меняться. Он также объявляет метод сохранения состояния внутри снимка и
/// метод восстановления состояния из него.
class Originator {
    
    
    private let logName = String(describing: Originator.self)

    /// Для удобства состояние создателя хранится внутри одной переменной.
    private var state: String

    init(state: String) {
        self.state = state
        printLog("initial state is: \(state)\n")
    }

    /// Бизнес-логика Создателя может повлиять на его внутреннее состояние.
    /// Поэтому клиент должен выполнить резервное копирование состояния с
    /// помощью метода save перед запуском методов бизнес-логики.
    func makeChanges(_ value: String) {
        state = value
        printLog("Make chagnes... State: \(state)\n")
    }

    private func generateRandomString() -> String {
        return String(UUID().uuidString.suffix(4))
    }

    /// Сохраняет текущее состояние внутри снимка.
    func prepareMemento() -> Memento {
        return ConcreteMemento(state: state)
    }

    /// Восстанавливает состояние Создателя из объекта снимка.
    func restoreFromMemento(memento: Memento) {
        guard let memento = memento as? ConcreteMemento else { return }
        self.state = memento.state
        printLog("Restored state: \(state)")
    }
    
    private func printLog(_ value: String){
        print("\(logName):  \(value)")
    }
}



/// Опекун не зависит от класса Конкретного Снимка. Таким образом, он не имеет
/// доступа к состоянию создателя, хранящемуся внутри снимка. Он работает со
/// всеми снимками через базовый интерфейс Снимка.
class Caretaker {
    
    private let logName = String(describing: Originator.self)

    private lazy var mementos = [Memento]()
    
    private var originator: Originator

    init(originator: Originator) {
        self.originator = originator
    }
    
    
    func save(_ state: Memento){
        printLog("Caretaker: Saving Originator's state...\(state.name)")
        mementos.append(state)
    }

    func save() {
        printLog("Caretaker: Saving Originator's state...")
        mementos.append(originator.prepareMemento())
    }
    
    //just return previous state
    func redo(){
        guard !mementos.isEmpty else { return }
        let removedMemento = mementos.removeLast()

        originator.restoreFromMemento(memento: removedMemento)
    }

    // save current + return previous
    func undo() {
        
        let currentState = originator.prepareMemento()
        self.redo()
        self.save(currentState)        
    }

    func showHistory() {
        printLog("Caretaker: Here's the list of mementos:\n")
        mementos.forEach({ printLog(" -- \($0.name)")})
    }
    
    private func printLog(_ value: String){
        print("\(logName):  \(value)")
    }
}

/// Давайте посмотрим как всё это будет работать.
class MementoConceptual {

    func testMementoConceptual() {

        let originator = Originator(state: "First state")
        let caretaker = Caretaker(originator: originator)

        caretaker.save()
        originator.makeChanges("RED")

        caretaker.save()
        originator.makeChanges("Orange")

        caretaker.save()
        originator.makeChanges("YELLOW")
        
        
        print("\n")
        caretaker.showHistory()

        print("\n")
        caretaker.undo()

        print("\n")
        caretaker.undo()

        print("\n")
        caretaker.redo()
        
        print("\n")
        caretaker.redo()
    }
}
