// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC721TokenReceiver} from "forge-std/interfaces/IERC721.sol";
import "forge-std/console.sol";

interface IERC721 {
    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function transferFrom(address from, address to, uint256 tokenId) external;
    function approve(address to, uint256 tokenId) external;
    function setApprovalForAll(address operator, bool approved) external;
    function getApproved(uint256 tokenId) external view returns (address operator);
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
}


contract NFinTech is IERC721 {
    string private _name;
    string private _symbol;

    uint256 private _tokenId;

    mapping(uint256 => address) private _owner;
    mapping(address => uint256) private _balances;
    mapping(address => bool) private isClaim;

    mapping(uint256 => address) private _tokenApproved;
    mapping(address => mapping(address => bool)) private _allApproved;
    
    error ZeroAddress();

    constructor(string memory name_, string memory symbol_) payable {
        _name = name_;
        _symbol = symbol_;
    }

    function claim() public {
        if (isClaim[msg.sender] == false) {
            uint256 id = _tokenId;
            _owner[id] = msg.sender;

            _balances[msg.sender] += 1;
            isClaim[msg.sender] = true;

            _tokenId += 1;
        }
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function balanceOf(address owner) public view returns (uint256) {
        if (owner == address(0)) revert ZeroAddress();
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _owner[tokenId];
        if (owner == address(0)) revert ZeroAddress();
        return owner;
    }

    // TODO: Implement setApproveForAll function
    // TODO: Implement isApprovedForAll function
    // TODO: Implement approve function
    // TODO: Implement getApproved function

    function setApprovalForAll(address operator, bool approved) external{
        if (operator == address(0)) revert ZeroAddress();
        _allApproved[msg.sender][operator] = approved;
        // console.log("HELLO???");
        // console.logAddress(operator);
        emit ApprovalForAll(msg.sender, operator, approved);
    }
    function isApprovedForAll(address owner, address operator) external view returns (bool){
        return _allApproved[owner][operator];
    }
    function approve(address to, uint256 tokenId) external{
        address owner = ownerOf(tokenId);
        require(owner == msg.sender || _allApproved[owner][msg.sender], "You can't approve");
        _tokenApproved[tokenId] = to;
        
        emit Approval(owner, to, tokenId);
    }
    function getApproved(uint256 tokenId) external view returns (address operator){
        address owner = ownerOf(tokenId);
        return  _tokenApproved[tokenId];
    }

    // TODO: Implement transferFrom function
    // TODO: Implement safeTransferFrom function

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external{
        address owner = ownerOf(tokenId);
        require(from != address(0) && to != address(0), "safeTransferFrom failed");
        require((owner == msg.sender || _tokenApproved[tokenId] == msg.sender || _allApproved[owner][msg.sender] == true), "safeTransferFrom failed");
        
        if (to.code.length > 0){
            bytes4 ret = IERC721TokenReceiver(to).onERC721Received(msg.sender, from, tokenId, data);
            require(ret == IERC721TokenReceiver.onERC721Received.selector, "onERC721Received failed");
        }

        _balances[to] += 1;
        _balances[from] -= 1;
        _owner[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }
    function safeTransferFrom(address from, address to, uint256 tokenId) external{
        address owner = ownerOf(tokenId);
        require(from != address(0) && to != address(0), "safeTransferFrom failed");
        require((owner == msg.sender || _tokenApproved[tokenId] == msg.sender || _allApproved[owner][msg.sender] == true), "safeTransferFrom failed");
        
        if (to.code.length > 0){
            bytes4 ret = IERC721TokenReceiver(to).onERC721Received(msg.sender, from, tokenId, "");
            require(ret == IERC721TokenReceiver.onERC721Received.selector, "onERC721Received failed");
        }

        _balances[to] += 1;
        _balances[from] -= 1;
        _owner[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }
    function transferFrom(address from, address to, uint256 tokenId) external{
        address owner = ownerOf(tokenId);
        require(from != address(0) && to != address(0), "safeTransferFrom failed");
        require((owner == msg.sender || _tokenApproved[tokenId] == msg.sender || _allApproved[owner][msg.sender] == true), "safeTransferFrom failed");

        _balances[to] += 1;
        _balances[from] -= 1;
        _owner[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }
}
