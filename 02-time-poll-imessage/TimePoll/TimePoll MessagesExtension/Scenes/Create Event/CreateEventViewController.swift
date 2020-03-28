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
    
    
    private var currentDataSnapshot: DataSourceSnapshot!
    private var dataSource: DataSource!
    
    private let cellReuseIdentifier = "EventDateCell"
}


// MARK: - Table View Structure
extension CreateEventViewController {
    enum TableSection: CaseIterable {
        case all
    }
    
    typealias DataSource = UITableViewDiffableDataSource<TableSection, Date>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<TableSection, Date>
}



// MARK: - Lifecycle
extension CreateEventViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = makeTableViewDataSource()
        setupTableView()

//        loadTrips()
    }
}



// MARK: - Event Handling
extension CreateEventViewController {
      
    @IBAction func saveSelectedDates() {
    //        delegate?.viewControllerDidSelectAddTrip(self)
    }
}





// MARK: - Navigation
//extension CreateEventViewController {
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//}



// MARK: - Private Helpers
private extension CreateEventViewController {
    
    func makeTableViewDataSource() -> DataSource {
        DataSource(
            tableView: tableView,
            cellProvider: {
                [weak self] (tableView, indexPath, trip) -> UITableViewCell? in
                guard let self = self else { return nil }
                
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: self.cellReuseIdentifier,
                    for: indexPath
                )
                
                self.configure(cell, with: trip)
                
                return cell
            }
        )
    }
    
    
//    func loadTrips() {
//        modelController.loadTrips()
//    }
    
    
    func configure(_ cell: UITableViewCell, with date: Date) {
//        let primaryImage: UIImage?
//        if let primaryImageData = trip.primaryImageData {
//            primaryImage = UIImage(data: primaryImageData)
//        } else {
//            primaryImage = nil
//        }
//
//        cell.viewModel = TripTableViewCell.ViewModel(
//            title: trip.title,
//            subtitle: trip.shortDescription,
//            primaryImage: primaryImage
//        )
    }

    
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
    }

    
    func updateSnapshot(withNew data: [Date], animate: Bool = true) {
        guard let dataSource = dataSource else { return }

        currentDataSnapshot = DataSourceSnapshot()

        currentDataSnapshot.appendSections([.all])
        currentDataSnapshot.appendItems(data)

        dataSource.apply(currentDataSnapshot, animatingDifferences: animate)
    }
}


// MARK: - UITableViewDelegate
extension CreateEventViewController: UITableViewDelegate {
    
    
}

extension CreateEventViewController: Storyboarded {}
