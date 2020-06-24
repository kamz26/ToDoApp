//
//  AddTaskViewController.swift
//  ToDoApp
//
//  Created by Abhisek K. on 25/06/20.
//  Copyright © 2020 Abhisek K. All rights reserved.
//

import UIKit

class AddTaskViewController: AppBaseViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var taskTitleLabel: UITextField!
    @IBOutlet weak var taskDescriptionLabel: UITextView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UISetup()
    }
    
    
    fileprivate func UISetup(){
        taskDescriptionLabel.layer.borderWidth = 0.5
        taskDescriptionLabel.layer.borderColor = UIColor.lightGray.cgColor
        taskDescriptionLabel.layer.cornerRadius = 5
        taskDescriptionLabel.text = ""
        
        cancelBtn.layer.cornerRadius = 5
        doneBtn.layer.cornerRadius = 5
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK: - IBAction
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        validateFields()
        //        self.navigationController?.popViewController(animated: true)
    }
    
    
    fileprivate func validateFields(){
        if taskTitleLabel.text?.count == 0 && taskDescriptionLabel.text.count == 0{
            super.popupAlert(title: "Empty Task", message: "Empty task can't be saved", actionTitles: ["Okay"], actions:  [{ (action1) in
                self.dismiss(animated: true, completion: nil)
               
                }])
             return
        }
        saveTask()
    }
    
    fileprivate func  saveTask(){
        var dict:  [String: Any] = [:]
        dict["title"] = taskTitleLabel.text ?? ""
        dict["description"] = taskDescriptionLabel.text ?? ""
        dict["isSelected"] = false
        dict["taskId"] = UUID().uuidString
        
        CoreDataManager.sharedManager.saveTask(taskData: dict)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
}

extension AddTaskViewController{
    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        setupNavigationBarItems()
    }
    
    private func setupNavigationBarItems() {
        navigationItem.title = "New todo Item"
    }
}

extension UITextView {

   override open func draw(_ rect: CGRect)
   {
       super.draw(rect)
       setContentOffset(CGPoint.zero, animated: false)
   }

}
