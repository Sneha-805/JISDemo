<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
    // Handle dismiss link: clear session attrs and reload
    String dismiss = request.getParameter("dismiss");
    if ("true".equals(dismiss)) {
        session.removeAttribute("cin");
        session.removeAttribute("postMessage");
        // Redirect to same page without query string to avoid back-button weirdness
        String uri = request.getRequestURI();
        response.sendRedirect(uri);
        return;
    }

    // Read session values set by servlet
    String cin = (String) session.getAttribute("cin");
    String postMessage = (String) session.getAttribute("postMessage");
    if (cin == null) cin = "";
    if (postMessage == null) postMessage = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>Post Case — Police Portal</title>

    <!-- Simple, modern styles -->
    <style>
      @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap');

      :root{
        --bg:#f7f6f3;
        --card:#ffffff;
        --accent:#fbc02d;
        --accent-dark:#f57f17;
        --muted:#6b5e53;
        --success:#4caf50;
        --radius:12px;
      }

      *{box-sizing:border-box}
      body{
        margin:0;
        font-family:"Poppins",system-ui,-apple-system,Segoe UI,Roboto,"Helvetica Neue",Arial;
        background: linear-gradient(180deg,#fff 0%, #fbf8f3 100%);
        color:var(--muted);
        -webkit-font-smoothing:antialiased;
        -moz-osx-font-smoothing:grayscale;
        padding:32px;
        display:flex;
        align-items:flex-start;
        justify-content:center;
        min-height:100vh;
      }

      .wrap{
        width:100%;
        max-width:920px;
      }

      header{
        display:flex;
        align-items:center;
        justify-content:space-between;
        margin-bottom:18px;
      }
      header h1{
        font-size:20px;
        color:var(--accent-dark);
        margin:0;
        letter-spacing:0.2px;
      }
      header .who{
        font-size:14px;
        background:linear-gradient(90deg, rgba(255,245,157,0.9), rgba(255,249,196,0.9));
        padding:8px 12px;
        border-radius:999px;
        color:var(--muted);
        font-weight:600;
      }

      .grid{
        display:grid;
        grid-template-columns: 1fr 360px;
        gap:20px;
      }

      /* Card form */
      .card{
        background:var(--card);
        border-radius:var(--radius);
        padding:22px;
        box-shadow: 0 8px 30px rgba(98,80,67,0.06);
      }

      form .field{
        margin-bottom:14px;
      }
      label{
        display:block;
        font-size:13px;
        margin-bottom:6px;
        color:#5d4037;
        font-weight:600;
      }
      input[type="text"],
      input[type="date"],
      select,
      textarea{
        width:100%;
        padding:10px 12px;
        border-radius:8px;
        border:1px solid #ffe082;
        background:#fffdf2;
        color:var(--muted);
        font-size:14px;
        outline:none;
      }
      input[type="text"]:focus,
      input[type="date"]:focus,
      select:focus,
      textarea:focus{
        box-shadow:0 0 0 4px rgba(251,192,45,0.08);
        border-color:var(--accent);
      }

      .note{
        font-size:13px;
        color:#8d6e63;
        margin-top:6px;
      }

      .btn{
        display:inline-block;
        background:var(--accent);
        color:white;
        padding:10px 18px;
        border-radius:10px;
        border:none;
        font-weight:700;
        cursor:pointer;
        text-decoration:none;
        font-size:14px;
        transition:transform .12s ease, box-shadow .12s ease;
      }
      .btn:hover{ transform:translateY(-2px); box-shadow:0 8px 20px rgba(251,192,45,0.18) }

      /* Sidebar / info column */
      .info {
        display:flex;
        flex-direction:column;
        gap:14px;
      }
      .card.small{
        padding:16px;
      }
      .meta-row{
        display:flex;
        justify-content:space-between;
        align-items:center;
        gap:8px;
        font-size:14px;
      }
      .muted{
        color:#8d6e63;
        font-size:13px;
      }

      /* Popup modal (server-driven) */
      .modal-overlay{
        position:fixed;
        inset:0;
        display:flex;
        align-items:center;
        justify-content:center;
        background:rgba(0,0,0,0.42);
        z-index:999;
        animation:fadeIn .18s ease;
      }
      .modal{
        background:var(--card);
        padding:20px 22px;
        border-radius:10px;
        width:clamp(280px, 70%, 520px);
        box-shadow:0 14px 34px rgba(0,0,0,0.18);
        text-align:center;
      }
      .modal h3{
        margin:0 0 8px 0;
        color:var(--accent-dark);
        font-size:18px;
      }
      .modal p{ margin:6px 0; color:var(--muted) }
      .modal .cin{
        margin-top:8px;
        display:inline-block;
        background:linear-gradient(90deg,#fff59d,#fff8e1);
        padding:8px 12px;
        border-radius:8px;
        font-weight:700;
        color:#5d4037;
      }
      .modal .ok{
        display:inline-block;
        margin-top:14px;
        background:var(--accent);
        color:#fff;
        padding:8px 14px;
        border-radius:8px;
        text-decoration:none;
        font-weight:700;
      }

      @keyframes fadeIn {
        from{opacity:0; transform:translateY(6px)}
        to{opacity:1; transform:none}
      }

      /* small screens */
      @media (max-width:900px){
        .grid{ grid-template-columns: 1fr; }
        .info{ order:2 }
      }
    </style>
</head>
<body>
  <div class="wrap">
    <header>
      <h1>Police — Submit Case</h1>
      <div class="who">Officer: ${sessionScope.username}</div>
    </header>

    <div class="grid">
      <!-- Main form card -->
      <main class="card" aria-labelledby="postcaseTitle">
        <h2 id="postcaseTitle" style="margin:0 0 12px; color:var(--accent-dark); text-transform:uppercase; font-size:14px;">Post a New Case</h2>

        <form action="PoliceReportServlet" method="post" autocomplete="off">
          <div class="field">
            <label for="name_def">Name of the defendant</label>
            <input id="name_def" name="name_def" type="text" required>
          </div>

          <div class="field">
            <label for="addr">Defendant address</label>
            <input id="addr" name="addr" type="text" required>
          </div>

          <div class="field">
            <label for="crime_typ">Crime type</label>
            <select id="crime_typ" name="crime_typ" required>
              <option value="theft">Theft</option> 
              <option value="assault">Assault</option> 
              <option value="fraud">Fraud</option>
              <option value="arson">Arson</option> 
              <option value="kidnap">Kidnap</option>
              <option value="murder">Murder</option>
            </select>
          </div>

          <div class="field" style="display:flex; gap:12px; align-items:flex-end;">
            <div style="flex:1;">
              <label for="date_comt">Date when crime is committed</label>
              <input id="date_comt" name="date_comt" type="date" required>
            </div>
            <div style="flex:1;">
              <label for="where">Place of crime</label>
              <input id="where" name="where" type="text" required>
            </div>
          </div>

          <div class="field">
            <label for="arrst_off">Name of arresting officer</label>
            <input id="arrst_off" name="arrst_off" type="text" required>
          </div>

          <div class="field">
            <label for="date_arrst">Date of the arrest</label>
            <input id="date_arrst" name="date_arrst" type="date" required>
          </div>

          <div style="text-align:right; margin-top:6px;">
            <button class="btn" type="submit" name="smt">Submit</button>
          </div>
        </form>
      </main>

      <!-- Right column: info / notes -->
      <aside class="info">
        <div class="card small">
          <div class="meta-row">
            <div style="font-size:14px; font-weight:700; color:var(--accent-dark)">Guidelines</div>
            <div class="muted">Please be accurate</div>
          </div>
          <p class="note">Fill every required field. After submission you will receive a CIN which will appear as a popup on this page. Use that CIN for future reference.</p>
        </div>

        <div class="card small">
          <div class="meta-row">
            <div style="font-size:13px; font-weight:700">Quick tips</div>
            <div class="muted">Secure</div>
          </div>
          <ul style="margin:10px 0 0 18px; color:var(--muted);">
            <li>Double-check defendant's name & address</li>
            <li>Provide exact crime date and place</li>
            <li>Keep the CIN safe after submission</li>
          </ul>
        </div>
      </aside>
    </div>

   
  </div>

  <!-- Server-rendered popup modal (no JS) -->
  <%
    boolean showModal = !(cin.trim().isEmpty() && postMessage.trim().isEmpty());
    if (showModal) {
  %>
    <div class="modal-overlay" role="dialog" aria-modal="true" aria-labelledby="modalTitle">
      <div class="modal">
        <h3 id="modalTitle">Case Submitted ✅</h3>
        <p><strong><%= postMessage %></strong></p>
        <div class="cin">CIN: <%= cin %></div>
        <!-- The OK link triggers server-side clearing via ?dismiss=true -->
        <div>
          <a class="ok" href="<%= request.getRequestURI() + "?dismiss=true" %>">OK</a>
        </div>
      </div>
    </div>
  <% } %>
</body>
</html>
