// SPDX-Micense-Identifer : MIT

pragma solidity ^0.8.2;

error InsufficienceBalance();

contract Test {

    address public myAddress;
    uint public contractValue;

    // Faire une fonction pour set une adresse et la stocker dans une variable
    function setMyAddress(address _myAddress) external {
        myAddress = _myAddress;
    }

    // Faire une fonction pour transferer de l'argent au contrat
    function transferMoney() external payable {
        myAddress = msg.sender;
        contractValue = msg.value;
    }

    // Faire une fonction pour récupérer le balance du contrat
    function getBalance() external view returns(uint) {
        return myAddress.balance / 10 ** 18; // division pour Ether
    }

    // Faire une fonction pour récupérer le balance d'une adresse spécifique
    function getSpecificBalance(address _address) external view returns(uint) {
        return _address.balance / 10 ** 18; // division pour Ether
    }

    // Faire une fonction pour transferer de l'argent à une autre adresse via transfer
    function transferMoneyTo(address payable _to) external payable {
        _to.transfer(msg.value);
    }

    // Faire une fonction pour transferer de l'argent à une autre adresse via send
    function sendViaSend(address payable _to) external payable {
        bool sent = _to.send(msg.value);
        require(sent, "Failed to send Ether");
    }

    // Faire une fonction pour transferer de l'argent à une autre adresse via call
    function sendViaCall(address payable _to) external payable {
        (bool sent,) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }

    // Faire une fonction qui permet de faire un trasfert d'eth vers l'adresse stockée, 
    // si et uniquemnt si elle a une balance supérieure à une valeur donnée en parametre avec transfer
    function transferToMyAddress(uint _amount) external {
       /*  require(myAddress.balance >= _amount, "Balance is not sufficient"); TOO EXPENSIVE GAS
        payable(myAddress).transfer(_amount); */
        if(myAddress.balance <= _amount) {
            revert InsufficienceBalance();
        } else {
            payable(myAddress).transfer(_amount);
        }
    }

    // Faire une fonction qui permet de faire un transfert d'eth vers l'adresse stockée, 
    // si et uniquemnt si elle a une balance supérieure à une valeur donnée en parametre avec send
    function sendToMyAddress(address payable _to, uint _amount) external payable {
        require(myAddress.balance >= _amount, "Balance is not sufficient");
        bool sent = _to.send(_amount);
        require(sent, "Failed to send Ether");

        require(msg.value >= 1, "Not enough Ether provided."); // 1 wei minimum
    }

}