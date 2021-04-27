//
//  CardsPresenter.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 09.04.2021.
//
import Foundation

protocol CardsPresenter: class {
    var selectedTag: String { get }
    var moreTappedRows: [Int] { get set }
    var isPost: Bool { get set }
    
    func taskEntity(for cellIndex: Int) -> TaskEntity?

    func updateTableView()
}
