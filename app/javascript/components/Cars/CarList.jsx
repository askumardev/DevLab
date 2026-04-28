import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

export default function CarList({ initialCars = [] }) {
  const [cars, setCars] = useState(initialCars);
  const [loading, setLoading] = useState(initialCars.length === 0);

  const navigate = useNavigate();

  const fetchCars = () => {
    fetch("/api/v1/cars")
      .then((res) => res.json())
      .then((data) => {
        setCars(data);
        setLoading(false);
      });
  };

  useEffect(() => {
    if (cars.length === 0) {
      fetchCars();
    }
  }, []);

  return (
    <div>
      {/* ✅ NEW BUTTON */}
      <button
        onClick={() => navigate("/")}
        style={{ marginBottom: "15px", padding: "8px 12px", cursor: "pointer" }}
      >
        ⬅ Back to Home
      </button>

      <h2>Cars Table 🚗</h2>

      {loading ? (
        <p>Loading...</p>
      ) : (
        <table border="1" cellPadding="10">
          <thead>
            <tr>
              <th>ID</th>
              <th>Brand</th>
              <th>Model</th>
              <th>Price</th>
              <th>Year</th>
            </tr>
          </thead>

          <tbody>
            {cars.map((car) => (
              <tr key={car.id}>
                <td>{car.id}</td>
                <td>{car.brand}</td>
                <td>{car.model}</td>
                <td>{car.price}</td>
                <td>{car.year}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}