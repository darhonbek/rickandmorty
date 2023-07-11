//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import Foundation
import UIKit

final class CharactersListTableViewController: UITableViewController {
    private let viewModel: CharactersListViewModelProtocol

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(viewModel: CharactersListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(CharacterListCellView.self, forCellReuseIdentifier: "CharacterListCellView")

        viewModel.loadData { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterListCellView", for: indexPath) as? CharacterListCellView else {
            fatalError("CharacterListCellView does not exist.")
        }

        let cellViewModel = viewModel.cellViewModel(forRowAt: indexPath)
        cell.viewModel = cellViewModel

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
}
