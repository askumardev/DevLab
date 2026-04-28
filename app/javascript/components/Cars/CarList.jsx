import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

export default function CarsList({ initialCars = [] }) {
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

  const handleDelete = (id) => {
    if (!confirm("Are you sure?")) return;

    fetch(`/api/v1/cars/${id}`, {
      method: "DELETE",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      },
    }).then(() => fetchCars());
  };

  return (
    <div>
      <h2>Cars Table 🚗</h2>

      <button onClick={() => navigate("/cars/new")}>
        ➕ Add Car
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