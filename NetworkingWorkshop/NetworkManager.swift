//
//  NetworkManager.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 29.03.2021.
//

import UIKit

class NetworkManager {
//
//    static func getRequest(url: String) { // static для того, чтобы сделать метод методом класса (чтобы этот метод можно было вызывать, не создавая экземпляр класса NetworkManager, т.е. будем напрямую обращаться к объекту NetworkManager и вызывать метод getRequest)
//
//        guard let url = URL(string: url) else { return }
//
//        let session = URLSession.shared
//        session.dataTask(with: url) { (data, response, error) in
//
//            guard let response = response, let data = data else { return }
//
//            print(response)
//            print(data)
//
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: [])
//                print(json)
//            } catch {
//                print(error)
//            }
//        }.resume()
//    }
//
//    static func postRequest(url: String) {
//
//        guard let url = URL(string: url) else { return }
//
//        let userData = ["Course": "Networking", "Lesson": "GET and POST"]
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else { return }
//        request.httpBody = httpBody
//
//        let session = URLSession.shared
//        session.dataTask(with: request) { (data, response, error) in
//
//            guard let response = response, let data = data else { return }
//
//            print(response)
//
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: [])
//                print(json)
//            } catch {
//                print(error)
//            }
//        } .resume()
//    }
//
//    static func downloadImage(url: String, completion: @escaping (_ image: UIImage)->()) {
//        guard let url = URL(string: url) else { return }
//
//        let session = URLSession.shared
//        session.dataTask(with: url) { (data, response, error) in
//            if let data = data, let image = UIImage(data: data) {
//                DispatchQueue.main.async {
////                    self.activityIndicator.stopAnimating()
////                    self.imageView.image = image
//
//                    //доступа к аутлетам (imageView) из MainViewController у нас нет, поэтому создадим completion
//                    completion(image) // производим захват изображения и потом передадим его в аутлет
//                }
//            }
//        } .resume()
//    }
//
//    static func fetchData(url: String, completion: @escaping (_ courses: [Course])->()) {
//
//        guard let url = URL(string: url) else { return }
//
//        URLSession.shared.dataTask(with: url) { (data, _, _) in
//            guard let data = data else { return }
//
//            // jsonDecoder декодирует данные и раскладывает их по модели
//
//            do {
//
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase // конвертируем написание number_of_lessons (то, как написано в json'е) в numberOfLessons, чтобы в структуре Course писать numberOfLessons, а не number_of_lessons
//
//                // сохраняем декодированные данные в массив, который является свойством класса
//                let courses = try decoder.decode([Course].self, from: data)
//                completion(courses) // захватываем массив типа Course
//            } catch let error {
//                print("Error serializatiin json ", error)
//            }
//
//        }.resume()
//    }
//
//    static func uploadImage(url: String) {
//        let image = UIImage(named: "completedDuels")!
//        // словарь с параметрами авторизации
//        let httpHeaders = ["Authorization": "Client-ID 1a12660f1df2623"] // взято из апи
//        guard let imageProperties = ImageProperties(withImage: image, forKey: "image") else { return }
//        // ключ "image" взят из api https://api.imgur.com/endpoints/image#image-upload
//
//        guard let url = URL(string: url) else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.allHTTPHeaderFields = httpHeaders
//        request.httpBody = imageProperties.data // данные для отправки на сервер
//
//        // создавая сессию, вызываем метод dataTask, который отправляет запрос на сервер
//        // в URLSession.shared.dataTask(with: request) выгружаем изображение
//        // в (data, response, error) получаем его обратно (response - ответ сервера)
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let response = response {
//                print("RESPONSE: \(response)")
//            }
//
//            if let data = data {
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//                    print(json)
//                } catch {
//                    print("ERROR: \(error)")
//                }
//            }
//        }.resume()
//
//    }
}

