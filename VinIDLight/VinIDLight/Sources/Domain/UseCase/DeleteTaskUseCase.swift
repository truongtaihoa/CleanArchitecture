//
//  DeleteTaskUseCase.swift
//  VinIDLight
//
//  Created by Truong Huu Hoa on 11/17/20.
//  Copyright © 2020 VinID. All rights reserved.
//

import Foundation
import RxSwift

protocol DeleteTaskUseCaseType {
    
    func execute(query: String, task: Task) -> Observable<[Task]>
}

class DeleteTaskUseCase: DeleteTaskUseCaseType {
    
    let repository: TaskRepositoryType
    
    init(repository: TaskRepositoryType) {
        
        self.repository = repository
    }
    
    func execute(query: String, task: Task) -> Observable<[Task]> {
        
        return self.repository
            .deleteTask(task)
            .flatMap { [unowned self] _ -> Observable<[Task]> in
                
                if query.isEmpty {
                    
                    return self.repository.getAllTasks()
                }
                
                return self.repository.getTasks(query: query)
            }
    }
}
