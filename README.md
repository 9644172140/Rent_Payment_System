# Rent Payment System

A decentralized rent payment system built on blockchain using Solidity smart contracts, enabling automated rent collection with built-in security deposit management and late payment penalties.

## Project Description

The Rent Payment System is a blockchain-based solution that revolutionizes traditional rental agreements by providing a transparent, automated, and secure platform for rent payments. Built on the Core Testnet 2 blockchain, this smart contract system eliminates the need for intermediaries while ensuring trust between landlords and tenants through immutable blockchain technology.

The system handles the entire rental lifecycle from agreement creation to security deposit returns, with built-in mechanisms for late payment penalties and grace periods. All transactions are recorded on the blockchain, providing complete transparency and eliminating disputes over payment history.

## Project Vision

Our vision is to create a decentralized rental ecosystem that:

- **Eliminates traditional rental friction** by automating payment processes and reducing manual interventions
- **Provides transparent and immutable records** of all rental transactions and agreements
- **Ensures fair treatment** for both landlords and tenants through smart contract automation
- **Reduces rental disputes** by clearly defined terms and automatic enforcement
- **Enables global accessibility** allowing anyone to participate in the rental market regardless of location
- **Builds trust through technology** by removing the need for intermediaries and third-party payment processors

## Key Features

### Core Functionality
- **Automated Rental Agreements**: Create binding rental contracts with predefined terms including rent amount, security deposit, and lease duration
- **Secure Rent Payments**: Process monthly rent payments with automatic validation and fund transfer to landlords
- **Security Deposit Management**: Automatic handling of security deposits with controlled release mechanisms

### Advanced Features
- **Late Payment Penalties**: Automatic calculation and application of late fees (5% per month) after a 5-day grace period
- **Grace Period Protection**: Built-in 5-day grace period for rent payments to accommodate payment delays
- **Lease Expiration Tracking**: Automatic monitoring of lease terms and expiration dates
- **Transparent Payment History**: Complete on-chain record of all payments and transactions
- **Multi-party Validation**: Separate roles and permissions for landlords and tenants

### Security Features
- **Role-based Access Control**: Strict permissions ensuring only authorized parties can perform specific actions
- **Immutable Agreement Terms**: Once created, rental agreements cannot be altered, ensuring fairness
- **Secure Fund Handling**: Smart contract manages all financial transactions securely
- **Overflow Protection**: Built-in protections against common smart contract vulnerabilities

### User Experience
- **Simple Interface**: Easy-to-use functions for creating agreements and making payments
- **Real-time Status Updates**: Instant feedback on payment status and agreement details
- **Event Logging**: Comprehensive event emissions for all major contract interactions
- **Gas Optimization**: Efficient contract design minimizing transaction costs

## Future Scope

### Short-term Enhancements (3-6 months)
- **Mobile DApp Development**: Create user-friendly mobile applications for both Android and iOS
- **Payment Reminders**: Implement automated notification system for upcoming rent payments
- **Multi-currency Support**: Add support for various cryptocurrencies and stablecoins
- **Dispute Resolution**: Integrate decentralized arbitration mechanisms for conflict resolution

### Medium-term Expansion (6-12 months)
- **Advanced Analytics**: Develop comprehensive dashboards for payment history and rental analytics
- **Integration with Traditional Systems**: Bridge connections with existing property management software
- **Credit Scoring**: Implement on-chain credit scoring based on payment history
- **Insurance Integration**: Partner with insurance providers for rental property coverage

### Long-term Vision (1-2 years)
- **Cross-chain Compatibility**: Expand to multiple blockchain networks for broader accessibility
- **AI-powered Features**: Integrate artificial intelligence for predictive analytics and automated decision making
- **Regulatory Compliance**: Implement features to comply with various international rental regulations
- **Property Management Suite**: Develop comprehensive property management tools including maintenance requests and tenant screening

### Advanced Features
- **Fractional Ownership**: Enable multiple investors to own shares in rental properties
- **Automated Maintenance**: Smart contract integration with IoT devices for automated maintenance scheduling
- **Dynamic Pricing**: Implement market-based dynamic rent pricing mechanisms
- **Decentralized Identity**: Integration with blockchain-based identity verification systems

## Technical Specifications

### Smart Contract Details
- **Solidity Version**: 0.8.19
- **License**: MIT
- **Network**: Core Testnet 2 (Chain ID: 1115)
- **Gas Optimization**: Enabled with 200 runs

### Key Contract Functions
1. **createRentalAgreement()**: Initialize new rental agreements with security deposit
2. **payRent()**: Process monthly rent payments with late fee calculations
3. **returnSecurityDeposit()**: Landlord-controlled security deposit return mechanism

### Development Tools
- **Framework**: Hardhat
- **Testing**: Hardhat Toolbox
- **Deployment**: Custom deployment scripts for Core Testnet 2
- **Environment**: Node.js with dotenv configuration

## Getting Started

### Prerequisites
- Node.js (v14 or higher)
- npm or yarn
- Core Testnet 2 wallet with test tokens

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/rent-payment-system.git
cd rent-payment-system
```

2. Install dependencies
```bash
npm install
```

3. Configure environment variables
```bash
cp .env.example .env
# Edit .env with your private key and configuration
```

4. Compile contracts
```bash
npm run compile
```

5. Deploy to Core Testnet 2
```bash
npm run deploy
```

### Usage Examples

#### Creating a Rental Agreement
```javascript
// Landlord creates agreement with 1 ETH monthly rent and 2 ETH security deposit
await rentPaymentSystem.createRentalAgreement(
  tenantAddress,
  ethers.parseEther("1"), // Monthly rent
  ethers.parseEther("2"), // Security deposit
  12, // 12 months lease
  { value: ethers.parseEther("2") } // Send security deposit
);
```

#### Making Rent Payment
```javascript
// Tenant pays monthly rent
await rentPaymentSystem.payRent(agreementId, {
  value: ethers.parseEther("1") // Monthly rent amount
});
```

#### Returning Security Deposit
```javascript
// Landlord returns deposit with deduction for damages
await rentPaymentSystem.returnSecurityDeposit(
  agreementId,
  ethers.parseEther("0.5") // Damage deduction
);
```

## Contributing

We welcome contributions to the Rent Payment System! Please read our contributing guidelines and submit pull requests for any improvements.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please open an issue on GitHub or contact our development team.

---

**Built with ❤️ for the decentralized future of rental payments**

0xb6b52cb17c8cb4ab50f0c9b66229ea75389ad2fb46dac753329ac2308bb212f5![Uploading Screenshot (3).png…]()
