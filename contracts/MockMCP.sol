// contracts/MockMCP.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./interfaces/IMCP.sol";

contract MockMCP is IMCP {
    mapping(uint256 => bool) public requests;
    uint256 public nextRequestId = 1;
    
    function requestAIInteraction(
        string memory modelProvider,
        string memory modelId,
        string memory prompt,
        string memory parameters
    ) external override returns (uint256) {
        uint256 requestId = nextRequestId++;
        requests[requestId] = true;
        
        emit AIRequestSent(
            msg.sender,
            modelProvider,
            modelId,
            prompt,
            parameters,
            requestId
        );
        
        return requestId;
    }
    
    function registerAIResponse(
        uint256 requestId,
        address requester,
        string memory response
    ) public override {
        require(requests[requestId], "Request does not exist");
        
        emit AIResponseReceived(
            requestId,
            requester,
            response,
            block.timestamp
        );
    }
    
    // For testing: simulate AI response
    function simulateResponse(uint256 requestId, address requester, string memory response) external {
        registerAIResponse(requestId, requester, response);
    }
}