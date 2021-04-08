//
//  LifecyclePresenter.swift
//  NetworkingWorkshop
//
//  Created by Юлия Милованова on 05.04.2021.
//

import Foundation

protocol LifecyclePresenter {
    func viewWillAppear()
    func viewDidLoad()
    func viewWillDisappear()
    func viewDidAppear()
    func viewDidDisappear()
}

extension LifecyclePresenter {
    func viewWillAppear() { }
    func viewDidLoad() { }
    func viewWillDisappear() { }
    func viewDidAppear() { }
    func viewDidDisappear() { }
}
