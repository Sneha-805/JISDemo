<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <title>Court Updates</title>
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <style>
    :root{
      --bg: #fffef6;
      --card: #ffffff;
      --accent: #f6c94d;
      --text: #3e2f2a;
      --muted: #6f574c;
      font-family: "Poppins", system-ui, -apple-system, "Segoe UI", Roboto, Arial;
    }
    body{
      margin:0;
      background:var(--bg);
      color:var(--text);
      padding:24px;
    }
    .container{ max-width:900px; margin:0 auto; }
    header{ display:flex; justify-content:space-between; align-items:center; gap:12px; margin-bottom:18px; }
    h1{ margin:0; font-size:20px; color:var(--text); }
    .subtitle{ color:var(--muted); font-size:13px; }

    .controls{ display:flex; gap:10px; margin:14px 0; align-items:center; }
    .search{ flex:1; }
    input[type="search"]{
      width:100%;
      padding:10px 12px;
      border-radius:8px;
      border:1px solid #ecdba8;
      background:#fff;
      font-size:14px;
      color:var(--text);
    }
    .btn{ background:var(--accent); color:#fff; padding:9px 12px; border:none; border-radius:8px; cursor:pointer; font-weight:600; }
    .btn.secondary{ background:#fff; color:var(--text); border:1px solid #ecdba8; }

    .updates{ display:grid; grid-template-columns:1fr; gap:12px; margin-top:8px; }
    .update{ background:var(--card); padding:14px; border-radius:10px; box-shadow:0 6px 16px rgba(0,0,0,0.04); border-left:6px solid var(--accent); }
    .update h3{ margin:0 0 6px 0; font-size:16px; color:var(--text); }
    .update p{ margin:0 0 10px 0; color:var(--muted); line-height:1.5; }
    .meta{ font-size:13px; color:#8a6f61; display:flex; justify-content:space-between; gap:8px; align-items:center; }

    .empty{ text-align:center; padding:24px; color:var(--muted); background:#fff; border-radius:8px; border:1px dashed #f0e2b6; }

    @media (min-width:720px){
      .updates{ grid-template-columns: repeat(2,1fr); }
    }
  </style>
</head>
<body>
  <div class="container">
    <header>
      <div>
        <h1>Courtroom Updates</h1>
        <div class="subtitle">Latest announcements, schedules and important notices</div>
      </div>
      <div class="subtitle">Published: <strong>Today</strong></div>
    </header>

    <div class="controls">
      <div class="search">
        <input id="q" type="search" placeholder="Search updates (title, body, posted by)..." />
      </div>
      <button id="clearBtn" class="btn secondary">Clear</button>
      <button id="refreshBtn" class="btn">Refresh</button>
    </div>

    <div id="updates" class="updates">
      <!-- Sample contained records (static) -->
      <article class="update" data-title="Court Closed for Maintenance" data-body="All court operations suspended for maintenance on 2025-11-20." data-postedby="Registrar" data-date="2025-11-18">
        <h3>Court Closed for Maintenance</h3>
        <p>All court operations will be suspended on <strong>20 Nov 2025</strong> for scheduled maintenance. Online services may be limited.</p>
        <div class="meta"><span>Posted by: Registrar</span><span>18-Nov-2025</span></div>
      </article>

      <article class="update" data-title="New Hearing Schedules Released" data-body="Hearing schedules for civil division have been uploaded." data-postedby="Court Admin" data-date="2025-11-17">
        <h3>New Hearing Schedules Released</h3>
        <p>Fresh hearing schedules for pending civil cases have been published. Lawyers are advised to check the updated list in the portal.</p>
        <div class="meta"><span>Posted by: Court Admin</span><span>17-Nov-2025</span></div>
      </article>

      <article class="update" data-title="Training: Court Portal" data-body="Training session on portal usage for staff and lawyers." data-postedby="IT Department" data-date="2025-11-16">
        <h3>Training: Court Portal</h3>
        <p>A training session for the new digital court portal will be held on <strong>24 Nov 2025</strong> in Conference Hall B. Attendance recommended for staff and lawyers.</p>
        <div class="meta"><span>Posted by: IT Department</span><span>16-Nov-2025</span></div>
      </article>

      <article class="update" data-title="Filing Deadline Notice" data-body="All documents must be filed by 3 PM before system upgrade." data-postedby="Registrar Office" data-date="2025-11-15">
        <h3>Filing Deadline Notice</h3>
        <p>Due to a system upgrade, lawyers must ensure documents are filed before <strong>3:00 PM</strong> on working days to avoid rejection.</p>
        <div class="meta"><span>Posted by: Registrar Office</span><span>15-Nov-2025</span></div>
      </article>

      <article class="update" data-title="Courtroom Reassignment" data-body="Case allocation changes effective immediately for certain benches." data-postedby="Admin" data-date="2025-11-14">
        <h3>Courtroom Reassignment</h3>
        <p>Some benches have been reassigned due to judge unavailability. Check individual case assignments for updates.</p>
        <div class="meta"><span>Posted by: Admin</span><span>14-Nov-2025</span></div>
      </article>
    </div>

    <div id="empty" class="empty" style="display:none;">
      No updates match your search.
    </div>
  </div>

  <script>
    // Simple client-side search/filter without any backend
    (function(){
      const q = document.getElementById('q');
      const updates = Array.from(document.querySelectorAll('#updates .update'));
      const empty = document.getElementById('empty');
      const clearBtn = document.getElementById('clearBtn');
      const refreshBtn = document.getElementById('refreshBtn');

      function normalize(s){
        return (s || '').toLowerCase();
      }

      function filter(){
        const term = normalize(q.value);
        let shown = 0;
        updates.forEach(node => {
          const title = normalize(node.dataset.title);
          const body = normalize(node.dataset.body);
          const postedBy = normalize(node.dataset.postedby);
          const date = normalize(node.dataset.date);
          if (!term || title.includes(term) || body.includes(term) || postedBy.includes(term) || date.includes(term)) {
            node.style.display = '';
            shown++;
          } else {
            node.style.display = 'none';
          }
        });
        empty.style.display = shown === 0 ? '' : 'none';
      }

      q.addEventListener('input', filter);
      clearBtn.addEventListener('click', function(){
        q.value = '';
        filter();
      });
      refreshBtn.addEventListener('click', function(){
        // page is static; refresh simply re-applies filter (placeholder for real refresh)
        filter();
      });

      // initial filter (show all)
      filter();
    })();
  </script>
</body>
</html>
