//
//  TaskListViewController.swift
//  Task Management
//
//  Created by MAC on 04/03/25.
//

import UIKit
import SwiftUI

final class TaskListViewController: BaseController {
    
    private var searchView: SearchView!
    private var collectionView: UICollectionView!
    
    private var taskManager: TaskManager!
    
    private lazy var priority_due_Btn: CustomButton = {
        let button = CustomButton()
        button.configureButton(title: "", bgColor: .orange)
        button.setImage(UIImage(systemName: "arrowtriangle.down.circle.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var addTaskBtn: CustomButton = {
        let button = CustomButton()
        button.configureButton(title: "", bgColor: .brandColor)
        button.setImage(UIImage(systemName: "plus.circle.dashed"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    var selectedIIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        UNUserNotificationCenter.current().setBadgeCount(0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchView.horiSearchStack.cornerRadiusWithBorder(isRound: true,isBorder: true,borWidth: 1,borColor: .darkGray)
        
    }
    
    private func setupView(){
        
        taskManager = TaskManager()
        taskManager.delegate = self
        
        view.backgroundColor = .BackgroundColor
        
        searchView = SearchView()
        view.addSubview(searchView)
        searchView.makeConstraints(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, edge: .zero, height: 55)
        
        searchView.searchDelegate = self
        
        searchView.moreOptionBtn.menu = createMenu()
        searchView.moreOptionBtn.showsMenuAsPrimaryAction = true
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.makeConstraints(top: searchView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, edge: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        let buttonsStackView = VerticalStack(arrangedSubViews: [priority_due_Btn, addTaskBtn], spacing: 16, alignment: .fill, distribution: .fillEqually)
        view.addSubview(buttonsStackView)
        buttonsStackView.makeConstraints(top: nil, leading: nil, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, edge: .init(top: 0, left: 0, bottom: 35, right: 20))
        
        addTaskBtn.equalSizeConstrinats(45)
        priority_due_Btn.equalSizeConstrinats(45)
        
        addTaskBtn.addTarget(self, action: #selector(createTaskAction(_:)), for: .touchUpInside)
        
        if let secPopularIndex = taskManager.taskCategories.firstIndex(where: { $0.isSelected }){
            selectedIIndexPath = IndexPath(item: 0, section: secPopularIndex)
        }
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(MostPopularCollectionCell.self, forCellWithReuseIdentifier: MostPopularCollectionCell.reuseIdentifer)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        
        priority_due_Btn.menu = createMenu()
        priority_due_Btn.showsMenuAsPrimaryAction = true
        
        searchView.moreOptionBtn.menu = categoryListMenu()
        searchView.moreOptionBtn.showsMenuAsPrimaryAction = true
    }
    
    @objc func createTaskAction(_ sender: UIButton){
        let taskDetailPage = TaskDetailsController(taskManager: taskManager)
        navigationController?.pushViewController(taskDetailPage, animated: true)
    }
    
}

extension TaskListViewController: SearchFieldAction{
    
    func beginSearch() {
    }
    
    func clearSearch() {
        taskManager.searchFields.searchQuery = ""
        
        taskManager.fetchTasks()
    }
    
    func searchWith(key word: String) {
        taskManager.searchFields.searchQuery = word
        
        taskManager.fetchTasks()
    }
    
    func closeSearch() {
        taskManager.searchFields.searchQuery = ""
        
        taskManager.fetchTasks()
    }
}

extension TaskListViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    private func createLayout()-> UICollectionViewCompositionalLayout{
        let layout = UICollectionViewCompositionalLayout{ [self] section, layoutEnvironment in
            if section == 0{
                return mostPopularLayout()
            }else{
                return taskListLayout()
            }
        }
        return layout
    }
    func mostPopularLayout()-> NSCollectionLayoutSection{
        
        let item = CompostionalLayout.createItem(width: .estimated(50), height: .estimated(50))
        
        let group = CompostionalLayout.createGroup(alignment: .horizonatal, width: .estimated(50), height: .estimated(50), items: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 5, leading: 5, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    func taskListLayout()-> NSCollectionLayoutSection{
        let item1 = CompostionalLayout.createItem(width: .fractionalWidth(1), height: .estimated(300))
        
        let group1 = CompostionalLayout.createGroup(alignment: .horizonatal, width: .fractionalWidth(1.0), height: .estimated(300), items: [item1])
        group1.interItemSpacing = .fixed(10)
        
        let section1 = NSCollectionLayoutSection(group: group1)
        section1.interGroupSpacing = 10
        section1.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        return section1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? taskManager.taskStatus.count : taskManager.fetchedResultsController.fetchedObjects?.count ?? 0
        //taskManager.fetchedObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MostPopularCollectionCell.reuseIdentifer, for: indexPath) as? MostPopularCollectionCell else{ return UICollectionViewCell() }
            let task_ = taskManager.taskStatus[indexPath.item]
            cell.setupData(task_)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            let result = taskManager.fetchedResultsController.fetchedObjects?[indexPath.item]
            cell.contentConfiguration = UIHostingConfiguration(content: {
                VStack(alignment: .leading) {
                    
                    let dueDate = (result?.dueDate ?? Date())
                    let isupComing = DateHelpers.isUpcoming(dueDate)
                    let taskExpired = DateHelpers.isDateExpired(dueDate)
                    let isCompleted = (result?.isCompleted) ?? false
                    let flag = (result?.priority)
                    let category = (result?.category)
                    
                    HStack{
                        Menu {
                            Button("Completed") { [weak self] in
                                guard let result else{ return }
                                guard let self else{ return }
                                let updatedStatus = taskManager.updateTask(task: result, taskStatus: .completed)
                                if updatedStatus{
                                    //collectionView.reloadItems(at: [indexPath])
                                    taskManager.fetchTasks()
                                }
                            }
                            Button("Upcoming") { [weak self] in
                                guard let result else{ return }
                                guard let self else{ return }
                                let updatedStatus = taskManager.updateTask(task: result, taskStatus: .upcoming)
                                if updatedStatus{
                                    //collectionView.reloadItems(at: [indexPath])
                                    taskManager.fetchTasks()
                                }
                            }
                            Button("Overdue") { [weak self] in
                                guard let result else{ return }
                                guard let self else{ return }
                                let updatedStatus = taskManager.updateTask(task: result, taskStatus: .overdue)
                                if updatedStatus{
                                    //collectionView.reloadItems(at: [indexPath])
                                    taskManager.fetchTasks()
                                }
                            }
                        } label: {
                            Text(isCompleted ? "Completed" : isupComing ? "Upcoming" : "OverDue")
                                .foregroundColor(isCompleted ? .green : taskExpired ? .red : .orange)
                                .font(.custom("Poppins-SemiBold", size: 17))
                        }
                        .disabled(isCompleted || !isupComing)
                        
                        if let category{
                            Text(category)
                                .foregroundColor(.mint)
                                .font(.custom("Poppins-Medium", size: 16))
                        }
                        Spacer()
                        if let flag = flag, let priortity = Priority(rawValue: Int(flag)){
                            HStack(spacing: 6){
                                Image(systemName: "flag.fill")
                                    .resizable().frame(width: 20, height: 20)
                                    .foregroundStyle(priortity == .high ? .red : priortity == .medium ? .orange : .black)
                                Text(priortity.value)
                                    .foregroundColor(priortity == .high ? .red : priortity == .medium ? .orange : .black)
                                    .font(.custom("Poppins-Medium", size: 15))
                            }
                        }
                    }
                    (
                        Text(result?.title ?? "-")
                            .foregroundStyle(.black)
                            .font(.custom("Poppins-Medium", size: 16))
                        +
                        
                        Text("\t")
                        
                        +
                        Text((DateHelpers.formattedDate(dueDate)))
                            .foregroundStyle(.purple)
                            .font(.custom("Poppins-Regular", size: 14))
                    )
                    Text(result?.desc ?? "-")
                        .foregroundStyle(.black)
                        .font(.custom("Poppins-Regular", size: 14))
                    
                    HStack(spacing: 6){
                        Image(systemName: "location.fill")
                            .resizable().frame(width: 20, height: 20)
                            .foregroundStyle(.black)
                        
                        Text(result?.location_name ?? "-")
                            .foregroundStyle(.black)
                            .font(.custom("Poppins-Regular", size: 14))
                    }
                    Divider()
                        .frame(height: 1)
                }
            })
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0{
            if let selectedIIndexPath,selectedIIndexPath != indexPath{
                taskManager.taskStatus[selectedIIndexPath.item].isSelected.toggle()
                collectionView.reloadItems(at: [selectedIIndexPath])
                
                self.selectedIIndexPath = indexPath
                taskManager.taskStatus[indexPath.item].isSelected.toggle()
                collectionView.reloadItems(at: [indexPath])
                taskStatusChanges()
            }else if let selectedIIndexPath,selectedIIndexPath == indexPath{
                print("same category selected")
            }else{
                taskManager.taskStatus[indexPath.item].isSelected.toggle()
                collectionView.reloadItems(at: [indexPath])
                selectedIIndexPath = indexPath
                taskStatusChanges()
            }
        }
    }
    
    func taskStatusChanges(){
        if let selectedIIndexPath{
            taskManager.searchFields.taskStatus = taskManager.taskStatus[selectedIIndexPath.item].name
            taskManager.fetchTasks()
        }
    }
    
    func categoryChanges(){
        if let selectedIIndexPath{
            taskManager.searchFields.category = taskManager.taskCategories[selectedIIndexPath.item].name
        }
    }
    
}


extension TaskListViewController{
    
    func createMenu() -> UIMenu {
        
        let dueDateAction = UIAction(title: "Due Date") { [weak self] _ in
            guard let self = self else { return }
            taskManager.searchFields.sortByDueDate.toggle()
            taskManager.fetchTasks()
            priority_due_Btn.menu = createMenu()
        }
        dueDateAction.state = taskManager.searchFields.sortByDueDate ? .on : .off
        
        let priorityAction = UIAction(title: "Priority") { [weak self] _ in
            guard let self = self else { return }
            taskManager.searchFields.sortByPriority.toggle()
            taskManager.fetchTasks()
            priority_due_Btn.menu = createMenu()
        }
        priorityAction.state = taskManager.searchFields.sortByPriority ? .on : .off
        
        return UIMenu(title: "", options: .displayInline, children: [dueDateAction, priorityAction])
    }
    
    private func categoryListMenu() -> UIMenu{
        
        let categories = taskManager.taskCategories.map{ $0.name }
        
        let categoryActions = categories.map { category in
            UIAction(title: category.rawValue, image: nil, state: category == taskManager.searchFields.category ? .on : .off) { [weak self] _ in
                guard let self = self else{ return }
                taskManager.searchFields.category = category
                taskManager.fetchTasks()
                searchView.moreOptionBtn.menu = categoryListMenu()
            }
        }
                
        let categoryMenu = UIMenu(title: "Category", options: .displayInline, children: categoryActions)
        
        return categoryMenu
    }
}
extension TaskListViewController: TaskManagerDelegate{
    
    func fetchInitalTask() {
        print("inital fetch called")
        
        if collectionView.numberOfSections >= 1{
            collectionView.reloadSections(IndexSet(integer: 1))
        }

        //collectionView.reloadData()
    }
    
    func didChangeTasks() {
        print("didChangeTasks called")
        if collectionView.numberOfSections >= 1{
            collectionView.reloadSections(IndexSet(integer: 1))
        }
        //collectionView.reloadData()
    }
    
}
struct DateHelpers{
    
    static func formattedDate(_ date: Date, withFormat format: String = "dd/MM/yyyy h:mm a") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    static func isUpcoming(_ date: Date) -> Bool {
        return date >= Date()
    }
    
    static func isDateExpired(_ date: Date) -> Bool {
        return date < Date()
    }
}
