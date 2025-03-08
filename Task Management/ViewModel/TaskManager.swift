//
//  TaskManager.swift
//  TaskEntity Management
//
//  Created by MAC on 04/03/25.
//

import CoreData

protocol TaskManagerDelegate: AnyObject {
    func fetchInitalTask()
    func didChangeTasks()
}


struct CatgorySection{
    var name: CategoryRow
    var isSelected: Bool
}

struct TaskSection{
    var name: TaskStatus
    var isSelected: Bool
}

class TaskManager: NSObject, NSFetchedResultsControllerDelegate {
    
    weak var delegate: TaskManagerDelegate?
    
    var taskCategories: [CatgorySection] = CategoryRow.allCases.map{ CatgorySection(name: $0, isSelected: $0 == .all) }
    
    var taskStatus: [TaskSection] = TaskStatus.allCases.map{ TaskSection(name: $0, isSelected: $0 == .all) }
    
    var searchFields: SearchQueryFields = SearchQueryFields()

    private let context = CoreDataManager.shared.context
    
    private(set) var fetchedObjects: [TaskEntity] = []
    
    var fetchedResultsController: NSFetchedResultsController<TaskEntity>!
    
    override init() {
        super.init()
        fetchTasks()
    }

    func createTask(taskData: TaskData, isCompleted: Bool)-> Bool{
        let task = TaskEntity(context: context)
        task.title = taskData.title
        task.priority = Int16(taskData.priority.rawValue)
        task.longtitude = Double(taskData.coordinate.longitude)
        task.location_name = taskData.location
        task.latitude = Double(taskData.coordinate.latitude)
        task.isCompleted = isCompleted
        task.dueDate = taskData.due_date
        task.desc = taskData.desc
        task.createdAt = Date()
        task.notification_id = taskData.notificationId
        task.category = taskData.category.rawValue
        task.status = TaskStatus.upcoming.rawValue
        
        NotificationManager.instance.scheduleNotification(with: taskData)
        
        return save()
        
    }

    func fetchAllTasks() {
        fetchedObjects = fetchedResultsController.fetchedObjects ?? []
        DispatchQueue.main.async{ [weak self] in
            self?.delegate?.fetchInitalTask()
        }
    }
    
    func updateTask(task: TaskEntity, taskStatus: TaskStatus)-> Bool {
        task.isCompleted = taskStatus == .completed
        task.status = taskStatus.rawValue
        if taskStatus == .completed{
            if let notificationId = task.notification_id{
                NotificationManager.instance.cancelNotification(with: notificationId)
            }
        }
        return save()
    }
    
    func deleteTask(task: TaskEntity)-> Bool {
        context.delete(task)
        return save()
    }
    
    private func save()-> Bool {
        if context.hasChanges {
            do {
                try context.save()
                return true
            } catch {
                print("Error saving context: \(error)")
                return false
            }
        }
        
        return true
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        print("controllerDidChangeContent called")
        DispatchQueue.main.async{ [weak self] in
            self?.delegate?.fetchInitalTask()
        }
    }
}


extension TaskManager{
    
    func fetchTasks() {
        
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        var predicates: [NSPredicate] = []

        if let searchQuery = searchFields.searchQuery, !searchQuery.isEmpty {
            let titlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchQuery)
            let descPredicate = NSPredicate(format: "desc CONTAINS[cd] %@", searchQuery)
            predicates.append(NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate, descPredicate]))
        }

        if searchFields.category != .all {
            predicates.append(NSPredicate(format: "category == %@", searchFields.category.rawValue))
        }

        if let priority = searchFields.priortity {
            predicates.append(NSPredicate(format: "priority == %@", priority.rawValue))
        }

        let today = Date()
            
        let statusPredicate: NSPredicate?
        switch searchFields.taskStatus {
        case .all:
            statusPredicate = nil
        case .completed:
            statusPredicate = NSPredicate(format: "isCompleted == true")
        case .upcoming:
            statusPredicate = NSPredicate(format: "isCompleted == false AND dueDate >= %@", Date() as NSDate)
        case .overdue:
            //let overdueThreshold = today.timeIntervalSinceReferenceDate
            //statusPredicate = NSPredicate(format: "isCompleted == false AND dueDate.timeIntervalSinceReferenceDate < %f", overdueThreshold)

            statusPredicate = NSPredicate(format: "isCompleted == false AND dueDate < %@", Date() as NSDate)
        }
        
        if let statusPredicate = statusPredicate {
            predicates.append(statusPredicate)
        }

        var sortDescriptors: [NSSortDescriptor] = []

        if searchFields.sortByDueDate {
            sortDescriptors.append(NSSortDescriptor(key: "dueDate", ascending: true))
        }
        
        if searchFields.sortByPriority {
            sortDescriptors.append(NSSortDescriptor(key: "priority", ascending: false))
        }

        if sortDescriptors.isEmpty {
            sortDescriptors.append(NSSortDescriptor(key: "createdAt", ascending: false))
        }
        
        fetchRequest.predicate = predicates.isEmpty ? nil : NSCompoundPredicate(andPredicateWithSubpredicates: predicates)

        
        fetchRequest.sortDescriptors = sortDescriptors
        
        fetchedResultsController = nil
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self

        
        do {
            try fetchedResultsController.performFetch()
            print("inside perform : \(fetchedResultsController.fetchedObjects?.count ?? -1)")
            
            fetchedObjects = fetchedResultsController.fetchedObjects ?? []
            DispatchQueue.main.async{ [weak self] in
                self?.delegate?.fetchInitalTask()
            }
        } catch {
            print("Error fetching tasks: \(error.localizedDescription)")
            
            fetchedObjects = fetchedResultsController.fetchedObjects ?? []
            DispatchQueue.main.async{ [weak self] in
                self?.delegate?.fetchInitalTask()
            }
        }
        
    }

}


enum CategoryRow: String, CaseIterable{
    case all = "All"
    case work = "Work"
    case personal = "Personal"
    case shopping = "Shopping"
    case fitness = "Fitness"
}

struct SearchQueryFields{
    var searchQuery: String?
    var category: CategoryRow = .all
    var priortity: Priority?
    var taskStatus: TaskStatus = .all
    var sortByDueDate: Bool = false
    var sortByPriority: Bool = false
}

enum TaskStatus: String, CaseIterable {
    case all = "All"
    case completed = "Completed"
    case upcoming = "Upcoming"
    case overdue = "OverDue"
}
