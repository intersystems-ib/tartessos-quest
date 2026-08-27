import { useState } from "react";
import { useTranslation } from "react-i18next";
import { ActivationCode } from "../../components/ActivationCode";
import { GameFrame } from "../../components/GameFrame";
import { useGame } from "../../game/GameContext";
import level00Image from "../../assets/images/level00.png";
import styles from "./Level00Intro.module.css";

const LEVEL_ID = "level-00-intro" as const;
const ACTIVATION_CODE = "AQ-IRIS-0001";

export function Level00Intro() {
  const { t } = useTranslation();
  const { completeLevel, isLevelCompleted } = useGame();

  const alreadyCompleted = isLevelCompleted(LEVEL_ID);
  const [introCompleted, setIntroCompleted] = useState(alreadyCompleted);

  function handleStartExpedition() {
    completeLevel(LEVEL_ID, ACTIVATION_CODE);
    setIntroCompleted(true);
  }

  return (
    <GameFrame>
      <div className={styles.scene}>
        <img
          src={level00Image}
          alt={t("levels.level00.imageAlt")}
          className={styles.sceneImage}
        />

        <div className={styles.sceneCaption}>
          {introCompleted
            ? t("levels.level00.captionCompleted")
            : t("levels.level00.captionInitial")}
        </div>
      </div>

      <section className={styles.panel}>
        {!introCompleted ? (
          <>
            <h1>{t("levels.level00.title")}</h1>

            <p>{t("levels.level00.paragraph1")}</p>
            <p>{t("levels.level00.paragraph2")}</p>
            <p>{t("levels.level00.paragraph3")}</p>
            <p>{t("levels.level00.paragraph4")}</p>

            <button
              className={styles.primaryButton}
              onClick={handleStartExpedition}
            >
              {t("levels.level00.startButton")}
            </button>
          </>
        ) : (
          <div className={styles.successPanel}>
            <h1>{t("levels.level00.successTitle")}</h1>

            <p>{t("levels.level00.successParagraph1")}</p>
            <p>{t("levels.level00.successParagraph2")}</p>

            <ActivationCode
              label={t("levels.level00.activationCodeLabel")}
              code={ACTIVATION_CODE}
            />

            <p className={styles.hint}>{t("levels.level00.hint")}</p>
          </div>
        )}
      </section>
    </GameFrame>
  );
}