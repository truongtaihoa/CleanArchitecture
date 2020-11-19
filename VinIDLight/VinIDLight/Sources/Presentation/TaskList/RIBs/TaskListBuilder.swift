//
//  TaskListBuilder.swift
//  VinIDLight
//
//  Created by Truong Huu Hoa on 11/17/20.
//  Copyright © 2020 VinID. All rights reserved.
//

import RIBs

protocol TaskListDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class TaskListComponent: Component<TaskListDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TaskListBuildable: Buildable {
    func build() -> LaunchRouting
}

final class TaskListBuilder: Builder<TaskListDependency>, TaskListBuildable {

    override init(dependency: TaskListDependency) {
        super.init(dependency: dependency)
    }

    func build() -> LaunchRouting {
        
        let storyboard = UIStoryboard(name: "TaskListViewController", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? TaskListViewController else {
            fatalError("")
        }
        
        let repository = RMTaskRepository()
        let createTaskUseCase = CreateTaskUseCase(repository: repository)
        let getAllTasksUseCase = GetAllTasksUseCase(repository: repository)
        let searchTaskUseCase = SearchTaskUseCase(repository: repository)
        let deleteAllTasksUseCase = DeleteAllTasksUseCase(repository: repository)
        let deleteTaskUseCase = DeleteTaskUseCase(repository: repository)
        let finishTaskUseCase = FinishTaskUseCase(repository: repository)
        
        let interactor = TaskListInteractor(
            presenter: viewController,
            createTaskUseCase: createTaskUseCase,
            getAllTasksUseCase: getAllTasksUseCase,
            searchTaskUseCase: searchTaskUseCase,
            deleteAllTasksUseCase: deleteAllTasksUseCase,
            deleteTaskUseCase: deleteTaskUseCase,
            finishTaskUseCase: finishTaskUseCase
        )
        
        return TaskListRouter(interactor: interactor, viewController: viewController)
    }
}
