pragma solidity ^0.6.0;

import "https://github.com/unstoppable-domains/smart-contracts/contracts/interfaces/IController.sol";
import "https://github.com/unstoppable-domains/smart-contracts/contracts/interfaces/IController.sol";

contract DomainRegistry {
  IController public controller;
  mapping(bytes32 => address) public domains;
  bytes32[] public domainList;

  constructor(IController _controller) public {
    controller = _controller;
  }

  function registerDomain(bytes32 _label, address _owner) public {
    require(domains[_label] == address(0), "Domain is already registered.");
    domains[_label] = _owner;
    domainList.push(_label);
  }

  function transferDomain(bytes32 _label, address _newOwner) public {
    require(domains[_label] == msg.sender, "Only the current domain owner can transfer the domain.");
    domains[_label] = _newOwner;
  }
}

contract ENSResolver {
  DomainRegistry public registry;

  constructor(DomainRegistry _registry) public {
    registry = _registry;
  }

  function supportsInterface(bytes4 _interfaceID) public view returns (bool) {
    return _interfaceID == keccak256(abi.encodePacked("supportsInterface(bytes4)"))
        || _interfaceID == keccak256(abi.encodePacked("addr(bytes32)"))
        || _interfaceID == keccak256(abi.encodePacked("name(bytes32)"))
        || _interfaceID == keccak256(abi.encodePacked("setName(bytes32)"))
        || _interfaceID == keccak256(abi.encodePacked("setAddr(bytes32,address)"));
  }

  function addr(bytes32 _node) public view returns (address) {
    return registry.domains[_node];
  }

  function setAddr(bytes32 _node, address _addr) public {
    require(msg.sender == registry.domains[_node], "Only the domain owner can set the address.");
    registry.domains[_node] = _addr;
  }

  function name(bytes32 _node) public view returns (string memory) {
    return string(abi.encodePacked(_node));
  }

  function setName(bytes32 _node, string memory _name) public {
    require(msg.sender == registry.domains[_node], "Only the domain owner can set the name.");
    // set the name in the registry
  }
}