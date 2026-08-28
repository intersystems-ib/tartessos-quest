import { irisRequest } from "./irisClient";
import type { QuestApiProgressResponse } from "../game/gameTypes";

const USE_MOCK_API = import.meta.env.VITE_USE_MOCK_API !== "false";

const mockProgress: QuestApiProgressResponse = {
  currentLevel: "level-00-intro",
  completedLevels: [],
  activationCodes: {},
};

export type ExerciseValidationResponse = {
  success: boolean;
  exercise: number;
  validationCode: string;
  adventurerName?: string;
  errorCode: string;
  errorMessage: string;
};

export async function getQuestProgress(): Promise<QuestApiProgressResponse> {
  if (USE_MOCK_API) {
    await new Promise((resolve) => window.setTimeout(resolve, 500));
    return mockProgress;
  }

  return irisRequest<QuestApiProgressResponse>("/api/quest/progress");
}

export async function validateExercise1(): Promise<ExerciseValidationResponse> {
  if (USE_MOCK_API) {
    await new Promise((resolve) => window.setTimeout(resolve, 500));

    return {
      success: false,
      exercise: 1,
      validationCode: "",
      errorCode: "MOCK_API_ENABLED",
      errorMessage:
        "La API mock está activada. Desactiva VITE_USE_MOCK_API para validar contra IRIS.",
    };
  }

  return irisRequest<ExerciseValidationResponse>("/exercise/1/validate");
}