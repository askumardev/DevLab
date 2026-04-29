import React from "react";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";

import Home from "./components/Home";
import CarList from "./components/Cars/CarList";
import CarForm from "./components/Cars/CarForm";
import ShowCar from "./components/Cars/ShowCar";
import ArticleList from "./components/Articles/ArticleList";
import ArticleForm from "./components/Articles/ArticleForm";
import ShowArticle from "./components/Articles/ShowArticle";
import Reports from "./components/Reports/Reports";

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
        <Route path="/cars/new" element={<CarForm />} />
        <Route path="/cars/:id" element={<ShowCar />} />
        <Route path="/cars/:id/edit" element={<CarForm />} />

        {/* Articles Index */}
        <Route path="/articles" element={<ArticleList />} />
        <Route path="/articles/new" element={<ArticleForm />} />
        <Route path="/articles/:id" element={<ShowArticle />} />
        <Route path="/articles/:id/edit" element={<ArticleForm />} />

        {/* Reports */}
        <Route path="/reports" element={<Reports />} />

        {/* fallback */}
        <Route path="*" element={<Navigate to="/" />} />
      </Routes>
    </BrowserRouter>
  );
}