// Created by Denis Mandych on 06.09.2025

import Foundation
import Xray

public protocol XrayProviding: Actor {
    nonisolated var isRunning: Bool { get }
    nonisolated var version: String { get }

    func start(config: Data) async throws
    func stop() async throws
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

    public func start(config: Data) async throws {
        try await performWithError { error in
            XrayStart(config, &error)
        }
    }

    public func stop() async throws {
        try await performWithError { error in
            XrayStop(&error)
        }
    }

    public func configure(memoryLimitMB: Int) {
        XraySetMemoryLimit(Int64(memoryLimitMB))
    }

    @discardableResult
    private func performWithError<T: Sendable>(_ block: @escaping (inout NSError?) -> T) async throws -> T {
        try await Task.detached(priority: .userInitiated) {
            var error: NSError?
            let result = block(&error)
            if let error { throw error }
            return result
        }.value
    }
}
