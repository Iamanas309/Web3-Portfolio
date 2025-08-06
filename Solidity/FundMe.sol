pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol"; // interface for price feed
import {PriceConverter} from "./PriceConverter.sol"; // custom library to convert ETH to USD

error NotOwner(); // custom error to save gas instead of using a string in require()

contract FundMe {
    using PriceConverter for uint256; // attaches the library to uint256 types (msg.value)

    mapping(address => uint256) public addressToAmountFunded; // keeps track of how much each address funded
    address[] public funders; // list of funders

    // Could we make this constant?  /* hint: no! We should make it immutable! */
    address public /* immutable */ i_owner; // the address that deployed the contract (owner)
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18; // minimum USD to fund (5 USD, scaled to 18 decimals)

    constructor() {
        i_owner = msg.sender; // sets the owner when the contract is deployed
    }

    function fund() public payable {
        // require user to send enough ETH to meet minimum USD equivalent
        require(msg.value.getConversionRate() >= MINIMUM_USD, "You need to spend more ETH!");
        // add the amount funded to the address's total
        addressToAmountFunded[msg.sender] += msg.value;
        // add sender to funders array
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        // returns the version number of the Chainlink price feed
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    modifier onlyOwner() {
        // make sure only the owner can call certain functions
        if (msg.sender != i_owner) revert NotOwner(); // reverts with a custom error (cheaper than require string)
        _; // runs the rest of the function
    }

    function withdraw() public onlyOwner {
        // loop through all funders
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex]; // get each funder
            addressToAmountFunded[funder] = 0; // reset their funded amount to 0
        }
        funders = new address[](0); // reset the array to empty

        // call (forwards all gas, returns bool)
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed"); // reverts if call fails
    }

    fallback() external payable {
        fund(); // fallback gets called when msg.data is not empty
    }

    receive() external payable {
        fund(); // receive gets called when msg.data is empty
    }
}