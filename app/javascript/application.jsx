console.log("Module script started loading");

import "@hotwired/turbo-rails"
import "./controllers"
// import "./channels"
import React from "react";
import { createRoot } from "react-dom/client";
import App from "./App";

document.addEventListener("turbo:load", () => {
  const el = document.getElementById("react-root");

  if (el) {
    const initialData = {
      cars: el.dataset.cars ? JSON.parse(el.dataset.cars) : [],
    };

    const root = createRoot(el);
    root.render(<App initialData={initialData} />);
  }
});