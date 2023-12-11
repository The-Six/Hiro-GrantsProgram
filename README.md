# Hiro-GrantsProgram

## Grants Program Instructions to run the program:

### 1. Go to terminal and open the clarinet console

`clarinet console`

### 2. Execute the bootstrap proposal by inputting

`(contract-call? .core construct .edp000-bootstrap)`

### 3. Submit the edp001-dev-fund proposal

`(contract-call? .proposal-submission propose .edp001-dev-fund "Proposal-title" "Proposal-description")`

### 4. Advance the chain 144 blocks

`::advance_chain_tip 144`

### 5. Check the current proposal data before voting

`(contract-call? .proposal-voting get-proposal-data .edp001-dev-fund)`

### 6. Vote Yes with 100 tokens

`(contract-call? .proposal-voting vote u100 true .edp001-dev-fund)`

### 7. Check the updated proposal data

`(contract-call? .proposal-voting get-proposal-data .edp001-dev-fund)`

### 8. Advance the chain tip

`::advance_chain_tip 1440`

### 9. Conclude the proposal vote

`(contract-call? .proposal-voting conclude .edp001-dev-fund)`

### 10. Check the ede005-dev-fund contract now

`::get_assets_maps`

Notes: Our contracts are not deployed on the blockchain and this is why we can only test the functionality locally through the clarinet console and not through a dynamic frontend. A button is created to validate this. Please open the Chrome Console to view the error message.
