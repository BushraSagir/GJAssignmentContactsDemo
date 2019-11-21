//
//  ContactEditTableViewCell.swift
//  GJContacts
//
//  Created by Bushra Sagir on 11/21/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import UIKit

protocol ContactEditTableViewCellDelegate: class {
  func textChanged(contactMetaData: ContactDetaildata, text: String)
}

class ContactEditTableViewCell: UITableViewCell {
  
  @IBOutlet weak var descLabel: UILabel!
  @IBOutlet weak var infoTextField: BindableTextField! {
    didSet {
      infoTextField.bind {[weak self] in
        guard let self = self else {
          return
        }
        self.delegate?.textChanged(contactMetaData: self.contactMetadata, text: $0)
      }
    }
  }
  
  var contactMetadata: ContactDetaildata!
  weak var delegate: ContactEditTableViewCellDelegate?
  
  static let identifier = "ContactEditTableViewCell"
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func config(metaData: ContactDetaildata) {
    contactMetadata = metaData
    descLabel.text = metaData.desc
    infoTextField.text = metaData.info
    infoTextField.keyboardType = metaData.keyboardType
  }
}
