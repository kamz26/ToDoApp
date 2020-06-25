//
//  TodoListViewController.swift
//  ToDoApp
//
//  Created by Abhisek K. on 24/06/20.
//  Copyright © 2020 Abhisek K. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: AppBaseViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var todoListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //MARK: - Variables
    var taskDataList: [Task] = []
    var filteredTaskDataList: [Task] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
        fetchListData()
        viewSetup()
    }
    
    
    fileprivate func fetchListData(){
        self.taskDataList =  CoreDataManager.sharedManager.fetchTask()
        self.filteredTaskDataList = self.taskDataList
        todoListTableView.reloadAsync()
    }
    
    fileprivate func viewSetup(){
        todoListTableView.register(cellType: TodoTableViewCell.self)
        
        
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        searchBar.delegate = self
        
//        searchTextfield.delegate = self
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension TodoListViewController{
    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        setupNavigationBarItems()
    }
    
    private func setupNavigationBarItems() {
        navigationItem.title = "Todo List"
        setupRightNavigationBar()
    }
    private func setupRightNavigationBar() {
        let rebelButton = UIButton(type: .system)
        rebelButton.setTitle("Add", for: .normal)
        rebelButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: rebelButton)]
    }
    
    @objc func addAction(){
        
        let vc = AddTaskViewController.initFromNib()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTaskDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: TodoTableViewCell.self, for: indexPath)
        cell.configureTask(task: self.filteredTaskDataList[indexPath.row])
        cell.buttonPressed = { [weak self] in
            let task = self?.filteredTaskDataList[indexPath.row]
            self?.updateList(task: task!)
            
        }
       return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = AddTaskViewController.initFromNib()
        vc.selectedTask = self.filteredTaskDataList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let task = self.filteredTaskDataList[indexPath.row]
            CoreDataManager.sharedManager.delete(task: task)
            self.fetchListData()
        }
        return [delete]
    }
    
    
    func updateList(task:Task){
        
        var dict:  [String: Any] = [:]
        dict["title"] = task.taskTitle
        dict["description"] = task.taskDescription
        dict["isSelected"] = !task.taskIsSelected
        dict["taskId"] = task.taskId
        CoreDataManager.sharedManager.updateTask(taskData: dict)
        self.fetchListData()
        self.todoListTableView.reloadAsync()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredTaskDataList = searchText.isEmpty ? taskDataList : taskDataList.filter({(task: Task) -> Bool in
            
            return task.taskTitle!.range(of: searchText, options: .caseInsensitive) != nil
        })
        todoListTableView.reloadData()
    }
    
}

    
    
    


