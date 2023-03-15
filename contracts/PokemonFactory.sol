// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract PokemonFactory {
    struct Pokemon {
        uint id;
        string name;
        uint[4] abilities;
    }

    struct Ability {
        string name;
        string description;
    }

    Pokemon[] private pokemons;

    mapping(uint => address) public pokemonToOwner;
    mapping(address => uint) ownerPokemonCount;
    mapping(uint => Ability) abilitys;

    event eventNewPokemon(uint _id, string _name);
    event eventNewAbility(uint _id, string _name, string _description);

    function createPokemon(uint _id, string memory _name) public {
        require(_id > 0, "_id must to be greater than 0.");
        require(
            bytes(_name).length > 2,
            "_name must to have a character lenght > 2."
        );
        uint ZERO = 0;
        pokemons.push(Pokemon(_id, _name, [ZERO, ZERO, ZERO, ZERO]));
        pokemonToOwner[_id] = msg.sender;
        ownerPokemonCount[msg.sender]++;
        emit eventNewPokemon(_id, _name);
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

    function createAbilitys(
        uint _id,
        string memory _name,
        string memory _description
    ) public {
        require(_id > 0, "_id must to be greater than 0.");
        require(
            bytes(_name).length > 2,
            "_name must to have a character lenght > 2."
        );
        require(
            bytes(_description).length > 2,
            "_description must to have a character lenght > 2."
        );

        abilitys[_id] = Ability(_name, _description);
        emit eventNewAbility(_id, _name, _description);
    }
}
