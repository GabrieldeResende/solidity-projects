// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract CRUDBookstore {

    struct Book{
        string title;
        uint16 year;
    }

    uint32 private nextId = 0;
    mapping(uint32 => Book) public books;

    address private immutable owner;

    constructor() {
        owner = msg.sender;
    }

    function compare(string memory str1, string memory str2) private pure returns (bool){
        bytes memory arrA = bytes(str1);
        bytes memory arrB = bytes(str2);
        return arrA.length == arrB.length && keccak256(arrA) == keccak256(arrB);
    }

    function addBook(Book memory newBook) public {
        nextId++;
        books[nextId] = newBook;
    }

    function editBook(uint32 id, Book memory newBook) public restricted {
        Book memory oldBook = books[id];

        if(!compare(oldBook.title, newBook.title) && !compare(newBook.title, ""))
            books[id].title = newBook.title;

        if(oldBook.year != newBook.year && newBook.year > 0)
            books[id].year = newBook.year;
    }

    function removeBook(uint32 id) public restricted {
        delete books[id];
    }

    modifier restricted() {
        require(owner == msg.sender, "You dont have permission");
        _;
    }
}