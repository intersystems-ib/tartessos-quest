import { Level00Intro } from "../levels/Level00Intro";
import { Level01AdventurerRegistration } from "../levels/Level01AdventurerRegistration";
import { Level02ExcavationTools } from "../levels/Level02ExcavationTools";
import { Level03ChamberModel } from "../levels/Level03ChamberModel";
import { Level04Notebook } from "../levels/Level04Notebook";
import { Level05PersistentChambers } from "../levels/Level05PersistentChambers";
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

    case "level-03-chamber-model":
      return <Level03ChamberModel />;

    case "level-04-notebook":
      return <Level04Notebook />;

    case "level-05-persistent-chambers":
      return <Level05PersistentChambers />;

    default:
      return <Level00Intro />;
  }
}