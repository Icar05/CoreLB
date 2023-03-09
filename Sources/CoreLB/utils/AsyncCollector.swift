//
//  File.swift
//  
//
//  Created by Галяткин Александр on 02.03.2023.
//

import Foundation



protocol Action{
    associatedtype T
    func loadData(_ callback: @escaping (T) -> Void )
}

final class AsyncCollector<T>{
    
    
    
    private var onFinish: (([T]) -> Void)? = nil
    
    private var onUpdate: ((T) -> Void)? = nil
    
    private var totalCount = 0

    private var collectedResaults: [T] = []
    
    
    
    func collectResults(input: [any Action], onFinish: @escaping ([T]) -> Void, onUpdate: @escaping (T) -> Void ){
        self.onFinish = onFinish
        self.onUpdate = onUpdate
        self.totalCount = input.count
        
        input.forEach{
            $0.loadData{ data in
                if(data is T){
                    self.update(data: data as! T)
                }
            }
        }
    }
    
    private func update(data: T){
        self.collectedResaults.append(data)
        self.totalCount -= 1
        self.onUpdate?(data)
        
        if(totalCount == 0){
            self.onFinish?(collectedResaults)
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

class TestAsyncCollector{
    
    
    
    
    func test(){
        let actions: [any Action] = [
            SimpleAsynkActionOne(),
            SimpleAsynkActionTwo(),
            SimpleAsynkActionThree()
        ]
        
        
        AsyncCollector<String>().collectResults(input: actions){ result in
            print("result is: \(result)")
        } onUpdate: { update in
            print("update with  \(update)")
        }
    }
    
    

}
