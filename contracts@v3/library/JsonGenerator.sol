// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev How to use:
 * first import library, then
 *  ```
 *   using JsonHelper for JsonHelper.JsonValue;
 *   function getJson() external pure returns (string memory) {
 *       JsonHelper.JsonValue[] memory jsonArray = new JsonHelper.JsonValue[](3);
 *       jsonArray[0] = JsonHelper.createString("Hello");
 *       jsonArray[1] = JsonHelper.createNumber(42);
 *       jsonArray[2] = JsonHelper.createBool(true);
 *       JsonHelper.JsonValue memory jsonObject = JsonHelper.createArray(jsonArray);
 *       return JsonHelper.toJson(jsonObject);
 *   }
 *  ```
 * then implementing requirment functions.
 *
 * this is work on "string, int256, bool" as array. you can inspire from it!
 *
 * Library created by: https://lotuschain.org {LibExtentions}
*/

library JsonHelper {
    enum JsonType { NULL, STRING, NUMBER, BOOL, ARRAY }

    struct JsonValue {
        JsonType valueType;
        string stringValue;
        int256 intValue;
        bool boolValue;
        JsonValue[] arrayValue;
    }

    function createString(string memory value) internal pure returns (JsonValue memory) {
        return JsonValue(JsonType.STRING, value, 0, false, new JsonValue[](0));
    }

    function createNumber(int256 value) internal pure returns (JsonValue memory) {
        return JsonValue(JsonType.NUMBER, "", value, false, new JsonValue[](0));
    }

    function createBool(bool value) internal pure returns (JsonValue memory) {
        return JsonValue(JsonType.BOOL, "", 0, value, new JsonValue[](0));
    }

    function createArray(JsonValue[] memory elements) internal pure returns (JsonValue memory) {
        return JsonValue(JsonType.ARRAY, "", 0, false, elements);
    }

    function toJson(JsonValue memory json) internal pure returns (string memory) {
        if (json.valueType == JsonType.NULL) {
            return "null";
        } else if (json.valueType == JsonType.STRING) {
            return string(abi.encodePacked('"', json.stringValue, '"'));
        } else if (json.valueType == JsonType.NUMBER) {
            return intToString(json.intValue);
        } else if (json.valueType == JsonType.BOOL) {
            return json.boolValue ? "true" : "false";
        } else if (json.valueType == JsonType.ARRAY) {
            return arrayToJson(json.arrayValue);
        }

        return "";
    }

    function arrayToJson(JsonValue[] memory array) internal pure returns (string memory) {
        string memory result;
        for (uint256 i = 0; i < array.length; i++) {
            if (i > 0) {
                result = string(abi.encodePacked(result, ",")); // Add comma separator
            }
            result = string(abi.encodePacked(result, toJson(array[i])));
        }
        return string(abi.encodePacked("[", result, "]"));
    }

    function intToString(int256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        bool negative = value < 0;
        uint256 intValue = negative ? uint256(-value) : uint256(value);
        uint256 temp = intValue;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(negative ? digits + 1 : digits);
        uint256 index = digits;
        temp = intValue;
        while (temp != 0) {
            index--;
            buffer[index] = bytes1(uint8(48 + temp % 10));
            temp /= 10;
        }
        if (negative) {
            buffer[0] = '-';
        }
        return string(buffer);
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
