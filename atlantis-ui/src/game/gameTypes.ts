export type LevelId =
  | "level-00-intro"
  | "level-01-iris-intro"
  | "level-02-objectscript-basics"
  | "level-03-debugging"
  | "level-04-classes"
  | "level-05-persistence"
  | "level-06-sql"
  | "level-07-rest"
  | "level-08-embedded-python"
  | "level-09-globals";

export type GameProgress = {
  currentLevel: LevelId;
  completedLevels: LevelId[];
  activationCodes: Record<string, string>;
};