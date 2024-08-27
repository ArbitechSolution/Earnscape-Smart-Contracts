// SPDX-License-Identifier: MIT

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.20;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

pragma solidity ^0.8.20;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

pragma solidity ^0.8.20;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


interface IContract5 {
    function withdrawToContract4(uint256 amount) external;
}

contract EarnscapeVesting is Ownable {

    IERC20 public token;
    IContract5 public contract5;

    address public contract3Address;
    uint256 public totalAmountVested;

    uint256 private  cliffPeriod = 0 minutes;
    uint256 public  slicedPeriod = 1 minutes;

    struct Category {
        string name;
        uint256 supply;
        uint256 remainingSupply;
        uint256 vestingDuration;
    }

    struct UserData {
        string name;
        address userAddress;
        uint256 amount;
        uint256 vestingTime;
    }

    struct VestingSchedule {
        address beneficiary;
        uint256 cliff;
        uint256 start;
        uint256 duration;
        uint256 slicePeriodSeconds;
        uint256 amountTotal;
        uint256 released;
    }

    struct VestingDetail {
        uint256 index;
        VestingSchedule schedule;
    }

    mapping(uint256 => Category) private categories;
    mapping(uint256 => UserData[]) private categoryUsers;
    mapping(address => mapping(uint256 => VestingSchedule)) private vestedUserDetail;
    mapping(address => uint256) private holdersVestingCount;

    event UserAdded(uint256 indexed categoryId, string name, address userAddress, uint256 amount);
    event VestingScheduleCreated(address indexed beneficiary, uint256 start, uint256 cliff, uint256 duration, uint256 slicePeriodSeconds, uint256 amount);
    event SupplyUpdated(uint256 indexed categoryId, uint256 additionalSupply);
    event TokensReleasedImmediately(uint256 indexed categoryId, address recipient, uint256 amount);

    constructor(address _contract3Address,address _contract5Address, address _tokenAddress) Ownable(msg.sender) {
        contract3Address = _contract3Address;
        contract5 = IContract5(_contract5Address);
        token = IERC20(_tokenAddress);
        _initializeCategories();
    }

    function _initializeCategories() internal {
        categories[0] = Category("Seed Investors", 2500000  * 10**18, 2500000 * 10**18, 5 minutes);  // for testing change to 50% (66666667)
        categories[1] = Category("Private Investors", 2500000 * 10**18, 2500000 * 10**18, 5 minutes);
        categories[2] = Category("KOL Investors", 1600000 * 10**18, 1600000 * 10**18, 5 minutes);
        categories[3] = Category("Public Sale", 2000000 * 10**18, 2000000 * 10**18, 0);
        categories[4] = Category("Ecosystem Rewards", 201333333 * 10**18, 201333333 * 10**18, 5 minutes);
        categories[5] = Category("Airdrops", 50000000 * 10**18, 50000000 * 10**18, 5 minutes);
        categories[6] = Category("Development Reserve", 200000000 * 10**18, 200000000 * 10**18, 5 minutes);
        categories[7] = Category("Liquidity & Market Making", 150000000 * 10**18, 150000000 * 10**18, 0);
        categories[8] = Category("Team & Advisors", 200000000 * 10**18, 200000000 * 10**18, 5 minutes);
    }

    function addUserData(
        uint256 categoryId,
        string[] memory names,
        address[] memory userAddresses,
        uint256[] memory amounts
    ) public onlyOwner {
        require(names.length == userAddresses.length && userAddresses.length == amounts.length, "Array length mismatch");

        for (uint256 i = 0; i < userAddresses.length; i++) {
            if (categories[categoryId].remainingSupply < amounts[i]) {
                uint256 neededAmount = amounts[i] - categories[categoryId].remainingSupply;
               if (categoryId == 0 || categoryId == 1 || categoryId == 2) {
                    IContract5(contract5).withdrawToContract4(neededAmount);
                    categories[categoryId].supply += neededAmount;
                    categories[categoryId].remainingSupply += neededAmount;
                } else {
                    revert("Insufficient category supply and withdraw not allowed for this category");
                }
               // also add needamount in supply to track tsupply distributed.
            }

            require(categories[categoryId].remainingSupply >= amounts[i], "Insufficient category supply");
            categories[categoryId].remainingSupply -= amounts[i];
            categoryUsers[categoryId].push(UserData(names[i], userAddresses[i], amounts[i], categories[categoryId].vestingDuration));
            emit UserAdded(categoryId, names[i], userAddresses[i], amounts[i]);
            // Create vesting schedule for the user
            createVestingSchedule(
                userAddresses[i],
                block.timestamp,
                cliffPeriod,
                categories[categoryId].vestingDuration,
                slicedPeriod,
                amounts[i]
            );
        }
    }

    function createVestingSchedule(
        address _beneficiary,
        uint256 _start,
        uint256 _cliff,
        uint256 _duration,
        uint256 _slicePeriodSeconds,
        uint256 _amount
    ) internal {
        require(_duration >= _cliff, "TokenVesting: duration must be >= cliff");
        uint256 cliff = _start + _cliff;
        uint256 currentVestingIndex = holdersVestingCount[_beneficiary]++;
        vestedUserDetail[_beneficiary][currentVestingIndex] = VestingSchedule(
            _beneficiary,
            cliff,
            _start,
            _duration,
            _slicePeriodSeconds,
            _amount,
            0
        );
        totalAmountVested += _amount;
        emit VestingScheduleCreated(_beneficiary, _start, _cliff, _duration, _slicePeriodSeconds, _amount);
    }

    function calculateReleaseableAmount(address beneficiary) public view returns (uint256 totalReleasable, uint256 totalRemaining) {
        uint256 vestingCount = holdersVestingCount[beneficiary];
        for (uint256 i = 0; i < vestingCount; i++) {
            VestingSchedule storage vestingSchedule = vestedUserDetail[beneficiary][i];
            (uint256 releasable, uint256 remaining) = _computeReleasableAmount(vestingSchedule);

            totalReleasable += releasable;
            totalRemaining += remaining;
        }
        return (totalReleasable, totalRemaining);
    }

    function _computeReleasableAmount(VestingSchedule memory vestingSchedule) internal view returns (uint256 releasable, uint256 remaining) {
        uint256 currentTime = getCurrentTime();
        uint256 totalVested = 0;
        if (currentTime < vestingSchedule.cliff) {
            return (0, vestingSchedule.amountTotal - vestingSchedule.released);
        } else if (currentTime >= vestingSchedule.start + vestingSchedule.duration) {
            releasable = vestingSchedule.amountTotal - vestingSchedule.released;
            return (releasable, 0);
        } else {
            uint256 timeFromStart = currentTime - vestingSchedule.start;
            uint256 secondsPerSlice = vestingSchedule.slicePeriodSeconds;
            uint256 vestedSlicePeriods = timeFromStart / secondsPerSlice;
            uint256 vestedSeconds = vestedSlicePeriods * secondsPerSlice;

            totalVested = (vestingSchedule.amountTotal * vestedSeconds) / vestingSchedule.duration;
        }
        releasable = totalVested - vestingSchedule.released;
        remaining = vestingSchedule.amountTotal - totalVested;
        return (releasable, remaining);
    }

    function getUserVestingDetails(address beneficiary) public view returns (VestingDetail[] memory) {
        uint256 vestingCount = holdersVestingCount[beneficiary];
        require(vestingCount > 0, "TokenVesting: no vesting schedules found for the beneficiary");

        VestingDetail[] memory details = new VestingDetail[](vestingCount);
        for (uint256 i = 0; i < vestingCount; i++) {
            details[i] = VestingDetail({
                index: i,
                schedule: vestedUserDetail[beneficiary][i]
            });
        }
        return details;
    }

    function getCategoryDetails(uint256 categoryId) public view returns (Category memory) {
        return categories[categoryId];
    }

    function getCategoryUsers(uint256 categoryId) public view returns (UserData[] memory) {
        return categoryUsers[categoryId];
    }

    function getCurrentTime() internal view virtual returns (uint256) {
        return block.timestamp;
    }

    function updateCategorySupply(uint256 categoryId, uint256 additionalSupply) public onlyOwner {
        categories[categoryId].remainingSupply += additionalSupply;
        emit SupplyUpdated(categoryId, additionalSupply);
    }

    function releaseImmediately(uint256 categoryId, address recipient) public onlyOwner {
        require(categoryId == 3 || categoryId == 7, "Only Public Sale or Liquidity & Market Making categories allowed");
        uint256 amount = categories[categoryId].remainingSupply;
        require(amount > 0, "No remaining supply to release");
        categories[categoryId].remainingSupply = 0;
        require(token.transfer(recipient, amount), "Token transfer failed");
        emit TokensReleasedImmediately(categoryId, recipient, amount);
    }

    function releaseVestedAmount(address beneficiary) public onlyOwner {
        (uint256 releasable, ) = calculateReleaseableAmount(beneficiary);
        require(releasable > 0, "No releasable amount available");

        uint256 remainingAmount = releasable;
        uint256 vestingCount = holdersVestingCount[beneficiary];

        for (uint256 i = 0; i < vestingCount && remainingAmount > 0; i++) {
            VestingSchedule storage vestingSchedule = vestedUserDetail[beneficiary][i];
            (uint256 releasableAmount, ) = _computeReleasableAmount(vestingSchedule);

            if (releasableAmount > 0) {
                uint256 releaseAmount = releasableAmount > remainingAmount ? remainingAmount : releasableAmount;
                vestingSchedule.released += releaseAmount;
                remainingAmount -= releaseAmount;
                require(token.transfer(beneficiary, releaseAmount), "Token transfer failed");
            }
        }
    }
}
    
