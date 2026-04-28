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

  const isEdit = Boolean(id);

  // ---------------- FETCH FOR EDIT ----------------
  useEffect(() => {
    if (id) {
      fetch(`/api/v1/cars/${id}`)
        .then((res) => res.json())
        .then((data) =>
          setFormData({
            brand: data.brand || "",
            model: data.model || "",
            price: data.price || "",
            year: data.year || "",
          })
        );
    }
  }, [id]);

  // ---------------- HANDLE INPUT ----------------
  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    });
  };

  // ---------------- SUBMIT ----------------
  const handleSubmit = (e) => {
    e.preventDefault();

    const method = isEdit ? "PUT" : "POST";
    const url = isEdit ? `/api/v1/cars/${id}` : "/api/v1/cars";

    fetch(url, {
      method,
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector(
          'meta[name="csrf-token"]'
        ).content,
      },
      body: JSON.stringify({ car: formData }),
    }).then(() => navigate("/cars"));
  };

  return (
    <div>
      <h2>{isEdit ? "Edit Car ✏️" : "Add New Car 🚗"}</h2>

      <form onSubmit={handleSubmit}>
        Brand: <input
          name="brand"
          value={formData.brand}
          onChange={handleChange}
          placeholder="Brand"
          required
        /><br /><br />

        Model: <input
          name="model"
          value={formData.model}
          onChange={handleChange}
          placeholder="Model"
          required
        /><br /><br />

        Price: <input
          name="price"
          value={formData.price}
          onChange={handleChange}
          placeholder="Price"
        /><br /><br />

        Year: <input
          name="year"
          value={formData.year}
          onChange={handleChange}
          placeholder="Year"
        />

        <br /><br />

        <button type="submit">
          {isEdit ? "Update" : "Create"}
        </button>{" "}
        <button type="button" onClick={() => navigate("/cars")}>
          Cancel
        </button>
      </form>
    </div>
  );
}