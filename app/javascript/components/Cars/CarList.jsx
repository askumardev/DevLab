import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

export default function CarList({ initialCars = [] }) {
  const [cars, setCars] = useState(initialCars);
  const [loading, setLoading] = useState(initialCars.length === 0);

  const navigate = useNavigate();

  const fetchCars = async () => {
    const query = `
      query {
        cars {
          id
          brand
          model
          price
          year
        }
      }
    `;

    const response = await fetch("/graphql", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ query }),
    });

    const result = await response.json();
    setCars(result.data.cars);
    setLoading(false);
  };

  useEffect(() => {
    if (cars.length === 0) fetchCars();
  }, []);

  const handleDelete = async (id) => {
    if (!confirm("Are you sure?")) return;

    await fetch("/api/v1/cars/" + id, {
      method: "DELETE",
    });

    setCars(cars.filter((c) => c.id !== id));
  };

  return (
    <div>
      <button onClick={() => navigate("/")}>⬅ Back to Home</button>

      <h2>Cars Table 🚗</h2>

      {/* ✅ ADD NEW CAR BUTTON */}
      <button
        onClick={() => navigate("/cars/new")}
        style={{
          marginBottom: "15px",
          padding: "10px 14px",
          cursor: "pointer",
          backgroundColor: "#4CAF50",
          color: "white",
          border: "none",
        }}
      >
        ➕ Add New Car
      </button>

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
              <th>Actions</th>
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

                <td>
                  <button onClick={() => navigate(`/cars/${car.id}`)}>
                    Show
                  </button>{" "}
                  <button onClick={() => navigate(`/cars/${car.id}/edit`)}>
                    Edit
                  </button>{" "}
                  <button onClick={() => handleDelete(car.id)}>
                    Delete
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}