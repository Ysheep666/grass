//
//  MotionListViewController.swift
//  Runner
//
//  Created by Yang on 2020/4/9.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit

class MotionListViewController: UITableViewController {
    var allMotions: [Motion] = []
    var motions: [Motion] = []
    var sortedGroupKeys: [String] = []
    var groups: [String: [Motion]] = [:]
    var selectedMotions: [Motion] = []

    lazy var searchController: UISearchController = {
        let serch = UISearchController(searchResultsController: nil)
        serch.searchResultsUpdater = self
        serch.hidesNavigationBarDuringPresentation = false
        serch.obscuresBackgroundDuringPresentation = false
        serch.searchBar.delegate = self
        serch.searchBar.placeholder = "搜索"
        serch.searchBar.searchBarStyle = .minimal
        return serch
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        if navigationItem.leftBarButtonItem == nil {
            navigationItem.leftBarButtonItem =  UIBarButtonItem(
                barButtonSystemItem: UIBarButtonItem.SystemItem.stop,
                target: self,
                action: #selector(close)
            )
        }

        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        allMotions = loadJson(FlutterDartProject.lookupKey(forAsset: "assets/motions.json"))
        updateData()
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive { return 1 }
        return sortedGroupKeys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive { return motions.count }
        if let group = groups[sortedGroupKeys[section]] {
            return group.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if searchController.isActive { return 0 }
        tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .top, animated: false)
        return sortedGroupKeys.firstIndex(of: title)!
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive { return nil }
        return sortedGroupKeys[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let motion = getData(at: indexPath) else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MotionCell", for: indexPath) as! MotionCell
        cell.motion = motion
        cell.isISelected = selectedMotions.contains(motion)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let motion = getData(at: indexPath) else { return }
        impactFeedback(.light)
        print(motion)
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searchController.isActive { return nil }
        return sortedGroupKeys
    }

    func getData(at indexPath: IndexPath) -> Motion? {
        if searchController.isActive {
            return motions[indexPath.row]
        }

        let key: String = sortedGroupKeys[indexPath.section]
        if let motion = groups[key]?[indexPath.row] {
            return motion
        }
        return nil
    }

    func updateData(_ searchText: String = "") {
        motions = searchText == "" ? allMotions : allMotions.filter({
            $0.name.contains(searchText) || $0.initials.contains(searchText) || $0.type.contains(searchText)
        })
        if !searchController.isActive {
            groups = [String: [Motion]]()
            motions.forEach { motion in
                let initials = motion.initials
                let index = String(initials[initials.startIndex])
                var value = groups[index] ?? [Motion]()
                value.append(motion)
                groups[index] = value
            }
            sortedGroupKeys = Array(groups.keys).sorted(by: <)
        }
    }

    @objc func close() {
        navigationController!.dismiss(animated: true, completion: nil)
    }
}


extension MotionListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchController.isActive {
            updateData(searchText)
        }
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateData()
        tableView.reloadData()
    }
}
