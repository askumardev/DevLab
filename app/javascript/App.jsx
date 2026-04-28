import React from "react";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";

import Home from "./components/Home";
import CarList from "./components/Cars/CarList";
import CarForm from "./components/Cars/CarForm";

export default function App({ initialData }) {
  return (
    <BrowserRouter basename="/react-client">
      <Routes>
        {/* Home */}
        <Route path="/" element={<Home />} />

        {/* Cars Index */}
        <Route
          path="/cars"
          element={<CarList initialCars={initialData.cars} />}
        />

        {/* Create Car */}
        <Route path="/cars/new" element={<CarForm />} />

        {/* Edit Car */}
        <Route path="/cars/:id/edit" element={<CarForm />} />

        {/* fallback */}
        <Route path="*" element={<Navigate to="/" />} />
      </Routes>
    </BrowserRouter>
  );
}