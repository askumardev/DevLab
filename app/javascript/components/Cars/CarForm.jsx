import React, { useState, useEffect } from "react";
import { useNavigate, useParams } from "react-router-dom";

export default function CarForm() {
  const [formData, setFormData] = useState({
    brand: "",
    model: "",
    price: "",
    year: "",
  });

  const navigate = useNavigate();
  const { id } = useParams();

  useEffect(() => {
    if (id) {
      fetch(`/api/v1/cars/${id}`)
        .then((res) => res.json())
        .then((data) => setFormData(data));
    }
  }, [id]);

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    });
  };

  const handleSubmit = (e) => {
    e.preventDefault();

    const method = id ? "PUT" : "POST";
    const url = id ? `/api/v1/cars/${id}` : "/api/v1/cars";

    fetch(url, {
      method,
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      },
      body: JSON.stringify({ car: formData }),
    }).then(() => navigate("/cars"));
  };

  return (
    <div>
      <h2>{id ? "Edit Car ✏️" : "Add New Car 🚗"}</h2>

      <form onSubmit={handleSubmit}>
        <input name="brand" value={formData.brand} onChange={handleChange} placeholder="Brand" required />
        <input name="model" value={formData.model} onChange={handleChange} placeholder="Model" required />
        <input name="price" value={formData.price} onChange={handleChange} placeholder="Price" />
        <input name="year" value={formData.year} onChange={handleChange} placeholder="Year" />

        <br /><br />

        <button type="submit">{id ? "Update" : "Create"}</button>{" "}
        <button type="button" onClick={() => navigate("/cars")}>
          Cancel
        </button>
      </form>
    </div>
  );
}