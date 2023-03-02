//
//  File.swift
//  
//
//  Created by Галяткин Александр on 02.03.2023.
//

import Foundation

protocol Action{
    func loadData(_ callback: @escaping (String) -> Void )
}

final class AsyncCollector{
    
    
    
    private var onFinish: ((String) -> Void)? = nil
    
    private var onUpdate: ((String) -> Void)? = nil
    
    private var totalCount = 0

    private var collectedResaults: [String] = []
    
    
    
    func collectResults(input: [Action], onFinish: @escaping (String) -> Void, onUpdate: @escaping (String) -> Void ){
        self.onFinish = onFinish
        self.onUpdate = onUpdate
        self.totalCount = input.count
        
        input.forEach{
            $0.loadData{ data in
                self.update(data: data)
            }
        }
    }
    
    private func update(data: String){
        self.collectedResaults.append(data)
        self.totalCount -= 1
        self.onUpdate?(data)
        
        if(totalCount == 0){
            self.onFinish?(collectedResaults.joined())
        }
    }
    
    
}

class SimpleAsynkActionOne: Action{
    
    func loadData(_ callback: @escaping (String) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            callback(" [SimpleAsynkActionOne] ")
        }
    }
    
}


class SimpleAsynkActionTwo: Action{
    
    func loadData(_ callback: @escaping  (String) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            callback(" [SimpleAsynkActionTwo] ")
        }
    }
    
}

class SimpleAsynkActionThree: Action{
    
    func loadData(_ callback: @escaping (String) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 12.0) {
            callback(" [SimpleAsynkActionThree] ")
        }
    }
    
}

class TestAboutActions{
    
    
    
    
    func test(){
        let actions: [Action] = [
            SimpleAsynkActionOne(),
            SimpleAsynkActionTwo(),
            SimpleAsynkActionThree()
        ]
        
        
        AsyncCollector().collectResults(input: actions){ result in
            print("result is: \(result)")
        } onUpdate: { update in
            print("update with  \(update)")
        }
    }
    
    

}
