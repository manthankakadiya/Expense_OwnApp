# 💰 Expense App (Personal Expense Tracker)

A complete personal finance tracker in **one HTML file**. No install, no server, no sign-up. All data stays private in your own browser (localStorage).

## ✨ Features

**Tracking**
- Add **expenses and income** with amount, category, date, payment method (Cash / UPI / Card / Bank / Wallet) and note
- Edit and delete any entry, with an **Undo** option after delete
- **Recurring transactions** (rent, salary, subscriptions) that are added automatically every month
- Custom categories with your own emoji (add or remove anytime)

**Insights**
- Dashboard with **Income, Expense, Balance, Daily average** for any month
- **Donut chart** of spending by category
- **6-month trend chart** (income vs expense)
- Top spending category and savings rate

**Budgeting**
- Overall **monthly budget** with a progress bar
- **Per-category budgets** with progress bars
- Alerts at 80% and when you go over budget

**Search and filters**
- Search by note or category
- Filter by type, category and month (or all time)
- Sort by newest, oldest, highest or lowest amount

**Data and privacy**
- Export to **CSV** (opens in Excel / Google Sheets)
- **Import CSV** (same format as the export)
- Full **Backup / Restore** as JSON
- Optional **PIN lock** screen
- Light / Dark / Auto theme
- Changeable currency symbol
- Works fully offline

**📱 Phone app experience (PWA)**
- **Installable** on Android, iPhone and desktop, with its own icon, full screen and no browser bar
- **Works offline** after the first visit (service worker caches the app)
- **Quick-add button (+)**: a bottom sheet where you type the amount, tap a category and save in about 3 seconds
- Phone-style **bottom tab bar**, big touch targets, numeric keypad, and safe-area support for notch phones
- **Home-screen shortcut**: long-press the icon (Android) and choose "Add expense"
- "Install app" banner, an Offline indicator and an "update ready" prompt
- Asks the browser to protect your data from automatic clean-up
- Light haptic buzz on save

## 🚀 How to add this to your repo

Repo: https://github.com/manthankakadiya/Expanse-App

Your repo needs these files in the root folder:

| File | What it is |
|---|---|
| `index.html` | the app (code below) |
| `manifest.json` | makes it installable (code below) |
| `sw.js` | offline support (code below) |
| `icon.svg` | app icon (code below) |
| `icon-192.png`, `icon-512.png` | PNG app icons (download these two files from the chat) |
| `README.md` | this file |

```bash
git clone https://github.com/manthankakadiya/Expanse-App
cd Expanse-App
# put all the files above in this folder
git add .
git commit -m "Add installable offline expense app (PWA)"
git push
```

Then turn on **GitHub Pages**: Repo > Settings > Pages > Source: `main` branch, `/ (root)`.
Your app will be live at `https://manthankakadiya.github.io/Expanse-App/`

### 📲 Install on your phone

- **Android (Chrome):** open the link, tap **Install** on the banner (or menu > Install app).
- **iPhone (Safari):** open the link, tap **Share > Add to Home Screen**.
- **Desktop (Chrome/Edge):** click the install icon in the address bar.

> **Important:** installing and offline mode need **https** (GitHub Pages is https) or `localhost`. Opening `index.html` directly from a folder still works as a normal app, but cannot be installed.
> **After you change `index.html`:** change `expenses-v1` to `expenses-v2` in `sw.js` so phones pick up the new version.
> Data is stored per browser and device. Use **Backup / Restore** in Settings to move it between devices. The PIN is a casual privacy lock, not strong encryption.
> If you used an earlier version, your old expenses are migrated automatically.

## 📄 index.html

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<link rel="manifest" href="manifest.json">
<link rel="icon" href="icon.svg" type="image/svg+xml">
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-title" content="Expenses">
<meta name="apple-mobile-web-app-status-bar-style" content="default">
<meta name="theme-color" content="#4f46e5">
<title>My Expenses</title>
<style>
:root{--bg:#f4f5fa;--card:#fff;--text:#1d2130;--muted:#7b8296;--primary:#4f46e5;--danger:#e5484d;--ok:#16a34a;--warn:#f59e0b;--border:#e3e6ef}
@media (prefers-color-scheme:dark){:root:not([data-theme="light"]){--bg:#11131a;--card:#1b1e28;--text:#eceef6;--muted:#9aa2b8;--primary:#8087ff;--danger:#ff6b70;--ok:#4ade80;--warn:#fbbf24;--border:#2b3042}}
:root[data-theme="dark"]{--bg:#11131a;--card:#1b1e28;--text:#eceef6;--muted:#9aa2b8;--primary:#8087ff;--danger:#ff6b70;--ok:#4ade80;--warn:#fbbf24;--border:#2b3042}
*{box-sizing:border-box}
body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,sans-serif;background:var(--bg);color:var(--text)}
.wrap{max-width:820px;margin:0 auto;padding:14px}
header{display:flex;justify-content:space-between;align-items:center;gap:10px;margin-bottom:10px}
h1{font-size:21px;margin:0}
h3{margin:0 0 10px;font-size:16px}
nav{display:flex;gap:6px;position:sticky;top:0;background:var(--bg);padding:6px 0;z-index:5;overflow-x:auto}
nav button{flex:1;white-space:nowrap;background:var(--card);color:var(--text);border:1px solid var(--border)}
nav button.on{background:var(--primary);color:#fff;border-color:var(--primary)}
.tab{display:none}.tab.on{display:block}
.card{background:var(--card);border:1px solid var(--border);border-radius:14px;padding:14px;margin:12px 0}
.stats{display:grid;grid-template-columns:repeat(4,1fr);gap:10px}
@media(max-width:620px){.stats{grid-template-columns:1fr 1fr}}
.stat{background:var(--card);border:1px solid var(--border);border-radius:14px;padding:12px}
.stat b{display:block;font-size:19px;margin-top:4px}
.grid{display:grid;grid-template-columns:1fr 1fr;gap:10px}
@media(max-width:520px){.grid{grid-template-columns:1fr}}
input,select,button{font:inherit;padding:10px;border-radius:10px;border:1px solid var(--border);background:var(--bg);color:var(--text);width:100%}
button{cursor:pointer;background:var(--primary);color:#fff;border:none;font-weight:600;width:auto}
button.ghost{background:transparent;color:var(--text);border:1px solid var(--border)}
button.danger{background:var(--danger)}
button.sm{padding:5px 9px;font-size:13px}
.row{display:flex;gap:8px;flex-wrap:wrap;margin-top:10px}
.row>*{flex:1;min-width:110px}
.seg{display:flex;gap:6px;margin-bottom:10px}
.seg button{flex:1;background:var(--bg);color:var(--text);border:1px solid var(--border)}
.seg button.on.expense{background:var(--danger);color:#fff;border-color:var(--danger)}
.seg button.on.income{background:var(--ok);color:#fff;border-color:var(--ok)}
.muted{color:var(--muted);font-size:13px}
.income{color:var(--ok)}.expense{color:var(--danger)}
.item{display:flex;align-items:center;gap:10px;padding:10px 0;border-bottom:1px solid var(--border)}
.item:last-child{border-bottom:none}
.ic{font-size:22px;width:38px;height:38px;display:grid;place-items:center;background:var(--bg);border-radius:10px}
.mid{flex:1;min-width:0}.mid div:first-child{white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.r{text-align:right}.amt{font-weight:700;white-space:nowrap}
.bar{height:8px;border-radius:99px;background:var(--border);overflow:hidden;margin:5px 0}
.bar>div{height:100%;background:var(--primary)}.bar>div.warn{background:var(--warn)}.bar>div.over{background:var(--danger)}
.empty{text-align:center;color:var(--muted);padding:18px}
.alert{padding:8px 12px;border-radius:10px;margin-top:8px;font-size:14px;background:rgba(245,158,11,.15)}
.alert.over{background:rgba(229,72,77,.15)}
.legend{display:flex;justify-content:space-between;font-size:14px;padding:3px 0}
.dot{display:inline-block;width:10px;height:10px;border-radius:50%;margin-right:6px}
.chartrow{display:flex;gap:16px;align-items:center;flex-wrap:wrap}.chartrow>div:last-child{flex:1;min-width:200px}
#toast{position:fixed;left:50%;bottom:20px;transform:translateX(-50%);background:#222;color:#fff;padding:10px 16px;border-radius:12px;display:none;gap:12px;align-items:center;z-index:50}
#toast button{background:none;color:#8ab4ff;padding:0}
.lock{position:fixed;inset:0;background:var(--bg);display:grid;place-items:center;z-index:100}
.lock[hidden]{display:none}
.lock .box{width:min(320px,90%);text-align:center}
.catrow{display:flex;align-items:center;gap:8px;padding:6px 0;border-bottom:1px solid var(--border)}
.catrow input[type=number]{width:110px}

/* ---- phone app feel ---- */
[hidden]{display:none!important}
.wrap{padding-top:calc(14px + env(safe-area-inset-top));padding-bottom:calc(110px + env(safe-area-inset-bottom))}
button{-webkit-tap-highlight-color:transparent;touch-action:manipulation}
button:active{transform:scale(.97)}
@media(max-width:700px){
  nav{position:fixed;top:auto;bottom:0;left:0;right:0;background:var(--card);border-top:1px solid var(--border);padding:6px 8px calc(6px + env(safe-area-inset-bottom));gap:4px;overflow:visible;z-index:20}
  nav button{border:none;background:transparent;padding:11px 2px;font-size:12px}
}
#fab{position:fixed;right:16px;bottom:calc(78px + env(safe-area-inset-bottom));width:58px;height:58px;border-radius:50%;font-size:30px;line-height:1;padding:0;box-shadow:0 6px 18px rgba(0,0,0,.3);z-index:30}
#sheetBg{position:fixed;inset:0;background:rgba(0,0,0,.45);z-index:55}
#sheet{position:fixed;left:0;right:0;bottom:0;max-width:520px;margin:0 auto;background:var(--card);border-radius:20px 20px 0 0;padding:16px 16px calc(16px + env(safe-area-inset-bottom));z-index:60;animation:up .2s ease-out}
@keyframes up{from{transform:translateY(40px);opacity:0}to{transform:none;opacity:1}}
.chips{display:flex;flex-wrap:wrap;gap:8px;margin-top:12px;max-height:140px;overflow:auto}
.chip{background:var(--bg);color:var(--text);border:1px solid var(--border);border-radius:99px;padding:8px 12px}
.chip.on{background:var(--primary);color:#fff;border-color:var(--primary)}
#offline{position:fixed;top:calc(6px + env(safe-area-inset-top));left:50%;transform:translateX(-50%);background:#444;color:#fff;font-size:12px;padding:4px 12px;border-radius:99px;z-index:70}
#installBar{position:fixed;left:12px;right:90px;bottom:calc(78px + env(safe-area-inset-bottom));background:var(--card);border:1px solid var(--border);border-radius:14px;padding:10px 12px;display:flex;gap:8px;align-items:center;z-index:30;font-size:14px}
#installBar span{flex:1}
#toast{z-index:80;bottom:calc(150px + env(safe-area-inset-bottom))}
@media(min-width:701px){#fab,#installBar{bottom:24px}#toast{bottom:24px}}
</style>
</head>
<body>

<div id="lock" class="lock" hidden>
  <div class="box card">
    <h3>🔒 Enter PIN</h3>
    <input type="password" id="pinInput" inputmode="numeric" placeholder="PIN" autocomplete="off">
    <div class="row"><button id="unlockBtn">Unlock</button></div>
    <div class="muted" id="pinErr" style="margin-top:8px"></div>
  </div>
</div>

<div class="wrap">
  <header>
    <h1>💰 My Expenses</h1>
    <input type="month" id="month" style="width:auto">
  </header>
  <nav id="tabs">
    <button data-tab="dash" class="on">📊 Dashboard</button>
    <button data-tab="tx">🧾 Transactions</button>
    <button data-tab="plan">🎯 Plan</button>
    <button data-tab="set">⚙️ Settings</button>
  </nav>

  <!-- DASHBOARD -->
  <section id="dash" class="tab on">
    <div class="stats" id="cards" style="margin-top:12px"></div>
    <div class="card"><h3>Monthly budget</h3><div id="budgetBox"></div></div>
    <div class="card"><h3>Spending by category</h3><div id="donut" class="chartrow"></div></div>
    <div class="card"><h3>6-month trend</h3><div id="trend"></div></div>
    <div class="card"><h3>Recent</h3><div id="recent"></div></div>
  </section>

  <!-- TRANSACTIONS -->
  <section id="tx" class="tab">
    <div class="card">
      <div class="seg" id="typeSeg">
        <button data-type="expense" class="on expense">➖ Expense</button>
        <button data-type="income" class="income">➕ Income</button>
      </div>
      <div class="grid">
        <input type="number" id="amount" placeholder="Amount" min="0" step="0.01" inputmode="decimal">
        <select id="category"></select>
        <input type="date" id="date">
        <select id="method"></select>
      </div>
      <input type="text" id="note" placeholder="Note (optional)" style="margin-top:10px">
      <div class="row">
        <button id="saveBtn">Add</button>
        <button class="ghost" id="cancelBtn" style="display:none">Cancel edit</button>
      </div>
    </div>
    <div class="card">
      <div class="grid">
        <input type="search" id="fSearch" placeholder="🔍 Search">
        <select id="fType"><option value="">All types</option><option value="expense">Expenses</option><option value="income">Income</option></select>
        <select id="fCat"></select>
        <select id="fSort">
          <option value="new">Newest first</option><option value="old">Oldest first</option>
          <option value="high">Highest amount</option><option value="low">Lowest amount</option>
        </select>
      </div>
      <label class="muted" style="display:block;margin:10px 0"><input type="checkbox" id="fAll" style="width:auto"> Show all time (ignore month)</label>
      <div id="txSummary" class="muted"></div>
      <div id="list"></div>
    </div>
  </section>

  <!-- PLAN -->
  <section id="plan" class="tab">
    <div class="card">
      <h3>Monthly budget (overall)</h3>
      <div class="row"><input type="number" id="budgetInput" placeholder="0 = no budget" min="0" inputmode="decimal"><button id="budgetSave">Save</button></div>
    </div>
    <div class="card"><h3>Category budgets</h3><div id="catBudgets"></div></div>
    <div class="card">
      <h3>Recurring transactions</h3>
      <div class="muted" style="margin-bottom:8px">Added automatically every month on the chosen day.</div>
      <div class="grid">
        <select id="rType"><option value="expense">Expense</option><option value="income">Income</option></select>
        <select id="rCat"></select>
        <input type="number" id="rAmount" placeholder="Amount" min="0" step="0.01" inputmode="decimal">
        <input type="number" id="rDay" placeholder="Day of month (1-31)" min="1" max="31">
        <input type="text" id="rNote" placeholder="Name (e.g. Rent, Netflix)">
        <select id="rMethod"></select>
      </div>
      <div class="row"><button id="rAdd">Add recurring</button></div>
      <div id="recList" style="margin-top:10px"></div>
    </div>
  </section>

  <!-- SETTINGS -->
  <section id="set" class="tab">
    <div class="card">
      <h3>Preferences</h3>
      <div class="grid">
        <div><div class="muted">Currency symbol</div><input type="text" id="currency" maxlength="4"></div>
        <div><div class="muted">Theme</div>
          <select id="theme"><option value="auto">Auto</option><option value="light">Light</option><option value="dark">Dark</option></select></div>
      </div>
    </div>
    <div class="card">
      <h3>PIN lock</h3>
      <div class="row"><input type="password" id="newPin" inputmode="numeric" placeholder="New PIN (4+ digits)">
        <button id="pinSet">Set PIN</button><button class="ghost" id="pinOff">Remove</button></div>
    </div>
    <div class="card">
      <h3>Categories</h3>
      <div id="catList"></div>
      <div class="row"><input type="text" id="newCatIcon" maxlength="2" placeholder="😀" style="max-width:70px;min-width:70px;flex:none">
        <input type="text" id="newCatName" placeholder="New category name"><button id="catAdd">Add</button></div>
    </div>
    <div class="card">
      <h3>Data</h3>
      <div class="row">
        <button class="ghost" id="csvBtn">⬇️ Export CSV</button>
        <button class="ghost" id="csvImpBtn">⬆️ Import CSV</button>
        <button class="ghost" id="backupBtn">💾 Backup</button>
        <button class="ghost" id="restoreBtn">♻️ Restore</button>
        <button class="danger" id="wipeBtn">🗑️ Erase all</button>
      </div>
      <input type="file" id="csvFile" accept=".csv" hidden>
      <input type="file" id="restoreFile" accept=".json" hidden>
    </div>
  </section>
</div>

<button id="fab" aria-label="Quick add">+</button>
<div id="sheetBg" hidden></div>
<div id="sheet" hidden>
  <div class="seg" id="qType">
    <button data-type="expense" class="on expense">➖ Expense</button>
    <button data-type="income" class="income">➕ Income</button>
  </div>
  <input type="number" id="qAmount" placeholder="0" inputmode="decimal" style="font-size:28px;font-weight:700;text-align:center">
  <div id="qChips" class="chips"></div>
  <input type="text" id="qNote" placeholder="Note (optional)" style="margin-top:10px">
  <div class="row"><button id="qSave">Save</button><button class="ghost" id="qClose">Cancel</button></div>
</div>
<div id="offline" hidden>📴 Offline mode</div>
<div id="installBar" hidden><span>📲 Install this app</span><button id="installBtn" class="sm">Install</button><button id="installX" class="sm ghost">✕</button></div>

<div id="toast"><span id="toastMsg"></span><button id="toastUndo">Undo</button></div>

<script>
/* ---------- constants ---------- */
const COLORS=["#4f46e5","#ef4444","#10b981","#f59e0b","#06b6d4","#ec4899","#8b5cf6","#84cc16","#f97316","#64748b"];
const DEF_CATS=[["Food","🍔"],["Transport","🚗"],["Shopping","🛍️"],["Bills","💡"],["Rent","🏠"],["Health","💊"],["Entertainment","🎬"],["Travel","✈️"],["Education","📚"],["Other","📦"]];
const INC_CATS=[["Salary","💼"],["Business","🏪"],["Gift","🎁"],["Interest","🏦"],["Other Income","💵"]];
const METHODS=["Cash","UPI","Card","Bank","Wallet"];
const KEY="expense_app_v2";

/* ---------- helpers ---------- */
const $=q=>document.querySelector(q);
const pad=n=>String(n).padStart(2,"0");
const esc=s=>String(s??"").replace(/[&<>"']/g,c=>({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c]));
const ym=d=>`${d.getFullYear()}-${pad(d.getMonth()+1)}`;
const todayStr=()=>{const d=new Date();return `${ym(d)}-${pad(d.getDate())}`};
const uid=()=>Date.now()*1000+Math.floor(Math.random()*1000);
const daysIn=m=>{const[y,mo]=m.split("-").map(Number);return new Date(y,mo,0).getDate()};
const nextMonth=m=>{const[y,mo]=m.split("-").map(Number);return mo===12?`${y+1}-01`:`${y}-${pad(mo+1)}`};
const prevMonth=m=>{const[y,mo]=m.split("-").map(Number);return mo===1?`${y-1}-12`:`${y}-${pad(mo-1)}`};
const monthShort=m=>{const[y,mo]=m.split("-").map(Number);return new Date(y,mo-1).toLocaleString("en",{month:"short"})};
const pinHash=s=>{let x=5381;for(const c of "pin|"+s+"|salt")x=((x<<5)+x+c.charCodeAt(0))|0;return String(x)};

/* ---------- state ---------- */
function load(){
  try{const d=JSON.parse(localStorage.getItem(KEY));if(d&&Array.isArray(d.tx))return d;}catch(e){}
  let old=[];try{old=JSON.parse(localStorage.getItem("expense_app_data_v1"))||[]}catch(e){}
  return{
    settings:{currency:"₹",theme:"auto",pin:null,budget:0},
    cats:DEF_CATS.map(([name,icon])=>({name,icon,budget:0})),
    tx:old.map(e=>({id:e.id,type:"expense",amount:e.amount,category:e.category,date:e.date,note:e.note||"",method:"Cash"})),
    rec:[]
  };
}
let S=load();
let viewMonth=ym(new Date()),txType="expense",editId=null;
const save=()=>{try{localStorage.setItem(KEY,JSON.stringify(S))}catch(e){alert("Could not save data (storage full or blocked).")}};
const money=n=>S.settings.currency+Number(n).toLocaleString("en-IN",{maximumFractionDigits:2});
const iconOf=name=>{const c=S.cats.find(c=>c.name===name)||INC_CATS.map(([n,i])=>({name:n,icon:i})).find(c=>c.name===name);return c?c.icon:"📦"};
const catsFor=type=>type==="income"?INC_CATS.map(([name,icon])=>({name,icon})):S.cats;
const monthTx=m=>S.tx.filter(t=>t.date.startsWith(m));
const sum=(arr,type)=>arr.filter(t=>t.type===type).reduce((s,t)=>s+t.amount,0);
const spentByCat=m=>{const o={};monthTx(m).filter(t=>t.type==="expense").forEach(t=>o[t.category]=(o[t.category]||0)+t.amount);return o};

/* ---------- recurring ---------- */
function runRecurring(){
  const cur=ym(new Date());let added=0;
  S.rec.forEach(r=>{
    let m=r.last?nextMonth(r.last):r.start;
    while(m<=cur){
      const d=Math.min(r.day,daysIn(m));const date=`${m}-${pad(d)}`;
      if(date>todayStr())break;
      S.tx.push({id:uid(),type:r.type,amount:r.amount,category:r.category,date,note:(r.note||r.category)+" (recurring)",method:r.method});
      r.last=m;added++;m=nextMonth(m);
    }
  });
  if(added)save();
}

/* ---------- toast ---------- */
let undoFn=null,toastTimer;
function toast(msg,undo,label){
  $("#toastMsg").textContent=msg;undoFn=undo||null;$("#toastUndo").textContent=label||"Undo";
  $("#toastUndo").style.display=undo?"inline":"none";
  $("#toast").style.display="flex";clearTimeout(toastTimer);
  toastTimer=setTimeout(()=>$("#toast").style.display="none",5000);
}
$("#toastUndo").onclick=()=>{if(undoFn)undoFn();$("#toast").style.display="none"};

/* ---------- selects ---------- */
function fillCats(sel,type,keep){
  const cur=keep?sel.value:"";
  sel.innerHTML=catsFor(type).map(c=>`<option value="${esc(c.name)}">${c.icon} ${esc(c.name)}</option>`).join("");
  if(cur&&[...sel.options].some(o=>o.value===cur))sel.value=cur;
}
function fillAllSelects(){
  fillCats($("#category"),txType,true);
  fillCats($("#rCat"),$("#rType").value,true);
  const all=[...S.cats.map(c=>c.name),...INC_CATS.map(c=>c[0])];
  const cur=$("#fCat").value;
  $("#fCat").innerHTML='<option value="">All categories</option>'+all.map(n=>`<option>${esc(n)}</option>`).join("");
  $("#fCat").value=cur;
  [$("#method"),$("#rMethod")].forEach(s=>{const c=s.value;s.innerHTML=METHODS.map(m=>`<option>${m}</option>`).join("");if(c)s.value=c});
}

/* ---------- dashboard ---------- */
function renderDash(){
  const t=monthTx(viewMonth),inc=sum(t,"income"),exp=sum(t,"expense"),bal=inc-exp;
  const isCur=viewMonth===ym(new Date());
  const days=isCur?new Date().getDate():daysIn(viewMonth);
  const rate=inc>0?Math.round(bal/inc*100):null;
  $("#cards").innerHTML=
    `<div class="stat"><span class="muted">Income</span><b class="income">${money(inc)}</b></div>
     <div class="stat"><span class="muted">Expense</span><b class="expense">${money(exp)}</b></div>
     <div class="stat"><span class="muted">Balance${rate!==null?` · saved ${rate}%`:""}</span><b class="${bal>=0?"income":"expense"}">${money(bal)}</b></div>
     <div class="stat"><span class="muted">Daily average</span><b>${money(exp/days)}</b></div>`;

  // budget
  const bud=+S.settings.budget||0;let html="";
  if(bud>0){
    const p=exp/bud*100;
    html=`<div style="display:flex;justify-content:space-between"><span>${money(exp)} of ${money(bud)}</span><span>${Math.round(p)}%</span></div>
      <div class="bar"><div class="${p>=100?"over":p>=80?"warn":""}" style="width:${Math.min(p,100)}%"></div></div>
      <div class="muted">${bud-exp>=0?money(bud-exp)+" left":"Over by "+money(exp-bud)}</div>`;
    if(p>=100)html+=`<div class="alert over">🚨 You have exceeded your monthly budget.</div>`;
    else if(p>=80)html+=`<div class="alert">⚠️ You have used ${Math.round(p)}% of your monthly budget.</div>`;
  }else html='<div class="muted">No budget set. Add one in the Plan tab.</div>';
  const sc=spentByCat(viewMonth);
  S.cats.filter(c=>c.budget>0&&(sc[c.name]||0)>=c.budget*0.8).forEach(c=>{
    const over=(sc[c.name]||0)>=c.budget;
    html+=`<div class="alert ${over?"over":""}">${over?"🚨":"⚠️"} ${c.icon} ${esc(c.name)}: ${money(sc[c.name])} of ${money(c.budget)}</div>`;
  });
  $("#budgetBox").innerHTML=html;

  // donut
  const rows=Object.entries(sc).sort((a,b)=>b[1]-a[1]);
  if(!rows.length){$("#donut").innerHTML='<div class="empty" style="width:100%">No expenses this month</div>'}
  else{
    let off=25;
    const segs=rows.map(([c,v],i)=>{const p=v/exp*100;const s=`<circle r="15.9155" cx="21" cy="21" fill="none" stroke="${COLORS[i%COLORS.length]}" stroke-width="6" stroke-dasharray="${p} ${100-p}" stroke-dashoffset="${off}"/>`;off-=p;return s}).join("");
    $("#donut").innerHTML=
      `<div><svg viewBox="0 0 42 42" width="170" height="170">
        <circle r="15.9155" cx="21" cy="21" fill="none" stroke="var(--border)" stroke-width="6"/>${segs}
        <text x="21" y="22" text-anchor="middle" font-size="3.6" fill="var(--text)" font-weight="700">${money(exp)}</text></svg></div>
       <div>${rows.map(([c,v],i)=>`<div class="legend"><span><span class="dot" style="background:${COLORS[i%COLORS.length]}"></span>${iconOf(c)} ${esc(c)}</span><span>${money(v)} · ${Math.round(v/exp*100)}%</span></div>`).join("")}</div>`;
  }

  // trend (6 months)
  const ms=[];let m=viewMonth;for(let i=0;i<6;i++){ms.unshift(m);m=prevMonth(m)}
  const data=ms.map(mm=>{const x=monthTx(mm);return{m:mm,i:sum(x,"income"),e:sum(x,"expense")}});
  const max=Math.max(1,...data.flatMap(d=>[d.i,d.e]));
  const bars=data.map((d,k)=>{
    const x=k*50+8,hi=d.i/max*88,he=d.e/max*88;
    return `<rect x="${x}" y="${100-hi}" width="16" height="${hi}" rx="3" fill="var(--ok)"/>
            <rect x="${x+18}" y="${100-he}" width="16" height="${he}" rx="3" fill="var(--danger)"/>
            <text x="${x+17}" y="116" text-anchor="middle" font-size="10" fill="var(--muted)">${monthShort(d.m)}</text>`}).join("");
  $("#trend").innerHTML=`<svg viewBox="0 0 310 122" width="100%"><line x1="0" y1="100" x2="310" y2="100" stroke="var(--border)"/>${bars}</svg>
    <div class="muted"><span class="dot" style="background:var(--ok)"></span>Income &nbsp; <span class="dot" style="background:var(--danger)"></span>Expense</div>`;

  // recent
  const rec=[...S.tx].sort((a,b)=>b.date.localeCompare(a.date)||b.id-a.id).slice(0,5);
  $("#recent").innerHTML=rec.length?rec.map(itemHTML.bind(null,false)).join(""):'<div class="empty">Nothing yet. Add your first transaction.</div>';
}

/* ---------- transactions ---------- */
function itemHTML(withActions,t){
  const sign=t.type==="income"?"+":"-";
  return `<div class="item"><div class="ic">${iconOf(t.category)}</div>
    <div class="mid"><div>${esc(t.note||t.category)}</div><div class="muted">${t.date} · ${esc(t.category)} · ${esc(t.method||"")}</div></div>
    <div class="r"><div class="amt ${t.type}">${sign}${money(t.amount)}</div>
    ${withActions?`<div style="margin-top:4px"><button class="sm ghost" data-act="edit" data-id="${t.id}">✏️</button> <button class="sm ghost" data-act="del" data-id="${t.id}">🗑️</button></div>`:""}</div></div>`;
}
function filteredTx(){
  const q=$("#fSearch").value.trim().toLowerCase(),ty=$("#fType").value,ca=$("#fCat").value,all=$("#fAll").checked,so=$("#fSort").value;
  let l=S.tx.filter(t=>(all||t.date.startsWith(viewMonth))&&(!ty||t.type===ty)&&(!ca||t.category===ca)&&(!q||(t.note+" "+t.category+" "+t.method).toLowerCase().includes(q)));
  l.sort((a,b)=>so==="old"?a.date.localeCompare(b.date)||a.id-b.id:so==="high"?b.amount-a.amount:so==="low"?a.amount-b.amount:b.date.localeCompare(a.date)||b.id-a.id);
  return l;
}
function renderTx(){
  const l=filteredTx();
  $("#txSummary").textContent=`${l.length} item(s) · Income ${money(sum(l,"income"))} · Expense ${money(sum(l,"expense"))}`;
  $("#list").innerHTML=l.length?l.map(itemHTML.bind(null,true)).join(""):'<div class="empty">No transactions found</div>';
}
function resetForm(){
  editId=null;$("#amount").value="";$("#note").value="";$("#date").value=todayStr();
  $("#saveBtn").textContent="Add";$("#cancelBtn").style.display="none";
}
function setType(t){
  txType=t;
  document.querySelectorAll("#typeSeg button").forEach(b=>b.classList.toggle("on",b.dataset.type===t));
  fillCats($("#category"),t,false);
}
$("#typeSeg").onclick=e=>{const b=e.target.closest("button");if(b)setType(b.dataset.type)};
$("#saveBtn").onclick=()=>{
  const amount=parseFloat($("#amount").value);
  if(!(amount>0)){alert("Enter a valid amount");return}
  const d={type:txType,amount,category:$("#category").value,date:$("#date").value||todayStr(),note:$("#note").value.trim(),method:$("#method").value};
  if(editId)S.tx=S.tx.map(t=>t.id===editId?{...t,...d}:t);else S.tx.push({id:uid(),...d});
  save();resetForm();renderAll();toast("Saved ✔");
};
$("#cancelBtn").onclick=resetForm;
["#fSearch","#fType","#fCat","#fSort","#fAll"].forEach(s=>$(s).oninput=renderTx);

/* ---------- plan ---------- */
function renderPlan(){
  $("#budgetInput").value=S.settings.budget||"";
  const sc=spentByCat(viewMonth);
  $("#catBudgets").innerHTML=S.cats.map(c=>{
    const sp=sc[c.name]||0,p=c.budget>0?sp/c.budget*100:0;
    return `<div class="catrow"><span style="width:26px">${c.icon}</span>
      <div style="flex:1"><div>${esc(c.name)} <span class="muted">· spent ${money(sp)}</span></div>
      ${c.budget>0?`<div class="bar"><div class="${p>=100?"over":p>=80?"warn":""}" style="width:${Math.min(p,100)}%"></div></div>`:""}</div>
      <input type="number" min="0" data-catbudget="${esc(c.name)}" value="${c.budget||""}" placeholder="Budget"></div>`}).join("");
  $("#recList").innerHTML=S.rec.length?S.rec.map(r=>
    `<div class="item"><div class="ic">${iconOf(r.category)}</div>
     <div class="mid"><div>${esc(r.note||r.category)}</div><div class="muted">${r.type} · day ${r.day} · ${esc(r.method)}</div></div>
     <div class="r"><div class="amt ${r.type}">${money(r.amount)}</div><button class="sm ghost" data-act="delrec" data-id="${r.id}">🗑️</button></div></div>`).join("")
    :'<div class="empty">No recurring items</div>';
}
$("#budgetSave").onclick=()=>{S.settings.budget=Math.max(0,parseFloat($("#budgetInput").value)||0);save();renderAll();toast("Budget saved ✔")};
$("#catBudgets").addEventListener("change",e=>{
  const n=e.target.dataset.catbudget;if(n===undefined)return;
  const c=S.cats.find(c=>c.name===n);if(c){c.budget=Math.max(0,parseFloat(e.target.value)||0);save();renderAll()}
});
$("#rType").onchange=()=>fillCats($("#rCat"),$("#rType").value,false);
$("#rAdd").onclick=()=>{
  const amount=parseFloat($("#rAmount").value),day=parseInt($("#rDay").value);
  if(!(amount>0)||!(day>=1&&day<=31)){alert("Enter a valid amount and day (1-31)");return}
  S.rec.push({id:uid(),type:$("#rType").value,amount,category:$("#rCat").value,day,note:$("#rNote").value.trim(),method:$("#rMethod").value,start:ym(new Date()),last:null});
  $("#rAmount").value="";$("#rDay").value="";$("#rNote").value="";
  runRecurring();save();renderAll();toast("Recurring added ✔");
};

/* ---------- settings ---------- */
function renderSettings(){
  $("#currency").value=S.settings.currency;$("#theme").value=S.settings.theme;
  $("#catList").innerHTML=S.cats.map(c=>`<div class="catrow"><span>${c.icon}</span><span style="flex:1">${esc(c.name)}</span><button class="sm ghost" data-act="delcat" data-name="${esc(c.name)}">🗑️</button></div>`).join("");
}
function applyTheme(){
  const t=S.settings.theme;
  if(t==="auto")document.documentElement.removeAttribute("data-theme");else document.documentElement.setAttribute("data-theme",t);
}
$("#currency").onchange=()=>{S.settings.currency=$("#currency").value||"₹";save();renderAll()};
$("#theme").onchange=()=>{S.settings.theme=$("#theme").value;save();applyTheme()};
$("#pinSet").onclick=()=>{const p=$("#newPin").value;if(p.length<4){alert("PIN must be at least 4 digits");return}S.settings.pin=pinHash(p);$("#newPin").value="";save();toast("PIN set ✔")};
$("#pinOff").onclick=()=>{S.settings.pin=null;save();toast("PIN removed")};
$("#catAdd").onclick=()=>{
  const name=$("#newCatName").value.trim(),icon=$("#newCatIcon").value.trim()||"📦";
  if(!name)return;
  if(S.cats.some(c=>c.name.toLowerCase()===name.toLowerCase())){alert("Category already exists");return}
  S.cats.push({name,icon,budget:0});$("#newCatName").value="";$("#newCatIcon").value="";
  save();fillAllSelects();renderAll();
};

/* ---------- data ---------- */
function download(name,content,type){
  const a=document.createElement("a");a.href=URL.createObjectURL(new Blob([content],{type}));
  a.download=name;a.click();setTimeout(()=>URL.revokeObjectURL(a.href),1000);
}
const q=v=>'"'+String(v??"").replace(/"/g,'""')+'"';
$("#csvBtn").onclick=()=>{
  const rows=[["Date","Type","Category","Amount","Method","Note"],...[...S.tx].sort((a,b)=>a.date.localeCompare(b.date)).map(t=>[t.date,t.type,t.category,t.amount,t.method,t.note])];
  download("expenses.csv",rows.map(r=>r.map(q).join(",")).join("\n"),"text/csv");
};
function parseCSV(text){
  const rows=[];let row=[],cur="",inQ=false;
  for(let i=0;i<text.length;i++){
    const c=text[i];
    if(inQ){if(c==='"'){if(text[i+1]==='"'){cur+='"';i++}else inQ=false}else cur+=c}
    else if(c==='"')inQ=true;
    else if(c===","){row.push(cur);cur=""}
    else if(c==="\n"||c==="\r"){if(c==="\r"&&text[i+1]==="\n")i++;row.push(cur);cur="";if(row.some(x=>x!==""))rows.push(row);row=[]}
    else cur+=c;
  }
  if(cur!==""||row.length){row.push(cur);rows.push(row)}
  return rows;
}
$("#csvImpBtn").onclick=()=>$("#csvFile").click();
$("#csvFile").onchange=ev=>{
  const f=ev.target.files[0];if(!f)return;
  const r=new FileReader();
  r.onload=()=>{
    try{
      const rows=parseCSV(r.result).slice(1);let n=0;
      rows.forEach(c=>{
        const amount=parseFloat(c[3]);
        if(!/^\d{4}-\d{2}-\d{2}$/.test(c[0])||!(amount>0))return;
        const type=c[1]==="income"?"income":"expense";
        S.tx.push({id:uid()+n,type,amount,category:c[2]||"Other",date:c[0],method:c[4]||"Cash",note:c[5]||""});n++;
      });
      save();renderAll();alert(n+" transaction(s) imported.");
    }catch(e){alert("Could not read that CSV file.")}
  };
  r.readAsText(f);ev.target.value="";
};
$("#backupBtn").onclick=()=>download("expenses-backup.json",JSON.stringify(S,null,2),"application/json");
$("#restoreBtn").onclick=()=>$("#restoreFile").click();
$("#restoreFile").onchange=ev=>{
  const f=ev.target.files[0];if(!f)return;
  const r=new FileReader();
  r.onload=()=>{
    try{
      const d=JSON.parse(r.result);
      if(!d||!Array.isArray(d.tx)||!Array.isArray(d.cats))throw 0;
      if(confirm("Replace ALL current data with this backup?")){S=d;S.rec=S.rec||[];save();applyTheme();fillAllSelects();renderAll()}
    }catch(e){alert("Invalid backup file")}
  };
  r.readAsText(f);ev.target.value="";
};
$("#wipeBtn").onclick=()=>{
  if(!confirm("Erase ALL data? This cannot be undone."))return;
  if(!confirm("Really erase everything? Consider a Backup first."))return;
  localStorage.removeItem(KEY);S=load();S.tx=[];applyTheme();fillAllSelects();renderAll();
};

/* ---------- global actions (delegated) ---------- */
document.addEventListener("click",e=>{
  const b=e.target.closest("[data-act]");if(!b)return;
  const id=+b.dataset.id,act=b.dataset.act;
  if(act==="edit"){
    const t=S.tx.find(x=>x.id===id);if(!t)return;
    editId=id;setType(t.type);
    $("#amount").value=t.amount;$("#category").value=t.category;$("#date").value=t.date;
    $("#method").value=t.method||"Cash";$("#note").value=t.note;
    $("#saveBtn").textContent="Update";$("#cancelBtn").style.display="block";
    showTab("tx");window.scrollTo({top:0,behavior:"smooth"});
  }
  if(act==="del"){
    const t=S.tx.find(x=>x.id===id);if(!t)return;
    S.tx=S.tx.filter(x=>x.id!==id);save();renderAll();
    toast("Deleted",()=>{S.tx.push(t);save();renderAll()});
  }
  if(act==="delrec"){S.rec=S.rec.filter(r=>r.id!==id);save();renderAll()}
  if(act==="delcat"){
    const n=b.dataset.name;
    if(S.tx.some(t=>t.category===n)&&!confirm(`"${n}" has transactions. They will keep this category name. Delete it anyway?`))return;
    S.cats=S.cats.filter(c=>c.name!==n);save();fillAllSelects();renderAll();
  }
});

/* ---------- tabs / month / lock ---------- */
function showTab(id){
  document.querySelectorAll(".tab").forEach(s=>s.classList.toggle("on",s.id===id));
  document.querySelectorAll("#tabs button").forEach(b=>b.classList.toggle("on",b.dataset.tab===id));
}
$("#tabs").onclick=e=>{const b=e.target.closest("button");if(b)showTab(b.dataset.tab)};
$("#month").onchange=()=>{viewMonth=$("#month").value||ym(new Date());renderAll()};

function checkLock(){
  if(!S.settings.pin)return;
  $("#lock").hidden=false;
  const tryUnlock=()=>{
    if(pinHash($("#pinInput").value)===S.settings.pin){$("#lock").hidden=true;$("#pinInput").value="";$("#pinErr").textContent=""}
    else $("#pinErr").textContent="Wrong PIN";
  };
  $("#unlockBtn").onclick=tryUnlock;
  $("#pinInput").onkeydown=e=>{if(e.key==="Enter")tryUnlock()};
}

/* ---------- render all / init ---------- */
function renderAll(){renderDash();renderTx();renderPlan();renderSettings()}
function init(){
  applyTheme();runRecurring();
  $("#month").value=viewMonth;$("#date").value=todayStr();
  fillAllSelects();setType("expense");renderAll();checkLock();
}
/* ---------- quick add (bottom sheet) ---------- */
let qType="expense",qCat="";
const buzz=()=>{try{navigator.vibrate&&navigator.vibrate(15)}catch(e){}};
function renderChips(){
  const l=catsFor(qType);
  if(!l.some(c=>c.name===qCat))qCat=l[0].name;
  $("#qChips").innerHTML=l.map(c=>`<button type="button" class="chip ${c.name===qCat?"on":""}" data-qcat="${esc(c.name)}">${c.icon} ${esc(c.name)}</button>`).join("");
}
function openSheet(){
  qType="expense";qCat="";
  document.querySelectorAll("#qType button").forEach(b=>b.classList.toggle("on",b.dataset.type==="expense"));
  renderChips();$("#qAmount").value="";$("#qNote").value="";
  $("#sheetBg").hidden=false;$("#sheet").hidden=false;setTimeout(()=>$("#qAmount").focus(),60);
}
function closeSheet(){$("#sheetBg").hidden=true;$("#sheet").hidden=true}
function quickSave(){
  const amount=parseFloat($("#qAmount").value);
  if(!(amount>0)){$("#qAmount").focus();return}
  S.tx.push({id:uid(),type:qType,amount,category:qCat,date:todayStr(),note:$("#qNote").value.trim(),method:"Cash"});
  save();closeSheet();buzz();renderAll();toast("Saved ✔");
}
$("#fab").onclick=openSheet;$("#sheetBg").onclick=closeSheet;$("#qClose").onclick=closeSheet;$("#qSave").onclick=quickSave;
$("#qAmount").onkeydown=$("#qNote").onkeydown=e=>{if(e.key==="Enter")quickSave()};
$("#qType").onclick=e=>{const b=e.target.closest("button");if(!b)return;qType=b.dataset.type;document.querySelectorAll("#qType button").forEach(x=>x.classList.toggle("on",x===b));renderChips()};
$("#qChips").onclick=e=>{const b=e.target.closest("[data-qcat]");if(!b)return;qCat=b.dataset.qcat;renderChips()};

/* ---------- PWA: install, offline, updates ---------- */
(function(){
  try{ // icon for iPhone home screen
    const c=document.createElement("canvas");c.width=c.height=180;const x=c.getContext("2d");
    x.fillStyle="#4f46e5";x.fillRect(0,0,180,180);x.fillStyle="#fff";x.font="bold 110px system-ui,sans-serif";
    x.textAlign="center";x.textBaseline="middle";x.fillText("₹",90,98);
    const l=document.createElement("link");l.rel="apple-touch-icon";l.href=c.toDataURL("image/png");document.head.appendChild(l);
  }catch(e){}
  const off=()=>{$("#offline").hidden=navigator.onLine};
  addEventListener("online",off);addEventListener("offline",off);off();

  let dp=null;
  addEventListener("beforeinstallprompt",e=>{e.preventDefault();dp=e;let d=null;try{d=localStorage.getItem("installDismissed")}catch(_){}if(!d)$("#installBar").hidden=false});
  $("#installBtn").onclick=async()=>{if(!dp)return;dp.prompt();try{await dp.userChoice}catch(e){}dp=null;$("#installBar").hidden=true};
  $("#installX").onclick=()=>{$("#installBar").hidden=true;try{localStorage.setItem("installDismissed","1")}catch(e){}};
  addEventListener("appinstalled",()=>{$("#installBar").hidden=true});

  const ios=/iphone|ipad|ipod/i.test(navigator.userAgent),standalone=navigator.standalone||matchMedia("(display-mode: standalone)").matches;
  try{if(ios&&!standalone&&!localStorage.getItem("iosHint")){localStorage.setItem("iosHint","1");setTimeout(()=>toast("Install: tap Share, then Add to Home Screen"),1500)}}catch(e){}

  try{navigator.storage&&navigator.storage.persist&&navigator.storage.persist()}catch(e){} // protect data from auto-clean

  if("serviceWorker" in navigator&&location.protocol.startsWith("http")){
    navigator.serviceWorker.register("sw.js").then(reg=>{
      reg.addEventListener("updatefound",()=>{
        const w=reg.installing;
        w&&w.addEventListener("statechange",()=>{if(w.state==="installed"&&navigator.serviceWorker.controller)toast("New version ready",()=>location.reload(),"Refresh")});
      });
    }).catch(()=>{});
  }
  if(new URLSearchParams(location.search).get("add")==="1")setTimeout(openSheet,300); // home-screen shortcut
})();

init();
</script>
</body>
</html>
```

## 📄 manifest.json

```json
{
  "name": "My Expenses",
  "short_name": "Expenses",
  "description": "Personal expense tracker. Private, offline, free.",
  "start_url": "./index.html",
  "scope": "./",
  "display": "standalone",
  "orientation": "portrait",
  "background_color": "#f4f5fa",
  "theme_color": "#4f46e5",
  "icons": [
    { "src": "icon-192.png", "sizes": "192x192", "type": "image/png", "purpose": "any" },
    { "src": "icon-512.png", "sizes": "512x512", "type": "image/png", "purpose": "any" },
    { "src": "icon-512.png", "sizes": "512x512", "type": "image/png", "purpose": "maskable" },
    { "src": "icon.svg", "sizes": "any", "type": "image/svg+xml", "purpose": "any" }
  ],
  "shortcuts": [
    { "name": "Add expense", "short_name": "Add", "url": "./index.html?add=1" }
  ]
}
```

## 📄 sw.js

```js
const CACHE = "expenses-v1"; // change to v2, v3... when you update index.html
const ASSETS = ["./", "./index.html", "./manifest.json", "./icon.svg", "./icon-192.png", "./icon-512.png"];

self.addEventListener("install", e => {
  e.waitUntil(
    caches.open(CACHE)
      .then(c => Promise.all(ASSETS.map(a => c.add(a).catch(() => {}))))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener("activate", e => {
  e.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

// Open instantly from cache, refresh the cache in the background
self.addEventListener("fetch", e => {
  if (e.request.method !== "GET") return;
  if (new URL(e.request.url).origin !== location.origin) return;
  e.respondWith(
    caches.match(e.request, { ignoreSearch: true }).then(hit => {
      const net = fetch(e.request).then(res => {
        if (res && res.ok) { const copy = res.clone(); caches.open(CACHE).then(c => c.put(e.request, copy)); }
        return res;
      }).catch(() => hit || caches.match("./index.html"));
      return hit || net;
    })
  );
});
```

## 📄 icon.svg

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
  <rect width="512" height="512" fill="#4f46e5"/>
  <text x="256" y="300" font-size="290" font-weight="700" text-anchor="middle" dominant-baseline="middle"
        font-family="system-ui, sans-serif" fill="#ffffff">₹</text>
</svg>
```

## 🛠️ Customize

- **Default categories:** edit `DEF_CATS` in the script (or use Settings > Categories).
- **Payment methods:** edit the `METHODS` list.
- **Currency:** change it in Settings, or edit the default in `load()`.

## 💡 Tips

- Use the **+** button for fast entry; use the Transactions tab when you want to add a payment method.
- Take a **Backup** from time to time. Clearing your browser data will erase the app's data.
- Use **Export CSV** to analyse your spending in Excel or Google Sheets.
