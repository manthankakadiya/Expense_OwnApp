# ExpenseIQ – Personal Deposit & Withdraw Expense Tracker 💳💰

A modern, responsive, and privacy-first personal finance tracker designed for both **laptop/desktop** and **mobile phone** screens. Works entirely offline in your browser using `localStorage` — no backend server or database setup required!

🔗 **Repository:** [https://github.com/manthankakadiya/Expanse-App](https://github.com/manthankakadiya/Expanse-App)

---

## ✨ Key Features

### 1. 📥 Deposit & 📤 Withdraw Management
- **Segmented Type Switch**: Easily switch between **Deposit Money** (Money In) and **Withdraw Money** (Money Out).
- **Dedicated Categories**:
  - **Deposits:** Salary 💼, Freelance 💻, Business 🏢, Investment 📈, Gift 🎁, Cash In 💵, Other Deposit 📦
  - **Withdrawals:** Food 🍔, Transport 🚗, Shopping 🛍️, Entertainment 🎮, Health 💊, Bills 📄, Education 📚, Other 📦
- **Instant Activity Feed**: Immediate visual confirmation of newly added transactions with color-coded badges.

### 2. 📊 Dynamic Dashboard & Real-Time Net Balance
- **Net Balance Hero Card**: Computes `Net Balance = Total Deposits - Total Withdrawals` in real time with high-visibility indicators.
- **Monthly Spending vs. Budget**: Interactive progress bar alerting you if you are approaching or exceeding your monthly withdrawal limit.
- **Top Spending Area**: Identifies your highest spending category this month automatically.
- **Recent Activity**: Displays deposits in green (`+₹...`) and withdrawals in red (`-₹...`).

### 3. 📈 Analytics & Range Distribution
- **💵 Monthly Cash Flow**: Grouped bar chart comparing total Deposits vs. total Withdrawals over the last 6 months.
- **💰 ₹0 – ₹1000 Range Distribution Chart**: Dual-axis bar and line histogram specifically analyzing daily micro-expenses in ₹100 intervals.
- **🥧 Spending by Category**: Interactive doughnut chart powered by Chart.js.

### 4. 📋 Transaction History & Filters
- **Filter by Type**: Show All, Deposits Only, or Withdrawals Only.
- **Search & Sort**: Search across titles, notes, and categories with pagination.
- **Edit & Delete Modals**: Full CRUD support with responsive modals.
- **Export to CSV**: Download your complete financial logs into a spreadsheet with UTF-8 encoding.

### 5. 📱 Built for Both Phone & Laptop
- **Mobile (≤ 768px)**:
  - Bottom navigation bar with an elevated central **⇄ Transact** button.
  - Native-style bottom sheets for modals.
  - Touch-friendly 46px+ tap targets.
- **Laptop / Desktop (> 768px)**:
  - Collapsible dark sidebar with icon-only mode.
  - Multi-column grids and expanded data tables.
- **🌙 Dark Mode**: System-aware with persistent preference saved to local storage.

---

## 🚀 How to Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/manthankakadiya/Expanse-App.git
   cd Expanse-App
   ```
2. **Open in any browser:**
   - Double-click `index.html` or `expense-tracker.html` to open it directly in Google Chrome, Microsoft Edge, Safari, or Firefox.
   - Alternatively, serve it via GitHub Pages or any static file server (`npx serve .` or `python -m http.server`).

---

## 🛠️ Tech Stack
- **HTML5 & CSS3**: Modern CSS Variables, Flexbox, CSS Grid, Media Queries
- **JavaScript (Vanilla ES6+)**: State management, LocalStorage CRUD, CSV generation
- **Chart.js**: Fast, responsive canvas-based charts
