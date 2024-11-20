//
//  ViewController.swift
//  ToDoListEM
//
//  Created by Vadim on 20.11.2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let searchField = UITextField()
    let tableView = UITableView()
    let toolbar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.tintColor = .fromHex("F4F4F4")
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "Задачи"
        
        setSearchField()
        setToolbar()
        setTableView()
    }

    
    private func setSearchField(){
        searchField.backgroundColor = .fromHex("272729")
        searchField.textColor = .fromHex("F4F4F4")
        searchField.setPlaceholder("Search", leftIcon: UIImage(systemName: "magnifyingglass"), rightIcon: UIImage(systemName: "mic.fill"))
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.layer.cornerRadius = 15
        view.addSubview(searchField)
        NSLayoutConstraint.activate([
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            searchField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setToolbar(){
        toolbar.backgroundColor = .fromHex("272729")
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbar)
        NSLayoutConstraint.activate([
            toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 83)
        ])
    }
    
    private func setTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .none
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: toolbar.topAnchor)
        ])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else {return UITableViewCell()}
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension UITextField {
    func setPlaceholder(_ placeholderText: String, leftIcon: UIImage? = nil, rightIcon: UIImage? = nil, padding: CGFloat = 16) {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding + (leftIcon == nil ? 0 : 24), height: self.frame.height))
        self.leftView = leftPaddingView
        self.leftViewMode = .always

        if let leftIcon = leftIcon {
            let leftIconView = UIImageView(frame: CGRect(x: padding, y: 0, width: 20, height: 20))
            leftIconView.image = leftIcon
            leftIconView.contentMode = .scaleAspectFit
            leftIconView.tintColor = .fromHex("8E8E8F")
            leftPaddingView.addSubview(leftIconView)
            leftIconView.center.y = leftPaddingView.center.y
        }

        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding + (rightIcon == nil ? 0 : 24) , height: self.frame.height))
        self.rightView = rightPaddingView
        self.rightViewMode = .always

        if let rightIcon = rightIcon {
            let rightIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            rightIconView.image = rightIcon
            rightIconView.contentMode = .scaleAspectFit
            rightIconView.tintColor = .fromHex("8E8E8F")
            rightPaddingView.addSubview(rightIconView)
            rightIconView.center = rightPaddingView.center
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.fromHex("8E8E8F"),
            .paragraphStyle: {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.firstLineHeadIndent = 0
                return paragraphStyle
            }()
        ]
        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
    }
}

extension UIColor {
    static func fromHex(_ hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.count) != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
