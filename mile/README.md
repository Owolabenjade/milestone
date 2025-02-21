# Milestone-Based Crowdfunding Smart Contract

A secure and transparent crowdfunding solution built with Clarity on the Stacks blockchain that implements milestone-based fund release.

## Overview

This smart contract enables project creators to raise funds with built-in accountability through milestone-based fund releases. Instead of receiving all funds at once, project creators only gain access to funds as they complete predefined milestones, creating transparency and reducing risk for backers.

## Features

- **Project Creation**: Define a funding goal and up to 10 milestones with specific funding amounts
- **Backer Contribution**: Allow backers to pledge funds to projects
- **Milestone Tracking**: Track the completion status of each milestone
- **Secure Fund Release**: Release funds only when project owner marks milestones as complete
- **Input Validation**: Comprehensive validation of all user inputs

## Contract Functions

### create-project

Creates a new crowdfunding project with milestone-based funding.

```clarity
(define-public (create-project (goal uint) (milestones (list 10 uint))))
```

**Parameters:**
- `goal`: The total funding goal (in microSTX)
- `milestones`: A list of 10 milestone amounts that must add up to the goal amount

**Returns:**
- `(ok uint)`: The project ID if successful
- `(err uint)`: Error code if creation fails

**Validation:**
- Goal must meet minimum threshold (1 STX)
- Milestone amounts must add up to the total goal
- At least one milestone must have a non-zero amount

### pledge

Allows users to pledge funds to a project.

```clarity
(define-public (pledge (project-id uint) (amount uint)))
```

**Parameters:**
- `project-id`: The ID of the project to fund
- `amount`: The amount to pledge (in microSTX)

**Returns:**
- `(ok true)`: If pledge is successful
- `(err uint)`: Error code if pledge fails

**Validation:**
- Pledge amount must meet minimum threshold (0.01 STX)
- Project must exist

### release-funds

Releases funds for a completed milestone to the project owner.

```clarity
(define-public (release-funds (project-id uint) (milestone-index uint)))
```

**Parameters:**
- `project-id`: The ID of the project
- `milestone-index`: The index of the milestone to mark as complete

**Returns:**
- `(ok true)`: If funds are released successfully
- `(err uint)`: Error code if release fails

**Validation:**
- Only the project owner can release funds
- Milestone must not already be marked as complete
- Project must exist

## Error Codes

- `200`: Invalid goal amount
- `201`: Invalid milestone configuration
- `202`: Invalid pledge amount
- `100`: Project not found
- `102`: Unauthorized operation
- `103`: Transfer failed

## Security Features

- Input validation for all user-supplied data
- Minimum thresholds for goals and pledges
- Response checking for all operations
- Authorization checks for fund releases

## Implementation Notes

- All amounts are in microSTX (1 STX = 1,000,000 microSTX)
- Milestones are stored in a fixed-size list of 10 elements
- Milestone status is tracked as a list of boolean values

## Usage Example

1. **Create a project with 3 milestones:**
   ```clarity
   (create-project u5000000 (list u1000000 u2000000 u2000000 u0 u0 u0 u0 u0 u0 u0))
   ```
   This creates a project with a 5 STX goal, split into three milestones (1 STX, 2 STX, 2 STX).

2. **Pledge funds to the project:**
   ```clarity
   (pledge u1 u500000)
   ```
   This pledges 0.5 STX to project #1.

3. **Release funds for the first milestone:**
   ```clarity
   (release-funds u1 u0)
   ```
   This releases funds for the first milestone of project #1.

## Project Structure

📦 milestone-crowdfunding
 ┣ 📂 contracts
 ┃ ┣ 📜 milestone-crowdfunding.clar  # Main Clarity smart contract
 ┃ ┣ 📜 voting.clar                  # Voting mechanism contract
 ┃ ┣ 📜 utils.clar                    # Utility functions
 ┃ ┗ 📜 README.md                     # Contract documentation
 ┣ 📂 tests
 ┃ ┣ 📜 milestone-crowdfunding-test.ts  # Unit tests using Clarinet
 ┃ ┣ 📜 voting-test.ts                  # Tests for voting mechanism
 ┃ ┗ 📜 README.md                        # Testing documentation
 ┣ 📂 scripts
 ┃ ┣ 📜 deploy.ts                       # Deployment script for the contract
 ┃ ┣ 📜 interact.ts                      # Script for interacting with the contract
 ┃ ┗ 📜 README.md                        # How to use scripts
 ┣ 📂 frontend
 ┃ ┣ 📂 src
 ┃ ┃ ┣ 📜 App.js                         # Main frontend application
 ┃ ┃ ┣ 📜 ContractInteractions.js        # Functions to interact with contract
 ┃ ┃ ┣ 📜 components/
 ┃ ┗ 📜 README.md                        # Frontend instructions
 ┣ 📜 README.md                           # Overview of project
 ┣ 📜 .clarinet.toml                      # Clarinet configuration
 ┣ 📜 package.json                        # Dependencies (if frontend included)
 ┗ 📜 LICENSE                             # Open-source license
