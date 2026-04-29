import React, { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import axios from "axios";

const api = axios.create({ baseURL: "/api/v1" });

export default function ShowArticle() {
  const { id } = useParams();
  const [article, setArticle] = useState(null);
  const [commentForm, setCommentForm] = useState({ author: "", body: "" });
  const [commentError, setCommentError] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    api
      .get(`/articles/${id}`)
      .then((response) => setArticle(response.data))
      .catch((err) => console.error("Failed to fetch article", err));
  }, [id]);

  const handleCommentChange = (event) => {
    setCommentForm({
      ...commentForm,
      [event.target.name]: event.target.value,
    });
  };

  const handleCommentSubmit = async (event) => {
    event.preventDefault();
    setCommentError(null);

    try {
      const response = await api.post(`/articles/${id}/comments`, {
        comment: commentForm,
      });

      setArticle((current) => ({
        ...current,
        comments: [...(current.comments || []), response.data],
      }));
      setCommentForm({ author: "", body: "" });
    } catch (err) {
      console.error("Failed to create comment", err);
      setCommentError("Unable to save comment. Please try again.");
    }
  };

  const handleDeleteComment = async (commentId) => {
    if (!confirm("Are you sure you want to delete this comment?")) return;

    try {
      await api.delete(`/articles/${id}/comments/${commentId}`);
      setArticle((current) => ({
        ...current,
        comments: current.comments.filter((comment) => comment.id !== commentId),
      }));
    } catch (err) {
      console.error("Failed to delete comment", err);
      setCommentError("Unable to delete comment.");
    }
  };

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

      <div style={{ marginTop: "24px" }}>
        <h3>Comments</h3>
        {article.comments && article.comments.length > 0 ? (
          <ul>
            {article.comments.map((comment) => (
              <li key={comment.id} style={{ marginBottom: "12px" }}>
                <p>
                  <strong>{comment.author}</strong> said:
                </p>
                <p>{comment.body}</p>
                <small>
                  {new Date(comment.created_at).toLocaleString()}
                </small>
                <br />
                <button
                  type="button"
                  onClick={() => handleDeleteComment(comment.id)}
                  style={{ marginTop: "6px" }}
                >
                  Delete comment
                </button>
              </li>
            ))}
          </ul>
        ) : (
          <p>No comments yet.</p>
        )}
      </div>

      <div style={{ marginTop: "24px" }}>
        <h3>Add a comment</h3>
        {commentError && <p style={{ color: "red" }}>{commentError}</p>}

        <form onSubmit={handleCommentSubmit}>
          <div>
            <label>
              Name:
              <input
                name="author"
                value={commentForm.author}
                onChange={handleCommentChange}
                placeholder="Your name"
              />
            </label>
          </div>

          <div style={{ marginTop: "10px" }}>
            <label>
              Comment:
              <textarea
                name="body"
                value={commentForm.body}
                onChange={handleCommentChange}
                placeholder="Write your comment"
                rows={4}
                required
              />
            </label>
          </div>

          <div style={{ marginTop: "15px" }}>
            <button type="submit">Post Comment</button>{" "}
            <button type="button" onClick={() => setCommentForm({ author: "", body: "" })}>
              Clear
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
