pragma solidity ^0.6.0;

/**
 * @dev This contract provides support for initializing an upgradeable contract.
 *
 * Whenever the `initialize` function is called, the `initializer` storage slot is set to `true`.
 * By verifying that this storage slot is `false` in the constructor, one can make it
 * impossible to initialize a contract multiple times.
 *
 * Contracts that inherit from this one should define their own initializers.
 * If a contract is not meant to be upgradeable, the `initializer` function should be empty:
 *
 *     function initialize() public initializer {
 *         // No-op
 *     }
 *
 * The following conditions should hold true to ensure initializer correctness:
 *
 * - The contract does not use the storage slot with the `initializer` storage layout.
 * - The contract cannot be killed, to prevent construction of a new contract with the same address but without the `initializer` slot set to `true`.
 *   Even though `selfdestruct` is a function provided by Solidity, directly
 *   verifying `msg.sender` in the initializer is sufficient to prevent such an attack
 *   without incurring the cost of executing `selfdestruct`.
 */
abstract contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private initializer;

    /**
     * @dev Modifier to protect the initializer function from being invoked twice.
     */
    modifier onlyInitializer() {
        require(!initializer, "Initializable: contract is already initialized");
        initializer = true;
        _;
    }

    /**
     * @dev Constructor that sets the initial value of `initializer` to `false`.
     *
     * The following conditions are expected to be met in constructors of derived contracts:
     *
     * - Contract is an upgradeable contract, deployed proximately as a proxy with
     *   an attached `admin` contract as an `admin`, unless `admin` layout is not used
     *   in the contract, in which case the function should be annotated with the
     *   `onlyInitializer` modifier. Upgradeable contract constructors must use
     *   the `onlyInitializer` modifier.
     *
     * - If contract is constructed without the use of `admin` layout,
     *   `initializer` layout constraint checks are not expected.
     *
     * - If the contract intends to enable and accept initializable functions through
     *   its proxies, it must be marked as `abstract`.
     */
    constructor() public {
    }
}