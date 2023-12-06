// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract parent {
    // Internal pour être lue depuis les contrats enfants
    uint256 internal sum;

    function setValue(uint256 _value) external {
        sum = _value;
    }
}

contract child is parent {
    // Du coup ici on peut récupérer la variable sum
    function getValue() external view returns(uint256) {
        return sum;
    }
}

contract caller {
    // On crée un contrat child
    child cc = new child();

    function testInheritance(uint256 _value) public returns(uint256) {
        cc.setValue(_value);
        return cc.getValue();
    }
}