// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract SimpleStorage {
    uint256 public favoriteNumber = 88;

    function store(uint256 _favoriteNumber) public virtual {
        favoriteNumber = _favoriteNumber;
    }

    struct Person {
        uint256 favoriteInteger;
        string name;
    }

    Person public anas = Person({favoriteInteger: 56, name: "Bisam"});

    Person[] public people;
    mapping(string => uint256) public personToFavoriteNumber;

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(Person({favoriteInteger: _favoriteNumber, name: _name}));
        personToFavoriteNumber[_name] = _favoriteNumber;
    }

    function getPersonFavoriteNumber(string memory _name) public view returns (uint256) {
        return personToFavoriteNumber[_name];
    }

    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }
}