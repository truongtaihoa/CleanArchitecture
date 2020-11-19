//
//  UpdateTaskUseCase.swift
//  VinIDLight
//
//  Created by Truong Huu Hoa on 11/18/20.
//  Copyright © 2020 VinID. All rights reserved.
//

import Foundation
import RxSwift

protocol UpdateTaskUseCaseType {
    
    func execute(_ param: Task) -> Observable<Task>
}

class FinishTaskUseCase: UpdateTaskUseCaseType {
    
    let repository: TaskRepositoryType
    
    init(repository: TaskRepositoryType) {
        
        self.repository = repository
    }
    
    func execute(_ param: Task) -> Observable<Task> {
        
        let task = Task(
            id: param.id,
            title: param.title,
            isDone: !param.isDone
        )
        return self.repository.updateTask(task)
    }
}
