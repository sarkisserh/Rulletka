//
//  RatingVC.swift
//  rulletka
//
//  Created by MacBook on 15/08/2023.
//
import UIKit
import Firebase
import SnapKit

class RatingVC: UIViewController, UITableViewDelegate {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    let balanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let balanceImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "coins"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView ()
        return tableView
    }()
    
    var items = [RatingModel]()
    var balance: Int = 0 {
           didSet {
               balanceLabel.text = "\(balance)"
           }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        loadViews()
    }
    
    func setupViews() {
        view.addSubview(tableView)
        view.addSubview(nameLabel)
        view.addSubview(balanceLabel)
        view.addSubview(balanceImageView)
        view.backgroundColor = .lightGray
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }

        balanceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(41)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        balanceImageView.snp.makeConstraints { make in
               make.centerY.equalTo(balanceLabel)
               make.left.equalTo(balanceLabel.snp.right).offset(5)
               make.width.height.equalTo(20)
           }
        
        loadUserDataFromFirebase()
        
        func loadUserDataFromFirebase() {
            if let currentUser = Auth.auth().currentUser {
                let userID = currentUser.uid
                let ref = Database.database().reference()
                
                ref.child("users/\(userID)/name").getData(completion:  { error, snapshot in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return;
                    }
                    
                    if let name = snapshot?.value as? String {
                        DispatchQueue.main.async {
                            self.nameLabel.text = name
                        }
                    }
                });
                
                ref.child("users/\(userID)/balance").getData(completion:  { error, snapshot in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return;
                    }
                    
                    if let balance = snapshot?.value as? Int {
                        DispatchQueue.main.async {
                            self.balanceLabel.text = "Balance: \(balance)"
                        }
                    }
                });
            }
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(balanceLabel.snp.bottom).offset(15) 
            make.left.right.bottom.equalToSuperview()
        }

        
        tableView.register(RatingCell.self, forCellReuseIdentifier: RatingCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .lightGray
    }
    
    func loadViews() {
        setRatingItems()
    }
    private func createRatingItems() {
        setRatingItems()
    }

    private func setRatingItems() {
        var characters = [RatingModel]()
        let userID = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        ref.child("users").getData(completion:  { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            
            if let users = snapshot?.value as? [String: Any] {
                for id in users.keys {
                    if let user = users[id] as?  [String: Any] {
                        let name = user["name"] as? String ?? ""
                        let balance = user["balance"] as? Int ?? 0
                        let numberModel = RatingModel(name: name, balance: balance)
                        characters.append(numberModel)
                    }
                }
                // Отсортировать массив characters по balance в убывающем порядке
                self.items = characters.sorted(by: { $0.balance > $1.balance })
                self.tableView.reloadData()
            }
        })
    }
}
extension RatingVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RatingCell.reuseId, for: indexPath)
        
        guard let ratingcell = cell as? RatingCell else {
            return cell
        }
        
        let index = indexPath.row
        var item = getRatingItem(index: indexPath.row)
        
        ratingcell.setupCell(item: item, index: index)
        
        return ratingcell
    }
    
    func getRatingItem(index: Int) -> RatingModel {
        return items[index]
    }
}
