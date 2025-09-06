// Created by Denis Mandych on 06.09.2025

import Foundation
@_implementationOnly import Xray

public protocol XrayProviderLogger {
    func logMessage(_ message: String?)
}

private final class XrayLoggerImpl: NSObject, XrayLoggerProtocol {
    private let logger: (any XrayProviderLogger)?

    init(logger: (any XrayProviderLogger)?) {
        self.logger = logger
    }

    func logMessage(_ s: String?) {
        logger?.logMessage(s)
    }
}

public actor XrayProvider {
    private let logger: any XrayLoggerProtocol

    public init(logger: (any XrayProviderLogger)? = nil) {
        self.logger = XrayLoggerImpl(logger: logger)
    }

    public nonisolated var isRunning: Bool {
        XrayIsRunning()
    }

    public nonisolated var version: String {
        XrayVersion()
    }

    // MARK: - Core Methods

    public func start(config: Data) throws {
        try performWithError { error in
            XrayStart(config, logger, &error)
        }
    }

    public func stop() throws {
        try performWithError { error in
            XrayStop(&error)
        }
    }

    public func measureDelay(for url: String? = nil) throws -> Int {
        var delay: Int64 = 0
        try performWithError { error in
            if let url {
                XrayMeasureDelayForUrl(url, &delay, &error)
            } else {
                XrayMeasureDelay(&delay, &error)
            }
        }
        return Int(delay)
    }

    public func measureOutboundDelay(
        for url: String? = nil,
        config: String
    ) throws -> Int {
        var delay: Int64 = 0
        try performWithError { error in
            if let url {
                XrayMeasureOutboundDelayForUrl(url, config, &delay, &error)
            } else {
                XrayMeasureOutboundDelay(config, &delay, &error)
            }
        }
        return Int(delay)
    }

    // MARK: - Configuration

    public func configure(
        memoryLimitMB: Int? = nil,
        defaultTestURL: String? = nil,
        requestTimeoutMS: Int? = nil
    ) {
        if let memoryLimitMB {
            XraySetMemoryLimit(Int64(memoryLimitMB))
        }
        if let defaultTestURL {
            XraySetDefaultTestURL(defaultTestURL)
        }
        if let requestTimeoutMS {
            XraySetRequestTimeout(Int64(requestTimeoutMS))
        }
    }

    // MARK: - Private Helpers

    private func performWithError(_ block: (inout NSError?) -> Void) throws {
        var error: NSError?
        block(&error)
        if let error {
            throw error
        }
    }
}
