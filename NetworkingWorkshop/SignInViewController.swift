//
//  SignInViewController.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 26.03.2021.
//

import UIKit

class SignInViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView!
    let authorizationManager = AuthorizationManager()
    let userManager = UserManager()
    let hashPasswordUseCase = HashPasswordUseCaseImplementation()
    
    lazy var continueButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = CGPoint(x: view.center.x, y: view.frame.height - 150)
        button.backgroundColor = .white
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.layer.cornerRadius = 4
        button.alpha = 0.5
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        return button
    }()
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(continueButton)
        setContinueButton(enabled: false)
        
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = continueButton.center
        
        view.addSubview(activityIndicator)
        
        emailTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(keyboardWillAppear),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillAppear(notification: NSNotification){
        
        let userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        continueButton.center = CGPoint(x: view.center.x,
                                        y: view.frame.height - keyboardFrame.height - 16.0 - continueButton.frame.height / 2)
        
        activityIndicator.center = continueButton.center
    }
    
    private func setContinueButton(enabled: Bool) {
        
        if enabled {
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
    
    @objc private func textFieldChanged() {
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
            else { return }
        
        let formFilled = !(email.isEmpty) && !(password.isEmpty)
        
        setContinueButton(enabled: formFilled)
    }

    @objc private func handleSignIn() {
        
        setContinueButton(enabled: false)
        continueButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
        else { return }
        
        
        authorizationProcess(login: email, password: password)
        print("Successfully logged in")

    }
    
    func authorizationProcess(
        login: String,
        password: String,
        successCompletion: EmptyClosure? = nil,
        failureCompletion: EmptyClosure? = nil
    ) {
        
        authorizationManager.getTeams(with: login, codeScreen: false) { [weak self] error in
            guard let self = self else { return }
            
            guard error == nil else {
                failureCompletion?()
                return
            }
            
            let (hashedPassword, isCrypted) = self.hashPasswordUseCase.hash(password: password)
            self.authorizationManager.login(with: login, password: hashedPassword, isCrypted: isCrypted) { error in
                DispatchQueue.main.async {
                    if error != nil {
                        
                        failureCompletion?()
                        
                        switch (error as? AuthError)?.reason {
                        case .tooManyDevices:
                            return
                        case .userBlocked:
                            return
                        default:
                            return
                        }
                        
                    } else {
                        if let url = UserDefaults.standard.string(forKey: "base_url") {
                        }
                        
                        if !login.isEmpty, !password.isEmpty {
                            self.getCurrentUser(login: login, successCompletion: successCompletion)
                        }
                    }
                }
            }
        }
    }
    
    private func getCurrentUser(login: String, successCompletion: EmptyClosure?) {
        userManager.getCurrentUser(completion: {
            DispatchQueue.main.async {
                
                if UserModel.shared.loggedBefore {
                    self.presentingViewController?.dismiss(animated: true)
                } else {
                    UserModel.shared.loggedBefore = true
                    self.presentingViewController?.dismiss(animated: true)
                }
            }
            
            successCompletion?()
        }, failureCompletion: nil)
    }
}
