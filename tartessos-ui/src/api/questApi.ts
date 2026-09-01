import { irisRequest } from "./irisClient";
import type { QuestApiProgressResponse } from "../game/gameTypes";

export type ExerciseValidationResponse = {
  success: boolean;
  exercise: number;
  validationCode: string;
  adventurerName?: string;
  errorCode: string;
  errorMessage: string;
};

export async function getQuestProgress(): Promise<QuestApiProgressResponse> {
  return irisRequest<QuestApiProgressResponse>("/progress");
}

export async function validateExercise1(): Promise<ExerciseValidationResponse> {
  return irisRequest<ExerciseValidationResponse>("/exercise/1/validate");
}