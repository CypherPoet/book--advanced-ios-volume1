//
//  DateSelectionViewController.swift
//  TimePoll MessagesExtension
//
//  Created by Brian Sipple on 3/29/20.
//  Copyright © 2020 CypherPoet. All rights reserved.
//

import UIKit



class DateSelectionViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!

    var dateChoices: [EventDate]!
    weak var delegate: CreateEventViewControllerDelegate?


    private var currentDataSnapshot: DataSourceSnapshot!
    private var dataSource: DataSource!

    private static let cellReuseIdentifier = "DateOptionCell"
    private static let storyboardName = "MainInterface"
}



// MARK: - Instantiation
extension DateSelectionViewController {

    static func instantiate(
        dateChoices: [EventDate],
        delegate: CreateEventViewControllerDelegate?
    ) -> DateSelectionViewController {
        let viewController = DateSelectionViewController.instantiateFromStoryboard(
            named: Self.storyboardName
        )

        viewController.dateChoices = dateChoices
        viewController.delegate = delegate
        
        return viewController
    }
}


// MARK: - Table View Structure
extension DateSelectionViewController {
    enum TableSection: CaseIterable {
        case all
    }

    typealias TableViewCell = EventDateChoiceTableViewCell
    typealias TableDataItem = EventDate
    typealias DataSource = UITableViewDiffableDataSource<TableSection, TableDataItem>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<TableSection, TableDataItem>
}



// MARK: - Lifecycle
extension DateSelectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = makeTableViewDataSource()

        configureTableView()
        updateSnapshot(withNew: dateChoices)
    }
}



// MARK: - Event Handling
extension DateSelectionViewController {
    
    @IBAction func saveSelectedDates() {
        delegate?.viewController(self, didCreateMessageWith: dateChoices)
    }
}


// MARK: - Navigation
extension DateSelectionViewController {
}


// MARK: - Private Helpers
private extension DateSelectionViewController {

    func makeTableViewDataSource() -> DataSource {
        DataSource(
            tableView: tableView,
            cellProvider: {
                [weak self] (tableView, indexPath, eventDate) -> TableViewCell? in
                guard let self = self else { return nil }

                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: Self.cellReuseIdentifier,
                    for: indexPath
                ) as? TableViewCell else {
                    fatalError()
                }

                self.configure(cell, with: eventDate)

                return cell
            }
        )
    }


    func configure(_ cell: TableViewCell, with eventDate: TableDataItem) {
        cell.eventDate = eventDate
        cell.showsTotalVoteCount = true
    }


    func configureTableView() {
        tableView.register(TableViewCell.nib, forCellReuseIdentifier: Self.cellReuseIdentifier)
        tableView.delegate = self
    }


   func updateSnapshot(withNew data: [TableDataItem], animate: Bool = true) {
       guard let dataSource = dataSource else { return }

       currentDataSnapshot = DataSourceSnapshot()

       currentDataSnapshot.appendSections([.all])
       currentDataSnapshot.appendItems(data)

       dataSource.apply(currentDataSnapshot, animatingDifferences: animate)
   }
}



// MARK: - UITableViewDelegate
extension DateSelectionViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard
            var eventDate = dataSource.itemIdentifier(for: indexPath),
            let dateChoicesIndex = dateChoices.firstIndex(of: eventDate)
        else { return }
        
        eventDate.hasBeenVotedForByRecipient.toggle()
        eventDate.totalVoteCount += eventDate.hasBeenVotedForByRecipient ? 1 : -1
        
        dateChoices[dateChoicesIndex] = eventDate
        
        updateSnapshot(withNew: dateChoices, animate: false)
    }

}


extension DateSelectionViewController: Storyboarded {}
