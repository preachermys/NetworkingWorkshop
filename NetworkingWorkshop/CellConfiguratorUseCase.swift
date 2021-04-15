//
//  CellConfiguratorUseCase.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 09.04.2021.
//

import UIKit

protocol CellConfiguratorUseCase {
    func setup(presenter: CardsPresenter,
               reloadAdapter: ReloadAdapter?
    )
    
    func congifure<T: UITableViewCell>(cell: T?, cellIndex: Int, card: CardEntity)
}

final class CellConfiguratorUseCaseImplementation: CellConfiguratorUseCase {
    var reloadAdapter: ReloadAdapter?
    weak var presenter: CardsPresenter?
        
    func setup(
        presenter: CardsPresenter,
        reloadAdapter: ReloadAdapter?) {
        self.presenter = presenter
        self.reloadAdapter = reloadAdapter
    }
    
    // swiftlint:disable function_body_length
    func congifure<T: UITableViewCell>(cell: T?, cellIndex: Int, card: CardEntity) {
        guard let presenter = presenter else { return }
        
        if let cell = cell as? ErrorTVCell {
            
            cell.prepareView(title: card.title, feedType: card.type)
            
        } else if let cell = cell as? FeedTimeLineTVC {
            cell.reloadDelegate = reloadAdapter
            cell.taskEntity = presenter.taskEntity(for: cellIndex)
            cell.prepareView(
                cardModel: card,
                cellIndex: cellIndex)
        } else if let cell = cell as? FeedVideoTVCell {
            
            cell.reloadDelegate = reloadAdapter
            cell.taskEntity = presenter.taskEntity(for: cellIndex)
            cell.prepareView(
                cardModel: card,
                cellIndex: cellIndex)
        } else if let cell = cell as? FeedOpenQuizTVCell {
            cell.reloadDelegate = reloadAdapter
            cell.taskEntity = presenter.taskEntity(for: cellIndex)
            cell.prepareView(cardModel: card,
                             cellIndex: cellIndex)
        } else if let cell = cell as? FeedQuizTVCell {

            cell.reloadDelegate = reloadAdapter
            cell.taskEntity = presenter.taskEntity(for: cellIndex)
            cell.prepareView(cardModel: card,
                             cellIndex: cellIndex)
        } else if let cell = cell as? FeedAudioTVCell {

            cell.reloadDelegate = reloadAdapter
            cell.isPost = presenter.isPost
            cell.taskEntity = presenter.taskEntity(for: cellIndex)
            cell.prepareView(cardModel: card,
                             cellIndex: cellIndex)
            
        }
    }
}

final class ReloadAdapter: RowReloaderProtocol {
    weak var presenter: CardsPresenter?

    init(presenter: CardsPresenter? = nil) {
        self.presenter = presenter
    }

    func updateRow(row: Int) {
        if let index = presenter?.moreTappedRows.firstIndex(of: row) {
            presenter?.moreTappedRows.remove(at: index)
        } else {
            presenter?.moreTappedRows.append(row)
        }

        presenter?.updateTableView()
    }
}
