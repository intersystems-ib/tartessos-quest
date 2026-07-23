import { irisRequest } from "./irisClient";
import type { QuestApiProgressResponse } from "../game/gameTypes";

const USE_MOCK_API = import.meta.env.VITE_USE_MOCK_API !== "false";

const mockProgress: QuestApiProgressResponse = {
  currentLevel: "level00",
  completedLevels: [],
  activationCodes: {},
};

export async function getQuestProgress(): Promise<QuestApiProgressResponse> {
  if (USE_MOCK_API) {
    await new Promise((resolve) => window.setTimeout(resolve, 500));
    return mockProgress;
  }

  return irisRequest<QuestApiProgressResponse>("/api/quest/progress");
}