<h1 align="center">
  <img src="https://github.com/maael/deck-game/raw/main/assets/sprites/knight.png" align="left" width="5%" />
  Untitled Deck Game
  <img src="https://github.com/maael/deck-game/raw/main/assets/sprites/knight.png" align="right" width="5%" />
</h1>

## Gameplay

<p align="center">
  <img src="https://github.com/maael/deck-game/raw/main/assets/loop.gif" />
</p>

A mix of Kingdom Hearts: Chain of Memories, One Step From Eden, and Titan Souls.

Using the action combat style with cards from One Step From Eden, but not constrained by tiles, similar to Kingdom Hearts: Chain of Memories (but no random encounters). Focused on big boss fights like Titan Souls, rather than lots of little fights and exploration - although there is some little fights and exploration to allow finding materials to craft cards and build decks.

The concept is that you have to theory-craft decks to make it easier to fight the big bosses, tailoring the deck to each encounter.

## Story

> TBC

I did have some idea that it would be a robot lost in an abandoned old world similar to Nier: Automata/BLAME!, with the cards being new circuits it can socket to get new abilities - and trying to either restore some hope to the world or find out what happened, or a bit of both. But I'm not too invested in this. I'll work on the story more after the core gameplay loop is complete and basic features are there.

## Development

Requires [LÖVE](https://www.love2d.org/) to be installed, follow the instruction on their website.

```sh
git clone git@github.com:maael/deck-game.git
cd deck-game
love .
```

The used vendor plugins are in `./vendor`. Any alterations that have been made will be highlighted here or in code with comments.

## Building

> TBC

## Technologies

- [Lua](http://www.lua.org/)
- [LÖVE](https://www.love2d.org/)
  - [Tiled](https://www.mapeditor.org/)
  - [Simple Tiled Implementation](https://github.com/karai17/Simple-Tiled-Implementation)
  - [FPSGraph](https://github.com/icrawler/FPSGraph)
  - [Anim8](https://github.com/kikito/anim8)
  - [STALKER-X](https://github.com/a327ex/STALKER-X)

## Assets

Some free placeholders currently from [itch.io](https://itch.io).

## Features and Roadmap

- [x] Rendering Tiled maps
- [x] Interactive items from Tiled maps data
- [x] Basic player movement and collisions with maps
- [x] Allow players to pickup/interact with items placed in Tiled maps
- [x] Camera system
  - [Gamera](https://github.com/kikito/gamera) - Changed to this one
  - [Hump](https://github.com/HDictus/hump/tree/temp-master) - includes other things
  - [STALKER-X](https://github.com/a327ex/STALKER-X) - Tried this one but the canvas stuff made things difficult and it didn't play nice with lighting systems
- [ ] Fog of war/visibility system
- [ ] Player animations
- [ ] Player inventory system
- [ ] Enemies
  - [ ] Basic enemies
  - [ ] Enemy movement
  - [ ] Enemy animation
  - [ ] Enemy attack patterns
  - [ ] Enemy drop tables
- [ ] Card combat system
- [ ] Lighting system
- [ ] Menu system
- [ ] Deck crafting system
- [ ] Map animations
- [ ] Save games
- [ ] Fancier boss mechanics
- [ ] Achievements
- [ ] Discord rich presence (maybe [this](https://github.com/pfirsich/lua-discordRPC))
- [ ] Twitch/Stream integrations
- [ ] Steam integration
