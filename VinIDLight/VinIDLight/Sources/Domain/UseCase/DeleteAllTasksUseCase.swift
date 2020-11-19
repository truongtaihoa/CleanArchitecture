//
//  DeleteAllTasksUseCase.swift
//  VinIDLight
//
//  Created by Truong Huu Hoa on 11/17/20.
//  Copyright © 2020 VinID. All rights reserved.
//

import Foundation
import RxSwift

protocol DeleteAllTasksUseCaseType {
    
    func execute() -> Observable<Bool>
}

class DeleteAllTasksUseCase: DeleteAllTasksUseCaseType {
        
    let repository: TaskRepositoryType
    
    init(repository: TaskRepositoryType) {
        
        self.repository = repository
    }
    
    func execute() -> Observable<Bool> {
        
        return  self.repository.deleteAllTasks()
    }
}
