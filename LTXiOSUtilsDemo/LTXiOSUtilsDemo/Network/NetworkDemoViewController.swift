//
//  NetworkDemoViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by CoderStar on 2022/3/16.
//

import Foundation
import LTXiOSUtils

class NetworkDemoViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }

    private func getData() {
        let request = DefaultAPIRequest(path: "/config/homeBanner", dataType: HomeBanner.self)
        let defaultAPIService = APIService.shared

        defaultAPIService.sendRequest(request) { result in
            switch result.result {
            case let .success(model):
                Log.d(model.data?.interval)
            case let .failure(error):
                Log.d(error)
            }
        }
    }
}

struct HomeBanner: APIDefaultJSONParsable {
    var interval: Int = 0
}
