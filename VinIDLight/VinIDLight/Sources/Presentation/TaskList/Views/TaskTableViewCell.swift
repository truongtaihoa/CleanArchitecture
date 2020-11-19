//
//  TaskTableViewCell.swift
//  VinIDLight
//
//  Created by Truong Huu Hoa on 11/18/20.
//  Copyright © 2020 VinID. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleTextField.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(viewModel: TaskCellViewModel) {
        
        iconImageView.image = viewModel.iconImage
        titleTextField.text = viewModel.title
    }
}
