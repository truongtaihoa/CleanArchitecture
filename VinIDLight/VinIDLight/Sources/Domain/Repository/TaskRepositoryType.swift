//
//  TaskRepository.swift
//  VinIDLight
//
//  Created by Truong Huu Hoa on 11/17/20.
//  Copyright © 2020 VinID. All rights reserved.
//

import Foundation
import RxSwift

protocol TaskRepositoryType {
    
    func getAllTasks() -> Observable<[Task]>
    func getTasks(query: String) -> Observable<[Task]>
    func insertTask(title: String, isDone: Bool) -> Observable<Task>
    func isExistTask(title: String) -> Observable<Bool>
    func deleteTask(_ task: Task) -> Observable<Bool>
    func deleteAllTasks() -> Observable<Bool>
    func updateTask(_ task: Task) -> Observable<Task>
}
