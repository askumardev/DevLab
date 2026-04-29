import React, { useState, useEffect } from "react";
import { useNavigate, useParams } from "react-router-dom";
import axios from "axios";

const api = axios.create({ baseURL: "/api/v1" });

export default function ArticleForm() {
  const [formData, setFormData] = useState({
    title: "",
    body: "",
  });
  const [error, setError] = useState(null);
  const navigate = useNavigate();
  const { id } = useParams();
  const isEdit = Boolean(id);

  useEffect(() => {
    if (!id) return;

    api
      .get(`/articles/${id}`)
      .then((response) => {
        setFormData({
          title: response.data.title || "",
          body: response.data.body || "",
        });
      })
      .catch((err) => {
        console.error("Failed to fetch article", err);
      });
  }, [id]);

  const handleChange = (event) => {
    setFormData({
      ...formData,
      [event.target.name]: event.target.value,
    });
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    setError(null);

    try {
      if (isEdit) {
        await api.put(`/articles/${id}`, { article: formData });
      } else {
        await api.post("/articles", { article: formData });
      }
      navigate("/articles");
    } catch (err) {
      console.error("Failed to save article", err);
      setError("Unable to save article. Please check the fields and try again.");
    }
  };

  return (
    <div>
      <button onClick={() => navigate("/articles")}>⬅ Back to Articles</button>

      <h2>{isEdit ? "Edit Article" : "Create Article"}</h2>

      {error && <p style={{ color: "red" }}>{error}</p>}

      <form onSubmit={handleSubmit}>
        <div>
          <label>
            Title:
            <input
              name="title"
              value={formData.title}
              onChange={handleChange}
              placeholder="Article title"
              required
            />
          </label>
        </div>

        <div style={{ marginTop: "10px" }}>
          <label>
            Body:
            <textarea
              name="body"
              value={formData.body}
              onChange={handleChange}
              placeholder="Article body"
              rows={6}
            />
          </label>
        </div>

        <div style={{ marginTop: "15px" }}>
          <button type="submit">{isEdit ? "Update" : "Create"}</button>{" "}
          <button type="button" onClick={() => navigate("/articles")}>Cancel</button>
        </div>
      </form>
    </div>
  );
}
