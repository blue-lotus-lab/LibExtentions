// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev How to use:
 * first import library, then
 *  ```
 *   examples of "how to use" in buttom of this file
 *  ```
 * 
 * ! not limitation of use this linked-list statement !
 *
 * you can inspire from it!
 *
 * Library created by: https://lotuschain.org {LibExtentions}
*/

library LinkedList {
    struct Node {
        uint256 data;
        uint256 next;
    }

    struct List {
        uint256 head;
        uint256 tail;
        mapping(uint256 => Node) nodes;
    }

    function insert(List storage list, uint256 data) internal {
        Node memory newNode = Node(data, 0);

        if (list.head == 0) {
            list.head = 1;
            list.tail = 1;
        } else {
            list.nodes[list.tail].next = list.tail + 1;
            list.tail += 1;
        }

        list.nodes[list.tail] = newNode;
    }

    // in multiple data with same value, remove last one
    function remove(List storage list, uint256 data) internal {
        require(list.head != 0, "List is empty");

        uint256 currentNode = list.head;
        uint256 previousNode = 0;

        while (currentNode != 0) {
            if (list.nodes[currentNode].data == data) {
                if (previousNode == 0) {
                    list.head = list.nodes[currentNode].next;
                } else {
                    list.nodes[previousNode].next = list.nodes[currentNode].next;
                }

                delete list.nodes[currentNode];
                break;
            }

            previousNode = currentNode;
            currentNode = list.nodes[currentNode].next;
        }
    }

    function get(List storage list, uint256 index) internal view returns (uint256) {
        require(index > 0 && index <= list.tail, "Invalid index");

        uint256 currentNode = list.head;

        for (uint256 i = 1; i <= index; i++) {
            if (i == index) {
                return list.nodes[currentNode].data;
            }

            currentNode = list.nodes[currentNode].next;
        }

        revert("Index not found");
    }
}

/* ----------------------------------------------------------------------------------
[
    { 
        "creator": "lotuschain-lab",
        "web3-home": "https://lotuschain.org",
        "ALT-id": "@ALT"
    }
]
---------------------------------------------------------------------------------- */

// ======================================================
// ================ LIST OF EXAMPLES ====================
// ======================================================
/*
// import "./LinkedList.sol";

contract ExampleContract {
    using LinkedList for LinkedList.List;

    LinkedList.List private myList;

    function addData(uint256 data) public {
        myList.insert(data);
    }

    // in multiple data with same value, remove last one
    function removeData(uint256 data) public {
        myList.remove(data);
    }

    function getData(uint256 index) public view returns (uint256) {
        return myList.get(index);
    }
}
*/
