import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";

const api = axios.create({ baseURL: "/api/v1" });

export default function ArticleList() {
  const [articles, setArticles] = useState([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  const fetchArticles = async () => {
    try {
      const response = await api.get("/articles");
      setArticles(response.data);
    } catch (error) {
      console.error("Failed to load articles", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchArticles();
  }, []);

  const handleDelete = async (id) => {
    if (!confirm("Are you sure you want to delete this article?")) {
      return;
    }

    try {
      await api.delete(`/articles/${id}`);
      setArticles((current) => current.filter((article) => article.id !== id));
    } catch (error) {
      console.error("Failed to delete article", error);
    }
  };

  return (
    <div>
      <button onClick={() => navigate("/")}>⬅ Back to Home</button>

      <h2>Articles</h2>

      <button
        onClick={() => navigate("/articles/new")}
        style={{
          marginBottom: "15px",
          padding: "10px 14px",
          cursor: "pointer",
          backgroundColor: "#4CAF50",
          color: "white",
          border: "none",
        }}
      >
        ➕ Add New Article
      </button>

      {loading ? (
        <p>Loading...</p>
      ) : (
        <table border="1" cellPadding="10">
          <thead>
            <tr>
              <th>ID</th>
              <th>Title</th>
              <th>Body</th>
              <th>Actions</th>
            </tr>
          </thead>

          <tbody>
            {articles.map((article) => (
              <tr key={article.id}>
                <td>{article.id}</td>
                <td>{article.title}</td>
                <td>{article.body}</td>
                <td>
                  <button onClick={() => navigate(`/articles/${article.id}`)}>
                    Show
                  </button>{" "}
                  <button onClick={() => navigate(`/articles/${article.id}/edit`)}>
                    Edit
                  </button>{" "}
                  <button onClick={() => handleDelete(article.id)}>
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
