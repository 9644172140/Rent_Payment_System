// SPDX-License-Identifier:n
pragma solidity ^0.8.19;

/**
 * @title RentPaymentSystem
 * @dev A smart contract for automated rent payment management
 * @author Your Name
 */
contract RentPaymentSystem {
    
    // Struct to store rental agreement details
    struct RentalAgreement {
        address tenant;
        address landlord;
        uint256 monthlyRent;
        uint256 securityDeposit;
        uint256 leaseStartDate;
        uint256 leaseDuration; // in months
        uint256 lastPaymentDate;
        uint256 depositAmount;
        bool isActive;
        bool depositReturned;
    }
    
    // Mapping from agreement ID to rental agreement
    mapping(uint256 => RentalAgreement) public rentalAgreements;
    
    // Mapping to track late payment penalties
    mapping(uint256 => uint256) public latePenalties;
    
    // Counter for agreement IDs
    uint256 public agreementCounter;
    
    // Constants
    uint256 public constant LATE_PENALTY_RATE = 5; // 5% per month
    uint256 public constant GRACE_PERIOD = 5 days;
    uint256 public constant SECONDS_IN_MONTH = 30 days;
    
    // Events
    event AgreementCreated(
        uint256 indexed agreementId,
        address indexed tenant,
        address indexed landlord,
        uint256 monthlyRent,
        uint256 securityDeposit
    );
    
    event RentPaid(
        uint256 indexed agreementId,
        address indexed tenant,
        uint256 amount,
        uint256 paymentDate
    );
    
    event DepositReturned(
        uint256 indexed agreementId,
        address indexed tenant,
        uint256 amount
    );
    
    event LatePenaltyApplied(
        uint256 indexed agreementId,
        uint256 penaltyAmount
    );
    
    // Modifiers
    modifier onlyTenant(uint256 _agreementId) {
        require(
            rentalAgreements[_agreementId].tenant == msg.sender,
            "Only tenant can perform this action"
        );
        _;
    }
    
    modifier onlyLandlord(uint256 _agreementId) {
        require(
            rentalAgreements[_agreementId].landlord == msg.sender,
            "Only landlord can perform this action"
        );
        _;
    }
    
    modifier agreementExists(uint256 _agreementId) {
        require(
            rentalAgreements[_agreementId].isActive,
            "Agreement does not exist or is inactive"
        );
        _;
    }
    
    /**
     * @dev Creates a new rental agreement
     * @param _tenant Address of the tenant
     * @param _monthlyRent Monthly rent amount in wei
     * @param _securityDeposit Security deposit amount in wei
     * @param _leaseDuration Duration of lease in months
     */
    function createRentalAgreement(
        address _tenant,
        uint256 _monthlyRent,
        uint256 _securityDeposit,
        uint256 _leaseDuration
    ) external payable {
        require(_tenant != address(0), "Invalid tenant address");
        require(_tenant != msg.sender, "Landlord cannot be tenant");
        require(_monthlyRent > 0, "Monthly rent must be greater than 0");
        require(_securityDeposit > 0, "Security deposit must be greater than 0");
        require(_leaseDuration > 0, "Lease duration must be greater than 0");
        require(msg.value == _securityDeposit, "Must send security deposit amount");
        
        agreementCounter++;
        
        rentalAgreements[agreementCounter] = RentalAgreement({
            tenant: _tenant,
            landlord: msg.sender,
            monthlyRent: _monthlyRent,
            securityDeposit: _securityDeposit,
            leaseStartDate: block.timestamp,
            leaseDuration: _leaseDuration,
            lastPaymentDate: 0,
            depositAmount: msg.value,
            isActive: true,
            depositReturned: false
        });
        
        emit AgreementCreated(
            agreementCounter,
            _tenant,
            msg.sender,
            _monthlyRent,
            _securityDeposit
        );
    }
    
    /**
     * @dev Allows tenant to pay monthly rent
     * @param _agreementId ID of the rental agreement
     */
    function payRent(uint256 _agreementId) 
        external 
        payable 
        onlyTenant(_agreementId) 
        agreementExists(_agreementId) 
    {
        RentalAgreement storage agreement = rentalAgreements[_agreementId];
        
        // Check if lease has expired
        require(
            block.timestamp <= agreement.leaseStartDate + (agreement.leaseDuration * SECONDS_IN_MONTH),
            "Lease has expired"
        );
        
        uint256 totalAmount = agreement.monthlyRent;
        
        // Calculate late penalty if applicable
        if (agreement.lastPaymentDate > 0) {
            uint256 dueDate = agreement.lastPaymentDate + SECONDS_IN_MONTH;
            if (block.timestamp > dueDate + GRACE_PERIOD) {
                uint256 daysLate = (block.timestamp - dueDate - GRACE_PERIOD) / 1 days;
                uint256 penalty = (agreement.monthlyRent * LATE_PENALTY_RATE * daysLate) / (100 * 30);
                latePenalties[_agreementId] += penalty;
                totalAmount += penalty;
                
                emit LatePenaltyApplied(_agreementId, penalty);
            }
        }
        
        require(msg.value >= totalAmount, "Insufficient payment amount");
        
        // Update payment date
        agreement.lastPaymentDate = block.timestamp;
        
        // Transfer rent to landlord
        payable(agreement.landlord).transfer(totalAmount);
        
        // Refund excess payment
        if (msg.value > totalAmount) {
            payable(msg.sender).transfer(msg.value - totalAmount);
        }
        
        emit RentPaid(_agreementId, msg.sender, totalAmount, block.timestamp);
    }
    
    /**
     * @dev Returns security deposit to tenant (called by landlord)
     * @param _agreementId ID of the rental agreement
     * @param _deductionAmount Amount to deduct from deposit for damages
     */
    function returnSecurityDeposit(uint256 _agreementId, uint256 _deductionAmount) 
        external 
        onlyLandlord(_agreementId) 
        agreementExists(_agreementId) 
    {
        RentalAgreement storage agreement = rentalAgreements[_agreementId];
        
        require(!agreement.depositReturned, "Deposit already returned");
        require(
            block.timestamp > agreement.leaseStartDate + (agreement.leaseDuration * SECONDS_IN_MONTH),
            "Lease has not expired yet"
        );
        require(_deductionAmount <= agreement.depositAmount, "Deduction exceeds deposit");
        
        uint256 returnAmount = agreement.depositAmount - _deductionAmount;
        agreement.depositReturned = true;
        agreement.isActive = false;
        
        if (returnAmount > 0) {
            payable(agreement.tenant).transfer(returnAmount);
        }
        
        emit DepositReturned(_agreementId, agreement.tenant, returnAmount);
    }
    
    // View functions
    
    /**
     * @dev Get rental agreement details
     * @param _agreementId ID of the rental agreement
     */
    function getRentalAgreement(uint256 _agreementId) 
        external 
        view 
        returns (
            address tenant,
            address landlord,
            uint256 monthlyRent,
            uint256 securityDeposit,
            uint256 leaseStartDate,
            uint256 leaseDuration,
            uint256 lastPaymentDate,
            bool isActive,
            bool depositReturned
        ) 
    {
        RentalAgreement storage agreement = rentalAgreements[_agreementId];
        return (
            agreement.tenant,
            agreement.landlord,
            agreement.monthlyRent,
            agreement.securityDeposit,
            agreement.leaseStartDate,
            agreement.leaseDuration,
            agreement.lastPaymentDate,
            agreement.isActive,
            agreement.depositReturned
        );
    }
    
    /**
     * @dev Check if rent payment is overdue
     * @param _agreementId ID of the rental agreement
     */
    function isRentOverdue(uint256 _agreementId) external view returns (bool) {
        RentalAgreement storage agreement = rentalAgreements[_agreementId];
        
        if (!agreement.isActive || agreement.lastPaymentDate == 0) {
            return false;
        }
        
        uint256 dueDate = agreement.lastPaymentDate + SECONDS_IN_MONTH;
        return block.timestamp > dueDate + GRACE_PERIOD;
    }
    
    /**
     * @dev Get total penalty amount for an agreement
     * @param _agreementId ID of the rental agreement
     */
    function getTotalPenalty(uint256 _agreementId) external view returns (uint256) {
        return latePenalties[_agreementId];
    }
}
