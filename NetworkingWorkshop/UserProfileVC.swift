//
//  UserProfileVC.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 24.03.2021.
//

import UIKit

class UserProfileVC: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 32,
                                   y: view.frame.height - 172,
                                   width: view.frame.width - 64,
                                   height: 50)
        button.backgroundColor = UIColor.white
        button.setTitle("Log Out", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameLabel.isHidden = true
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchingUserData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    private func setupViews() {
        view.addSubview(logoutButton)
    }
}


extension UserProfileVC {
    
    private func openLoginViewController() {
        
        DispatchQueue.main.async {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let signInViewController = storyboard.instantiateViewController(identifier: "SignIn") as! SignInViewController
            self.present(signInViewController, animated: true)
            return
        }
    }
    
    private func fetchingUserData() {
        self.activityIndicator.stopAnimating()
        self.userNameLabel.isHidden = false
        self.userNameLabel.text = UserModel.shared.lastname + " " + UserModel.shared.firstname
    }
    
    @objc private func signOut() {
        LogoutService.shared.logout()
    }
}
