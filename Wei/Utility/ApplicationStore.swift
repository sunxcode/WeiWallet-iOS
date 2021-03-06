//
//  ApplicationStore.swift
//  Wei
//
//  Created by yuzushioh on 2018/03/15.
//  Copyright © 2018 popshoot. All rights reserved.
//

protocol ApplicationStoreProtocol {
    
    /// Represents user's master seed
    var seed: String? { get set }
    
    /// Represents user's mnemonic backup phrase
    var mnemonic: String? { get set }
    
    /// Represents user's access token for wei server
    var accessToken: String? { get set }
    
    /// Represents a flag whether user has done backup
    var isAlreadyBackup: Bool { get set }
    
    /// Represents a user's currency
    var currency: Currency? { get set }
    
    /// Clears data in keychain
    func clearData()
}

final class ApplicationStore: ApplicationStoreProtocol, Injectable {
    
    typealias Dependency = (
        KeychainStore,
        CacheProtocol,
        LocalTransactionRepositoryProtocol,
        UserDefaultsStoreProtocol
    )
    
    private let keychainStore: KeychainStore
    private let cache: CacheProtocol
    private let localTransactionRepository: LocalTransactionRepositoryProtocol
    private var userDefaultsStore: UserDefaultsStoreProtocol
    
    init(dependency: Dependency) {
        (keychainStore, cache, localTransactionRepository, userDefaultsStore)  = dependency
    }
    
    // MARK: - Stores in Keychain
    
    var seed: String? {
        get {
            return keychainStore[.seed]
        }
        set {
            keychainStore[.seed] = newValue
        }
    }
    
    var mnemonic: String? {
        get {
            return keychainStore[.mnemonic]
        }
        set {
            keychainStore[.mnemonic] = newValue
        }
    }
    
    var accessToken: String? {
        get {
            return keychainStore[.accessToken]
        }
        set {
            keychainStore[.accessToken] = newValue
        }
    }
    
    var isAlreadyBackup: Bool {
        get {
            return keychainStore[.isAlreadyBackup] != nil
        }
        set {
            keychainStore[.isAlreadyBackup] = "backup.wei"
        }
    }
    
    // MARK: - Stores in UserDefaults
    
    var currency: Currency? {
        get {
            guard let currencyString = userDefaultsStore.currency,
                let currency = Currency(rawValue: currencyString) else {
                    return nil
            }
            return currency
        }
        set {
            userDefaultsStore.currency = newValue?.rawValue
        }
    }
    
    func clearData() {
        keychainStore.clearKeychain()
        cache.clear()
        localTransactionRepository.deleteAllObjects()
    }
}
