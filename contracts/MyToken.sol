// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IExerciceSolution.sol";

contract MyToken is
    Ownable,
    IExerciceSolution,
    ERC721Enumerable,
{
    uint256 private _nextTokenId;
    mapping(uint256 => uint) private _animalSex;
    mapping(uint256 => uint) private _animalLegs;
    mapping(uint256 => bool) private _animalWings;
    mapping(uint256 => string) private _animalName;
    mapping(address => bool) private _breeders;

    constructor() ERC721("MyToken", "MTK") Ownable() {
        _breeders[0x43981d9b7f031500f618727B68e554930eE99BB8] = true;
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _mint(to, tokenId);
    }

    function isBreeder(address account) public view returns (bool) {
        return _breeders[account];
    }

    function registrationPrice() public pure returns (uint256) {
        return 1;
    }

    function registerMeAsBreeder() public payable virtual {
        require(
            msg.value == registrationPrice(),
            "MyToken: registration price is not correct"
        );
        _breeders[msg.sender] = true;
        address payable _owner = payable(owner());
        _owner.transfer(msg.value);
    }

    function declareAnimal(
        uint sex,
        uint legs,
        bool wings,
        string calldata name
    ) public returns (uint256) {
        // require(isBreeder(msg.sender), "User is not breeder");
        uint currentId = _nextTokenId;
        _animalSex[currentId] = sex;
        _animalLegs[currentId] = legs;
        _animalWings[currentId] = wings;
        _animalName[currentId] = name;
        safeMint(msg.sender);
        return currentId;
    }

    function getAnimalCharacteristics(
        uint animalNumber
    )
        public
        view
        returns (string memory _name, bool _wings, uint _legs, uint _sex)
    {
        return (
            _animalName[animalNumber],
            _animalWings[animalNumber],
            _animalLegs[animalNumber],
            _animalSex[animalNumber]
        );
    }

    function declareDeadAnimal(uint animalNumber) public {
        _burn(animalNumber);
        _animalSex[animalNumber] = 0;
        _animalLegs[animalNumber] = 0;
        _animalWings[animalNumber] = false;
        _animalName[animalNumber] = "";
    }

    // Selling functions
    function isAnimalForSale(
        uint animalNumber
    ) public view virtual returns (bool) {}

    function animalPrice(
        uint animalNumber
    ) public view virtual returns (uint256) {}

    function buyAnimal(uint animalNumber) public payable virtual {}

    function offerForSale(uint animalNumber, uint price) public virtual {}

    // Reproduction functions

    function declareAnimalWithParents(
        uint sex,
        uint legs,
        bool wings,
        string calldata name,
        uint parent1,
        uint parent2
    ) public virtual returns (uint256) {}

    function getParents(
        uint animalNumber
    ) public virtual returns (uint256, uint256) {}

    function canReproduce(uint animalNumber) public virtual returns (bool) {}

    function reproductionPrice(
        uint animalNumber
    ) public view virtual returns (uint256) {}

    function offerForReproduction(
        uint animalNumber,
        uint priceOfReproduction
    ) public virtual returns (uint256) {}

    function authorizedBreederToReproduce(
        uint animalNumber
    ) public virtual returns (address) {}

    function payForReproduction(uint animalNumber) public payable virtual {}
}
