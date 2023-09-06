//
//  ViewController.swift
//  fireBaseApp
//
//  Created by macbook on 13.08.2023.
//

import UIKit
import Firebase
import StoreKit

class SettingsVC: UIViewController {
    @IBOutlet weak var logOutButton: UIButton!
    
    @IBOutlet weak var rateappButton: UIButton!
    
    @IBOutlet weak var shareGameButton: UIButton!
    
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var balance = 0 {
        didSet {
            balanceLabel.text = String(balance)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButton()
        view.backgroundColor = .lightGray
        
        let userID = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        ref.child("users/\(userID)/balance").getData(completion:  { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            self.balance = snapshot?.value as? Int ?? 0
        });
        
        ref.child("users/\(userID)/name").getData(completion:  { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            self.nameLabel.text = snapshot?.value as? String ?? "Name"
        });
    }
    func configureButton(){
        logOutButton.layer.cornerRadius = 15
        rateappButton.layer.cornerRadius = 15
        shareGameButton.layer.cornerRadius = 15
        deleteAccountButton.layer.cornerRadius = 15
    }
    
    @IBAction func rateAppAction(_ sender: Any) {
        SKStoreReviewController.requestReview()
        
    }
    
    @IBAction func shareGameAction(_ sender: Any) {
        
        let items:[Any] = ["Rulletka for Traffbraza"]
        
        let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        self.present(avc, animated: true)
    }
    
    @IBAction func deleteAccountAction(_ sender: Any) {
        let user = Auth.auth().currentUser
        
        let alertController = UIAlertController(title: "Удаление аккаунта", message: "Вы уверены, что хотите удалить аккаунт?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
            user?.delete { error in
                if let error = error {
                    print("Ошибка при удалении аккаунта: \(error)")
                } else {
                    print("Аккаунт успешно удален")
                    // Также уберите данные пользователя из базы данных, если необходимо
                }
            }
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func logOutAction(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        }catch{
            print(error)
        }
        
    }
    
    
    
    
}
