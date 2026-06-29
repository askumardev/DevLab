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
    <div style={styles.page}>
      <header style={styles.header}>
        <div style={styles.brand}>HeyDoc</div>
        <nav style={styles.nav}>
          <a href="#features" style={styles.link}>
            Features
          </a>
          <a href="#about" style={styles.link}>
            About
          </a>
          <a href="#contact" style={styles.link}>
            Contact
          </a>
        </nav>
      </header>

      <main>
        <section style={styles.hero}>
          <div style={styles.heroContent}>
            <p style={styles.eyebrow}>Modern healthcare experiences</p>
            <h1 style={styles.title}>Care that feels clear, personal, and simple.</h1>
            <p style={styles.subtitle}>
              HeyDoc helps clinics welcome patients with a faster booking flow,
              helpful reminders, and a modern digital front door.
            </p>
            <div style={styles.actions}>
              <a href="#contact" style={styles.primaryButton}>
                Book a demo
              </a>
              <a href="#features" style={styles.secondaryButton}>
                Explore features
              </a>
            </div>
          </div>

          <div style={styles.cardPanel}>
            <div style={styles.statCard}>
              <strong style={styles.statNumber}>98%</strong>
              <span style={styles.statLabel}>patient satisfaction</span>
            </div>
            <div style={styles.cardList}>
              {highlights.map((item) => (
                <div key={item} style={styles.listItem}>
                  <span style={styles.check}>✓</span>
                  <span>{item}</span>
                </div>
              ))}
            </div>
          </div>
        </section>

        <section id="features" style={styles.section}>
          <h2 style={styles.sectionTitle}>Built for modern care teams</h2>
          <div style={styles.featureGrid}>
            {features.map((feature) => (
              <article key={feature.title} style={styles.featureCard}>
                <h3 style={styles.featureTitle}>{feature.title}</h3>
                <p style={styles.featureText}>{feature.description}</p>
              </article>
            ))}
          </div>
        </section>

        <section id="about" style={styles.sectionAlt}>
          <h2 style={styles.sectionTitle}>A calm experience for every visit</h2>
          <p style={styles.bodyText}>
            HeyDoc combines thoughtful design with dependable workflows so patients
            feel informed and clinics stay organized.
          </p>
        </section>
      </main>

      <footer id="contact" style={styles.footer}>
        <p style={styles.footerText}>Ready to launch your next patient journey?</p>
        <a href="mailto:hello@heydoc.example" style={styles.primaryButton}>
          hello@heydoc.example
        </a>
      </footer>
    </div>
  );
}

const styles = {
  page: {
    minHeight: "100vh",
    background: "linear-gradient(135deg, #f4fbff 0%, #eef7ff 100%)",
    color: "#16324f",
    fontFamily: "Inter, Arial, sans-serif",
  },
  header: {
    display: "flex",
    justifyContent: "space-between",
    alignItems: "center",
    padding: "24px 32px",
    maxWidth: "1200px",
    margin: "0 auto",
  },
  brand: {
    fontSize: "28px",
    fontWeight: 800,
    color: "#1665d8",
    letterSpacing: "-0.03em",
  },
  nav: {
    display: "flex",
    gap: "18px",
  },
  link: {
    color: "#45617f",
    textDecoration: "none",
    fontWeight: 600,
  },
  hero: {
    display: "grid",
    gridTemplateColumns: "1.2fr 0.8fr",
    gap: "32px",
    alignItems: "center",
    maxWidth: "1200px",
    margin: "0 auto",
    padding: "48px 32px 64px",
  },
  heroContent: {
    maxWidth: "620px",
  },
  eyebrow: {
    textTransform: "uppercase",
    letterSpacing: "0.2em",
    fontSize: "12px",
    fontWeight: 700,
    color: "#3b82f6",
    marginBottom: "12px",
  },
  title: {
    fontSize: "clamp(36px, 5vw, 58px)",
    lineHeight: 1.1,
    margin: "0 0 16px",
    color: "#0f2744",
  },
  subtitle: {
    fontSize: "18px",
    lineHeight: 1.7,
    color: "#4b627d",
    marginBottom: "24px",
  },
  actions: {
    display: "flex",
    flexWrap: "wrap",
    gap: "12px",
  },
  primaryButton: {
    display: "inline-block",
    padding: "12px 18px",
    background: "#1665d8",
    color: "white",
    textDecoration: "none",
    borderRadius: "999px",
    fontWeight: 700,
  },
  secondaryButton: {
    display: "inline-block",
    padding: "12px 18px",
    border: "1px solid #cfe0f7",
    background: "white",
    color: "#16324f",
    textDecoration: "none",
    borderRadius: "999px",
    fontWeight: 700,
  },
  cardPanel: {
    background: "white",
    borderRadius: "24px",
    boxShadow: "0 20px 45px rgba(20, 55, 92, 0.12)",
    padding: "24px",
  },
  statCard: {
    background: "#ecf6ff",
    borderRadius: "18px",
    padding: "20px",
    marginBottom: "16px",
  },
  statNumber: {
    display: "block",
    fontSize: "44px",
    color: "#1665d8",
  },
  statLabel: {
    color: "#45617f",
    fontSize: "14px",
  },
  cardList: {
    display: "grid",
    gap: "10px",
  },
  listItem: {
    display: "flex",
    alignItems: "center",
    gap: "10px",
    padding: "10px 0",
    borderTop: "1px solid #edf4fb",
  },
  check: {
    color: "#1665d8",
    fontWeight: 800,
  },
  section: {
    maxWidth: "1200px",
    margin: "0 auto",
    padding: "0 32px 56px",
  },
  sectionAlt: {
    maxWidth: "1200px",
    margin: "0 auto",
    padding: "0 32px 72px",
  },
  sectionTitle: {
    fontSize: "28px",
    marginBottom: "20px",
    color: "#0f2744",
  },
  featureGrid: {
    display: "grid",
    gridTemplateColumns: "repeat(auto-fit, minmax(220px, 1fr))",
    gap: "18px",
  },
  featureCard: {
    background: "white",
    borderRadius: "18px",
    padding: "20px",
    boxShadow: "0 10px 25px rgba(20, 55, 92, 0.08)",
  },
  featureTitle: {
    margin: "0 0 8px",
    fontSize: "20px",
  },
  featureText: {
    margin: 0,
    color: "#4b627d",
    lineHeight: 1.6,
  },
  bodyText: {
    maxWidth: "680px",
    fontSize: "18px",
    lineHeight: 1.7,
    color: "#4b627d",
  },
  footer: {
    maxWidth: "1200px",
    margin: "0 auto",
    padding: "0 32px 48px",
    display: "flex",
    justifyContent: "space-between",
    alignItems: "center",
    gap: "16px",
    flexWrap: "wrap",
  },
  footerText: {
    margin: 0,
    color: "#45617f",
    fontWeight: 600,
  },
};
