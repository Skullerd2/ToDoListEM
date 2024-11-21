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
        label.textColor = .fromHex("F4F4F4")
        label.font = UIFont(name: "Helvetica Bold", size: 19)
        return label
    }()
    
    var descriptionTask: UILabel = {
        let label = UILabel()
        label.text = "Блять ебаная псина в говне опять обвалялась, а мне теперь слизывать"
        label.numberOfLines = 2
        label.textColor = .fromHex("F4F4F4")
        label.font = UIFont(name: "Helvetica Neue", size: 15)
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "01/01/24"
        label.textColor = .fromHex("8e8e8f")
        label.font = UIFont(name: "Helvetica Neue", size: 15)
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
        
        imageViewCompleted.translatesAutoresizingMaskIntoConstraints = false
        titleTask.translatesAutoresizingMaskIntoConstraints = false
        descriptionTask.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageViewCompleted.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageViewCompleted.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageViewCompleted.widthAnchor.constraint(equalToConstant: 35),
            imageViewCompleted.heightAnchor.constraint(equalTo: imageViewCompleted.widthAnchor),
            titleTask.leadingAnchor.constraint(equalTo: imageViewCompleted.trailingAnchor, constant: 5),
            titleTask.topAnchor.constraint(equalTo: imageViewCompleted.topAnchor, constant: 7),
            descriptionTask.topAnchor.constraint(equalTo: titleTask.bottomAnchor, constant: 10),
            descriptionTask.leadingAnchor.constraint(equalTo: titleTask.leadingAnchor),
            descriptionTask.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateLabel.topAnchor.constraint(equalTo: descriptionTask.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: descriptionTask.leadingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
