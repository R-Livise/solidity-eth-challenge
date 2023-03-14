import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { ethers } from "hardhat"
import { expect } from "chai";

describe("PokemonFactory", function () {
  async function deployPokemonFactory() {
    const PokemonFactory = await ethers.getContractFactory("PokemonFactory");
    const pokemonFactory = await PokemonFactory.deploy()

    return { pokemonFactory }
  }

  describe("deploy", async function () {
    it("Should to be empty array", async function () {
      const { pokemonFactory } = await loadFixture(deployPokemonFactory)
      const pokemons = await pokemonFactory.getAllPokemons()
      expect(Array.isArray(pokemons)).to.be.true;
      expect(pokemons.length).to.be.equal(0);
    })
    it("Should to be array with one pokemon", async function () {
      const { pokemonFactory } = await loadFixture(deployPokemonFactory)
      await pokemonFactory.createPokemon(1, "bullbasur")
      const pokemons = await pokemonFactory.getAllPokemons()
      expect(Array.isArray(pokemons)).to.be.true;
      expect(pokemons.length).to.be.equal(1);

    })

    it("Should create first pokemon like a name bullbasur", async function () {
      const { pokemonFactory } = await loadFixture(deployPokemonFactory)
      await pokemonFactory.createPokemon(1, "bullbasur")
      const pokemons = await pokemonFactory.getAllPokemons()
      expect(pokemons[0].name).to.be.equal("bullbasur");
    })
  })

  describe("event", async function () {
    it("Should emit a event newPokemon", async function () {
      const { pokemonFactory } = await loadFixture(deployPokemonFactory)
      const pokemonName = "bullbasur";
      const pokemonId = 1;
      expect(pokemonFactory.createPokemon(pokemonId, pokemonName))
        .to.emit(pokemonFactory, "eventNewPokemon")
        .withArgs(pokemonId, pokemonName)
    })
  })

})