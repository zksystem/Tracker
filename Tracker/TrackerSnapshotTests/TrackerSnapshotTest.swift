//
//  TrackerSnapshotTests.swift
//  Tracker
//
//  Created by Konstantin Zuykov on 01.10.2023.
//

import SnapshotTesting
import XCTest
@testable import Tracker

final class TrackerSnapshotTests: XCTestCase {

    func testTrackersViewControllerSnapshot() throws {
        let vc = TrackersViewController(trackerStore: StubTrackerStore())
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testTrackersViewControllerDarkSnapshot() throws {
        let vc = TrackersViewController(trackerStore: StubTrackerStore())
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }

}

extension TrackerSnapshotTests {
    private struct StubTrackerStore: TrackerStoreProtocol {
        var delegate: TrackerStoreDelegate?
        private static let category = TrackerCategory(label: "Chores")
        private static let trackers: [[Tracker]] = [
            [
                Tracker(
                    label: "Room cleaning",
                    emoji: "🙂",
                    color: .selection[4],
                    category: category,
                    completedDaysCount: 10,
                    schedule: [.saturday],
                    isPinned: true
                )
            ],
            [
                Tracker(
                    label: "Water plants",
                    emoji: "🌺",
                    color: .selection[1],
                    category: category,
                    completedDaysCount: 2,
                    schedule: nil,
                    isPinned: false
                ),
                Tracker(
                    label: "Eat hamburger",
                    emoji: "🍔",
                    color: .selection[0],
                    category: category,
                    completedDaysCount: 1,
                    schedule: nil,
                    isPinned: false
                )
            ]
        ]
        
        var numberOfTrackers: Int = 3
        var numberOfSections: Int = 2
        func loadFilteredTrackers(date: Date, searchString: String) throws {}
        
        func numberOfRowsInSection(_ section: Int) -> Int {
            switch section {
            case 0: return 1
            case 1: return 2
            default: return 0
            }
        }
        
        func headerLabelInSection(_ section: Int) -> String? {
            switch section {
            case 0: return "Pinned"
            case 1: return StubTrackerStore.category.label
            default: return nil
            }
        }
        
        func tracker(at indexPath: IndexPath) -> Tracker? {
            let tracker = StubTrackerStore.trackers[indexPath.section][indexPath.item]
            return tracker
        }
        
        func addTracker(_ tracker: Tracker, with category: TrackerCategory) throws {}
        func updateTracker(_ tracker: Tracker, with data: Tracker.Data) throws {}
        func deleteTracker(_ tracker: Tracker) throws {}
        func togglePin(for tracker: Tracker) throws {}
    }
}
