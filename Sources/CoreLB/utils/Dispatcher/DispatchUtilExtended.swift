//
//  DispatchUtilExtended.swift
//
//
//  Created by Галяткин Александр on 16.05.2023.
//

import Foundation



public enum DispatchUtilCommand{
    case action(Int, DispatchUtilCompletion)
    case wait
}



public class DispatchUtilExtended{
    
    
    
    
    private var counter = 0
    
    private let group = DispatchGroup()
    
    private var commands = [DispatchUtilCommand]()
    
    private var usedIds: [Int] = []
            
    private var onFinishCommand: Closure? = nil
    
    public init() { }
    
    
    public func doAction(_ action: @escaping DispatchUtilCompletion) -> DispatchUtilExtended{
        self.commands.append(DispatchUtilCommand.action(generateId(), action))
        return self
    }
    
    public func doOnFinish( _  onFinishCommand:  Closure? = nil) -> DispatchUtilExtended{
        self.onFinishCommand = onFinishCommand
        return self
    }
    
    public func wait() -> DispatchUtilExtended{
        self.commands.append(.wait)
        return self
    }
    
    
    private func generateId() -> Int{
        self.counter += 1
        return counter
    }
    
    
    private func onLeave(_ id: Int){
        if(!usedIds.contains(id)){
            self.usedIds.append(id)
            self.group.leave()
        }
    }
    
    public func execute(qos: DispatchQoS.QoSClass){
        
        DispatchQueue.global(qos: qos).async {
            
            // handle each of actions
            self.commands.forEach{ command in
                switch command{
                case .action(let id, let completion) :
                    self.group.enter()
                    completion {
                        self.onLeave(id)
                    }; break
                    
                case .wait:
                    self.group.wait()
                }
            }

            self.group.notify(queue: DispatchQueue.main) {
                self.onFinishCommand?()
                self.clear()
            }
            
        }
        
    }
    
    private func clear(){
        self.usedIds.removeAll()
        self.counter = 0
        self.commands.removeAll()
        self.onFinishCommand = nil
    }
}




