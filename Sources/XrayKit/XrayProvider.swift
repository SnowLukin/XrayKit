// Created by Denis Mandych on 06.09.2025

import Foundation
import LibXray

public protocol XrayProviding: Actor {
    nonisolated var isRunning: Bool { get }
    nonisolated var version: String { get }

    func start(config: Data) throws
    func stop() throws
}

public enum XrayError: LocalizedError {
    case callFailed(message: String)
    case invalidResponse

    public var errorDescription: String? {
        switch self {
        case .callFailed(let msg): return msg
        case .invalidResponse: return "Invalid response from LibXray"
        }
    }
}

public actor XrayProvider: XrayProviding {
    public init() {}

    public nonisolated var isRunning: Bool {
        LibXrayGetXrayState()
    }

    public nonisolated var version: String {
        LibXrayXrayVersion()
    }

    public func start(config: Data) throws {
        let base64Config = config.base64EncodedString()
        let result = LibXrayRunXrayFromJSON(base64Config)
        try unwrapBase64Response(result)
    }

    public func stop() throws {
        let result = LibXrayStopXray()
        try unwrapBase64Response(result)
    }

    private func unwrapBase64Response(_ str: String?) throws {
        guard let str = str,
              let data = Data(base64Encoded: str) else {
            throw XrayError.invalidResponse
        }
        guard let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw XrayError.invalidResponse
        }
        if let errMsg = obj["error"] as? String, !errMsg.isEmpty {
            throw XrayError.callFailed(message: errMsg)
        }
    }
}
