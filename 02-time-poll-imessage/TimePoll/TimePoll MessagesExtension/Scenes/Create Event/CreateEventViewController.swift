//
//  CreateEventViewController.swift
//  TimePoll MessagesExtension
//
//  Created by Brian Sipple on 3/28/20.
//  Copyright © 2020 CypherPoet. All rights reserved.
//

import UIKit


protocol CreateEventViewControllerDelegate: class {
    func viewController(_ controller: UIViewController, didCreateMessageWith eventDates: [EventDate])
}


class CreateEventViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var datePicker: UIDatePicker!

    var dateChoices: [EventDate]!
    weak var delegate: CreateEventViewControllerDelegate?
    
    
    private var currentDataSnapshot: DataSourceSnapshot!
    private var dataSource: DataSource!
    
    private static let cellReuseIdentifier = "EventDateCell"
    private static let storyboardName = "MainInterface"
}


// MARK: - Instantiation
extension CreateEventViewController {

    static func instantiate(
        dateChoices: [EventDate],
        delegate: CreateEventViewControllerDelegate? = nil
    ) -> CreateEventViewController {
        let viewController = CreateEventViewController.instantiateFromStoryboard(
            named: Self.storyboardName
        )
        
        viewController.dateChoices = dateChoices
        viewController.delegate = delegate

        return viewController
    }
}


// MARK: - Table View Structure
extension CreateEventViewController {
    enum TableSection: CaseIterable {
        case all
    }
    
    typealias TableViewCell = EventDateChoiceTableViewCell
    typealias TableDataItem = EventDate
    typealias DataSource = UITableViewDiffableDataSource<TableSection, TableDataItem>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<TableSection, TableDataItem>
}



// MARK: - Lifecycle
extension CreateEventViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = makeTableViewDataSource()
        
        configureTableView()
        updateSnapshot(withNew: dateChoices)
    }
}



// MARK: - Event Handling
extension CreateEventViewController {
      
    @IBAction func saveSelectedDates() {
        delegate?.viewController(self, didCreateMessageWith: dateChoices)
    }
    
    
    @IBAction func addDateChoice(_ sender: UIButton) {
        dateChoices.append(.init(
            date: datePicker.date,
            hasBeenVotedForByUser: true
        ))
        
        updateSnapshot(withNew: dateChoices, animate: true)
//        tableView.scrollToRow(at: <#T##IndexPath#>, at: <#T##UITableView.ScrollPosition#>, animated: <#T##Bool#>)
    }
}




// MARK: - Navigation
extension CreateEventViewController {
}



// MARK: - Private Helpers
private extension CreateEventViewController {
    
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
extension CreateEventViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard
            var eventDate = dataSource.itemIdentifier(for: indexPath),
            let dateChoicesIndex = dateChoices.firstIndex(of: eventDate)
        else { return }
        
        eventDate.hasBeenVotedForByUser.toggle()
        eventDate.totalVoteCount += eventDate.hasBeenVotedForByUser ? 1 : -1
        dateChoices[dateChoicesIndex] = eventDate
        
        updateSnapshot(withNew: dateChoices, animate: false)
    }
}


extension CreateEventViewController: Storyboarded {}
