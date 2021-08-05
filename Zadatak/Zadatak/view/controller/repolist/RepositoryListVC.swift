//
//  RepositoryListVC.swift
//  Zadatak
//
//  Created by Muamer Beginovic on 4. 8. 2021..
//

import UIKit


class RepositoryListVC: UIViewController {
    
    
    
    private var tableViewRepositories: UITableView!
    private let activityIndicatorLoading = UIActivityIndicatorView()
    private let refreshControl = UIRefreshControl()
    
    private let stackViewHeader = UIStackView()
    
    private var segmentedControlSort: UISegmentedControl!
    private let textFieldSearch = UITextField()

    private let repositoryListViewModel = RepositoryListViewModel()
    
    private lazy var guide = view.safeAreaLayoutGuide

    private var sortingOptions = ["Stars","Forks","Updated"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        title = "Repository List"
        

        setUpViews()

        fetchRepositorys()
        
    }
    
    
    private func setUpViews() {
        setUpSearchTextField()
        setUpSegmentedControl()
        setUStackViewHeader()
        setUpTableView()
        setUpLoadingActivityIndicator()
    }
    
    private func setUStackViewHeader() {
        
        view.addSubview(stackViewHeader)
        stackViewHeader.translatesAutoresizingMaskIntoConstraints = false
        stackViewHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        stackViewHeader.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8).isActive = true
        stackViewHeader.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16).isActive = true

        stackViewHeader.axis = .vertical
        stackViewHeader.alignment = .fill
        stackViewHeader.spacing = 8
        
        stackViewHeader.addArrangedSubview(textFieldSearch)
        stackViewHeader.addArrangedSubview(segmentedControlSort)
        
        stackViewHeader.distribution = .fillProportionally
        
        
    }
    
    private func setUpSearchTextField() {
        
        textFieldSearch.borderStyle = UITextField.BorderStyle.roundedRect
        textFieldSearch.placeholder = "Search..."
        
        
        textFieldSearch.addTarget(self, action: #selector(searchFieldDidChange), for: .editingChanged)
        
        
    }
    
    private func setUpSegmentedControl() {
        
        segmentedControlSort = UISegmentedControl(items: sortingOptions)
       
        segmentedControlSort.addTarget(self, action: #selector(self.segmentedValueChanged(_:)), for: .valueChanged)

        segmentedControlSort.isHidden = true
    }
    
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!) {
        repositoryListViewModel.sort = sortingOptions[sender.selectedSegmentIndex].lowercased()
        
        resetFetch()
        
        fetchFilteredRepositorys()
    }
    
    @objc func searchFieldDidChange(_ textField: UITextField) {
        
        guard let string = textField.text else {return}
        
        repositoryListViewModel.searchString = string
        
 
        
        segmentedControlSort.isHidden = !(string.count > 2)
        
        if string.count > 2 {
            resetFetch()
            fetchFilteredRepositorys()
            
        } else if string.isEmpty {
            
            resetFetch()
            fetchRepositorys()
            
        }
        
    }
    
    private func resetFetch() {
        repositoryListViewModel.page = 1
        tableViewRepositories.reloadData()
    }
    
    
    private func setUpLoadingActivityIndicator() {
        
        activityIndicatorLoading.center = self.view.center
        activityIndicatorLoading.tintColor = .red
        self.view.addSubview(activityIndicatorLoading)

        
        activityIndicatorLoading.style = .large
        activityIndicatorLoading.startAnimating()
        activityIndicatorLoading.hidesWhenStopped = true
        
        
    }
    
    private func setUpTableView() {
        
        tableViewRepositories = UITableView()
        
        tableViewRepositories.estimatedRowHeight = 100
        tableViewRepositories.rowHeight = UITableView.automaticDimension
        
        
        
        view.addSubview(tableViewRepositories)
        tableViewRepositories.translatesAutoresizingMaskIntoConstraints = false
        tableViewRepositories.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableViewRepositories.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableViewRepositories.topAnchor.constraint(equalTo: self.stackViewHeader.bottomAnchor, constant: 16).isActive = true
        tableViewRepositories.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        
        
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)

        tableViewRepositories.addSubview(refreshControl)
        
        
        view.layoutIfNeeded()
        
        
        
//        tableViewRepositories.separatorStyle = .none
        
        tableViewRepositories.register(RepositoryCell.self, forCellReuseIdentifier: "RepositoryCell")
        
        
        tableViewRepositories.delegate = self
        tableViewRepositories.dataSource = self
        
        
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
        repositoryListViewModel.searchString.count > 2 ? fetchFilteredRepositorys() : fetchRepositorys()
    }
    
    
    private func fetchRepositorys() {
        repositoryListViewModel.updateList() {[weak self] (response) in
            
            switch response {
            case .ok:
                self?.tableViewRepositories.reloadData()
            case .error:
                print("Error")
                
            }
            
            DispatchQueue.main.async {
                if ((self?.refreshControl.isRefreshing) != nil) { self?.refreshControl.endRefreshing() }
                self?.activityIndicatorLoading.stopAnimating()
            }
            
        }
    }
    
    private func fetchFilteredRepositorys() {
        activityIndicatorLoading.startAnimating()
        repositoryListViewModel.filterRepositoryList() {[weak self] (response) in
            
            switch response {
            case .ok:
                self?.tableViewRepositories.reloadData()
            case .error:
                print("Error")
                
            }
            
            DispatchQueue.main.async {
                if ((self?.refreshControl.isRefreshing) != nil) { self?.refreshControl.endRefreshing() }
                self?.activityIndicatorLoading.stopAnimating()
            }
            
        }
        
    }
    
    
    private func openDetails(_ repositoryViewModel: RepositoryViewModel) {
        
        if let navigator = navigationController {
            
            let controller = RepositoryDetailsVC()
            controller.repositoryViewModel = repositoryViewModel
            
            navigator.pushViewController(controller, animated: true)
            
        }
        
    }
    
    
    
}



extension RepositoryListVC: UITableViewDataSource, UITableViewDelegate {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryListViewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as? RepositoryCell {
            
            cell.selectionStyle = .none
            cell.configureCell(repositoryListViewModel.itemAtIndex(indexPath.row))
            
            return cell
        }
        
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        openDetails(repositoryListViewModel.itemAtIndex(indexPath.row))
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = repositoryListViewModel.numberOfRowsInSection() - 10
        if repositoryListViewModel.pagingEnabled && indexPath.row == lastElement {
            activityIndicatorLoading.startAnimating()
            repositoryListViewModel.page += 1
            repositoryListViewModel.searchString.isEmpty ? fetchRepositorys() : fetchFilteredRepositorys()
            
        }
    }
    
    
    
}
