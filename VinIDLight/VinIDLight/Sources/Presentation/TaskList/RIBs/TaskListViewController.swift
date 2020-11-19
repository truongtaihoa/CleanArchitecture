//
//  TaskListViewController.swift
//  VinIDLight
//
//  Created by Truong Huu Hoa on 11/17/20.
//  Copyright © 2020 VinID. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import RxCocoa
import RxDataSources

protocol TaskListPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    var addTaskTrigger: PublishRelay<String> { get }
    var finishTaskTrigger: PublishRelay<Task> { get }
    var deleteTaskTrigger: PublishRelay<Task> { get }
    var searchTaskTrigger: PublishRelay<String> { get }
}

final class TaskListViewController: UIViewController, TaskListPresentable, TaskListViewControllable {
    
    weak var listener: TaskListPresentableListener?
    
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let tasks = BehaviorRelay<[Task]>(value: [])
    let disposeBag = DisposeBag()
    
    typealias Section = AnimatableSectionModel<Int, TaskCellViewModel>
    typealias DataSource = RxTableViewSectionedAnimatedDataSource<Section>
    
    let cellReuseIdentifier = "TaskCell"
    
    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "Task List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(handleAddTask)
        )
        
        searchBar.backgroundColor = .clear
        searchBar.placeholder = "Search"
        
        contentTableView.estimatedRowHeight = 44
        contentTableView.rowHeight = 44
        
        tasks
            .map { $0.map { TaskCellViewModel(task: $0) } }
            .map { [Section(model: 0, items: $0)] }
            .asDriver(onErrorDriveWith: .never())
            .drive(contentTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        contentTableView.rx
            .itemSelected
            .subscribe(
                onNext: { [weak self] indexPath in
                    
                    guard let self = self else { return }
                    
                    let task = self.dataSource.sectionModels[indexPath.section].items[indexPath.row].task
                    self.listener?.finishTaskTrigger.accept(task)
                },
                onError: nil,
                onCompleted: nil,
                onDisposed: nil
            )
            .disposed(by: disposeBag)
        
        contentTableView.rx
            .itemDeleted
            .subscribe(
                onNext: { [weak self] indexPath in
                    
                    guard let self = self else { return }
                    
                    let task = self.dataSource.sectionModels[indexPath.section].items[indexPath.row].task
                    self.listener?.deleteTaskTrigger.accept(task)
                },
                onError: nil,
                onCompleted: nil,
                onDisposed: nil
            )
            .disposed(by: disposeBag)
        
        searchBar
            .rx
            .searchButtonClicked
            .subscribe(
                onNext: { [weak self] _ in
                    
                    guard let self = self else { return }
                    
                    self.searchBar.resignFirstResponder()
                },
                onError: nil,
                onCompleted: nil,
                onDisposed: nil
            )
            .disposed(by: disposeBag)
        
        searchBar
            .rx
            .value
            .subscribe(
                onNext: { [weak self] value in
                    
                    guard let self = self else { return }
                    
                    self.listener?.searchTaskTrigger.accept(value ?? "")
                },
                onError: nil,
                onCompleted: nil,
                onDisposed: nil
            )
            .disposed(by: disposeBag)
    }
    
    @objc
    func handleAddTask() {
        
        searchBar.resignFirstResponder()
        showAlertForAddTask()
    }
    
    func showAlertForAddTask() {
        
        let alertController = UIAlertController(title: "Enter task", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        let submitAction = UIAlertAction(title: "OK", style: .default) { [unowned alertController, self] _ in
            
            if let answer = alertController.textFields?[0] {
                
                self.listener?.addTaskTrigger.accept(answer.text ?? "")
            }
        }
        
        alertController.addAction(submitAction)
        
        present(alertController, animated: true)
    }
    
    func makeDataSource() -> RxTableViewSectionedAnimatedDataSource<Section> {
        let animation = AnimationConfiguration(insertAnimation: .automatic, reloadAnimation: .fade, deleteAnimation: .automatic)
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<Section>(
            animationConfiguration: animation,
            configureCell: { [unowned self] (_, tableView, indexPath, model) -> UITableViewCell in
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier) as? TaskTableViewCell  else {
                    
                    return UITableViewCell()
                }
                
                cell.configure(viewModel: model)
                return cell
            })
        
        dataSource.canEditRowAtIndexPath = { _, _  in
            return true
        }
        
        return dataSource
    }
}
