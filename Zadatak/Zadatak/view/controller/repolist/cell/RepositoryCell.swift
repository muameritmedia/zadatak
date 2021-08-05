//
//  RepositoryCell.swift
//  Zadatak
//
//  Created by Muamer Beginovic on 4. 8. 2021..
//

import UIKit
import Kingfisher


class RepositoryCell: UITableViewCell {
    
    
    private let imageViewRepository = UIImageView()
    private let labelRepositoryTitle = UILabel()
    private let labelRepositoryDescription = UILabel()
    private let labelRepositoryForks = UILabel()
    private let labelRepositoryWatchers = UILabel()
    private let stackViewForksWatchers = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        addSubview(imageViewRepository)
        addSubview(labelRepositoryTitle)
        addSubview(labelRepositoryDescription)
        addSubview(stackViewForksWatchers)
        
        setUpRepositoryImageView()
        setUpForkStarStackView()
        setUpRepositoryTitleLabel()
        setUpRepositoryDescriptionLabel()
        
        
        setUpRepositoryForksLabel()
        setUpRepositoryStarsLabel()

        
        
        
        
        
    }
    
    func setUpRepositoryImageView() {
        imageViewRepository.translatesAutoresizingMaskIntoConstraints = false
        imageViewRepository.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        imageViewRepository.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        imageViewRepository.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageViewRepository.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        imageViewRepository.clipsToBounds = true
        imageViewRepository.heightAnchor.constraint(equalToConstant: 92.0).isActive = true
        imageViewRepository.contentMode = .scaleAspectFit
    }
    
    func setUpRepositoryTitleLabel() {
        
        labelRepositoryTitle.translatesAutoresizingMaskIntoConstraints = false
        labelRepositoryTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        labelRepositoryTitle.leadingAnchor.constraint(equalTo: self.imageViewRepository.trailingAnchor, constant: 8).isActive = true
        labelRepositoryTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        
        labelRepositoryTitle.numberOfLines = 1
        labelRepositoryTitle.font = UIFont.boldSystemFont(ofSize: 14)
        
    }
    
    func setUpRepositoryDescriptionLabel() {
        
        labelRepositoryDescription.translatesAutoresizingMaskIntoConstraints = false
        labelRepositoryDescription.topAnchor.constraint(equalTo: self.labelRepositoryTitle.bottomAnchor, constant: 4).isActive = true
        labelRepositoryDescription.leadingAnchor.constraint(equalTo: self.imageViewRepository.trailingAnchor, constant: 8).isActive = true
        labelRepositoryDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        
        labelRepositoryDescription.numberOfLines = 2
        labelRepositoryDescription.font = UIFont.systemFont(ofSize: 14)
        labelRepositoryDescription.textColor = .gray

    }
    
    func setUpRepositoryForksLabel() {
        
        labelRepositoryForks.font = UIFont.systemFont(ofSize: 14)
        
    }
    
    func setUpRepositoryStarsLabel() {

        labelRepositoryWatchers.font = UIFont.systemFont(ofSize: 14)
        
    }
    
    func setUpForkStarStackView() {
        
        stackViewForksWatchers.translatesAutoresizingMaskIntoConstraints = false
        stackViewForksWatchers.leadingAnchor.constraint(equalTo: self.imageViewRepository.trailingAnchor, constant: 8).isActive = true
        stackViewForksWatchers.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        stackViewForksWatchers.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8).isActive = true
        stackViewForksWatchers.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        stackViewForksWatchers.axis = .horizontal
        stackViewForksWatchers.alignment = .center
        
        stackViewForksWatchers.addArrangedSubview(labelRepositoryForks)
        stackViewForksWatchers.addArrangedSubview(labelRepositoryWatchers)
        
        stackViewForksWatchers.distribution = .fillEqually
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {


    }

    
    func configureCell(_ repository: RepositoryViewModel) {
        
        labelRepositoryTitle.text = repository.full_name
        labelRepositoryDescription.text = repository.description
        labelRepositoryForks.text = "Forks: \(repository.forks ?? 0)"
        labelRepositoryWatchers.text = "Watchers: \(repository.watchers ?? 0)"

        if let owner = repository.owner {
            
            if let image = owner.avatar_url {
                
                
                if let url = URL(string: image) {
                    imageViewRepository.kf.setImage(with: url)
                }
                
                
            }
            
        }
        
    }
    
    
    
    
}
