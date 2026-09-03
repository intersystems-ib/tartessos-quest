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

export type Exercise2ValidationResponse = {
  success: boolean;
  exercise: number;
  validationCode: string;
  kit?: {
    trowel?: number;
    hat?: number;
    flashlight?: number;
    batteries?: number;
  };
  errorCode: string;
  errorMessage: string;
};

export type Exercise3ValidationResponse = {
  success: boolean;
  exercise: number;
  validationCode: string;
  model?: {
    baseClass?: string;
    derivedClasses?: string[];
  };
  errorCode: string;
  errorMessage: string;
};

export type Exercise4ValidationResponse = {
  success: boolean;
  exercise: number;
  validationCode: string;
  notebook?: {
    totalLines?: number;
    firstChamberType?: string;
  };
  errorCode: string;
  errorMessage: string;
};

export async function getQuestProgress(): Promise<QuestApiProgressResponse> {
  return irisRequest<QuestApiProgressResponse>("/progress");
}

export async function validateExercise1(): Promise<ExerciseValidationResponse> {
  return irisRequest<ExerciseValidationResponse>("/exercise/1/validate");
}

export async function validateExercise2(): Promise<Exercise2ValidationResponse> {
  return irisRequest<Exercise2ValidationResponse>("/exercise/2/validate");
}

export async function validateExercise3(): Promise<Exercise3ValidationResponse> {
  return irisRequest<Exercise3ValidationResponse>("/exercise/3/validate");
}

export async function validateExercise4(): Promise<Exercise4ValidationResponse> {
  return irisRequest<Exercise4ValidationResponse>("/exercise/4/validate");
}