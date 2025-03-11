//
//  TaskDetailsController.swift
//  Task Management
//
//  Created by MAC on 04/03/25.
//

import UIKit
import MapKit

final class TaskDetailsController: BaseController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: CustomLabel!
    
    @IBOutlet weak var task_titleLbl: CustomLabel!
    @IBOutlet weak var titleTF: CustomTextField!
    
    @IBOutlet weak var task_descLbl: CustomLabel!
    @IBOutlet weak var descTxtView: PlaceholderTextView!
    
    @IBOutlet weak var task_dueDateLbl: CustomLabel!
    @IBOutlet weak var dueDateTF: CustomTextField!
    
    @IBOutlet weak var task_dueTimeLbl: CustomLabel!
    @IBOutlet weak var dueTimeTF: CustomTextField!
    
    @IBOutlet weak var task_catgoryLbl: CustomLabel!
    @IBOutlet weak var catgoryTF: CustomTextField!
    @IBOutlet weak var catgoryBtn: UIButton!
    
    @IBOutlet weak var task_priorityLbl: CustomLabel!
    @IBOutlet weak var priorityTF: CustomTextField!
    @IBOutlet weak var priorityBtn: UIButton!
    
    @IBOutlet weak var task_locationLbl: CustomLabel!
    @IBOutlet weak var locationTF: CustomTextField!
    
    @IBOutlet weak var saveButton: CustomButton!
    
    var selectedPlaceMark: MKPlacemark?
    
    private var taskManager: TaskManager
    
    var selectedDate: Date?
    
    var taskPriortity: Priority?
    var taskCategory: CategoryRow?
    
    init(taskManager: TaskManager) {
        self.taskManager = taskManager
        super.init(nibName: "TaskDetailsController", bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupView(){
        titleLbl.configureLabel(labeltext: "Create Task")
        
        task_titleLbl.configureLabel(labeltext: "Task Title")
        titleTF.configureTextField(placeholder: "Enter Task Title")
        
        task_descLbl.configureLabel(labeltext: "Task Details")
        descTxtView.placeholder = "Enter Task details"
        
        task_dueDateLbl.configureLabel(labeltext: "Due Date")
        dueDateTF.configureTextField(placeholder: "Enter Task Due Date")
        
        task_catgoryLbl.configureLabel(labeltext: "Task Category")
        catgoryTF.configureTextField(placeholder: "Choose Task Category")
        
        task_priorityLbl.configureLabel(labeltext: "Task Priority")
        priorityTF.configureTextField(placeholder: "Choose Task Priority")
        
        task_locationLbl.configureLabel(labeltext: "Location")
        locationTF.configureTextField(placeholder: "location")
        
        dueDateTF.setInputDatePickerView(.dateAndTime){ [weak self] selecteddate in
            self?.selectedDate = selecteddate
        }
        
        titleTF.delegate = self
        
        locationTF.addTarget(self, action: #selector(presentLocationPage), for: .editingDidBegin)
        catgoryBtn.menu = showCategoryMenu()
        catgoryBtn.showsMenuAsPrimaryAction = true
        
        priorityBtn.menu = showPriorityMenu()
        priorityBtn.showsMenuAsPrimaryAction = true
        
        saveButton.configureButton(title: "Save", bgColor: .brandColor)
        saveButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    
    private func makeButtonAvaliable(){
        saveButton.isEnabled = (try? validateTaskInputs()) ?? false
    }
    
    private func showCategoryMenu()-> UIMenu{
        let categories = taskManager.taskCategories.map{ $0.name }.dropFirst()
        
        let categoryActions = categories.map { category in
            UIAction(title: category.rawValue, state: category == taskCategory ? .on : .off) { [weak self] _ in
                guard let self = self else{ return }
                print("Selected category: \(category)")
                catgoryTF.text = category.rawValue
                taskCategory = category
                catgoryBtn.menu = showCategoryMenu()
            }
        }
        
        let categoryMenu = UIMenu(title: "Choose Category", children: categoryActions)
        
        return categoryMenu
    }
    
    private func showPriorityMenu()-> UIMenu{
        let priorityLevels = Priority.allCases
        let priorityActions = priorityLevels.map { level in
            UIAction(title: level.value, state: level == taskPriortity ? .on : .off) { [weak self] _ in
                guard let self = self else{ return }
                print("Selected priority: \(level)")
                priorityTF.text = level.value
                taskPriortity = level
                priorityBtn.menu = showPriorityMenu()
            }
        }
        let priorityMenu = UIMenu(title: "Set Priority", options: .displayInline, children: priorityActions)
        
        return priorityMenu
    }
    
    @objc private func presentLocationPage() {
        let mapPage = MapLocationController()
        mapPage.mapLocdelegate = self
        mapPage.dismiss(animated: true) { [weak self] in
            self?.locationTF.resignFirstResponder()
        }
        present(mapPage, animated: true)
    }
    
    @objc func buttonAction(_ sender: UIButton){
        switch sender{
        case backBtn:
            navigationController?.popViewController(animated: true)
            break
        case saveButton:
            taksSaveAction()
            break
        default: break
        }
    }
    
    private func taksSaveAction(){
        do{
            let _ = try validateTaskInputs()
            Task{
                let status = await CreateTask()
                
                if status{
                    print("Task Created...")
                    taskManager.fetchTasks()
                    navigationController?.popViewController(animated: true)
                }else{
                    print("Erorr creating on task")
                }
            }
        }catch let error as TaskValidationError {
            print("Validation Error: \(error.message)")
            AlertHelper.showCustomAlert(
                on: self,
                title: error.message,
                message: "",
                onOk: {
                }
            )

        } catch {
            print("Unexpected error: \(error)")
        }
    }
}

extension TaskDetailsController: UITextFieldDelegate, UITextViewDelegate{
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == dueDateTF{
            selectedDate = nil
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func CreateTask() async -> Bool{
        let title: String = titleTF.text ?? ""
        let desc: String = descTxtView.text ?? ""
        let dueDate = selectedDate ?? Date()
        let category: CategoryRow = taskCategory ?? .all
        let priority: Priority = taskPriortity ?? .low
        let location: String = locationTF.text ?? ""
        
        let task = TaskData(title: title, desc: desc, due_date: dueDate, category: category, priority: priority, location: location, coordinate: selectedPlaceMark!.coordinate)
        
        let status = taskManager.createTask(taskData: task, isCompleted: false)
        
        return status
    }
    
    func validateTaskInputs() throws -> Bool{
        
        let title: String? = titleTF.text
        let desc: String? = descTxtView.text
        let dueDate: String? = dueDateTF.text
        let category: String? = catgoryTF.text
        let priority: String? = priorityTF.text
        let location: String? = locationTF.text
        
        guard let title = title, !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw TaskValidationError.emptyTitle
        }
        
        guard let desc = desc, !desc.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw TaskValidationError.emptyDescription
        }
        
        if selectedDate == nil {
            throw TaskValidationError.emptyDueDate
        }
        
        guard let dueDate = dueDate, !dueDate.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw TaskValidationError.emptyDueDate
        }
        
        guard let category = category, !category.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw TaskValidationError.emptyCategory
        }
        
        guard let priority = priority, !priority.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw TaskValidationError.emptyPriority
        }
        
        guard let location = location, !location.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw TaskValidationError.emptyLocation
        }
        
        return true
    }

}
extension TaskDetailsController: MapSettingsPlaceMark{
    func getfetchedUserPlaceMark(with place: MKPlacemark) {
        locationTF.text = place.title
        selectedPlaceMark = place
    }
}

extension UITextField{
    
    private class DatePickerWrapper {
        var onDateSelected: ((Date) -> Void)?
    }
    
    private var datePickerWrapper: DatePickerWrapper {
        get {
            if let wrapper = objc_getAssociatedObject(self, &AssociatedKeys.datePickerWrapper) as? DatePickerWrapper {
                return wrapper
            }
            let wrapper = DatePickerWrapper()
            objc_setAssociatedObject(self, &AssociatedKeys.datePickerWrapper, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return wrapper
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.datePickerWrapper, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private struct AssociatedKeys {
        static var datePickerWrapper = "datePickerWrapper"
    }

    func setInputDatePickerView(_ mode: UIDatePicker.Mode = .date, minDate: Date = Date(), completion: @escaping (Date) -> Void){
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 300))
        datePicker.datePickerMode = mode
        datePicker.preferredDatePickerStyle = .wheels
        let minimum_day = Calendar.current.isDateInToday(minDate) ? minDate : nil
        let maximum_day: Date? = nil//Date()
        datePicker.minimumDate = minimum_day
        datePicker.maximumDate = maximum_day
        
        // Store the callback in the wrapper object
        datePickerWrapper.onDateSelected = completion

        self.inputView = datePicker
        let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        toolbar.setItems([cancelButton,flexible,doneButton], animated: true)
        inputAccessoryView = toolbar
    }
    @objc func cancelTapped(){
        resignFirstResponder()
    }
    @objc func doneTapped(){
        if let datepicker = inputView as? UIDatePicker{
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            dateformatter.dateFormat = datepicker.datePickerMode == .time ? "h:mm: a" : "dd/MM/yyyy h:mm: a"
            text = dateformatter.string(from: datepicker.date)
            
            datePickerWrapper.onDateSelected?(datepicker.date)
        }
        resignFirstResponder()
    }
}


struct TaskData{
    var title: String
    var desc: String
    var due_date: Date
    var category: CategoryRow
    var priority: Priority
    var location: String
    var notificationId: String = UUID().uuidString
    var coordinate: CLLocationCoordinate2D
}

enum TaskValidationError: Error {
    case emptyTitle
    case emptyDescription
    case emptyDueDate
    case emptyCategory
    case emptyPriority
    case emptyLocation
    
    var message: String {
        switch self {
        case .emptyTitle: return "Title cannot be empty."
        case .emptyDescription: return "Description cannot be empty."
        case .emptyDueDate: return "Due date cannot be empty."
        case .emptyCategory: return "Category cannot be empty."
        case .emptyPriority: return "Priority cannot be empty."
        case .emptyLocation: return "Location cannot be empty."
        }
    }
}
extension String{
    
    func convertToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent parsing
        dateFormatter.timeZone = TimeZone.current

        return dateFormatter.date(from: self) ?? Date()
    }
}

public enum Priority: Int, CaseIterable{
    case high = 2
    case medium = 1
    case low = 0
    
    var value: String{
        switch self{
        case .high: return "High"
        case .medium: return "Medium"
        case .low: return "Low"
        }
    }
}
