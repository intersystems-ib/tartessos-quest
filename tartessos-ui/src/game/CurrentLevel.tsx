import { Level00Intro } from "../levels/Level00Intro";
import { Level01AdventurerRegistration } from "../levels/Level01AdventurerRegistration";
import { useGame } from "./GameContext";

export function CurrentLevel() {
  const { progress } = useGame();

  switch (progress?.currentLevel) {
    case "level-00-intro":
      return <Level00Intro />;

    case "level-01-adventurer-registration":
      return <Level01AdventurerRegistration />;

    default:
      return <Level00Intro />;
  }
}