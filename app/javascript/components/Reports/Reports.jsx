import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";

const api = axios.create({ baseURL: "/api/v1" });

export default function Reports() {
  const [reportData, setReportData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    api
      .get("/reports")
      .then((response) => {
        setReportData(response.data);
      })
      .catch((err) => {
        console.error("Failed to load report", err);
        setError("Unable to load report data.");
      })
      .finally(() => {
        setLoading(false);
      });
  }, []);

  return (
    <div>
      <button onClick={() => navigate("/")}>⬅ Back to Home</button>

      <h2>Article Reports</h2>

      {loading && <p>Loading report...</p>}
      {error && <p style={{ color: "red" }}>{error}</p>}

      {!loading && !error && (
        <div>
          {reportData.length === 0 ? (
            <p>No report data available.</p>
          ) : (
            reportData.map((article) => (
              <div key={article.id} style={{ marginBottom: "24px" }}>
                <h3>{article.title}</h3>
                <p>{article.body}</p>
                <p>
                  <strong>Comments count:</strong> {article.comments_count}
                </p>
                <p>
                  <strong>Sections:</strong> {article.sections.length}
                </p>
                {article.sections.length > 0 && (
                  <ul>
                    {article.sections.map((section) => (
                      <li key={section.id}>
                        <strong>{section.heading}</strong>: {section.content}
                      </li>
                    ))}
                  </ul>
                )}
              </div>
            ))
          )}
        </div>
      )}
    </div>
  );
}
