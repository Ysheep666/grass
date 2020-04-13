//
//  MotionListViewController.swift
//  Runner
//
//  Created by Yang on 2020/4/9.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit

class MotionListViewController: UITableViewController {
    var completion: ((_ motions: [Motion]) -> Void)?

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
            let buttonItem = UIBarButtonItem(
                barButtonSystemItem: UIBarButtonItem.SystemItem.stop,
                target: self,
                action: #selector(close)
            )
            navigationItem.leftBarButtonItem = buttonItem
        }

        refreshRightBarButton()

        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        refreshData()
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
        if let index = selectedMotions.firstIndex(of: motion) {
            selectedMotions.remove(at: index)
        } else {
            selectedMotions.append(motion)
        }

        refreshRightBarButton()
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searchController.isActive { return nil }
        return sortedGroupKeys
    }

    func refreshRightBarButton() {
        if navigationItem.rightBarButtonItem == nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "",
                style: .plain,
                target: self,
                action: #selector(save)
            )
        }

        let saveButton = navigationItem.rightBarButtonItem!
        var title = "确定"
        let titleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)]
        let isEnabled = !selectedMotions.isEmpty

        if selectedMotions.count > 1 {
            title += "(\(selectedMotions.count))"
        }
        saveButton.isEnabled = isEnabled
        saveButton.title = title
        saveButton.setTitleTextAttributes(titleAttributes, for: .normal)
        saveButton.setTitleTextAttributes(titleAttributes, for: .highlighted)
        saveButton.setTitleTextAttributes(titleAttributes, for: .disabled)
        saveButton.tintColor = UIColor.systemBlue
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

    func refreshData(_ searchText: String = "") {
        motions = searchText == "" ? Helper.motions : Helper.motions.filter({
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

    @objc func save() {
        completion?(selectedMotions)
        navigationController!.dismiss(animated: true, completion: nil)
    }
}


extension MotionListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchController.isActive {
            refreshData(searchText)
        }
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        refreshData()
        tableView.reloadData()
    }
}
