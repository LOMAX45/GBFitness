//
//  LoginViewController.swift
//  GBFitness
//
//  Created by Максим Лосев on 03.12.2022.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    //MARK: - Properties
    let disposedBag = DisposeBag()
    
    //MARK: - IBOutlets
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK: - Coordinator properties
    var onRegister: (() -> Void)?
    var onMap: (() -> Void)?
    
    //MARK: - IBActions
    @IBAction func enterDidTapped(_ sender: Any) {
        guard let login = loginField.text,
              let password = passwordField.text else {
            return
        }
        
        if (login == "" || password == "") {
            let alert = UIAlertController(title: "СООБЩЕНИЕ",
                                          message: "Все поля должны быть заполнены!",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
            return
        } else {
            lookingForUserInRealm(login: login, password: password)
        }
    }
    
    @IBAction func registerDidTapped(_ sender: Any) {
        onRegister?()
    }
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLoginBindings()
    }
    
    func configureLoginBindings () {
        Observable
            .combineLatest(
                loginField.rx.text,
                passwordField.rx.text
            )
            .map { login, password in
                return !(login ?? "").isEmpty && !(password ?? "").isEmpty
            }
            .bind { [weak loginButton] inputFields in
                loginButton?.isEnabled = inputFields
            }.disposed(by: disposedBag)
    }
    
    //MARK: - Private methods
    
    private func lookingForUserInRealm(login: String, password: String) {
        do {
            let realm = try Realm()
            guard let user = realm.object(ofType: User.self, forPrimaryKey: login) else {
                let alert = UIAlertController(title: "СООБЩЕНИЕ",
                                              message: "Пользователь с таким логином не существует. Пройдите регистрацию!",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true)
                return
            }
            if user.password == password {
                UserDefaults.standard.set(true, forKey: "isLogin")
                onMap?()
            } else {
                let alert = UIAlertController(title: "СООБЩЕНИЕ",
                                              message: "Не верный пароль для указанного логина. Назначить новый пароль можно через процедуру регистрации.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true)
            }
        } catch {
            print(error)
        }
    }

}
