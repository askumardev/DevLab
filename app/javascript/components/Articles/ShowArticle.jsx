import React, { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import axios from "axios";

const api = axios.create({ baseURL: "/api/v1" });

export default function ShowArticle() {
  const { id } = useParams();
  const [article, setArticle] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    api
      .get(`/articles/${id}`)
      .then((response) => setArticle(response.data))
      .catch((err) => console.error("Failed to fetch article", err));
  }, [id]);

  if (!article) return <p>Loading...</p>;

  return (
    <div>
      <button onClick={() => navigate("/articles")}>⬅ Back to Articles</button>

      <h2>Article Details</h2>
      <p>
        <strong>ID:</strong> {article.id}
      </p>
      <p>
        <strong>Title:</strong> {article.title}
      </p>
      <p>
        <strong>Body:</strong>
      </p>
      <p>{article.body}</p>

      <button onClick={() => navigate(`/articles/${article.id}/edit`)}>
        Edit
      </button>
    </div>
  );
}
