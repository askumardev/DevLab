import React from "react";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";

import Home from "./components/Home";
import CarList from "./components/Cars/CarList";

export default function App({ initialData }) {
  return (
    <BrowserRouter basename="/react-client">
      <Routes>
        {/* ✅ Home */}
        <Route path="/" element={<Home />} />

        {/* ✅ Cars Table */}
        <Route
          path="/cars"
          element={<CarList initialCars={initialData.cars} />}
        />

        {/* ✅ fallback */}
        <Route path="*" element={<Navigate to="/" />} />
      </Routes>
    </BrowserRouter>
  );
}