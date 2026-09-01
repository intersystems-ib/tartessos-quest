import { defineConfig, loadEnv } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), "");

  const irisApiUrl =
    env.VITE_IRIS_API_URL ?? "http://localhost:8080/api/tartessos";

  return {
    plugins: [react()],
    build: {
      sourcemap: true,
    },
    server: {
      port: 5173,
      proxy: {
        "/api/tartessos": {
          target: irisApiUrl.replace(/\/api\/tartessos\/?$/, ""),
          changeOrigin: true,
          secure: false,
        },
      },
    },
  };
});