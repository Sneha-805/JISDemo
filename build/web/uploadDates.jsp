<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <title>Choose Court Working Date</title>
  <style>
    .calendar { max-width:720px; margin:20px auto; font-family: Arial, sans-serif; }
    .cal-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:8px; }
    .cal-grid { display:grid; grid-template-columns: repeat(7, 1fr); gap:4px; }
    .cal-cell { padding:12px; border-radius:6px; min-height:60px; background:#fff9f0; text-align:center; }
    .cal-cell.weekday { background:#fffbe6; font-weight:600; }
    .date-number { display:block; font-size:14px; margin-bottom:6px; }
    .not-this-month { color:#bbb; background:#fafafa; }
    .working { background:#cfe8ff; cursor:pointer; border:2px solid #6fb3ff; }
    .working:hover { transform:translateY(-2px); }
    .selected { background:#6fb3ff; color:#fff; }
    .controls button { padding:6px 10px; }
    .legend { margin-top:12px; font-size:14px; }
  </style>
</head>
<body>
<div class="calendar">
  <div class="cal-header">
    <div class="controls">
      <button id="prevMonth" type="button">&lt; Prev</button>
    </div>
    <h2 id="monthLabel">Month</h2>
    <div class="controls">
      <button id="nextMonth" type="button">Next &gt;</button>
    </div>
  </div>

  <div class="cal-grid" id="weekdayNames">
    <div class="cal-cell weekday">Sun</div>
    <div class="cal-cell weekday">Mon</div>
    <div class="cal-cell weekday">Tue</div>
    <div class="cal-cell weekday">Wed</div>
    <div class="cal-cell weekday">Thu</div>
    <div class="cal-cell weekday">Fri</div>
    <div class="cal-cell weekday">Sat</div>
  </div>

  <div class="cal-grid" id="calendarGrid"></div>

  <div class="legend">
    <span style="display:inline-block;width:14px;height:14px;background:#cfe8ff;border:2px solid #6fb3ff;margin-right:6px;vertical-align:middle;"></span>
    Working day (click to assign) &nbsp;&nbsp;
    <span style="display:inline-block;width:14px;height:14px;background:#fffbe6;border:1px solid #ffd966;margin-right:6px;vertical-align:middle;"></span>
    Normal day
  </div>
</div>

<!-- hidden form to post selected date -->
<form id="assignForm" action="saveDateServlet" method="post">
  <input type="hidden" name="cin" value="<%= request.getAttribute("cin") != null ? request.getAttribute("cin") : "" %>"/>
  <input type="hidden" name="working_date" id="working_date" value=""/>
</form>

<script>
  // workingDatesJson set by servlet
  const workingDates = (function() {
    const json = '<%= request.getAttribute("workingDatesJson") != null ? request.getAttribute("workingDatesJson") : "[]" %>';
    try { return JSON.parse(json); } catch(e) { return []; }
  })();

  // Convert workingDates array to a Set for quick lookup (strings YYYY-MM-DD)
  const workingSet = new Set(workingDates);

  // Calendar state
  let viewMonth = new Date(); // current month
  viewMonth.setDate(1);

  const monthLabel = document.getElementById('monthLabel');
  const calendarGrid = document.getElementById('calendarGrid');

  function renderCalendar() {
    calendarGrid.innerHTML = '';
    const year = viewMonth.getFullYear();
    const month = viewMonth.getMonth();

    // first day of month
    const firstDay = new Date(year, month, 1);
    // weekday of first day (0=Sun..6=Sat)
    const startWeekday = firstDay.getDay();

    // last day of month
    const lastDay = new Date(year, month + 1, 0);
    const daysInMonth = lastDay.getDate();

    // previous month last day (to fill leading cells)
    const prevLastDay = new Date(year, month, 0).getDate();

    monthLabel.textContent = firstDay.toLocaleString(undefined, { month: 'long', year: 'numeric' });

    // total cells: 6 weeks * 7 = 42 (safe)
    const totalCells = 42;
    for (let cell = 0; cell < totalCells; cell++) {
      const cellEl = document.createElement('div');
      cellEl.className = 'cal-cell';

      // compute date number and if in this month
      let dateNum, cellDate, inThisMonth;

      if (cell < startWeekday) {
        // leading previous month
        dateNum = prevLastDay - (startWeekday - 1 - cell);
        cellEl.classList.add('not-this-month');
        cellDate = new Date(year, month - 1, dateNum);
        inThisMonth = false;
      } else if (cell >= startWeekday + daysInMonth) {
        // next month
        dateNum = cell - (startWeekday + daysInMonth) + 1;
        cellEl.classList.add('not-this-month');
        cellDate = new Date(year, month + 1, dateNum);
        inThisMonth = false;
      } else {
        // current month
        dateNum = cell - startWeekday + 1;
        cellDate = new Date(year, month, dateNum);
        inThisMonth = true;
      }

      // date label
      const dateStr = cellDate.toISOString().slice(0,10); // YYYY-MM-DD
      const numSpan = document.createElement('span');
      numSpan.className = 'date-number';
      numSpan.textContent = dateNum;
      cellEl.appendChild(numSpan);

      // if this date is in workingSet, mark it clickable
      if (workingSet.has(dateStr) && inThisMonth) {
        cellEl.classList.add('working');
        cellEl.title = 'Working day — click to assign';
        cellEl.addEventListener('click', function() {
          // set hidden input and submit
          document.getElementById('working_date').value = dateStr;
          // optional: show selection visual
          document.querySelectorAll('.working').forEach(function(e){ e.classList.remove('selected'); });
          cellEl.classList.add('selected');
          // submit the form
          document.getElementById('assignForm').submit();
        });
      }

      calendarGrid.appendChild(cellEl);
    }
  }

  document.getElementById('prevMonth').addEventListener('click', function() {
    viewMonth = new Date(viewMonth.getFullYear(), viewMonth.getMonth() - 1, 1);
    renderCalendar();
  });
  document.getElementById('nextMonth').addEventListener('click', function() {
    viewMonth = new Date(viewMonth.getFullYear(), viewMonth.getMonth() + 1, 1);
    renderCalendar();
  });

  // initial render
  renderCalendar();
</script>
</body>
</html>
