import { Level00Intro } from "../levels/Level00Intro";
import { Level01AdventurerRegistration } from "../levels/Level01AdventurerRegistration";
import { Level02ExcavationTools } from "../levels/Level02ExcavationTools";
import { useGame } from "./GameContext";

export function CurrentLevel() {
  const { progress } = useGame();

  switch (progress?.currentLevel) {
    case "level-00-intro":
      return <Level00Intro />;

    case "level-01-adventurer-registration":
      return <Level01AdventurerRegistration />;

    case "level-02-excavation-tools":
      return <Level02ExcavationTools />;

    default:
      return <Level00Intro />;
  }
}