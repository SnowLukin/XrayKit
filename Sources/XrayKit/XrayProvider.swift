// Created by Denis Mandych on 06.09.2025

import Foundation
import Xray

public protocol XrayProviding: Actor {
    nonisolated var isRunning: Bool { get }
    nonisolated var version: String { get }

    func start(config: Data) throws
    func stop() throws
    func configure(memoryLimitMB: Int)
}

public actor XrayProvider: XrayProviding {
    public init() {}

    public nonisolated var isRunning: Bool {
        XrayIsRunning()
    }

    public nonisolated var version: String {
        XrayVersion()
    }

    public func start(config: Data) throws {
        try performWithError { error in
            XrayStart(config, &error)
        }
    }

    public func stop() throws {
        try performWithError { error in
            XrayStop(&error)
        }
    }

    public func configure(memoryLimitMB: Int) {
        XraySetMemoryLimit(Int64(memoryLimitMB))
    }

    private func performWithError(
        _ block: (inout NSError?) -> Void
    ) throws {
        var error: NSError?
        block(&error)
        if let error {
            throw error
        }
    }
}
