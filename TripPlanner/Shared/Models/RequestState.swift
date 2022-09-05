import Foundation

public enum RequestState<T> {
    case notAsked
    case loading(last: T?)
    case success(T)
    case failure(Error)
}

extension RequestState {
    public var isLoading: Bool {
        switch self {
        case .loading:
            return true
        default:
            return false
        }
    }

    public var isLoadedSuccessfully: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }

    public var data: T? {
        switch self {
        case let .loading(data):
            return data

        case let .success(data):
            return data

        default: return nil
        }
    }

    public var error: Error? {
        switch self {
        case let .failure(error):
            return error

        default:
            return nil
        }
    }
}
