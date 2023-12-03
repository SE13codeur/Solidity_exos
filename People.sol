// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract People {
  struct Person {
    string name;
    uint age;
  }
  Person moi;

  function modifyPerson(string memory _name, uint _age) public {
    moi.name = _name;
    moi.age = _age;
  }

  Person[] public tabPerson;

  function addPerson(string memory _name, uint _age) public {
    tabPerson.push(Person(_name, _age));
  }

  function removePerson(uint _index) public {
    tabPerson[_index] = tabPerson[tabPerson.length - 1];
    tabPerson.pop();
  }
}