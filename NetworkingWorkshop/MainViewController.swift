//
//  MainViewController.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 24.03.2021.
//

import UIKit
import UserNotifications

enum Actions: String, CaseIterable {
    case exercises = "Exercises"
    case duels = "Duels"
    case feed = "Feed"
    case favorites = "Favorites"
    case exercisesAlamofire = "Exercises (Alamofire)"
    case duelsAlamofire = "Duels (Alamofire)"
    case feedAlamofire = "Feed (Alamofire)"
    case favoritesAlamofire = "Favorites (Alamofire)"
}

private let reuseIdentifier = "Cell"
private let url = "https://jsonplaceholder.typicode.com/posts"
private let swiftbookApi = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
private let uploadImage = "https://api.imgur.com/3/image"

class MainViewController: UICollectionViewController {
    
    let actions = Actions.allCases
    private var alert: UIAlertController!
    private var filePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLoggedIn()
    }
    
    private func showAlert() {
        alert = UIAlertController(title: "Downloading...", message: "0%", preferredStyle: .alert)
        
        let height = NSLayoutConstraint(item: alert.view,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 0,
                                        constant: 170)
        alert.view.addConstraint(height)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            
        }
        
        alert.addAction(cancelAction)
        present(alert, animated: true) {
            let size = CGSize(width: 40, height: 40)
            let point = CGPoint(x: self.alert.view.frame.width / 2 - size.width / 2, y: self.alert.view.frame.height / 2 - size.height / 2)
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
            activityIndicator.color = .gray
            activityIndicator.startAnimating()
            
            let progressView = UIProgressView(frame: CGRect(x: 0, y: self.alert.view.frame.height - 44, width: self.alert.view.frame.width, height: 2))
            progressView.tintColor = .blue
            
            
            self.alert.view.addSubview(activityIndicator)
            self.alert.view.addSubview(progressView)
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        cell.label.text = actions[indexPath.row].rawValue
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        
//        switch action {
//        case "Download Image":
//            performSegue(withIdentifier: "ShowImage", sender: self)
//        case "GET":
//            NetworkManager.getRequest(url: url)
//        case "POST":
//            NetworkManager.postRequest(url: url)
//        case "Our Courses":
//            performSegue(withIdentifier: "OurCourses", sender: self)
//        case "Upload Image":
//            print("Upload Image")
//        default:
//            break
//        }
        
        switch action {
        case .favorites:
            performSegue(withIdentifier: "ShowImage", sender: self)
//        case .get:
//            NetworkManager.getRequest(url: url)
//        case .post:
//            NetworkManager.postRequest(url: url)
        case .exercises:
            performSegue(withIdentifier: "OurCourses", sender: self)
        case .duels:
            performSegue(withIdentifier: "OurCourses", sender: self)
        case .feed:
            showAlert()
//            dataProvider.startDownload()
        case .exercisesAlamofire:
            performSegue(withIdentifier: "OurCoursesWithAlamofire", sender: self)
        case .duelsAlamofire:
            performSegue(withIdentifier: "DuelsWithAlamofire", sender: self)
        case .feedAlamofire:
            performSegue(withIdentifier: "PutRequest", sender: self)
        case .favoritesAlamofire:
//            AlamofireNetworkRequest.uploadImage(url: uploadImage)
            performSegue(withIdentifier: "OurCourses", sender: self)
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let duelsVC = segue.destination as? DuelsListViewController
        
//        switch segue.identifier {
//        case "DuelsWithAlamofireeee":
////            coursesVC?.fetchData()
//            imageVC?.fetchDataWithAlamofire()
//        case "OurCoursesWithAlamofire":
////            coursesVC?.fetchDataWithAlamofire()
//            imageVC?.fetchDataWithAlamofire()
//        case "ShowImage":
//            imageVC?.fetchImage()
//        case "ResponseData":
//            imageVC?.fetchDataWithAlamofire()
//        case "LargeImage":
//            imageVC?.downloadImageWithProgress()
//        case "PostRequest":
////            coursesVC?.postRequest()
//            imageVC?.fetchDataWithAlamofire()
//        case "PutRequest":
////            coursesVC?.putRequest()
//            imageVC?.fetchDataWithAlamofire()
//        default:
//            break
//        }
    }
    

}

extension MainViewController {
    private func checkLoggedIn () {
        
            DispatchQueue.main.async {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let signInViewController = storyboard.instantiateViewController(identifier: "SignIn") as! SignInViewController
                self.present(signInViewController, animated: true)
                return
            }

    }
}
