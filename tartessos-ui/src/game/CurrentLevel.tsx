import { Level00Intro } from "../levels/Level00Intro";
import { useGame } from "./GameContext";

export function CurrentLevel() {
  const { progress } = useGame();

  switch (progress?.currentLevel) {
    case "level-00-intro":
      return <Level00Intro />;

    default:
      return <Level00Intro />;
  }
}