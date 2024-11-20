//
//  TableViewCell.swift
//  ToDoListEM
//
//  Created by Vadim on 20.11.2024.
//

import UIKit

class TableViewCell: UITableViewCell {

    var titleTask: UILabel = {
        let label = UILabel()
        label.text = ""
        label.tintColor = .fromHex("F4F4F4")
        label.font = UIFont(name: "Helvetica Neue", size: 18)
        return label
    }()
    
    var descriptionTask: UILabel = {
        let label = UILabel()
        label.text = ""
        label.tintColor = .fromHex("F4F4F4")
        label.font = UIFont(name: "Helvetica Neue", size: 12)
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.tintColor = .fromHex("8E8E8F")
        label.font = UIFont(name: "Helvetica Neue", size: 12)
        return label
    }()
    
    var imageViewCompleted: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .none
        imageView.image = UIImage(systemName: "circle")
        imageView.tintColor = .fromHex("4D555E")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleTask)
        contentView.addSubview(descriptionTask)
        contentView.addSubview(dateLabel)
        contentView.addSubview(imageViewCompleted)
        
        NSLayoutConstraint.activate([
            imageViewCompleted.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageViewCompleted.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
