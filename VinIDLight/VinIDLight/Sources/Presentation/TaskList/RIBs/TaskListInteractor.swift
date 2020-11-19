//
//  TaskListInteractor.swift
//  VinIDLight
//
//  Created by Truong Huu Hoa on 11/17/20.
//  Copyright © 2020 VinID. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa
import Action
import RxSwiftExt

protocol TaskListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TaskListPresentable: Presentable {
    var listener: TaskListPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    var tasks: BehaviorRelay<[Task]> { get }
}

protocol TaskListListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class TaskListInteractor: PresentableInteractor<TaskListPresentable>, TaskListInteractable, TaskListPresentableListener {

    weak var router: TaskListRouting?
    weak var listener: TaskListListener?
    
    let addTaskTrigger = PublishRelay<String>()
    let finishTaskTrigger = PublishRelay<Task>()
    let deleteTaskTrigger = PublishRelay<Task>()
    var searchTaskTrigger = PublishRelay<String>()
    
    lazy var addTaskAction = makeAddTaskAction()
    lazy var finishTaskAction = makeFinishTaskAction()
    lazy var deleteTaskAction = makeDeleteTaskAction()
    lazy var searchTaskAction = makeSearchTaskAction()
    
    let createTaskUseCase: CreateTaskUseCaseType
    let getAllTasksUseCase: GetAllTasksUseCaseType
    let searchTaskUseCase: SearchTaskUseCaseType
    let deleteAllTasksUseCase: DeleteAllTasksUseCaseType
    let deleteTaskUseCase: DeleteTaskUseCaseType
    let finishTaskUseCase: FinishTaskUseCaseType

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: TaskListPresentable,
         createTaskUseCase: CreateTaskUseCaseType,
         getAllTasksUseCase: GetAllTasksUseCaseType,
         searchTaskUseCase: SearchTaskUseCaseType,
         deleteAllTasksUseCase: DeleteAllTasksUseCaseType,
         deleteTaskUseCase: DeleteTaskUseCaseType,
         finishTaskUseCase: FinishTaskUseCaseType) {
        
        self.createTaskUseCase = createTaskUseCase
        self.getAllTasksUseCase = getAllTasksUseCase
        self.searchTaskUseCase = searchTaskUseCase
        self.deleteAllTasksUseCase = deleteAllTasksUseCase
        self.deleteTaskUseCase = deleteTaskUseCase
        self.finishTaskUseCase = finishTaskUseCase
        
        super.init(presenter: presenter)
        
        presenter.listener = self
    }

    override func didBecomeActive() {
        
        super.didBecomeActive()
       
        defer {
            
            searchTaskTrigger.accept("")
        }
        
        configurePresenter()
        configureInteractor()
    }
    
    func configureInteractor() {
        
        addTaskTrigger
            .withLatestFrom(searchTaskTrigger) { ($1, $0) }
            .bind(to: addTaskAction.inputs)
            .disposeOnDeactivate(interactor: self)
        
        finishTaskTrigger
            .withLatestFrom(searchTaskTrigger) { ($1, $0) }
            .bind(to: finishTaskAction.inputs)
            .disposeOnDeactivate(interactor: self)
        
        deleteTaskTrigger
            .withLatestFrom(searchTaskTrigger) { ($1, $0) }
            .bind(to: deleteTaskAction.inputs)
            .disposeOnDeactivate(interactor: self)
        
        searchTaskTrigger
            .bind(to: searchTaskAction.inputs)
            .disposeOnDeactivate(interactor: self)
    }
    
    func configurePresenter() {
        
        addTaskAction
            .elements
            .bind(to: presenter.tasks)
            .disposeOnDeactivate(interactor: self)
        
        finishTaskAction
            .elements
            .bind(to: presenter.tasks)
            .disposeOnDeactivate(interactor: self)
        
        deleteTaskAction
            .elements
            .bind(to: presenter.tasks)
            .disposeOnDeactivate(interactor: self)
        
        searchTaskAction
            .elements
            .bind(to: presenter.tasks)
            .disposeOnDeactivate(interactor: self)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func makeAddTaskAction() -> Action<(String, String), [Task]> {
        
        return Action<(String, String), [Task]> { [unowned self] query, title in
            
            return self.createTaskUseCase.execute(query: query, title: title)
        }
    }
        
    func makeFinishTaskAction() -> Action<(String, Task), [Task]> {
        
        return Action<(String, Task), [Task]> { [unowned self] query, task in
            
            return self.finishTaskUseCase.execute(query: query, task: task)
        }
    }
    
    func makeDeleteTaskAction() -> Action<(String, Task), [Task]> {
        
        return Action<(String, Task), [Task]> { [unowned self] query, task in
            
            return self.deleteTaskUseCase.execute(query: query, task: task)
        }
    }

    func makeSearchTaskAction() -> Action<String, [Task]> {
        
        return Action<String, [Task]> { [unowned self] query in
            
            return self.searchTaskUseCase.execute(query: query)
        }
    }
}
