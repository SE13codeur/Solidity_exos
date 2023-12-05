// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./Token.sol";

contract Note is Ownable {

    struct Student {
        string name;
        uint noteBiology;
        uint noteMath;
        uint noteFrench;
        bool hasNotes;
    }

    mapping(address => Student) private students;
    address[] private studentAddresses;

    modifier validNotes(uint _biology, uint _math, uint _french) {
        require(_biology <= 20 && _math <= 20 && _french <= 20, "Notes must be between 0 and 20");
        _;
    }

    modifier studentExists(address _studentAddress) {
        require(students[_studentAddress].hasNotes, "Student does not exist");
        _;
    }

    function addStudent(address _studentAddress, string memory _name) public onlyOwner {
        require(!students[_studentAddress].hasNotes, "Student already exists");
        students[_studentAddress] = Student(_name, 0, 0, 0, false);
        studentAddresses.push(_studentAddress);
    }

    function addNote(address _studentAddress, uint _biology, uint _math, uint _french) 
    public onlyOwner validNotes(_biology, _math, _french) studentExists(_studentAddress) {
        Student storage student = students[_studentAddress];
        student.noteBiology = _biology;
        student.noteMath = _math;
        student.noteFrench = _french;
        student.hasNotes = true;
    }

    function getNote(address _studentAddress) public view studentExists(_studentAddress) returns (uint, uint, uint) {
        Student storage student = students[_studentAddress];
        return (student.noteBiology, student.noteMath, student.noteFrench);
    }

    function getAverageNote(address _studentAddress) public view studentExists(_studentAddress) returns (uint) {
        Student storage student = students[_studentAddress];
        return (student.noteBiology + student.noteMath + student.noteFrench) / 3;
    }

    function getClassAverageForSubject(string memory subject) public view returns (uint) {
        require(studentAddresses.length > 0, "No students in class");

        uint total = 0;
        for (uint i = 0; i < studentAddresses.length; i++) {
            Student storage student = students[studentAddresses[i]];
            if (keccak256(abi.encodePacked(subject)) == keccak256(abi.encodePacked("Biology"))) {
                total += student.noteBiology;
            } else if (keccak256(abi.encodePacked(subject)) == keccak256(abi.encodePacked("Math"))) {
                total += student.noteMath;
            } else if (keccak256(abi.encodePacked(subject)) == keccak256(abi.encodePacked("French"))) {
                total += student.noteFrench;
            }
        }
        return total / studentAddresses.length;
    }

    function getClassOverallAverage() public view returns (uint) {
        require(studentAddresses.length > 0, "No students in class");

        uint total = 0;
        for (uint i = 0; i < studentAddresses.length; i++) {
            total += getAverageNote(studentAddresses[i]);
        }
        return total / studentAddresses.length;
    }

    function isStudentPassing(address _studentAddress) public view studentExists(_studentAddress) returns (bool) {
        return getAverageNote(_studentAddress) >= 10;
    }
}
