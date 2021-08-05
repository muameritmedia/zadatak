//
//  RepositoryDetailsVC.swift
//  Zadatak
//
//  Created by Muamer Beginovic on 5. 8. 2021..
//

import UIKit

class RepositoryDetailsVC: UIViewController {

    
    var repositoryViewModel: RepositoryViewModel!
    
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageViewAvatar = UIImageView()
    private let labelAuthor = UILabel()
    private let labelTitle = UILabel()
    private let labelDescription = UILabel()
    private let stackViewForksWatchers = UIStackView()
    private let labelIssues = UILabel()
    private let labelRepositoryForks = UILabel()
    private let labelRepositoryWatchers = UILabel()

    private lazy var guide = view.safeAreaLayoutGuide
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        
        
        setUpViews()
        
        
    }
    
    
    private func setUpViews() {
        
        setupScrollView()
        setUpImageViewAvatar()
        setUpLabelAuthor()
        setUpLabelTitle()
        setUpLabelDescription()
        setUpForkStarStackView()
        setUpLabelIssues()
    }
    
    private func setUpImageViewAvatar() {
        
        contentView.addSubview(imageViewAvatar)
        imageViewAvatar.translatesAutoresizingMaskIntoConstraints = false
        imageViewAvatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        imageViewAvatar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        imageViewAvatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24).isActive = true
        imageViewAvatar.heightAnchor.constraint(equalToConstant: 250.0).isActive = true
        imageViewAvatar.contentMode = .scaleAspectFit
        view.layoutIfNeeded()
        
        
        imageViewAvatar.isUserInteractionEnabled = true
        
        imageViewAvatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageAvatarTapped)))
        
        if let owner = repositoryViewModel.owner {
            
            if let image = owner.avatar_url {
                
                if let url = URL(string: image) {
                    imageViewAvatar.kf.setImage(with: url)
                }
                
            }
            
        }
        
        
    }
    
    private func setUpLabelAuthor() {
        
        contentView.addSubview(labelAuthor)
        labelAuthor.translatesAutoresizingMaskIntoConstraints = false
        labelAuthor.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        labelAuthor.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        labelAuthor.topAnchor.constraint(equalTo: imageViewAvatar.bottomAnchor, constant: 16).isActive = true
        labelAuthor.textAlignment = .center
        labelAuthor.font =  UIFont.systemFont(ofSize: 14)
        labelAuthor.numberOfLines = 0
        
        if let name = repositoryViewModel.owner?.login {
            labelAuthor.text = "Author: \(name.uppercased())"
        }
        

        labelAuthor.isUserInteractionEnabled = true
        
        
        
    }
    
    private func setUpLabelTitle() {
        
        contentView.addSubview(labelTitle)
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        labelTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        labelTitle.topAnchor.constraint(equalTo: labelAuthor.bottomAnchor, constant: 16).isActive = true
        labelTitle.textAlignment = .center
        labelTitle.font =  UIFont.boldSystemFont(ofSize: 16)
        labelTitle.numberOfLines = 0
        if let full_name = repositoryViewModel.full_name {
            labelTitle.text = "Repository name: \(full_name.uppercased())"
        }
        

        labelTitle.isUserInteractionEnabled = true
        
        labelTitle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTitleTapped)))
        
        
    }
    
    @objc func labelTitleTapped() {
      
        if let repoUrl = repositoryViewModel.html_url {
            openBrowser(repoUrl)
        }
         
    }
    
    @objc func imageAvatarTapped() {
      
        if let ownerUrl = repositoryViewModel.owner?.html_url {
            openBrowser(ownerUrl)
        }
         
    }
    
    private func openBrowser(_ string: String) {
        if let url = URL(string: string) {
            UIApplication.shared.open(url)
        }
    }
    
    private func setUpLabelDescription() {
        
        view.addSubview(labelDescription)
        labelDescription.translatesAutoresizingMaskIntoConstraints = false
        labelDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        labelDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        labelDescription.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 16).isActive = true
        
        labelDescription.numberOfLines = 0
        labelDescription.font =  UIFont.systemFont(ofSize: 14)
        labelDescription.textColor = .gray
        labelDescription.text = repositoryViewModel.description
        
    }
    
    private func setUpForkStarStackView() {

        view.addSubview(stackViewForksWatchers)
        stackViewForksWatchers.translatesAutoresizingMaskIntoConstraints = false
        stackViewForksWatchers.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        stackViewForksWatchers.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        stackViewForksWatchers.topAnchor.constraint(equalTo: labelDescription.bottomAnchor, constant: 24).isActive = true

        stackViewForksWatchers.axis = .horizontal
        stackViewForksWatchers.alignment = .center
        
        stackViewForksWatchers.addArrangedSubview(labelRepositoryForks)
        stackViewForksWatchers.addArrangedSubview(labelRepositoryWatchers)
        
        stackViewForksWatchers.distribution = .fillEqually
        
        
        labelRepositoryForks.font = UIFont.systemFont(ofSize: 16)
        labelRepositoryWatchers.font = UIFont.systemFont(ofSize: 16)
        
        labelRepositoryForks.text = "Forks: \(repositoryViewModel.forks ?? 0)"
        labelRepositoryWatchers.text = "Watchers: \(repositoryViewModel.watchers ?? 0)"
        labelRepositoryWatchers.textAlignment = .right
        
    }

    func setupScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    
    private func setUpLabelIssues() {
        
        view.addSubview(labelIssues)
        labelIssues.translatesAutoresizingMaskIntoConstraints = false
        labelIssues.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        labelIssues.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        labelIssues.topAnchor.constraint(equalTo: stackViewForksWatchers.bottomAnchor, constant: 16).isActive = true
        labelIssues.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 16).isActive = true

        labelIssues.font = UIFont.systemFont(ofSize: 16)
        labelIssues.text = "Issues: \(repositoryViewModel.open_issues ?? 0)"
        
    }
    
    
}
