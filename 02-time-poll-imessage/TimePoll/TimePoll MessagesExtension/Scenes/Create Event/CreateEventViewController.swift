//
//  CreateEventViewController.swift
//  TimePoll MessagesExtension
//
//  Created by Brian Sipple on 3/28/20.
//  Copyright © 2020 CypherPoet. All rights reserved.
//

import UIKit


class CreateEventViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var datePicker: UIDatePicker!

    
    var dateChoices: [EventDate]!
    
    
    private var currentDataSnapshot: DataSourceSnapshot!
    private var dataSource: DataSource!
    
    private let cellReuseIdentifier = "EventDateCell"
}


// MARK: - Instantiation
extension CreateEventViewController {

    static func instantiate(
        dateChoices: [EventDate]
    ) -> CreateEventViewController {
        let viewController = CreateEventViewController.instantiateFromStoryboard(
            named: "MainInterface"
        )
        
        viewController.dateChoices = dateChoices

        return viewController
    }
}


// MARK: - Table View Structure
extension CreateEventViewController {
    enum TableSection: CaseIterable {
        case all
    }
    
    typealias DataSource = UITableViewDiffableDataSource<TableSection, EventDate>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<TableSection, EventDate>
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
    //        delegate?.viewControllerDidSelectAddTrip(self)
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
                [weak self] (tableView, indexPath, eventDate) -> UITableViewCell? in
                guard let self = self else { return nil }
                
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: self.cellReuseIdentifier,
                    for: indexPath
                )
                
                self.configure(cell, with: eventDate)
                
                return cell
            }
        )
    }
    
    
    func configure(_ cell: UITableViewCell, with eventDate: EventDate) {
        // TODO: Move this view setup logic to the cell class itself
        cell.textLabel?.text = EventDateChoiceTableViewCell.dateFormatter.string(from: eventDate.date)
        
        cell.accessoryType = eventDate.hasBeenVotedForByUser ? .checkmark : .none
        
        if eventDate.recipientVoteCount > 0 {
            cell.detailTextLabel?.text = "Votes: \(eventDate.recipientVoteCount)"
        }
    }

    
    func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
    }

    
    func updateSnapshot(withNew data: [EventDate], animate: Bool = true) {
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
        dateChoices[dateChoicesIndex] = eventDate
        
        updateSnapshot(withNew: dateChoices, animate: false)
    }
    
}


extension CreateEventViewController: Storyboarded {}
