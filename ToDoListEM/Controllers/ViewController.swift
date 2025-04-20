import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //Elements
    let searchField = UITextField()
    let tableView = UITableView()
    let toolbar = UIToolbar()
    let countTasksLabel = UILabel()
    let createTaskButton = UIButton(type: .system)
    
    var tasks: [Task] = []
    var filteredTaskIndices: [Int] = []
    var isSearching = false
    var context: NSManagedObjectContext!
    var heightOfRow: [Int] = []
    
    let networkManager = NetworkManager.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            tasks = try context.fetch(fetchRequest)
            updateCountTasksLabel()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self
        if isFirstLaunch(){
            fetchTasks()
        }
        view.backgroundColor = .black
        setupNavigationController()
        setupUI()
    }
    
    @objc func buttonTapped() {
        let date = fetchCurrentDate()
        saveTask(todo: "Название задачи", descript: "Описание задачи", completed: false, date: date)
        pushEditViewController(title: "Название задачи", desrip: "Описание задачи", completed: false, date: date, index: tasks.count - 1)
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .fromHex("F4F4F4")
        title = "Задачи"
    }
    
    private func setSearchField(){
        searchField.backgroundColor = .fromHex("272729")
        searchField.textColor = .fromHex("F4F4F4")
        searchField.setPlaceholder("Search", leftIcon: UIImage(systemName: "magnifyingglass"), rightIcon: UIImage(systemName: "mic.fill"))
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.layer.cornerRadius = 15
        view.addSubview(searchField)
    }
    
    private func setToolbar(){
        toolbar.backgroundColor = .fromHex("272729")
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbar)
    }
    
    private func setCountTasksLabel(){
        updateCountTasksLabel()
        countTasksLabel.font = UIFont(name: "Helvetica Neue", size: 15)
        countTasksLabel.sizeToFit()
        countTasksLabel.translatesAutoresizingMaskIntoConstraints = false
        toolbar.addSubview(countTasksLabel)
    }
    
    private func setCreateTaskButton(){
        createTaskButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        createTaskButton.tintColor = .fromHex("FED702")
        createTaskButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        createTaskButton.translatesAutoresizingMaskIntoConstraints = false
        toolbar.addSubview(createTaskButton)
    }
    
    private func setTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .none
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
    }
    
    private func setupUI() {
        setSearchField()
        setToolbar()
        setCountTasksLabel()
        setCreateTaskButton()
        setTableView()
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            searchField.heightAnchor.constraint(equalToConstant: 50),
            toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 83),
            countTasksLabel.centerXAnchor.constraint(equalTo: toolbar.centerXAnchor),
            countTasksLabel.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor, constant: -10),
            createTaskButton.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor, constant: -10),
            createTaskButton.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: toolbar.topAnchor)
        ])
    }
    
    func fetchCurrentDate() -> String{
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        let formattedDate = formatter.string(from: currentDate)
        return formattedDate
    }
    
    func updateCountTasksLabel(){
        countTasksLabel.text = isSearching ? "\(filteredTaskIndices.count) задач" : "\(tasks.count) задач"
    }
}

//MARK: - Table View

extension ViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredTaskIndices.count : tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        heightOfRow.append(cell.descriptionTask.numberOfLines)
        let task: Task
        if isSearching {
            let index = filteredTaskIndices[indexPath.row]
            task = tasks[index]
        } else {
            task = tasks[indexPath.row]
        }
        
        cell.titleTask.text = task.todo
        cell.descriptionTask.text = task.descrip
        cell.imageViewCompleted.image = task.completed ? UIImage(named: "checkmark") : UIImage(named: "circle")
        cell.dateLabel.text = task.date
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index: Int
        if isSearching {
            index = filteredTaskIndices[indexPath.row]
        } else {
            index = indexPath.row
        }
        let task = tasks[index]
        updateTask(todo: task.todo!, descript: task.descrip!, completed: !task.completed, date: task.date!, index: index)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let localIndex = isSearching ? filteredTaskIndices[indexPath.row] : indexPath.row
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] suggestedActions in
            
            let editAction = UIAction(title: "Редактировать", image: UIImage(named: "edit")?.withTintColor(.fromHex("F4F4F4"))) { [weak self] action in
                
                self?.pushEditViewController(title: self?.tasks[localIndex].todo ?? "Unknown", desrip: self?.tasks[localIndex].descrip ?? "Unknown", completed: self?.tasks[localIndex].completed ?? false, date: self?.tasks[localIndex].date ?? "Unknown", index: indexPath.row)
            }
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")?.withTintColor(.fromHex("F4F4F4"))) { [weak self] action in
                
                let shareText = "Название задачи: \(self?.tasks[localIndex].todo ?? "Unknown"), описание задачи: \(self?.tasks[localIndex].descrip ?? "Unknown"), статус задачи: \((((self?.tasks[localIndex].completed) != nil) ? "Не выполнена" : "Выполнена") ?? "Unknown"), время постановления: \(self?.tasks[localIndex].date ?? "Unknown")"
                let shareController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
                
                shareController.completionWithItemsHandler = { _, bool, _, _ in
                    if bool == true{
                        print("Успешно!")
                    }
                }
                self?.present(shareController, animated: true, completion: nil)
            }
            
            let deleteAction = UIAction(title: "Удалить", image: UIImage(named: "delete"), attributes: .destructive) { [weak self] action in
                self?.deleteTask(at: localIndex)
            }
            
            return UIMenu(children: [editAction, shareAction, deleteAction])
        }
        
        return configuration
    }
}



//MARK: - Transfer data between VC
protocol DataTransferDelegate: AnyObject {
    func didTransferData(title: String, descrip: String, completed: Bool, date: String, index: Int)
}

extension ViewController: DataTransferDelegate{
    func didTransferData(title: String, descrip: String, completed: Bool, date: String, index: Int) {
        updateTask(todo: title, descript: descrip, completed: completed, date: date, index: index)
    }
    
    func pushEditViewController(title: String, desrip: String, completed: Bool, date: String, index: Int){
        let editViewController = EditViewController()
        editViewController.delegate = self
        editViewController.titleTask = title
        editViewController.descriptionTask = desrip
        editViewController.dateTask = date
        editViewController.completed = completed
        editViewController.indexOfTask = index
        navigationController?.pushViewController(editViewController, animated: true)
    }
}

//MARK: - Is first launch
extension ViewController{
    func isFirstLaunch() -> Bool{
        let defaults = UserDefaults.standard
        let hasLaunchedBefore = defaults.bool(forKey: "hasLaunchedBefore")
        
        if !hasLaunchedBefore {
            defaults.set(true, forKey: "hasLaunchedBefore")
            return true
        }
        return false
    }
}

//MARK: - CoreData
extension ViewController{
    
    func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func updateTask(todo: String, descript: String, completed: Bool, date: String, index: Int){
        let context = getContext()
        tasks[index].todo = todo
        tasks[index].descrip = descript
        tasks[index].date = date
        tasks[index].completed = completed
        do {
            try context.save()
            tableView.reloadData()
            updateCountTasksLabel()
        } catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    func deleteTask(at index: Int){
        let context = getContext()
        let task = tasks[index]
        do {
            context.delete(task)
            tasks.remove(at: index)
            if isSearching {
                searchTask(task: searchField.text ?? "")
            }
            tableView.reloadData()
            updateCountTasksLabel()
            try context.save()
        } catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    func saveTask(todo: String, descript: String, completed: Bool, date: String) {
        let context = getContext()
        
        DispatchQueue.global(qos: .background).sync {
            let taskObject = Task(context: context)
            taskObject.todo = todo
            taskObject.descrip = descript
            taskObject.completed = completed
            taskObject.date = date
            
            do {
                try context.save()
                tasks.append(taskObject)
                if isSearching {
                    searchTask(task: searchField.text ?? "")
                }
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                    self?.updateCountTasksLabel()
                }
            } catch let error as NSError {
                print("Error saving task: \(error.localizedDescription)")
            }
        }
    }
}

//MARK: - Searching among the tasks

extension ViewController{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        searchTask(task: searchField.text ?? "")
        return true
    }
    
    func searchTask(task: String) {
        guard task != "" else {
            isSearching = false
            filteredTaskIndices = []
            tableView.reloadData()
            return
        }
        
        isSearching = true
        filteredTaskIndices = tasks.enumerated().compactMap { index, taskItem in
            taskItem.todo?.localizedCaseInsensitiveContains(task) == true ? index : nil
        }
        updateCountTasksLabel()
        tableView.reloadData()
    }
}

//MARK: - Network
extension ViewController{
    
    func fetchTasks(){
        networkManager.fetchTasks { [weak self] result in
            switch result{
            case .success(let tasks):
                for i in 0..<tasks.todos.count{
                    self?.saveTask(todo: tasks.todos[i].todo, descript: tasks.todos[i].todo, completed: tasks.todos[i].completed, date: "01/01/24")
                }
                self?.updateCountTasksLabel()
                self?.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
