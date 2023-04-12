import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { ethers } from "hardhat"
import { expect } from "chai";

describe("PokemonFactory", function () {
  async function deployPokemonFactory() {
    const PokemonFactory = await ethers.getContractFactory("PokemonFactory");
    const pokemonFactory = await PokemonFactory.deploy()

    return { pokemonFactory }
  }

  describe("Deploy", async function () {
    it("Should to be empty array", async function () {
      const { pokemonFactory } = await loadFixture(deployPokemonFactory)
      const pokemonsLength = await pokemonFactory.currentPokemonId()
      expect(pokemonsLength).to.be.equal(0);
    })
    it("Should to be array with one pokemon", async function () {
      const { pokemonFactory } = await loadFixture(deployPokemonFactory)
      await pokemonFactory.createPokemon(1, "bullbasur")
      console.log(await pokemonFactory.currentPokemonId());
      const pokemonsLength = await pokemonFactory.currentPokemonId()
      expect(pokemonsLength).to.be.equal(1);

    })

    it("Should create first pokemon like a name bullbasur", async function () {
      const { pokemonFactory } = await loadFixture(deployPokemonFactory)
      await pokemonFactory.createPokemon(1, "bullbasur")
      const pokemon = await pokemonFactory.pokemons(1)
      expect(pokemon.name).to.be.equal("bullbasur");
    })
  })

  describe("Reto 1: event", async function () {
    it("Should emit an event newPokemon", async function () {
      const { pokemonFactory } = await loadFixture(deployPokemonFactory)
      const pokemonName = "bullbasur";
      const pokemonId = 1;
      await expect(pokemonFactory.createPokemon(pokemonId, pokemonName))
        .to.emit(pokemonFactory, "eventNewPokemon")
        .withArgs(pokemonId, pokemonName)
    })
  })

  describe("Reto 2: require", async function () {
    it("Should valdiate that id > 0", async function () {
      const { pokemonFactory } = await loadFixture(deployPokemonFactory)
      const pokemonName = "bullbasur";
      let pokemonId = 0;
      await expect(pokemonFactory.createPokemon(pokemonId, pokemonName))
        .to.be.revertedWith(
          "_id must to be greater than 0."
        );
    })

    it("Should valdiate that name length characters > 2", async function () {
      const { pokemonFactory } = await loadFixture(deployPokemonFactory)
      const pokemonName = "bu";
      let pokemonId = 1;
      await expect(pokemonFactory.createPokemon(pokemonId, pokemonName))
        .to.be.revertedWith(
          "_name must to have a character lenght > 2."
        );
    })

    it("Should valdiate that name length special characters '°ú' > 2", async function () {
      const { pokemonFactory } = await loadFixture(deployPokemonFactory)
      const pokemonName = "°ú";
      let pokemonId = 1;
      await expect(pokemonFactory.createPokemon(pokemonId, pokemonName))
        .to.be.revertedWith(
          "_name must to have a character lenght > 2."
        );
    })
  })

  describe("Reto 3: ", async function () {
    it("Should valdiate that id > 0", async function () {
      const { pokemonFactory } = await loadFixture(deployPokemonFactory)
      expect(1).to.equal(1);
    })
  })

})