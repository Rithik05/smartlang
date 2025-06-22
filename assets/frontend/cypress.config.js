import { defineConfig } from "cypress";

export default defineConfig({
  e2e: {
    setupNodeEvents(on, config) {
      // implement node event listeners here
      on("task", {
        log(message) {
          console.log(message);
          return null;
        },
      });

      return {
        baseUrl: "http://localhost:4000",
        specPattern: "cypress/e2e/*.spec.{js,jsx}",
        viewportWidth: 1600,
        viewportHeight: 900
      }


    },
  },
});
