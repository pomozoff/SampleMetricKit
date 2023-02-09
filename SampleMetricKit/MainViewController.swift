//
//  MainViewController.swift
//  SampleMetricKit
//
//  Created by Anton Pomozov on 06.02.2023.
//

import MetricKit
import UIKit

final class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        MXMetricManager.shared.add(self)
    }

    @IBAction func tapOnButton(_ sender: UIButton) {
        navigationController?.pushViewController(ViewController(), animated: true)
    }
}

// MARK: - MXMetricManagerSubscriber

extension MainViewController: MXMetricManagerSubscriber {

    func didReceive(_ payloads: [MXMetricPayload]) {
        var taskIdentifier: UIBackgroundTaskIdentifier = .invalid
        taskIdentifier = UIApplication.shared.beginBackgroundTask(withName: "Processing Apple MetricKit payloads") {
            UIApplication.shared.endBackgroundTask(taskIdentifier)
        }

        DispatchQueue.global().async {
            payloads.forEach(self.processMetricPayload(_:))
            UIApplication.shared.endBackgroundTask(taskIdentifier)
        }
    }
}

// MARK: - Private

private extension MainViewController {
    func processMetricPayload(_ payload: MXMetricPayload) {
        NSLog("XXX - \(String(data: payload.jsonRepresentation(), encoding: .utf8) ?? "nil")")
    }
}
