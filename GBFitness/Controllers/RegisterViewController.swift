//
//  RegisterViewController.swift
//  GBFitness
//
//  Created by Максим Лосев on 03.12.2022.
//

import UIKit

class RegisterViewController: UIViewController {
    
    //MARK: - Properties
    var user: User?
    var dataService = DataService()
    var coordinator: ApplicationCoordinator?
    
    //MARK: - Coordinator properties
    var onMap: (() -> Void)?
    
    //MARK: - IBOutlets
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmationField: UITextField!
    
    //MARK: - IBActions
    @IBAction func doneDidTapped(_ sender: Any) {
        saveUserData()
        coordinator = ApplicationCoordinator()
        coordinator?.registrationDone()
        coordinator?.start()
        onMap?()
    }
    
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Private Methods
    private func saveUserData() {
        getUserProperties()
        guard let user = self.user else { return }
        dataService.saveUser(user)
        UserDefaults.standard.set(true, forKey: "isLogin")
    }
    
    private func getUserProperties() {
        guard let login = loginField.text,
              let password = passwordField.text,
              let passwordConfirmation = passwordConfirmationField.text else {
            return
        }
        
        
        if (login == "" || password == "" || passwordConfirmation == "") {
            let alert = UIAlertController(title: "СООБЩЕНИЕ",
                                          message: "Все поля должны быть заполнены!",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        } else {
            if (password == passwordConfirmation) {
                self.user = User()
                self.user?.login = login
                self.user?.password = password
            } else {
                let alert = UIAlertController(title: "СООБЩЕНИЕ",
                                              message: "Значения паролей не совпадают!",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true)
            }
        }
    }
    
}
