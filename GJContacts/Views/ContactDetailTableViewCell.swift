//
//  ContactDetailTableViewCell.swift
//  GJContacts
//
//  Created by Bushra Sagir on 11/20/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import UIKit

class ContactDetailTableViewCell: UITableViewCell {

  @IBOutlet weak var descLabel: UILabel!
  @IBOutlet weak var infoLabel: UILabel!
  
  static let identifier = "ContactDetailsTableViewCell"  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func config(metaData: ContactDetaildata) {
    descLabel.text = metaData.desc
    infoLabel.text = metaData.info
  }

}
