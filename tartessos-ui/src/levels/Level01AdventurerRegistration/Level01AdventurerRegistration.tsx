import { useState } from "react";
import { useTranslation } from "react-i18next";

import { ActivationCode } from "../../components/ActivationCode";
import { GameFrame } from "../../components/GameFrame";
import { validateExercise1 } from "../../api/questApi";
import { useGame } from "../../game/GameContext";

import level01Image from "../../assets/images/level01.png";
import styles from "./Level01AdventurerRegistration.module.css";

const LEVEL_ID = "level-01-adventurer-registration" as const;

export function Level01AdventurerRegistration() {
  const { t } = useTranslation();
  const { completeLevel, isLevelCompleted, progress } = useGame();

  const savedCode = progress?.activationCodes[LEVEL_ID] ?? null;
  const alreadyCompleted = isLevelCompleted(LEVEL_ID);

  const [loading, setLoading] = useState(false);
  const [validationCode, setValidationCode] = useState<string | null>(
    alreadyCompleted ? savedCode : null,
  );
  const [adventurerName, setAdventurerName] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  async function handleSubmitForm() {
    setLoading(true);
    setError(null);

    try {
      const response = await validateExercise1();

      if (!response.success) {
        setError(
          response.errorMessage ||
            t("levels.level01.genericValidationError"),
        );
        return;
      }

      setValidationCode(response.validationCode);
      setAdventurerName(response.adventurerName ?? null);

      completeLevel(LEVEL_ID, response.validationCode);
    } catch {
      setError(t("levels.level01.connectionError"));
    } finally {
      setLoading(false);
    }
  }

  return (
    <GameFrame>
      <div className={styles.scene}>
        <img
          src={level01Image}
          alt={t("levels.level01.imageAlt")}
          className={styles.sceneImage}
        />

        <div className={styles.sceneCaption}>
          {validationCode
            ? t("levels.level01.captionCompleted")
            : t("levels.level01.captionInitial")}
        </div>
      </div>

      <section className={styles.panel}>
        {!validationCode ? (
          <>
            <h1>{t("levels.level01.title")}</h1>

            <p>{t("levels.level01.paragraph1")}</p>
            <p>{t("levels.level01.paragraph2")}</p>
            <p>{t("levels.level01.paragraph3")}</p>

            {error && <p className={styles.error}>{error}</p>}

            <button
              className={styles.primaryButton}
              onClick={handleSubmitForm}
              disabled={loading}
            >
              {loading
                ? t("levels.level01.submittingButton")
                : t("levels.level01.submitButton")}
            </button>
          </>
        ) : (
          <div className={styles.successPanel}>
            <h1>{t("levels.level01.successTitle")}</h1>

            <p>{t("levels.level01.successMessage")}</p>

            {adventurerName && (
              <p>
                {t("levels.level01.adventurerNameLabel")}: {adventurerName}
              </p>
            )}

            <ActivationCode
              label={t("levels.level01.activationCodeLabel")}
              code={validationCode}
            />
          </div>
        )}
      </section>
    </GameFrame>
  );
}