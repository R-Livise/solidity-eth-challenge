// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract PokemonFactory {
    struct Pokemon {
        uint id;
        string name;
        uint[] abilities;
    }

    struct Ability {
        string name;
        string description;
    }

    Pokemon[] pokemons;
    mapping(uint => Ability) public abilities;
    mapping(uint => address) public pokemonToOwner;
    mapping(address => uint) ownerPokemonCount;

    event eventNewPokemon(uint _id, string _name);

    function createPokemon(uint _id, string memory _name) public {
        require(_id > 0, "_id must be greater than 0");
        require(
            bytes(_name).length > 2,
            "length characters of _name must be greater than 2"
        );
        uint[] memory abilitiesEmpty;
        pokemons.push(Pokemon(_id, _name, abilitiesEmpty));
        pokemonToOwner[_id] = msg.sender;
        ownerPokemonCount[msg.sender]++;
        emit eventNewPokemon(_id, _name);
    }

    function createAbilities(
        uint _id,
        string memory _name,
        string memory _description
    ) public {
        require(_id > 0, "_id must be greater than 0");
        require(
            bytes(_name).length > 2,
            "length characters of _name must be greater than 2"
        );
        abilities[_id] = Ability(_name, _description);
    }

    function addAbilitiesToPokemon(uint _idAbility, uint _idPokemon) public {
        pokemons[_idPokemon].abilities.push(_idAbility);
    }

    function getAllPokemons() public view returns (Pokemon[] memory) {
        return pokemons;
    }

    function getResult() public pure returns (uint product, uint sum) {
        uint a = 1;
        uint b = 2;
        product = a * b;
        sum = a + b;
    }
}
