//
//  File.swift
//
//
//  Created by Галяткин Александр on 17.01.2023.
//

import Foundation


public enum DispatchUtilCommand{
    case action(DispatchUtilCompletion)
    case wait
}


public class DispatchUtilExtended{
    
    
    
    
    private let group = DispatchGroup()
    
    private var commands = [DispatchUtilCommand]()
            
    private var onFinishCommand: Closure? = nil
    
    public init() { }
    
    
    public func doAction(_ command: DispatchUtilCommand) -> DispatchUtilExtended{
        self.commands.append(command)
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
    
    
    private func onLeave(){
        self.group.leave()
    }
    
    public func execute(qos: DispatchQoS.QoSClass){
        
        DispatchQueue.global(qos: qos).async {
            
            // handle each of actions
            self.commands.forEach{ command in
                switch command{
                case .action(let completion) :
                    self.group.enter()
                    completion {
                        self.onLeave()
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
        self.commands.removeAll()
        self.onFinishCommand = nil
    }
}




