import UIKit

class EditViewController: UIViewController, UITextFieldDelegate {

    weak var delegate: DataTransferDelegate?
    
    var titleTask = "Title"
    var descriptionTask = "Description"
    var dateTask = "01/01/24"
    var completed: Bool = false
    var indexOfTask: Int = 0
    
    let nameTextField = UITextField()
    let dateLabel = UILabel()
    let descriptionTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        nameTextField.delegate = self
        navigationController?.navigationBar.tintColor = .fromHex("FED702")
        setNameTextField()
        setDateLabel()
        setDescriptionTextView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        transferDataBack()
    }
    
    private func setNameTextField(){
        nameTextField.backgroundColor = .none
        nameTextField.backgroundColor = .none
        nameTextField.font = UIFont(name: "Helvetica Bold", size: 38)
        nameTextField.textColor = .fromHex("F4F4F4")
        nameTextField.text = titleTask
        nameTextField.layoutMargins = .zero
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -30),
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 11),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setDateLabel(){
        dateLabel.font = UIFont(name: "Helvetica Neue", size: 17)
        dateLabel.textColor = .fromHex("8E8E8F")
        dateLabel.text = dateTask
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setDescriptionTextView(){
        descriptionTextView.font = UIFont(name: "Helvetica Neue", size: 19)
        descriptionTextView.textColor = .fromHex("F4F4F4")
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.text = descriptionTask
        
        view.addSubview(descriptionTextView)
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 7),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


//MARK: - Transfer edited data back
extension EditViewController{
    func transferDataBack() {
        delegate?.didTransferData(title: nameTextField.text ?? "Unknown", descrip: descriptionTextView.text ?? "Unknown", completed: completed, date: dateLabel.text ?? "Unknown", index: indexOfTask)
    }
}

extension EditViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
}
