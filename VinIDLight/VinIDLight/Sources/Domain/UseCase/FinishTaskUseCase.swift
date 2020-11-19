//
//  UpdateTaskUseCase.swift
//  VinIDLight
//
//  Created by Truong Huu Hoa on 11/18/20.
//  Copyright © 2020 VinID. All rights reserved.
//

import Foundation
import RxSwift

protocol FinishTaskUseCaseType {
    
    func execute(query: String, task: Task) -> Observable<[Task]>
}

class FinishTaskUseCase: FinishTaskUseCaseType {
    
    let repository: TaskRepositoryType
    
    init(repository: TaskRepositoryType) {
        
        self.repository = repository
    }
    
    func execute(query: String, task: Task) -> Observable<[Task]> {
        
        let param = Task(
            id: task.id,
            title: task.title,
            isDone: !task.isDone
        )
        
        return self.repository
            .updateTask(param)
            .flatMap { [unowned self] _ -> Observable<[Task]> in
            
                if query.isEmpty {
                    
                    return self.repository.getAllTasks()
                }
                
                return self.repository.getTasks(query: query)
            }
    }
}
