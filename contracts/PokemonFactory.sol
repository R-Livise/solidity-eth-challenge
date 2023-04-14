// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./PokemonType.sol";

library StringUtils {
    /**
     * @dev Returns the length of a given string
     *
     * @param s The string to measure the length of
     * @return The length of the input string
     */
    function strlen(string memory s) internal pure returns (uint256) {
        uint256 len;
        uint256 i = 0;
        uint256 bytelength = bytes(s).length;

        for (len = 0; i < bytelength; len++) {
            bytes1 b = bytes(s)[i];
            if (b < 0x80) {
                i += 1;
            } else if (b < 0xE0) {
                i += 2;
            } else if (b < 0xF0) {
                i += 3;
            } else if (b < 0xF8) {
                i += 4;
            } else if (b < 0xFC) {
                i += 5;
            } else {
                i += 6;
            }
        }
        return len;
    }
}

contract PokemonFactory {
    using StringUtils for string;

    struct Pokemon {
        uint id;
        string name;
        uint[4] abilities;
        uint32[2] types;
    }

    struct Ability {
        string name;
        string description;
        bool isSet;
    }

    mapping(uint => address) public pokemonToOwner;
    mapping(address => uint) ownerPokemonCount;
    mapping(uint => Pokemon) public pokemons;
    mapping(uint => Ability) abilities;

    uint public currentPokemonId;
    event eventNewPokemon(uint _id, string _name);
    event eventNewAbility(uint _id, string _name, string _description);

    function createPokemon(
        uint _id,
        string memory _name,
        uint32[2] memory types
    ) public {
        require(_id > 0, "_id must to be greater than 0.");
        require(
            _name.strlen() > 2,
            "_name must to have a character lenght > 2."
        );
        uint ZERO = 0;

        currentPokemonId++;
        pokemons[currentPokemonId] = Pokemon(
            _id,
            _name,
            [1, ZERO, ZERO, ZERO],
            types
        );
        pokemonToOwner[currentPokemonId] = msg.sender;
        ownerPokemonCount[msg.sender]++;
        emit eventNewPokemon(_id, _name);
    }

    function createAbilitys(
        uint _id,
        string memory _name,
        string memory _description
    ) public {
        require(_id > 0, "_id must to be greater than 0.");
        require(
            _name.strlen() > 2,
            "_name must to have a character lenght > 2."
        );
        require(
            _description.strlen() > 2,
            "_description must to have a character lenght > 2."
        );

        abilities[_id] = Ability(_name, _description, true);
        emit eventNewAbility(_id, _name, _description);
    }

    function changeAbilityToPokomeon(
        uint _idPokemon,
        uint _idAbility,
        uint _position
    ) public {
        require(_idPokemon > 0, "_idPokemon must to be greater than 0.");
        require(_position > 0, "_position must to be lower equal than 4.");
        require(abilities[_idAbility].isSet, "_idAbility must not to be empty");
        pokemons[_idPokemon].abilities[_position] = _idAbility;
    }
}
