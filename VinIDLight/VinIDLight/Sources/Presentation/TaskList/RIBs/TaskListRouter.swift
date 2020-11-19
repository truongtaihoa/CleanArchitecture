//
//  TaskListRouter.swift
//  VinIDLight
//
//  Created by Truong Huu Hoa on 11/17/20.
//  Copyright © 2020 VinID. All rights reserved.
//

import RIBs

protocol TaskListInteractable: Interactable {
    var router: TaskListRouting? { get set }
    var listener: TaskListListener? { get set }
}

protocol TaskListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TaskListRouter: LaunchRouter<TaskListInteractable, TaskListViewControllable>, TaskListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TaskListInteractable, viewController: TaskListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
