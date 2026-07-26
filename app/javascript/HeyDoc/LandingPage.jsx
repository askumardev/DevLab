import "./heydoc.css";

import React from "react";

const features = [
  {
    title: "Faster triage",
    description:
      "Guide patients through a calm, guided intake experience from the very first click.",
  },
  {
    title: "Smart follow-ups",
    description:
      "Automate reminders and keep every appointment, prescription, and note in one place.",
  },
  {
    title: "Trusted care",
    description:
      "Create a polished experience that feels welcoming for patients and efficient for clinics.",
  },
];

const highlights = [
  "24/7 online booking",
  "Instant symptom checks",
  "Secure messaging",
];

export default function LandingPage() {
  return (
    <div className="heydoc-page">
      <header className="heydoc-header">
        <div className="heydoc-brand">HeyDoc</div>
        <nav className="heydoc-nav">
          <a href="#features" className="heydoc-link">
            Features
          </a>
          <a href="#about" className="heydoc-link">
            About
          </a>
          <a href="#contact" className="heydoc-link">
            Contact
          </a>
        </nav>
      </header>

      <main>
        <section className="heydoc-hero">
          <div className="heydoc-heroContent">
            <p className="heydoc-eyebrow">Modern healthcare experiences</p>
            <h1 className="heydoc-title">Care that feels clear, personal, and simple.</h1>
            <p className="heydoc-subtitle">
              HeyDoc helps clinics welcome patients with a faster booking flow,
              helpful reminders, and a modern digital front door.
            </p>
            <div className="heydoc-actions">
              <a href="#contact" className="heydoc-primaryButton">
                Book a demo
              </a>
              <a href="#features" className="heydoc-secondaryButton">
                Explore features
              </a>
            </div>
          </div>

          <div className="heydoc-cardPanel">
            <div className="heydoc-statCard">
              <strong className="heydoc-statNumber">98%</strong>
              <span className="heydoc-statLabel">patient satisfaction</span>
            </div>
            <div className="heydoc-cardList">
              {highlights.map((item) => (
                <div key={item} className="heydoc-listItem">
                  <span className="heydoc-check">✓</span>
                  <span>{item}</span>
                </div>
              ))}
            </div>
          </div>
        </section>

        <section id="features" className="heydoc-section">
          <h2 className="heydoc-sectionTitle">Built for modern care teams</h2>
          <div className="heydoc-featureGrid">
            {features.map((feature) => (
              <article key={feature.title} className="heydoc-featureCard">
                <h3 className="heydoc-featureTitle">{feature.title}</h3>
                <p className="heydoc-featureText">{feature.description}</p>
              </article>
            ))}
          </div>
        </section>

        <section id="about" className="heydoc-sectionAlt">
          <h2 className="heydoc-sectionTitle">A calm experience for every visit</h2>
          <p className="heydoc-bodyText">
            HeyDoc combines thoughtful design with dependable workflows so patients
            feel informed and clinics stay organized.
          </p>
        </section>
      </main>

      <footer id="contact" className="heydoc-footer">
        <p className="heydoc-footerText">Ready to launch your next patient journey?</p>
        <a href="mailto:hello@heydoc.example" className="heydoc-primaryButton">
          hello@heydoc.example
        </a>
      </footer>
    </div>
  );
}
