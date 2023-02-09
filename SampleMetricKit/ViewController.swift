//
//  ViewController.swift
//  SampleMetricKit
//
//  Created by Anton Pomozov on 06.02.2023.
//

import MetricKit
import UIKit

final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupCollectionView()
        setupBaseSnapshot()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let state = begin(name: "Visible", category: String(describing: Self.self))
        self.state = state
        NSLog("XXX - Begin signpost with state: \(state)")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        state.map {
            end(name: "Visible", category: String(describing: Self.self), state: $0)
            NSLog("XXX - End signpost with state: \($0)")
        }
    }

    private var items: [String] = []
    private var state: OSSignpostIntervalState?

    private var itemHeight: CGFloat = 40.0 {
        didSet {
            guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

            layout.itemSize = CGSize(width: itemHeight, height: itemHeight)
            layout.invalidateLayout()
        }
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemHeight, height: itemHeight)

        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    private lazy var heightLabel = UILabel()
    private lazy var heightTextField = UITextField()

    private lazy var dataSource: UICollectionViewDiffableDataSource<String, String> = {
        UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, id in
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.reuseIdentifier, for: indexPath) as? PhotoCell,
                let image = UIImage(named: "logo")
            else {
                assertionFailure("Failed to configure a cell")
                return PhotoCell()
            }

            cell.configure(image: image)

            return cell
        }
    }()
}

private extension ViewController {
    func setupView() {
        view.alpha = 0.7
        view.backgroundColor = .blue
    }

    func setupCollectionView() {
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: Constant.reuseIdentifier)
        collectionView.alpha = 0.7
        collectionView.backgroundColor = .magenta
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func setupBaseSnapshot() {
        let range = 0 ..< Constant.sectionCount

        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        snapshot.appendSections(range.map(String.init))

        for section in range {
            snapshot.appendItems(Array((0..<Constant.itemCount)).map { "\(section)_\($0)" }, toSection: "\(section)")
        }

        dataSource.apply(snapshot)
    }
}

private extension ViewController {
    @discardableResult
    func begin(name: StaticString, category: String) -> OSSignpostIntervalState {
        let logHandle = MXMetricManager.makeLogHandle(category: category)
        let signposter = OSSignposter(logHandle: logHandle)
        let signpostID = signposter.makeSignpostID()

        let state = signposter.beginAnimationInterval(name, id: signpostID)

        return state
    }

    func end(name: StaticString, category: String, state: OSSignpostIntervalState) {
        let logHandle = MXMetricManager.makeLogHandle(category: category)
        let signposter = OSSignposter(logHandle: logHandle)
        signposter.endInterval(name, state)
    }
}

private enum Constant {
    static let sectionCount = 100
    static let itemCount = 2000
    static let reuseIdentifier = "PhotoCell"
}
