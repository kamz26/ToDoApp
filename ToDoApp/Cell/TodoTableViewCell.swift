//
//  TodoTableViewCell.swift
//  ToDoApp
//
//  Created by Abhisek K. on 24/06/20.
//  Copyright © 2020 Abhisek K. All rights reserved.
//

import UIKit



class TodoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var selectionBtn: UIButton!
    
    var buttonPressed : (() -> ())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureTask(task:Task)  {
        self.titleLabel.text = task.taskTitle
        self.descriptionLabel.text = task.taskDescription
        if task.taskIsSelected{
            selectionBtn.layer.borderWidth = 1
            selectionBtn.layer.borderColor = UIColor.white.cgColor
            selectionBtn.setImage(UIImage.init(systemName: "checkmark.square"), for: .normal)
        }else{
            selectionBtn.layer.borderWidth = 1
            selectionBtn.layer.borderColor = UIColor.black.cgColor
            selectionBtn.backgroundColor = .white
            selectionBtn.setImage(nil, for: .normal)
        }
    }
    
    
    @IBAction func btnAction(_ sender: UIButton) {
        if let action = buttonPressed{
            action()
        }
        
    }
}
