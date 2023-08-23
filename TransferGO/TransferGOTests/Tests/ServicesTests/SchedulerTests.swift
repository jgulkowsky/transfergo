//
//  SchedulerTests.swift
//  TransferGOTests
//
//  Created by Jan Gulkowski on 23/08/2023.
//

import XCTest

final class SchedulerTests: XCTestCase {
    private var scheduler: Scheduler!
    
    func test_given_intervalIs_100_Milliseconds_when_startIsCalledAndWeWait_50_Milliseconds_then_onEventIsCalledExactly_1_Time() {
        startScheduler(
            withInterval: 0.1,
            andWaitFor: 0.05,
            andNumberOfEventCallsShouldBe: 1
        )
    }
    
    func test_given_intervalIs_100_Milliseconds_when_startIsCalledAndWeWait_150_Milliseconds_then_onEventIsCalledExactly_2_Times() {
        startScheduler(
            withInterval: 0.1,
            andWaitFor: 0.15,
            andNumberOfEventCallsShouldBe: 2
        )
    }
    
    func test_given_intervalIs_100_Milliseconds_when_startIsCalledAndWeWait_250_Milliseconds_then_onEventIsCalledExactly_3_Times() {
        startScheduler(
            withInterval: 0.1,
            andWaitFor: 0.25,
            andNumberOfEventCallsShouldBe: 3
        )
    }
    
    func test_given_intervalIs_200_Milliseconds_when_startIsCalledAndWeWait_150_Milliseconds_then_onEventIsCalledExactly_1_Time() {
        startScheduler(
            withInterval: 0.2,
            andWaitFor: 0.15,
            andNumberOfEventCallsShouldBe: 1
        )
    }
    
    func test_given_intervalIs_200_Milliseconds_when_startIsCalledAndWeWait_250_Milliseconds_then_onEventIsCalledExactly_2_Times() {
        startScheduler(
            withInterval: 0.2,
            andWaitFor: 0.25,
            andNumberOfEventCallsShouldBe: 2
        )
    }
    
    func test_given_intervalIs_200_Milliseconds_when_startIsCalledAndWeWait_50_Milliseconds_andStop_andThenWeWaitAnother250Milliseconds_then_onEventIsCalledExactly_1_Time_asAfterStopNoMoreEventsWereCalled() {
        // given
        scheduler = Scheduler(interval: 0.2)
        var numberOfOnEventCalls = 0
        
        // when
        scheduler.start {
            numberOfOnEventCalls += 1
        }

        wait(numberOfSeconds: 0.05) {
            scheduler.stop()
            
            wait(numberOfSeconds: 0.25) {
                // then
                XCTAssertEqual(numberOfOnEventCalls, 1)
            }
        }
    }
}

private extension SchedulerTests {
    // todo: this is the same as in CurrencyConverterViewModelTests - maybe it would be better to keep it into one place?
    func wait(
        numberOfSeconds: Double,
        thenCheck assertions: () -> Void
    ) {
        let exp = expectation(description: #function)
        let result = XCTWaiter.wait(for: [exp], timeout: numberOfSeconds)
        if result == XCTWaiter.Result.timedOut {
            assertions()
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func startScheduler(
        withInterval interval: Double,
        andWaitFor numberOfSeconds: Double,
        andNumberOfEventCallsShouldBe expectedNumberOfOnEventCalls: Int
    ) {
        // given
        scheduler = Scheduler(interval: interval)
        var numberOfOnEventCalls = 0
        
        // when
        scheduler.start {
            numberOfOnEventCalls += 1
        }
        
        // then
        wait(numberOfSeconds: numberOfSeconds) {
            XCTAssertEqual(numberOfOnEventCalls, expectedNumberOfOnEventCalls)
        }
    }
}
