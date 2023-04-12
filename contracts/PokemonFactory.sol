// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

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
    }

    struct Ability {
        string name;
        string description;
    }

    mapping(uint => address) public pokemonToOwner;
    mapping(address => uint) ownerPokemonCount;
    mapping(uint => Pokemon) public pokemons;
    mapping(uint => Ability) abilities;

    uint public currentPokemonId;
    uint currentAbilityId;
    event eventNewPokemon(uint _id, string _name);
    event eventNewAbility(uint _id, string _name, string _description);

    function createPokemon(uint _id, string memory _name) public {
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
            [ZERO, ZERO, ZERO, ZERO]
        );
        pokemonToOwner[currentPokemonId] = msg.sender;
        ownerPokemonCount[msg.sender]++;
        emit eventNewPokemon(_id, _name);
    }

    function getResult() public pure returns (uint product, uint sum) {
        uint a = 1;
        uint b = 2;
        product = a * b;
        sum = a + b;
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

        abilities[_id] = Ability(_name, _description);
        emit eventNewAbility(_id, _name, _description);
    }
}
