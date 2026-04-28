import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";

export default function ShowCar() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [car, setCar] = useState(null);

  useEffect(() => {
    fetch(`/api/v1/cars/${id}`)
      .then((res) => res.json())
      .then((data) => setCar(data));
  }, [id]);

  if (!car) return <p>Loading...</p>;

  return (
    <div>
      <h2>Car Details 🚗</h2>

      <p>ID: {car.id}</p>
      <p>Brand: {car.brand}</p>
      <p>Model: {car.model}</p>
      <p>Price: {car.price}</p>
      <p>Year: {car.year}</p>

      <button onClick={() => navigate(`/cars/${car.id}/edit`)}>Edit</button>{" "}
      <button onClick={() => navigate("/cars")}>Back</button>
    </div>
  );
}