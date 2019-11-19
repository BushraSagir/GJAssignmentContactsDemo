//
//  ContactListTableViewCell.swift
//  GJContacts
//
//  Created by Bushra Sagir on 11/19/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import UIKit

class ContactListTableViewCell: UITableViewCell {
  @IBOutlet weak var contactImageView: UIImageView!
  @IBOutlet weak var contactName: UILabel!
  @IBOutlet weak var favouriteImageView: UIImageView!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

//  func config(contact: Contact) {
//    let viewModel = ContactViewModel(contact: contact)
//    contactName.text = viewModel.name
//    contactImageView.image = UIImage.Contact.placeHolder
//    favouriteImageView.isHidden = !viewModel.isFavorite
//    favouriteImageView.image = viewModel.isFavorite ? UIImage.Contact.showFavorite : nil
//  }
}
