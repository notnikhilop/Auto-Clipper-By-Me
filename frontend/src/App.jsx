import { useEffect, useRef, useState } from 'react';
import { Activity, ArrowUpRight, Check, Clapperboard, Clock3, FileVideo2, FolderOpen, HelpCircle, Home, Link2, LoaderCircle, Plus, Settings2, Sparkles, Upload, WandSparkles, X } from 'lucide-react';

const API = 'http://127.0.0.1:8000';
const prettySize = n => n < 1048576 ? `${(n / 1024).toFixed(0)} KB` : `${(n / 1048576).toFixed(1)} MB`;

export default function App() {
  const picker = useRef(null);
  const [file, setFile] = useState(null);
  const [projects, setProjects] = useState([]);
  const [online, setOnline] = useState(false);
  const [busy, setBusy] = useState(false);
  const [notice, setNotice] = useState('');
  const [error, setError] = useState('');
  const [drag, setDrag] = useState(false);
  const [url, setUrl] = useState('');
  const [page, setPage] = useState('Home');

  async function refresh() {
    try { const r = await fetch(`${API}/api/projects`); if (!r.ok) throw Error(); const d = await r.json(); setProjects(d.projects || []); setOnline(true); }
    catch { setOnline(false); }
  }
  useEffect(() => { refresh(); const id = setInterval(refresh, 8000); return () => clearInterval(id); }, []);

  function selectVideo(f) {
    setError(''); setNotice(''); if (!f) return;
    const ext = f.name.slice(f.name.lastIndexOf('.')).toLowerCase();
    if (!['.mp4','.mov','.mkv','.webm','.avi'].includes(ext)) { setError('Choose an MP4, MOV, MKV, WEBM, or AVI video.'); return; }
    setFile(f);
  }
  async function upload() {
    if (!file) return;
    setBusy(true); setError(''); setNotice('');
    const body = new FormData(); body.append('file', file);
    try {
      const r = await fetch(`${API}/api/upload`, { method: 'POST', body });
      const data = await r.json(); if (!r.ok) throw Error(data.detail || 'Upload failed.');
      setNotice(`${data.filename} uploaded successfully. AI processing is the next milestone.`); setFile(null); if (picker.current) picker.current.value = ''; await refresh();
    } catch (e) { setError(online ? e.message : 'Backend is offline. Start the FastAPI server and try again.'); }
    finally { setBusy(false); }
  }

  const nav = [{name:'Home',icon:Home},{name:'My Projects',icon:FolderOpen},{name:'AI Clipper',icon:WandSparkles},{name:'AI Studio',icon:Sparkles}];
  return <div className="shell">
    <aside className="sidebar"><div className="brand"><div className="brandIcon"><Clapperboard size={20}/></div><div><b>AI Short Studio</b><small>CREATOR WORKSPACE</small></div></div>
      <div className="workspace"><div className="workspaceIcon">A</div><div><b>My Workspace</b><small>Personal plan</small></div><span>⌄</span></div>
      <label className="navLabel">WORKSPACE</label><nav>{nav.map(({name,icon:Icon})=><button key={name} onClick={()=>setPage(name)} className={page===name?'selected':''}><Icon size={17}/>{name}{name==='AI Clipper'&&<i>NEW</i>}</button>)}</nav>
      <div className="sideBottom"><div className="localCard"><span><Activity size={14}/> LOCAL PROCESSING</span><b>Your videos stay on your machine</b><p>Uploads are stored on the computer running the backend.</p><div className="progress"><i/></div><small>No cloud credits used</small></div><button className="sideLink"><Settings2 size={16}/> Settings</button><button className="sideLink"><HelpCircle size={16}/> Help & Support</button><div className="user"><div>N</div><span><b>Creator</b><small>Free workspace</small></span><strong>···</strong></div></div>
    </aside>
    <main><header><div className="crumb">Workspace <span>/</span> <b>{page}</b></div><div className="headerRight"><span className={online?'status on':'status'}><i/>{online?'Backend connected':'Backend offline'}</span><span className="help"><HelpCircle size={15}/> Help</span><div className="avatar">N</div></div></header>
      <div className="content"><div className="welcome"><div><label className="eyebrow"><Sparkles size={13}/> YOUR AI VIDEO WORKSPACE</label><h1>{page==='Home'?'Create something great.':page}</h1><p>Turn your long videos into scroll-stopping shorts.</p></div><button className="primary" onClick={()=>picker.current?.click()}><Plus size={16}/> New project</button></div>
        <section className="hero"><div className="heroText"><label className="pill"><WandSparkles size={13}/> AI-POWERED VIDEO CLIPPING</label><h2>One long video.<br/><em>Endless short moments.</em></h2><p>Upload your video and get ready to discover the moments worth sharing. Your creative workflow starts here.</p><div className="checks"><span><Check size={14}/> Local-first workflow</span><span><Check size={14}/> Creator-focused tools</span></div></div><div className="art"><div className="orbit o1"/><div className="orbit o2"/><div className="videoBack"><div className="bars"><i/><i/><i/><i/><i/></div><small>YOUR STORY</small></div><div className="videoFront"><div className="play">▶</div><div className="wave">▂▅▃▇▄▂▆▃▅▂▇</div><small>MAKE IT A SHORT</small></div><b className="spark">✦</b></div></section>
        <div className="sectionTitle"><div><h3>Start creating</h3><p>Bring in a video to begin your first project.</p></div><small>STEP 01 <b>—</b> IMPORT</small></div>
        <section className="imports"><div className={`uploadBox ${drag?'drag':''}`} onDragOver={e=>{e.preventDefault();setDrag(true)}} onDragLeave={()=>setDrag(false)} onDrop={e=>{e.preventDefault();setDrag(false);selectVideo(e.dataTransfer.files?.[0])}}><div className="uploadIcon"><Upload size={21}/></div><h3>Upload a video</h3><p>Drag and drop your video here, or browse files</p><button className="outline" onClick={()=>picker.current?.click()}><FolderOpen size={15}/> Browse files</button><small className="hint">MP4, MOV, MKV, WEBM, AVI · Up to 2 GB</small><input ref={picker} type="file" hidden accept="video/*" onChange={e=>selectVideo(e.target.files?.[0])}/>{file&&<div className="chosen"><FileVideo2 size={17}/><span>{file.name}<small>{prettySize(file.size)}</small></span><button onClick={()=>setFile(null)}><X size={15}/></button></div>}{file&&<button className="primary uploadButton" disabled={busy} onClick={upload}>{busy?<><LoaderCircle className="spin" size={15}/> Uploading...</>:<><Upload size={15}/> Upload video</>}</button>}{notice&&<div className="notice good"><Check size={15}/>{notice}</div>}{error&&<div className="notice bad"><X size={15}/>{error}</div>}</div>
          <div className="urlBox"><div className="urlIcon"><Link2 size={20}/></div><h3>Import from a link</h3><p>Paste a video URL to bring it into your workspace.</p><div className="urlInput"><Link2 size={15}/><input value={url} onChange={e=>setUrl(e.target.value)} placeholder="Paste video URL here..."/></div><button className="outline muted" disabled title="URL import will be added in a later milestone">Continue <ArrowUpRight size={14}/></button><small className="hint">URL importing is coming in a later milestone.</small></div></section>
        <div className="sectionTitle recent"><div><h3>Recent projects <span className="count">{projects.length}</span></h3><p>Your uploaded videos and editing projects.</p></div><button className="viewAll" onClick={()=>setPage('My Projects')}>View all <ArrowUpRight size={14}/></button></div>
        {projects.length?<div className="projectList">{projects.slice(0,8).map(p=><div className="project" key={p.id}><div className="projectIcon"><FileVideo2 size={18}/></div><div className="projectName"><b>{p.filename}</b><small>{prettySize(p.size_bytes)} · <Clock3 size={11}/> {new Date(p.created_at).toLocaleString()}</small></div><span className="uploaded">{p.status}</span></div>)}</div>:<div className="empty"><div><FolderOpen size={21}/></div><b>Your projects will appear here</b><small>Upload your first video to get started.</small></div>}
        <footer><span>AI Short Studio · Built for creators</span><span>Milestone 1 · Foundation</span></footer>
      </div>
    </main>
  </div>;
}
