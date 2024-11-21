import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Elements
    let searchField = UITextField()
    let tableView = UITableView()
    let toolbar = UIToolbar()
    let countTasksLabel = UILabel()
    let createTaskButton = UIButton(type: .system)
    
    var tasks: [ToDoS] = []
    
    let editViewController = EditViewController()
    
    let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchTasks()
        
        view.backgroundColor = .black
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .fromHex("F4F4F4")
        title = "Задачи"
        
        setSearchField()
        setToolbar()
        setCountTasksLabel()
        setCreateTaskButton()
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
    
    private func setCountTasksLabel(){
        countTasksLabel.text = "\(tasks.count) задач"
        countTasksLabel.font = UIFont(name: "Helvetica Neue", size: 15)
        countTasksLabel.sizeToFit()
        countTasksLabel.translatesAutoresizingMaskIntoConstraints = false
        toolbar.addSubview(countTasksLabel)
        
        NSLayoutConstraint.activate([
            countTasksLabel.centerXAnchor.constraint(equalTo: toolbar.centerXAnchor),
            countTasksLabel.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor, constant: -10),
        ])
    }
    
    private func setCreateTaskButton(){
        createTaskButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        createTaskButton.tintColor = .fromHex("FED702")
        createTaskButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        toolbar.addSubview(createTaskButton)
        createTaskButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            createTaskButton.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor, constant: -10),
            createTaskButton.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor, constant: -16)
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
        return view.frame.height / 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else {return UITableViewCell()}
        cell.titleTask.text = tasks[indexPath.row].todo
        cell.descriptionTask.text = tasks[indexPath.row].todo
        if tasks[indexPath.row].completed{
            cell.imageViewCompleted.image = UIImage(named: "checkmark")
        } else{
            cell.imageViewCompleted.image = UIImage(named: "circle")
        }
        cell.dateLabel.text = editViewController.fetchCurrentDate()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        tasks[indexPath.row].completed = !(tasks[indexPath.row].completed)
        tableView.reloadData()
    }
    
    @objc func buttonTapped() {
        
        navigationController?.pushViewController(editViewController, animated: true)
    }
}


//MARK: - Network
extension ViewController{
    
    func fetchTasks(){
        networkManager.fetchTasks { [weak self] result in
            switch result{
            case .success(let tasks):
                self?.tasks = tasks.todos
                self?.countTasksLabel.text = "\(String(describing: self!.tasks.count)) задач"
                self?.tableView.reloadData()
                print(tasks)
            case .failure(let error):
                print(error.localizedDescription)
            }
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

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
