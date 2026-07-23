import styles from "./LoadingScreen.module.css";

type LoadingScreenProps = {
  message: string;
};

export function LoadingScreen({ message }: LoadingScreenProps) {
  return (
    <section className={styles.loadingScreen}>
      <h1>Atlantis Quest</h1>
      <p>{message}</p>
      <div className={styles.cursor}>█</div>
    </section>
  );
}